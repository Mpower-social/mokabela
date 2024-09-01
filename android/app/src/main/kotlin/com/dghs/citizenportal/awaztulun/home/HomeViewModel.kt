package com.dghs.citizenportal.awaztulun.home

import android.util.Log
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.viewModelScope
import com.dghs.citizenportal.awaztulun.network.ApiService
import com.dghs.citizenportal.awaztulun.base.BaseViewModel
import com.dghs.citizenportal.awaztulun.model.IncidentList
import com.dghs.citizenportal.awaztulun.util.SharedPreferenceUtil
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import java.util.*
import javax.inject.Inject
import kotlin.collections.HashMap

class HomeViewModel : BaseViewModel() {
    @Inject
    lateinit var apiService: ApiService

    @Inject
    lateinit var sharedPreferenceUtil: SharedPreferenceUtil

    private val _text = MutableLiveData<String>().apply {
        value = "This is home Fragment"
    }
    val text: LiveData<String> = _text
    var mutableIncidentList = MutableLiveData<List<IncidentList>>()
    var mutableIncident = MutableLiveData<IncidentList>()
    var mutableAppVersion = MutableLiveData<String>()
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var lastRefreshTime: Long = 0
    fun sendFirebaseTokenToServer(){

        val profileJson = HashMap<String,String?>()
        profileJson["deviceId"] = sharedPreferenceUtil.getValue(SharedPreferenceUtil.DEVICE_ID,"").toString()
        profileJson["firebaseToken"] = sharedPreferenceUtil.getValue(SharedPreferenceUtil.KEY_FIREBASE_TOKEN,"").toString()
        profileJson["latitude"] = latitude.toString()
        profileJson["longitude"] = longitude.toString()
        Log.v("DATA_POST","dataMap:"+profileJson)

        viewModelScope.launch(Dispatchers.IO) {
            try {

                val result = apiService.updateByDeviceId(
                    profileJson).await()
                if(result.isSuccessful){
                    result.body()?.let {
                        viewModelScope.launch(Dispatchers.Main) {

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
    fun getIncidentById(id:String){
        viewModelScope.launch(Dispatchers.IO) {
            try {
                val result = apiService.getIncidentById(id).await()
                if(result.isSuccessful){
                    result.body()?.let {
                        viewModelScope.launch(Dispatchers.Main) {

                            it._value?.let {
                                mutableIncident.value = it
                            }

                        }
                    }
                }else{
                    viewModelScope.launch(Dispatchers.Main) {

                    }
                }
            }catch (ex:Exception){
                ex.printStackTrace()
                viewModelScope.launch(Dispatchers.Main) {
                    errorMessage.value = ex.message

                }
            }

        }
    }
    fun getIncidentList(){
        viewModelScope.launch(Dispatchers.IO) {
            try {
                val result = apiService.getIncidentList().await()
                if(result.isSuccessful){
                    result.body()?.let {
                        viewModelScope.launch(Dispatchers.Main) {

                            it._value?.let {
                                mutableIncidentList.value = it
                            }
                        }
                    }
                }else{
                    viewModelScope.launch(Dispatchers.Main) {

                    }
                }
            }catch (ex:Exception){
                ex.printStackTrace()
                viewModelScope.launch(Dispatchers.Main) {
                    errorMessage.value = ex.message

                }
            }

        }
    }
    fun getAppVersion(){
        viewModelScope.launch(Dispatchers.IO) {
            try {
                val result = apiService.getAppVersion().await()
                if(result.isSuccessful){
                    result.body()?.let {
                        viewModelScope.launch(Dispatchers.Main) {

                            it.let {
                                mutableAppVersion.value = it.version
                            }

                        }
                    }
                }else{
                    viewModelScope.launch(Dispatchers.Main) {

                    }
                }
            }catch (ex:Exception){
                ex.printStackTrace()
                viewModelScope.launch(Dispatchers.Main) {


                }
            }

        }
    }
}