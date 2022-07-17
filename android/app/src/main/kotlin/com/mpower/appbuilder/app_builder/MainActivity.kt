package com.mpower.appbuilder.app_builder

import android.annotation.SuppressLint
import android.content.ContentUris
import android.content.ContentValues
import android.content.Intent
import android.database.sqlite.SQLiteDatabase
import android.net.Uri
import android.util.Log
import android.widget.Toast
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import com.mpower.appbuilder.app_builder.models.FormInstance
import com.mpower.appbuilder.app_builder.utills.AssetFormDownloadUtil
import org.odk.collect.android.activities.*
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import io.reactivex.Observable
import io.reactivex.disposables.CompositeDisposable
import io.reactivex.schedulers.Schedulers
import org.odk.collect.android.application.Collect
import org.odk.collect.android.dao.FormsDao
import org.odk.collect.android.dao.InstancesDao
import org.odk.collect.android.listeners.PermissionListener
import org.odk.collect.android.preferences.GeneralKeys.KEY_USERNAME
import org.odk.collect.android.provider.FormsProviderAPI
import org.odk.collect.android.provider.InstanceProviderAPI
import org.odk.collect.android.provider.InstanceProviderAPI.InstanceColumns
import org.odk.collect.android.storage.StorageInitializer
import org.odk.collect.android.utilities.PermissionUtils

class MainActivity: FlutterActivity() {
    private val CHANNEL = "flutter_to_odk_communication"
    private var channelResult: MethodChannel.Result? = null
    private var formArguments: Map<String, Any>? = null
    private lateinit var database: SQLiteDatabase
    private var subscriptions: CompositeDisposable = CompositeDisposable()

