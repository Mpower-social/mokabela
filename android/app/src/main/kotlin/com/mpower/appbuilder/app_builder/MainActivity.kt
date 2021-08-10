package com.mpower.appbuilder.app_builder

import android.content.ContentUris
import android.content.Intent
import android.database.sqlite.SQLiteDatabase
import android.net.Uri
import android.widget.Toast
import com.mpower.appbuilder.app_builder.utills.AssetFormDownloadUtil
import org.odk.collect.android.activities.*
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import org.odk.collect.android.application.Collect
import org.odk.collect.android.dao.FormsDao
import org.odk.collect.android.dao.InstancesDao
import org.odk.collect.android.listeners.PermissionListener
import org.odk.collect.android.preferences.GeneralKeys.KEY_USERNAME
import org.odk.collect.android.provider.FormsProviderAPI
import org.odk.collect.android.storage.StorageInitializer
import org.odk.collect.android.utilities.PermissionUtils

class MainActivity: FlutterActivity() {
    private val CHANNEL = "flutter_to_odk_communication"
    private var channelResult: MethodChannel.Result? = null
    private var formArguments: Map<String, Any>? = null
    private lateinit var database: SQLiteDatabase

    override fun configureFlutterEngine(flutterEngine: FlutterEngine){
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            channelResult = result

            PermissionUtils().requestStoragePermissions(this, object: PermissionListener {
                override fun granted() {
                    when {
                        call.method.equals("openForms", true) -> {
                            val formId = call.argument<String>("formId")
                            formArguments = call.argument<Map<String, Any>>("arguments")
                            formArguments?.entries?.forEach { entry ->
                                Collect.getInstance().setValue(entry.key, entry.value.toString())
                            }

                            openOdkForm(formId)
                        }
                        call.method.equals("initializeOdk", true) -> {
                            val username = call.argument<String>("username") ?: "bahis_ulo"
                            initializeOdk(username)
                            AssetFormDownloadUtil(this@MainActivity).getForms()
                        }
                        else -> {
                            startActivityFromFlutter(call.method)
                        }
                    }

                    database = SQLiteDatabase.openDatabase(getDatabasePath("app_builder.db").absolutePath,null, SQLiteDatabase.OPEN_READWRITE)
                }

                override fun denied() {
                    channelResult?.error("Permission Required", "Failed", null)
                }
            })
        }
    }

    private fun openOdkForm(formId: String?) {
        val formCursor = FormsDao().getFormsCursorForFormId(formId)
        if(formCursor != null && formCursor.count > 0) {

            formCursor.moveToFirst()
            val idFormsTable = formCursor.getLong(formCursor.getColumnIndex(FormsProviderAPI.FormsColumns._ID))
            val formUri = ContentUris.withAppendedId(FormsProviderAPI.FormsColumns.CONTENT_URI, idFormsTable)
            openOdkForm(formUri)
        } else {
            channelResult?.error("Related form not found", "failed", null)
            Toast.makeText(this, "Related form not found", Toast.LENGTH_SHORT).show()
        }
    }

    private fun openOdkForm(formUri: Uri) {
        val intent = Intent(Intent.ACTION_EDIT, formUri)
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
            var value = data.getStringExtra("data")
            if(channelResult!=null) channelResult?.success(value)
        }

        if(requestCode == 101 && data!=null && data.data != null) {
            var value = data.data
            val instancePath = getFormInstancePath(value!!)
            if(channelResult!=null) channelResult?.success(instancePath)
        }

        //Reset shared preference items to avoid duplicate data in case of missing arguments
        formArguments?.entries?.forEach { entry ->
            Collect.getInstance().setValue(entry.key, "")
        }
    }

    private fun getFormInstancePath(instanceUri: Uri): String {
        val instanceId = ContentUris.parseId(instanceUri).toString()
        return InstancesDao().getInstancePathForInstanceId(instanceId);
    }

    private fun initializeOdk(username: String) {
        Collect.getInstance().setValue(KEY_USERNAME, username)
        Collect.getInstance().initializeJavaRosa()
        StorageInitializer().createOdkDirsOnStorage()
    }
}

