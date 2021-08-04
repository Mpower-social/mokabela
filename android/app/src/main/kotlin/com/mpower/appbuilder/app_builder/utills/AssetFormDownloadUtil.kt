package com.mpower.appbuilder.app_builder.utills

import android.content.ContentValues
import android.content.Context
import org.javarosa.xform.parse.XFormParser
import org.kxml2.io.KXmlParser
import org.kxml2.kdom.Document
import org.kxml2.kdom.Element
import org.odk.collect.android.R
import org.odk.collect.android.application.Collect
import org.odk.collect.android.dao.FormsDao
import org.odk.collect.android.logic.FormDetails
import org.odk.collect.android.logic.MediaFile
import org.odk.collect.android.provider.FormsProviderAPI
import org.odk.collect.android.storage.StoragePathProvider
import org.odk.collect.android.storage.StorageSubdirectory
import org.odk.collect.android.utilities.DocumentFetchResult
import org.odk.collect.android.utilities.FileUtils
import org.odk.collect.android.utilities.FormDownloader
import org.odk.collect.android.utilities.Validator
import org.xmlpull.v1.XmlPullParser
import java.io.*


/**
@Author: Md. Asaduzzaman,
@Date: 2019-12-10,
@Time: 5:59 PM.
 **/

class AssetFormDownloadUtil(val context: Context) {
    private val NAMESPACE_OPENROSA_ORG_XFORMS_XFORMS_LIST = "http://openrosa.org/xforms/xformsList"
    private val NAMESPACE_OPENROSA_ORG_XFORMS_XFORMS_MANIFEST = "http://openrosa.org/xforms/xformsManifest"
    private val TEMP_DOWNLOAD_EXTENSION = ".tempDownload"
    var formsDao: FormsDao = FormsDao()

    fun getForms(): Boolean {
        if(formsDao.formsCursor.count > 0) {
            return true
        }

        try {

            getFormList().forEach { selectedForm ->
                try {
                    deleteOldFormIfExist(selectedForm.formId)
                    val downloadFile = downloadForm(selectedForm.formName, selectedForm.downloadUrl)
                    val tempMediaPath = File(StoragePathProvider().getDirPath(StorageSubdirectory.CACHE), System.currentTimeMillis().toString()).absolutePath

                    if (selectedForm.manifestUrl != null) {

                        val mediaFiles = getMediaList(selectedForm.manifestUrl)
                        val tempMediaDir = File(tempMediaPath)
                        FileUtils.checkMediaPath(tempMediaDir)

                        mediaFiles.forEach { mediaFile ->
                            downloadMedia(tempMediaDir, mediaFile)
                        }
                    }

                    saveAndCleanUpData(downloadFile, tempMediaPath)
                } catch (ex: Exception) {
                    ex.stackTrace
                }
            }

            return true
        } catch (ex: Exception) {
            ex.stackTrace
        }

        return false
    }

    private fun getFormList() : List<FormDetails> {
        val documentFetchResult = handleXmlDocument(getFormListUrl())
        if(documentFetchResult != null) {
            return getFormDetails(documentFetchResult)
        }

        return emptyList()
    }

    private fun getMediaList(manifestUrl: String) : List<MediaFile> {
        val documentFetchResult = handleXmlDocument(manifestUrl)
        if(documentFetchResult != null) {
            return getMediaFiles(documentFetchResult)
        }

        return emptyList()
    }

