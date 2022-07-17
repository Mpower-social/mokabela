package com.mpower.appbuilder.app_builder.utills

import okhttp3.ResponseBody
import org.odk.collect.android.application.Collect
import org.odk.collect.android.dao.FormsDao
import org.odk.collect.android.storage.StoragePathProvider
import org.odk.collect.android.storage.StorageSubdirectory
import org.odk.collect.android.utilities.FileUtils
import org.odk.collect.android.utilities.ZipUtils
import org.w3c.dom.NodeList
import java.io.File
import java.io.FileOutputStream
import java.io.InputStream
import java.util.*
import javax.xml.parsers.DocumentBuilderFactory
import javax.xml.transform.TransformerFactory
import javax.xml.transform.dom.DOMSource
import javax.xml.transform.stream.StreamResult


/**
@Author: Md. Asaduzzaman,
@Date: 2020-04-05,
@Time: 5:44 PM.
 **/

object FormUtil {
    fun getInstanceId(xmlPath: String): String {
        var instanceId = ""

        val documentFactory = DocumentBuilderFactory.newInstance()

        try {
            val documentBuilder = documentFactory.newDocumentBuilder()
            val document = documentBuilder.parse(xmlPath)
            document.documentElement.normalize()

            instanceId = getNodeValue(document.getElementsByTagName("instanceID"))
        } catch (ex: Exception) {
            ex.stackTrace
        }

        return instanceId
    }

    fun addDeprecatedInstanceId(xmlPath: String, deprecatedId: String) {
        val instanceFile = File(StoragePathProvider().getAbsoluteInstanceFilePath(xmlPath))

        try {
            val document = DocumentBuilderFactory.newInstance().run {
                newDocumentBuilder().run {
                    parse(instanceFile)
                }
            }.apply {
                documentElement.normalize()
            }

            document.getElementsByTagName("meta").item(0).apply {
                appendChild(document.createElement("deprecatedID").apply {
                    appendChild(document.createTextNode(deprecatedId))
                })
            }

            TransformerFactory.newInstance().apply {
                newTransformer().apply {
                    transform(
                        DOMSource(document),
                        StreamResult(FileOutputStream(instanceFile))
                    )
                }
            }

        } catch (ex: Exception) {
            ex.stackTrace
        }
    }

    fun addMetaDataToSurveyForm(xmlPath: String, formId: String): Map<String, String?> {
        val instanceMap = hashMapOf<String, String?>()
        val instanceFile = File(StoragePathProvider().getAbsoluteInstanceFilePath(xmlPath))

        try {
            val document = DocumentBuilderFactory.newInstance().run {
                newDocumentBuilder().run {
                    parse(instanceFile)
                }
            }.apply {
                documentElement.normalize()
            }

            instanceMap["instanceID"] =
                getNodeValue(document.getElementsByTagName("instanceID")).split("uuid:").last()

            document.getElementsByTagName("meta").item(0).apply {
                //Project Id
                val projectId = Collect.getInstance().getPreferenceValue("projectId", "") as String?
                appendChild(document.createElement("meta_project_id").apply {
                    appendChild(document.createTextNode(projectId))
                })
                instanceMap["module_id"] = projectId

                /*
                //HH Base Entity Id
                val hhBaseEntityId = Collect.getInstance().getPreferenceValue(PreferenceUtil.KEY_SURVEY_REQUEST_HH_BASE_ENTITY_ID, "") as String?
                appendChild(document.createElement("meta_hh_baseentityid").apply {
                    appendChild(document.createTextNode(hhBaseEntityId))
                })

                //Division Id
                val divisionId = Collect.getInstance().getPreferenceValue(PreferenceUtil.KEY_SURVEY_REQUEST_DIVISION_ID, 0) as Int?
                appendChild(document.createElement("meta_division_id").apply {
                    appendChild(document.createTextNode("$divisionId"))
                })

                //District Id
                val districtId = Collect.getInstance().getPreferenceValue(PreferenceUtil.KEY_SURVEY_REQUEST_DISTRICT_ID, 0) as Int?
                appendChild(document.createElement("meta_district_id").apply {
                    appendChild(document.createTextNode("$districtId"))
                })

                //Upazila Id
                val upazilaId = Collect.getInstance().getPreferenceValue(PreferenceUtil.KEY_SURVEY_REQUEST_UPAZILA_ID, 0) as Int?
                appendChild(document.createElement("meta_upazila_id").apply {
                    appendChild(document.createTextNode("$upazilaId"))
                })

                //Union Id
                val unionId = Collect.getInstance().getPreferenceValue(PreferenceUtil.KEY_SURVEY_REQUEST_UNION_ID, 0) as Int?
                appendChild(document.createElement("meta_union_id").apply {
                    appendChild(document.createTextNode("$unionId"))
                })

                //Village Id
                val villageId = Collect.getInstance().getPreferenceValue(PreferenceUtil.KEY_SURVEY_REQUEST_VILLAGE_ID, 0) as Int?
                appendChild(document.createElement("meta_village_id").apply {
                    appendChild(document.createTextNode("$villageId"))
                })

                //Survey Type
                appendChild(document.createElement("meta_survey_type").apply {
                    appendChild(document.createTextNode(formType))
                })

                //Base Entity name
                val baseEntityName = Collect.getInstance().getPreferenceValue(PreferenceUtil.KEY_SURVEY_REQUEST_BASE_ENTITY_NAME, "") as String?
                appendChild(document.createElement("base_entity_name").apply {
                    appendChild(document.createTextNode(baseEntityName))
                })
                instanceMap["sub_module_id"] = baseEntityName
                 */
            }

            TransformerFactory.newInstance().apply {
                newTransformer().apply {
                    transform(
                        DOMSource(document),
                        StreamResult(FileOutputStream(instanceFile))
                    )
                }
            }

        } catch (ex: Exception) {
            ex.stackTrace
        }

        return instanceMap
    }

