package com.dghs.citizenportal.awaztulun.model

import com.google.gson.annotations.SerializedName

data class AppVersionResponse(
    @SerializedName("version") var version: String = "",
)
