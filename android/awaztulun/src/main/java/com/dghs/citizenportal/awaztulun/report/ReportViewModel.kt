package com.dghs.citizenportal.awaztulun.report

import android.graphics.Bitmap
import android.util.Log
import android.view.View
import android.widget.AdapterView
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.viewModelScope
import com.dghs.citizenportal.awaztulun.CitizenApplication
import com.dghs.citizenportal.awaztulun.R
import com.dghs.citizenportal.awaztulun.network.ApiService
import com.dghs.citizenportal.awaztulun.base.BaseViewModel
import com.dghs.citizenportal.awaztulun.model.IncidentTypeList
import com.dghs.citizenportal.awaztulun.model.SaveIncident
import com.dghs.citizenportal.awaztulun.util.Constants.Companion.getCurrentDateTime
import com.dghs.citizenportal.awaztulun.util.SharedPreferenceUtil
import id.zelory.compressor.Compressor
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.MultipartBody
import okhttp3.RequestBody
import okhttp3.RequestBody.Companion.asRequestBody
import java.io.File
import java.text.SimpleDateFormat
import java.util.*
import javax.inject.Inject

class ReportViewModel: BaseViewModel() {
    @Inject
    lateinit var apiService: ApiService
    @Inject
    lateinit var sharedPreferenceUtil: SharedPreferenceUtil
    var reportData = SaveIncident()
    var selectedIncidentImage: String? = null
    val mutableIncidentTypeList = MutableLiveData<List<IncidentTypeList>>()
    var mutableCloseScreen = MutableLiveData<Boolean>()
    var mutableIsHappening = MutableLiveData<Int>()
    var mutableProgressDialog = MutableLiveData<Boolean>()
    fun onSelectCaseItem(parent: AdapterView<*>?, view: View?, pos: Int, id: Long) {

        Log.d("idddddd",""+id+" "+pos)
        if(id.toInt() != 0) {
            if (parent != null) {
                reportData.incidentTypeId = mutableIncidentTypeList.value?.get(pos)?.id.toString()
            }
        }
    }

    fun getIncidentTypeList(){
        viewModelScope.launch(Dispatchers.IO) {
            try {
                val result = apiService.getIncidentTypeList().await()
                if(result.isSuccessful){
                    result.body()?.let {
                        viewModelScope.launch(Dispatchers.Main) {
                            val list = ArrayList<IncidentTypeList>()
                            list.add(0,IncidentTypeList(id ="0", description = "Select Incident Type"))
                            it._value?.let {
                                    it1 -> list.addAll(it1)
                            }

                            mutableIncidentTypeList.value = list
                        }
                    }
                }else{
                    viewModelScope.launch(Dispatchers.Main) {

                    }
                }
            }catch (ex:Exception){
                viewModelScope.launch(Dispatchers.Main) {
                    errorMessage.value = ex.message

                }
            }

        }
    }
    fun cancel(){
        mutableCloseScreen.value = true

    }
    fun submitInfo(){
        if(reportData.latitude.toDouble() == 0.0 || reportData.longitude.toDouble()== 0.0){
            errorMessage.value = "আপনার জিপিএস লোকেশন পাওয়া যায়নি"
            return
        }
        mutableProgressDialog.value = true
        viewModelScope.launch(Dispatchers.IO) {
            try {
                val myDate = getCurrentDateTime()
                val formatter = SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US)

//                reportData.caseId = UUID.randomUUID().toString()
                reportData.createdAt = formatter.format(myDate).toString()
                reportData.deviceId = sharedPreferenceUtil.getValue(SharedPreferenceUtil.DEVICE_ID,"").toString()
                reportData.firebaseToken = sharedPreferenceUtil.getValue(SharedPreferenceUtil.KEY_FIREBASE_TOKEN,"").toString()
                reportData.isHappeningNow = mutableIsHappening.value == R.id.yes_rb


                val requestBuilder = MultipartBody.Builder()
                    .setType(MultipartBody.FORM)
                    .addFormDataPart("contactNo", reportData.contactNo)
                    .addFormDataPart("description", reportData.description)
                    .addFormDataPart("incidentTypeId", reportData.incidentTypeId)
                    .addFormDataPart("incidentReportTypeId", reportData.incidentReportTypeId)
                    .addFormDataPart("isHappeningNow", reportData.isHappeningNow.toString())
                    .addFormDataPart("device_id", reportData.deviceId)
                    .addFormDataPart("latitude", reportData.latitude)
                    .addFormDataPart("longitude", reportData.longitude)
                    .addFormDataPart("firebaseToken", reportData.firebaseToken)

                selectedIncidentImage?.let {
                    val imageFile = File(it)
                    val compressedImage = Compressor(CitizenApplication.getInstance())
                        .setMaxWidth(640)
                        .setMaxHeight(480)
                        .setQuality(75)
                        .setCompressFormat(Bitmap.CompressFormat.WEBP)
                        .compressToFile(imageFile)

                    requestBuilder.addFormDataPart(
                        "files",
                        compressedImage.name,
                        compressedImage.asRequestBody("image/*".toMediaTypeOrNull())
                    )
                }

                val requestBody = requestBuilder.build()
                val result = apiService.saveIncident(
                    requestBody).await()
                if(result.isSuccessful){
                    result.body()?.let {
                        viewModelScope.launch(Dispatchers.Main) {
                            successMessage.value = "Successfully reported"
                            mutableProgressDialog.value = false
                        }
                    }
                }else{
                    viewModelScope.launch(Dispatchers.Main) {
                        errorMessage.value = "Failed to upload"
                        mutableProgressDialog.value = false
                    }
                }
            }catch (ex:Exception){
                viewModelScope.launch(Dispatchers.Main) {
                    errorMessage.value = ex.message
                    mutableProgressDialog.value = false

                }
            }

        }
    }
}