package com.mpower.appbuilder.app_builder.models

data class FormInstance(
    val id: Long,
    val formId: String,
    val displayName: String,
    val projectId: String,
    val instanceId: String,
    val instanceFilePath: String,
    val xml: String? = "",
    val submittedBy: String? = "",
    val lastChangeDate: Long
)