    override fun configureFlutterEngine(flutterEngine: FlutterEngine){
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            channelResult = result

            PermissionUtils().requestStoragePermissions(this, object: PermissionListener {
                override fun granted() {
                    when {
                        call.method.equals("openForm", true) -> {
                            val formId = call.argument<String>("formId")
                            formArguments = call.argument<Map<String, Any>>("arguments")
                            formArguments?.entries?.forEach { entry ->
                                Collect.getInstance().setValue(entry.key, entry.value.toString())
                            }

                            openOdkForm(formId)
                        }
                        call.method.equals("editForm", true) -> {
                            val instanceId = call.argument<Long>("instanceId")

                            instanceId?.let {
                                editOdkForm(it)
                            }
                        }
                        call.method.equals("draftForms", true) -> {
                            val formIds = call.argument<List<String>>("formIds")
                            val forms = getDraftForms(formIds ?: emptyList())
                            channelResult?.success(forms)
                        }
                        call.method.equals("finalizedForms", true) -> {
                            val formIds = call.argument<List<String>>("formIds")
                            val forms = getFinalizedForms(formIds ?: emptyList())
                            channelResult?.success(forms)
                        }
                        call.method.equals("sendBackToDraft", true) -> {
                            val instanceId = call.argument<Long>("instanceId")
                            instanceId?.let {
                                sendBackToDraft(it)
                            }
                        }
                        call.method.equals("deleteDraft", true) -> {
                            val instanceId = call.argument<Long>("instanceId")
                            instanceId?.let {
                                deleteDraftForm(it)
                            }
                        }
                        call.method.equals("initializeOdk", true) -> {
                            val formXml = call.argument<String>("xmlData")
                            val username = call.argument<String>("username") ?: "bahis_ulo"
                            initializeOdk(username)

                            subscriptions.add(Observable.fromCallable {AssetFormDownloadUtil(this@MainActivity).getForms(formXml)}
                                .subscribeOn(Schedulers.io())
                                .subscribe(
                                    {
                                       // fetchGeoCsvAndProcess()
                                        Log.v("Form Download: ", "Success")
                                    },
                                    { Log.v("Form Download: ", "Failure") }
                                )
                            )
                        }
                        else -> {
                            startActivityFromFlutter(call.method)
                        }
                    }

                  //  database = SQLiteDatabase.openDatabase(getDatabasePath("app_builder.db").absolutePath,null, SQLiteDatabase.OPEN_READWRITE)
                }

                override fun denied() {
                    channelResult?.error("Permission Required", "Failed", null)
                }
            })
        }
    }

    @SuppressLint("Range")
    private fun openOdkForm(formId: String?) {
        val formCursor = FormsDao().getFormsCursorForFormId(formId)
        if(formCursor != null && formCursor.count > 0) {
            formCursor.moveToFirst()
            val idFormsTable = formCursor.getLong(formCursor.getColumnIndex(FormsProviderAPI.FormsColumns._ID))
            val formUri = ContentUris.withAppendedId(FormsProviderAPI.FormsColumns.CONTENT_URI, idFormsTable)
            openEditOdkForm(formUri)
        } else {
            channelResult?.error("Related form not found", "failed", null)
            Toast.makeText(this, "Related form not found", Toast.LENGTH_SHORT).show()
        }
    }

    private fun editOdkForm(id: Long) {
        val instanceUri = ContentUris.withAppendedId(InstanceColumns.CONTENT_URI, id)
        openEditOdkForm(instanceUri)
    }

    private fun openEditOdkForm(uri: Uri) {
        val intent = Intent(Intent.ACTION_EDIT, uri)
        startActivityForResult(intent, 101)
    }

    private fun startActivityFromFlutter(methodName: String) {
        val intent = Intent(this, when(methodName) {
            "goToHouseholdForms" -> FormDownloadList::class.java
            "goToDownloadForms" -> FormDownloadList::class.java
            "goToDraftForms" -> InstanceChooserList::class.java
            "goToSendForms" -> InstanceUploaderListActivity::class.java
            else -> FileManagerTabs::class.java
        })

        startActivity(intent)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        if(requestCode == 100 && data!=null) {
            val value = data.getStringExtra("data")
            if(channelResult!=null) channelResult?.success(value)
            //if(channelResult!=null) channelResult?.success(value)
        }

        if(requestCode == 101 && data!=null && data.data != null) {
            val value = data.data
            val instancePath = getFormInstancePath(value!!)
            if(channelResult!=null) channelResult?.success(instancePath)
           // if(channelResult!=null) channelResult?.success(instancePath)
        }

        //Reset shared preference items to avoid duplicate data in case of missing arguments
        formArguments?.entries?.forEach { entry ->
            Collect.getInstance().setValue(entry.key, "")
        }
    }

    private fun getFormInstancePath(instanceUri: Uri): String {
        val instanceId = ContentUris.parseId(instanceUri).toString()
        return InstancesDao().getInstancePathForInstanceId(instanceId)
    }

    private fun initializeOdk(username: String) {

        Collect.getInstance().setValue(KEY_USERNAME, username)
        Collect.getInstance().initializeJavaRosa()
        StorageInitializer().createOdkDirsOnStorage()
    }

    @SuppressLint("Range")
    private fun getDraftForms(formIds: List<String>): String {
        val cursor = if(formIds.isEmpty())
            InstancesDao().draftInstancesCursor
        else {
            var selection = "${ InstanceColumns.JR_FORM_ID } IN("
            repeat(formIds.size) {
                selection += "?"
            }
            selection = "${ selection.trimEnd(',') })"

            InstancesDao().getDraftInstancesCursor(selection, formIds)
        }

        val formInstances = generateSequence { if (cursor.moveToNext()) cursor else null }
            .map {
                FormInstance(
                    id = it.getLong(it.getColumnIndex(InstanceColumns._ID)),
                    formId = it.getString(it.getColumnIndex(InstanceColumns.JR_FORM_ID)),
                    displayName = it.getString(it.getColumnIndex(InstanceColumns.DISPLAY_NAME)),
                    projectId = it.getString(it.getColumnIndex(InstanceColumns.MODULE_ID)),
                    instanceId = it.getString(it.getColumnIndex(InstanceColumns.INSTANCE_ID)),
                    instanceFilePath = it.getString(it.getColumnIndex(InstanceColumns.INSTANCE_FILE_PATH)),
                    lastChangeDate = it.getLong(it.getColumnIndex(InstanceColumns.LAST_STATUS_CHANGE_DATE))
                )
            }
            .toList()

        return Gson().toJson(formInstances)
    }

    @SuppressLint("Range")
    private fun getFinalizedForms(formIds: List<String>): String {
        val cursor = if(formIds.isEmpty())
            InstancesDao().finalizedInstancesCursor
        else {
            var selection = "${ InstanceColumns.JR_FORM_ID } IN("
            repeat(formIds.size) {
                selection += "?, "
            }
            selection = "${ selection.trimEnd(',') })"

            InstancesDao().getFinalizedInstancesCursor(selection, formIds)
        }

        val formInstances = generateSequence { if (cursor.moveToNext()) cursor else null }
            .map {
                FormInstance(
                    id = it.getLong(it.getColumnIndex(InstanceColumns._ID)),
                    formId = it.getString(it.getColumnIndex(InstanceColumns.JR_FORM_ID)),
                    displayName = it.getString(it.getColumnIndex(InstanceColumns.DISPLAY_NAME)),
                    projectId = it.getString(it.getColumnIndex(InstanceColumns.MODULE_ID)),
                    instanceId = it.getString(it.getColumnIndex(InstanceColumns.INSTANCE_ID)),
                    instanceFilePath = it.getString(it.getColumnIndex(InstanceColumns.INSTANCE_FILE_PATH)),
                    lastChangeDate = it.getLong(it.getColumnIndex(InstanceColumns.LAST_STATUS_CHANGE_DATE))
                )
            }
            .toList()

        return Gson().toJson(formInstances)
    }

    private fun sendBackToDraft(id: Long) {
        val instanceUri = Uri.withAppendedPath(InstanceColumns.CONTENT_URI, id.toString())
        val contentValues = ContentValues().apply {
            put(InstanceColumns.STATUS, InstanceProviderAPI.STATUS_INCOMPLETE)
        }

        Collect.getInstance().contentResolver.update(instanceUri, contentValues, null, null)
    }

    private fun deleteDraftForm(id: Long) {
        val instanceUri = Uri.withAppendedPath(InstanceColumns.CONTENT_URI, id.toString())
        Collect.getInstance().contentResolver.delete(instanceUri, null, null)
    }
}

