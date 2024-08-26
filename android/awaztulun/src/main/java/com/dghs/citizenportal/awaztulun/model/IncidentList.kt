package com.dghs.citizenportal.awaztulun.model

import com.dghs.citizenportal.awaztulun.model.Comments
import com.dghs.citizenportal.awaztulun.model.IncidentReportList
import com.dghs.citizenportal.awaztulun.model.IncidentTypeList
import com.google.gson.annotations.SerializedName
import java.lang.StringBuilder
import java.util.ArrayList

data class IncidentList(
    @SerializedName("id") var id: String = "",
    @SerializedName("contactNo") var name: String = "",
    @SerializedName("description") var description: String = "",
    @SerializedName("incidentTypeId") var incidentTypeId: IncidentTypeList,
    @SerializedName("incidentReportTypeId") var incidentReportTypeId: IncidentReportList,
    @SerializedName("isHappeningNow") var isHappeningNow: Boolean,
    @SerializedName("latitude") var latitude: String = "",
    @SerializedName("longitude") var longitude: String = "",
    @SerializedName("deviceId") var deviceId: String = "",
    @SerializedName("firebaseToken") var firebaseToken: String = "",
    @SerializedName("createdAt") var createdAt: String = "",
    @SerializedName("updatedAt") var updatedAt: String = "",
    @SerializedName("files") var files: List<String> = ArrayList(),
    @SerializedName("comments") var comments: List<Comments>? = ArrayList(),
) {
    fun appendComment(): String {
        var stringBuilder = StringBuilder()
        if (comments != null) {
            for (comment in comments!!){
                stringBuilder.append(comment.comment)
                stringBuilder.append("\n --- at ")
                stringBuilder.append(comment.createdAt)
                stringBuilder.append("\n\n")
            }
        }
        return stringBuilder.toString()
    }
}
