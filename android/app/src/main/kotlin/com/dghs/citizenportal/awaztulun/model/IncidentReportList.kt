package com.dghs.citizenportal.awaztulun.model

import com.google.gson.annotations.SerializedName

data class IncidentReportList(
    @SerializedName("id") var id: String = "",
    @SerializedName("name") var name: String = "",
    @SerializedName("description") var description: String = "",
    @SerializedName("createdAt") var createdAt: String = "",
    @SerializedName("updatedAt") var updatedAt: String = "",
)