    private fun getFormDetails(documentFetchResult: DocumentFetchResult) : List<FormDetails> {
        val formDetails = ArrayList<FormDetails>()

        if(documentFetchResult.isOpenRosaResponse) {
            val xFormElements = documentFetchResult.doc.rootElement
            if(xFormElements.name != "xforms")
                return formDetails

            if(!xFormElements.namespace.equals(NAMESPACE_OPENROSA_ORG_XFORMS_XFORMS_LIST, ignoreCase = true))
                return formDetails

            for (i in 0 until xFormElements.childCount) {
                if(xFormElements.getType(i) != Element.ELEMENT)
                    continue

                val xFormElement = xFormElements.getElement(i)
                if(!xFormElement.namespace.equals(NAMESPACE_OPENROSA_ORG_XFORMS_XFORMS_LIST, ignoreCase = true))
                    continue

                if(!xFormElement.name.equals("xform", ignoreCase = true))
                    continue

                var formId: String? = null
                var formName: String? = null
                var version: String? = null
                var majorMinorVersion: String? = null
                var downloadUrl: String? = null
                var manifestUrl: String? = null
                var hash: String? = null

                for (j in 0 until xFormElement.childCount) {
                    if(xFormElement.getType(j) != Element.ELEMENT)
                        continue

                    val childElement = xFormElement.getElement(j)
                    if(!childElement.namespace.equals(NAMESPACE_OPENROSA_ORG_XFORMS_XFORMS_LIST, ignoreCase = true))
                        continue

                    when(childElement.name) {
                        "formID" -> {
                            formId = XFormParser.getXMLText(childElement, true)
                            if(formId.isNullOrEmpty())
                                formId = null
                        }
                        "name" -> {
                            formName = XFormParser.getXMLText(childElement, true)
                            if(formName.isNullOrEmpty())
                                formName = null
                        }
                        "version" -> {
                            version = XFormParser.getXMLText(childElement, true)
                            if(version.isNullOrEmpty())
                                version = null
                        }
                        "majorMinorVersion" -> {
                            majorMinorVersion = XFormParser.getXMLText(childElement, true)
                            if(majorMinorVersion.isNullOrEmpty())
                                majorMinorVersion = null
                        }
                        "downloadUrl" -> {
                            downloadUrl = XFormParser.getXMLText(childElement, true)
                            if(downloadUrl.isNullOrEmpty())
                                downloadUrl = null
                        }
                        "manifestUrl" -> {
                            manifestUrl = XFormParser.getXMLText(childElement, true)
                            if(manifestUrl.isNullOrEmpty())
                                manifestUrl = null
                        }
                        "hash" -> {
                            hash = XFormParser.getXMLText(childElement, true)
                            if(hash.isNullOrEmpty())
                                hash = null
                        }
                    }
                }

                var isNewerFormVersionAvailable = false
                var areNewerMediaFilesAvailable = false

                if(formId != null && formName != null && downloadUrl != null) {

                    if (isThisFormAlreadyDownloaded(formId)) {
                        isNewerFormVersionAvailable = isNewerFormVersionAvailable(FormDownloader.getMd5Hash(hash))
                        if (!isNewerFormVersionAvailable && manifestUrl != null) {
                            val mediaFiles = getMediaList(manifestUrl)
                            if (mediaFiles.isNotEmpty()) {
                                areNewerMediaFilesAvailable =
                                    areNewerMediaFilesAvailable(formId, version, mediaFiles)
                            }
                        }
                    }

                    formDetails.add(FormDetails(formName, downloadUrl, manifestUrl, formId,
                        version?: majorMinorVersion, hash, null, isNewerFormVersionAvailable, areNewerMediaFilesAvailable))
                }
            }

        } else {
            val formElement = documentFetchResult.doc.rootElement
            var formId: String? = null
            var formName: String? = null
            var downloadUrl: String? = null

            for (i in 0 until formElement.childCount) {
                if(formElement.getType(i) != Element.ELEMENT)
                    continue

                val childElement = formElement.getElement(i)

                if(childElement.name == "formID") {
                    formId = XFormParser.getXMLText(childElement, true)
                    if(formId.isNullOrEmpty())
                        formId = null
                }

                if(childElement.name.equals("form", ignoreCase = true)) {
                    formName = XFormParser.getXMLText(childElement, true)
                    if(formName.isNullOrEmpty())
                        formName = null

                    downloadUrl = childElement.getAttributeValue(null, "url")
                    if(downloadUrl.isNullOrEmpty() || downloadUrl.trim().isNullOrEmpty())
                        downloadUrl = null
                }

                if(formId != null && formName != null && downloadUrl != null) {
                    formDetails.add(FormDetails(formName, downloadUrl, null, formId,
                        null, null, null, false, false))
                }
            }
        }

        return formDetails
    }

