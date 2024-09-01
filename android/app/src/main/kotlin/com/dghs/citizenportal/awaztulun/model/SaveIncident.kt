package com.dghs.citizenportal.awaztulun.model

import com.google.gson.annotations.SerializedName
import java.io.Serializable
import java.util.HashMap

data class SaveIncident(
    @SerializedName("id") var id: String = "",
    @SerializedName("contactNo") var contactNo: String = "",
    @SerializedName("description") var description: String = "",
    @SerializedName("incidentTypeId") var incidentTypeId: String = "",
    @SerializedName("incidentReportTypeId") var incidentReportTypeId: String = "",
    @SerializedName("isHappeningNow") var isHappeningNow: Boolean = false,
    @SerializedName("latitude") var latitude: String = "",
    @SerializedName("longitude") var longitude: String = "",
    @SerializedName("deviceId") var deviceId: String = "",
    @SerializedName("firebaseToken") var firebaseToken: String = "",
    @SerializedName("createdAt") var createdAt: String = "",
    @SerializedName("updatedAt") var updatedAt: String = "",
): Serializable {
    fun toJson(): HashMap<String, String?> {
        val map = hashMapOf<String, String?>()
        map["contactNo"] = contactNo
        map["description"] = description
        map["incidentTypeId"]  = incidentTypeId
        map["incidentReportTypeId"]  = incidentReportTypeId
        map["isHappeningNow"]  = isHappeningNow.toString()
        map["device_id"]  = deviceId
        map["latitude"]  = latitude
        map["longitude"]  = longitude
        map["firebaseToken"]  = firebaseToken
        map["createdAt"]  = createdAt
        return map
    }
}
