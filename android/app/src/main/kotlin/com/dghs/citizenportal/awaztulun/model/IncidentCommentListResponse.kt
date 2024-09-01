package com.dghs.citizenportal.awaztulun.model

import com.google.gson.annotations.SerializedName
import java.util.ArrayList

data class IncidentCommentListResponse(
    @SerializedName("isSuccess") var isSuccess: Boolean,
    @SerializedName("isFailure") var isFailure: Boolean,
    @SerializedName("error") var error: String = "",
    @SerializedName("_value") var _value: List<Comments> = ArrayList(),
)