    private fun getMediaFiles(documentFetchResult: DocumentFetchResult) : List<MediaFile> {
        val mediaFiles = ArrayList<MediaFile>()

        if(documentFetchResult.isOpenRosaResponse) {
            val manifestElements = documentFetchResult.doc.rootElement
            if(manifestElements.name != "manifest")
                return mediaFiles

            if(!manifestElements.namespace.equals(NAMESPACE_OPENROSA_ORG_XFORMS_XFORMS_MANIFEST, ignoreCase = true))
                return mediaFiles

            for (i in 0 until manifestElements.childCount) {
                if(manifestElements.getType(i) != Element.ELEMENT)
                    continue

                val mediaFileElement = manifestElements.getElement(i)
                if(!mediaFileElement.namespace.equals(NAMESPACE_OPENROSA_ORG_XFORMS_XFORMS_MANIFEST, ignoreCase = true))
                    continue

                if(!mediaFileElement.name.equals("mediaFile", ignoreCase = true))
                    continue

                var filename: String? = null
                var hash: String? = null
                var downloadUrl: String? = null

                for (j in 0 until mediaFileElement.childCount) {
                    if(mediaFileElement.getType(j) != Element.ELEMENT)
                        continue

                    val childElement = mediaFileElement.getElement(j)
                    if(!childElement.namespace.equals(NAMESPACE_OPENROSA_ORG_XFORMS_XFORMS_MANIFEST, ignoreCase = true))
                        continue

                    when(childElement.name) {
                        "filename" -> {
                            filename = XFormParser.getXMLText(childElement, true)
                            if(filename.isNullOrEmpty())
                                filename = null
                        }
                        "downloadUrl" -> {
                            downloadUrl = XFormParser.getXMLText(childElement, true)
                            if(downloadUrl.isNullOrEmpty())
                                downloadUrl = null
                        }
                        "hash" -> {
                            hash = XFormParser.getXMLText(childElement, true)
                            if(hash.isNullOrEmpty())
                                hash = null
                        }
                    }
                }


                if(filename != null && hash != null && downloadUrl != null) {
                    mediaFiles.add(MediaFile(filename, hash, downloadUrl))
                }
            }

        }

        return mediaFiles
    }

    private fun getFormListUrl() : String {
        return "${Collect.getInstance().getString(R.string.default_odk_formlist)}/formList.xml"
    }

    private fun isThisFormAlreadyDownloaded(formId: String): Boolean {
        val cursor = formsDao.getFormsCursorForFormId(formId)
        return cursor == null || cursor.count > 0
    }

    private fun isNewerFormVersionAvailable(md5Hash: String?): Boolean {
        return md5Hash != null && formsDao.getFormsCursorForMd5Hash(md5Hash).count == 0
    }

    private fun areNewerMediaFilesAvailable(
        formId: String,
        formVersion: String?,
        newMediaFiles: List<MediaFile>
    ): Boolean {
        val mediaDirPath = formsDao.getFormMediaPath(formId, formVersion)
        if (mediaDirPath != null) {
            val localMediaFiles = File(mediaDirPath).listFiles()
            if (localMediaFiles != null) {
                for (newMediaFile in newMediaFiles) {
                    if (!isMediaFileAlreadyDownloaded(localMediaFiles, newMediaFile)) {
                        return true
                    }
                }
            } else if (!newMediaFiles.isEmpty()) {
                return true
            }
        }

        return false
    }

    private fun isMediaFileAlreadyDownloaded(localMediaFiles: Array<File>, newMediaFile: MediaFile): Boolean {
        // TODO Zip files are ignored we should find a way to take them into account too
        if (newMediaFile.filename.endsWith(".zip")) {
            return true
        }

        var mediaFileHash = newMediaFile.hash
        mediaFileHash = mediaFileHash.substring(4, mediaFileHash.length)
        for (localMediaFile in localMediaFiles) {
            if (mediaFileHash == FileUtils.getMd5Hash(localMediaFile)) {
                return true
            }
        }
        return false
    }

    private fun handleXmlDocument(formListUrl: String): DocumentFetchResult? {
        var inputStreamReader: InputStreamReader? = null
        var inputStream: InputStream? = null
        var doc: Document? = null

        try {
            inputStream = context.assets.open(formListUrl)
            inputStreamReader = InputStreamReader(inputStream, "UTF-8")
            doc = Document()
            val parser = KXmlParser()
            parser.setInput(inputStreamReader)
            parser.setFeature(XmlPullParser.FEATURE_PROCESS_NAMESPACES, true)
            doc.parse(parser)

            return DocumentFetchResult(doc, true, "")

        } catch (ex: Exception) {
            ex.stackTrace
        } finally {
            inputStream?.close()
            inputStreamReader?.close()
        }

        return null
    }

