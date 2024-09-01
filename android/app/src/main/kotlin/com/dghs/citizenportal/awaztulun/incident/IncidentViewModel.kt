package com.dghs.citizenportal.awaztulun.incident

import android.util.Log
import android.view.View
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.viewModelScope
import com.dghs.citizenportal.awaztulun.network.ApiService
import com.dghs.citizenportal.awaztulun.base.BaseViewModel
import com.dghs.citizenportal.awaztulun.model.IncidentList
import com.dghs.citizenportal.awaztulun.model.Comments
import com.dghs.citizenportal.awaztulun.util.SharedPreferenceUtil
import com.google.gson.JsonObject
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.RequestBody.Companion.toRequestBody
import javax.inject.Inject

class IncidentViewModel: BaseViewModel() {
  @Inject
  lateinit var apiService: ApiService
  @Inject
  lateinit var sharedPreferenceUtil: SharedPreferenceUtil
  var mutableIncident = MutableLiveData<IncidentList>()
  var mutableIncidentComments = MutableLiveData<List<Comments>>()
  var mutableCloseScreen = MutableLiveData<Boolean>()
  private var incidentId: String? = null
  var commentText: String? = null

  init {
    progressVisibility.value = View.GONE
  }

  fun getIncidentById(id: String) {
    incidentId = id
    onRetrieveStart()

    viewModelScope.launch(Dispatchers.IO) {
      try {
        val result = apiService.getIncidentById(id).await()
        if(result.isSuccessful){
          result.body()?.let {
            viewModelScope.launch(Dispatchers.Main) {
              mutableIncident.value = it._value
              onRetrieveFinish()
            }
          }
        }else{
          viewModelScope.launch(Dispatchers.Main) {
            errorMessage.value = "Failed to get Incident Details"
            onRetrieveFinish()
          }
        }
      }catch (ex:Exception){
        ex.printStackTrace()
        viewModelScope.launch(Dispatchers.Main) {
          errorMessage.value = ex.message
          onRetrieveFinish()
        }
      }
    }
  }

  fun getIncidentCommentsById(id: String) {
    incidentId = id
    onRetrieveStart()

    viewModelScope.launch(Dispatchers.IO) {
      try {
        val commentJson = JsonObject().apply {
          addProperty("incidentId", incidentId)
        }

        val requestBody = commentJson.toString().toRequestBody("application/json".toMediaType())

        val result = apiService.getIncidentComment(requestBody).await()
        if(result.isSuccessful){
          result.body()?.let {
            viewModelScope.launch(Dispatchers.Main) {
              mutableIncidentComments.value = it._value
              onRetrieveFinish()
            }
          }
        }else{
          viewModelScope.launch(Dispatchers.Main) {
            errorMessage.value = "Failed to get Incident Details"
            onRetrieveFinish()
          }
        }
      }catch (ex:Exception){
        ex.printStackTrace()
        viewModelScope.launch(Dispatchers.Main) {
          errorMessage.value = ex.message
          onRetrieveFinish()
        }
      }
    }
  }

  fun cancel() {
    mutableCloseScreen.value = true
  }

  fun addComment() {
    if(commentText.isNullOrEmpty()){
      errorMessage.value = "কমেন্ট যোগ করুন"
      return
    }

    onRetrieveStart()
    viewModelScope.launch(Dispatchers.IO) {
      try {
        val commentJson = JsonObject().apply {
          addProperty("incidentId", incidentId)
          addProperty("comment", commentText)
        }

        val requestBody = commentJson.toString().toRequestBody("application/json".toMediaType())

        Log.v("POST_DATA","reportData>>"+commentJson.toString());
        val result = apiService.saveIncidentComment(
          requestBody).await()
        if(result.isSuccessful){
          result.body()?.let {
            viewModelScope.launch(Dispatchers.Main) {
              successMessage.value = "Successfully commented"
              onRetrieveFinish()
            }
          }
        }else{
          viewModelScope.launch(Dispatchers.Main) {
            errorMessage.value = "Failed to comment"
            onRetrieveFinish()
          }
        }
      }catch (ex:Exception){
        viewModelScope.launch(Dispatchers.Main) {
          errorMessage.value = ex.message
          onRetrieveFinish()
        }
      }
    }
  }
}