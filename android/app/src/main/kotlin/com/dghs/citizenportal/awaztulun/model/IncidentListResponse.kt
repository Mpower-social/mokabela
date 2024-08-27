package com.dghs.citizenportal.awaztulun.model

import com.dghs.citizenportal.awaztulun.model.IncidentList
import com.google.gson.annotations.SerializedName
import java.util.ArrayList

data class IncidentListResponse(
    @SerializedName("isSuccess") var isSuccess: Boolean,
    @SerializedName("isFailure") var isFailure: Boolean,
    @SerializedName("error") var error: String = "",
    @SerializedName("_value") var _value: List<IncidentList>? = ArrayList(),
)