    private fun handleFormMedia(downloadUrl: String, tempMediaFile: File): Boolean {
        var outputStream: OutputStream? = null
        var inputStream: InputStream? = null

        try {
            inputStream = context.assets.open(downloadUrl)

            outputStream = FileOutputStream(tempMediaFile)
            inputStream.use { input ->
                outputStream.use { output ->
                    input?.copyTo(output)
                }
            }

            return true

        } catch (ex: Exception) {
            ex.stackTrace
        } finally {
            inputStream?.close()
            outputStream?.flush()
            outputStream?.close()
        }

        return false
    }

    private fun downloadForm(formName: String, downloadUrl: String) : File {
        var rootName = formName.replace("[^\\p{L}\\p{Digit}]".toRegex(), " ")
        rootName = rootName.replace("\\p{javaWhitespace}+".toRegex(), " ")
        rootName = rootName.trim()

        var path = StoragePathProvider().getDirPath(StorageSubdirectory.FORMS) + File.separator + rootName + ".xml"
        val file = File(path)
        val tempFile = File.createTempFile(file.name, TEMP_DOWNLOAD_EXTENSION,
            File(StoragePathProvider().getDirPath(StorageSubdirectory.CACHE)))

        val isSuccess = handleFormMedia(downloadUrl, tempFile)
        if(isSuccess) {
            FileUtils.deleteAndReport(file)
            FileUtils.copyFile(tempFile, file)
            FileUtils.deleteAndReport(tempFile)
        } else {
            FileUtils.deleteAndReport(file)
            FileUtils.deleteAndReport(tempFile)
        }

        return file
    }

    private fun downloadMedia(tempMediaDir: File, mediaFile: MediaFile) : Boolean {

        val tempMediaFile = File(tempMediaDir, mediaFile.filename)

        val tempFile = File.createTempFile(tempMediaFile.name, TEMP_DOWNLOAD_EXTENSION,
            File(StoragePathProvider().getDirPath(StorageSubdirectory.CACHE)))

        val isSuccess = handleFormMedia(mediaFile.downloadUrl, tempFile)
        if(isSuccess) {
            FileUtils.deleteAndReport(tempMediaFile)
            FileUtils.copyFile(tempFile, tempMediaFile)
            FileUtils.deleteAndReport(tempFile)

            return true
        } else {
            FileUtils.deleteAndReport(tempMediaFile)
            FileUtils.deleteAndReport(tempFile)
        }

        return false
    }

    private fun saveAndCleanUpData(file: File, tempMediaPath: String?) {
        val parsedFields = FileUtils.getMetadataFromFormDefinition(file)
        val mediaPath = FileUtils.constructMediaPath(file.absolutePath)
        FileUtils.checkMediaPath(File(mediaPath))

        if (isSubmissionOk(parsedFields)) {
            saveNewForm(parsedFields, file, mediaPath)
            if (tempMediaPath != null) {
                val formMediaPath = File(mediaPath)
                FileUtils.moveMediaFiles(tempMediaPath, formMediaPath)
            }
        }

        //cleanUp(file, tempMediaPath)
    }

    private fun isSubmissionOk(parsedFields: Map<String, String>): Boolean {
        val submission = parsedFields[FileUtils.SUBMISSIONURI]
        return submission == null || Validator.isUrlValid(submission)
    }

    private fun saveNewForm(formInfo: Map<String, String>, formFile: File, mediaPath: String) {
        val v = ContentValues()
        v.put(FormsProviderAPI.FormsColumns.FORM_FILE_PATH, formFile.absolutePath)
        v.put(FormsProviderAPI.FormsColumns.FORM_MEDIA_PATH, mediaPath)
        v.put(FormsProviderAPI.FormsColumns.DISPLAY_NAME, formInfo[FileUtils.TITLE])
        v.put(FormsProviderAPI.FormsColumns.JR_VERSION, formInfo[FileUtils.VERSION])
        v.put(FormsProviderAPI.FormsColumns.JR_FORM_ID, formInfo[FileUtils.FORMID])
        v.put(FormsProviderAPI.FormsColumns.SUBMISSION_URI, formInfo[FileUtils.SUBMISSIONURI])
        v.put(FormsProviderAPI.FormsColumns.BASE64_RSA_PUBLIC_KEY, formInfo[FileUtils.BASE64_RSA_PUBLIC_KEY])
        v.put(FormsProviderAPI.FormsColumns.AUTO_DELETE, formInfo[FileUtils.AUTO_DELETE])
        v.put(FormsProviderAPI.FormsColumns.AUTO_SEND, formInfo[FileUtils.AUTO_SEND])
        v.put(FormsProviderAPI.FormsColumns.GEOMETRY_XPATH, formInfo[FileUtils.GEOMETRY_XPATH])
        formsDao.saveForm(v)
    }

