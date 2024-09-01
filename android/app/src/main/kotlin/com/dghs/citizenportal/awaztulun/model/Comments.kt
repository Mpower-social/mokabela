package com.dghs.citizenportal.awaztulun.model

import com.google.gson.annotations.SerializedName

data class Comments(
    @SerializedName("id") var id: String = "",
    @SerializedName("comment") var comment: String = "",
    @SerializedName("contactNo") var contactNo: String = "",
    @SerializedName("name") var name: String = "",
    @SerializedName("createdAt") var createdAt: String = "",
)