    fun getInstanceContent(xmlPath: String): Map<String, String> {

        val instanceMap = hashMapOf<String, String>()
        val documentFactory = DocumentBuilderFactory.newInstance()

        try {
            val documentBuilder = documentFactory.newDocumentBuilder()
            val document = documentBuilder.parse(File(StoragePathProvider().getAbsoluteInstanceFilePath(xmlPath)))
            document.documentElement.normalize()

            var moduleId = getNodeValue(document.getElementsByTagName("group_uid"))
            if(moduleId.isEmpty())
                moduleId = getNodeValue(document.getElementsByTagName("member_uid"))
            if(moduleId.isEmpty())
                moduleId = getNodeValue(document.getElementsByTagName("event_uid"))
            if(moduleId.isEmpty())
                moduleId = getNodeValue(document.getElementsByTagName("input_uid"))
            if(moduleId.isEmpty())
                moduleId = getNodeValue(document.getElementsByTagName("infrastructure_uid"))

            instanceMap["module_id"] = moduleId

            var subModuleId = getNodeValue(document.getElementsByTagName("annual_outcome_survey_uid"))
            if(subModuleId.isEmpty())
                subModuleId = getNodeValue(document.getElementsByTagName("rpsf_post_distribution_uid"))

            instanceMap["sub_module_id"] = subModuleId
            instanceMap["instanceID"] = getNodeValue(document.getElementsByTagName("instanceID"))
        } catch (ex: Exception) {
            ex.stackTrace
        }

        return instanceMap
    }

    private fun getNodeValue(documentNodes: NodeList): String {
        if(documentNodes.length > 0) {
            val valueNodes = documentNodes.item(0).childNodes
            if(valueNodes.length > 0)
                return valueNodes.item(0).nodeValue
        }

        return ""
    }

    /*fun saveXmlContent(submittedForm: SubmittedForm, hhUid: String): String {
        val fileDir = File(StoragePathProvider().getDirPath(StorageSubdirectory.INSTANCES), hhUid)
        FileUtils.checkMediaPath(fileDir)

        val file = File("${fileDir.absolutePath}${File.separator}${submittedForm.formName}_${submittedForm.instanceId}.xml")

        try {
            file.createNewFile()
            if(file.exists()) {
                val fileOutputStream = FileOutputStream(file)
                fileOutputStream.write(submittedForm.xmlContent.toByteArray())
                fileOutputStream.close()
            }
        } catch (ex: Exception) {
            ex.stackTrace
        }

        return file.absolutePath
    }*/

    private fun findAndRemoveCsvFiles(tempMediaDir: File) {
        val csvFiles = tempMediaDir.listFiles {
                file -> file.name.toLowerCase(Locale.US).endsWith(".csv")
        }

        for (csvFile in csvFiles) {
            csvFile.delete()
        }
    }

    private fun saveCsvZip(inputStream: InputStream?): String {
        val tempMediaPath = File(StoragePathProvider().getDirPath(StorageSubdirectory.CACHE), System.currentTimeMillis().toString()).absolutePath
        val tempMediaDir = File(tempMediaPath)
        FileUtils.checkMediaPath(tempMediaDir)
        val tempMediaFile = File(tempMediaDir, "temp.zip")
        val outputStream = FileOutputStream(tempMediaFile)

        inputStream.use { input ->
            outputStream.use { output ->
                input?.copyTo(output)
            }
        }

        findAndRemoveCsvFiles(tempMediaDir)
        ZipUtils.unzip(arrayOf(tempMediaFile))
        tempMediaFile.delete()

        return tempMediaPath
    }

    fun processCsvResponse(formsDao: FormsDao, response: ResponseBody?) {
        var tempMediaPath = saveCsvZip(response?.byteStream())

        formsDao.formMediaPaths.forEach { destPath ->
            if(!destPath.isNullOrEmpty()) {
                val destMediaDir = File(destPath)
                FileUtils.checkMediaPath(destMediaDir)
                findAndRemoveCsvFiles(destMediaDir)
                FileUtils.copyMediaFiles(tempMediaPath, destMediaDir)
            }
        }

        FileUtils.purgeMediaPath(tempMediaPath)
    }
}