    private fun cleanUp(file: File, tempMediaPath: String) {
        formsDao.deleteFormsFromMd5Hash(FileUtils.getMd5Hash(file))
        FileUtils.deleteAndReport(file)

        if (tempMediaPath != null) {
            FileUtils.purgeMediaPath(tempMediaPath)
        }
    }

    private fun deleteOldFormIfExist(formID: String) {
        val cursor = formsDao.getFormsCursorForFormId(formID)
        if(cursor != null && cursor.count > 0) {
            formsDao.deleteFormByFormId(formID)
        }
    }

    /*fun copyBreedMediaToCattleMedia(breedFormId: String, cattleFormId: String) {
        try {
            val breedMedia = FormsDao().getFormMediaPath(breedFormId, null)
            val cattleMedia = FormsDao().getFormMediaPath(cattleFormId, null)

            if(!(breedMedia.isNullOrEmpty() || cattleMedia.isNullOrEmpty())) {
                FileUtils.copyMediaFiles(breedMedia, File(cattleMedia))
            }
        } catch (ex: Exception) {
            ex.stackTrace
        }
    }

    private fun downloadCsvFile(tempMediaDir: File, formId: String, url: String): Boolean {

        val tempMediaFile = File(tempMediaDir, "$formId.zip")
        val isSuccess = handleFormMedia(url, tempMediaFile)
        if (isSuccess) {
            findAndRemoveCsvFiles(tempMediaDir)
            ZipUtils.unzip(arrayOf(tempMediaFile))
            tempMediaFile.delete()
        }

        return isSuccess
    }

    private fun findAndRemoveCsvFiles(tempMediaDir: File) {

        val csvFiles = tempMediaDir.listFiles {
            file -> file.name.toLowerCase(Locale.US).endsWith(".csv")
        }

        for (csvFile in csvFiles) {
            csvFile.delete()
        }
    }

    fun downloadCsvAndMoveToFormMedia() {
        try {
            var downloadUrl =
                "${ShurokkhaApplication.getServerBaseAddress()}${Constants.LIVESTOCK_PART_URL}${Constants.GET_CSV_INFO_URL}?username=${UserUtil.getCurrentUserId()}"
            val tempMediaPath =
                File(Collect.CACHE_PATH, System.currentTimeMillis().toString()).absolutePath
            val tempMediaDir = File(tempMediaPath)
            FileUtils.checkMediaPath(tempMediaDir)

            val isSuccess = downloadCsvFile(tempMediaDir, "temp", downloadUrl)
            if (isSuccess) {
                val farmerMedia = FormsDao().getFormMediaPath(Constants.FARMER_REG_FORM_ID, null)
                val cropMedia = FormsDao().getFormMediaPath(Constants.CATTLE_REG_FORM_ID, null)

                if (!farmerMedia.isNullOrEmpty()) {
                    val farmerMediaDir = File(farmerMedia)
                    FileUtils.checkMediaPath(farmerMediaDir)
                    findAndRemoveCsvFiles(farmerMediaDir)
                    FileUtils.copyMediaFiles(tempMediaPath, farmerMediaDir)
                }

                if (!cropMedia.isNullOrEmpty()) {
                    val cropMediaDir = File(cropMedia)
                    FileUtils.checkMediaPath(cropMediaDir)
                    findAndRemoveCsvFiles(cropMediaDir)
                    FileUtils.copyMediaFiles(tempMediaPath, cropMediaDir)
                }

                FileUtils.purgeMediaPath(tempMediaPath)
            }
        } catch (ex: Exception) {
            ex.stackTrace
        }
    }*/
}