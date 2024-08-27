package com.dghs.citizenportal.awaztulun.model

import com.google.gson.annotations.SerializedName

data class SaveIncidentResponse(
    @SerializedName("isSuccess") var isSuccess: Boolean,
    @SerializedName("isFailure") var isFailure: Boolean,
    @SerializedName("error") var error: String = "",
    @SerializedName("_value") var _value: String = "",
)
