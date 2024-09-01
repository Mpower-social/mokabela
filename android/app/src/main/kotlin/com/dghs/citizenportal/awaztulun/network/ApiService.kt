package com.dghs.citizenportal.awaztulun.network

import com.dghs.citizenportal.awaztulun.firebase.UpdateFirebaseTokenResponse
import com.dghs.citizenportal.awaztulun.model.*
import com.dghs.citizenportal.awaztulun.util.Constants
import io.reactivex.Observable
import kotlinx.coroutines.Deferred
import okhttp3.RequestBody
import retrofit2.Response
import retrofit2.http.*
import java.util.*

/**
 * Created by mahmud
on 30 aug 2023
 */
interface ApiService {

    @POST("/api/v1/incidentReport/listIncidentType")
    fun getIncidentTypeList(@Header("API-KEY") credentials:String = Constants.API_KEY): Deferred<Response<IncidentTypeListResponse>>

    @POST("/api/v1/incidentReport/listIncident")
    fun getIncidentList(@Header("API-KEY") credentials:String = Constants.API_KEY): Deferred<Response<IncidentListResponse>>

    @GET("/api/v1/incidentReport/incidentById/{id}")
    fun getIncidentById(@Path("id") id: String,@Header("API-KEY") credentials:String = Constants.API_KEY): Deferred<Response<IncidentResponse>>

    @POST("/api/v1/incidentReport/saveIncident")
    fun saveIncident(@Body body: RequestBody,@Header("API-KEY") credentials:String = Constants.API_KEY,): Deferred<Response<SaveIncidentResponse>>

    @POST("/api/v1/incidentReport/saveIncidentComment")
    fun saveIncidentComment(@Body body: RequestBody, @Header("API-KEY") credentials:String = Constants.API_KEY,): Deferred<Response<SaveIncidentResponse>>

    @POST("/api/v1/incidentReport/listIncidentComments")
    fun getIncidentComment(@Body body: RequestBody, @Header("API-KEY") credentials:String = Constants.API_KEY,): Deferred<Response<IncidentCommentListResponse>>

    @POST("/api/v1/incidentReport/updateFbToken/")
    fun updateFirebaseToken(@Body body: HashMap<String, String?>,@Header("API-KEY") credentials:String = Constants.API_KEY): Observable<UpdateFirebaseTokenResponse>

    @POST("/api/v1/incidentReport/updateByDeviceId/")
    fun updateByDeviceId(@Body body: HashMap<String, String?>,@Header("API-KEY") credentials:String = Constants.API_KEY): Deferred<Response<UpdateFirebaseTokenResponse>>

    @GET("api/v1/administration/appVersion")
    fun getAppVersion(): Deferred<Response<AppVersionResponse>>


}