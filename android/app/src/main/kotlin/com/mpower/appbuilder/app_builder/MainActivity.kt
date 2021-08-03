package com.mpower.appbuilder.app_builder

import android.content.ContentUris
import android.content.Intent
import android.database.sqlite.SQLiteDatabase
import android.net.Uri
import android.util.Log
import android.widget.Toast
import org.odk.collect.android.activities.*
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import org.odk.collect.android.application.Collect
import org.odk.collect.android.dao.FormsDao
import org.odk.collect.android.listeners.PermissionListener
import org.odk.collect.android.provider.FormsProviderAPI
import org.odk.collect.android.utilities.PermissionUtils
import java.util.*

class MainActivity: FlutterActivity() {
    private val CHANNEL = "flutter_to_odk_activity"
    private lateinit var channelResult: MethodChannel.Result
    private lateinit var database: SQLiteDatabase

    override fun configureFlutterEngine(flutterEngine: FlutterEngine){
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            channelResult = result

            PermissionUtils().requestStoragePermissions(this, object: PermissionListener {
                override fun granted() {
                    if(call.method.equals("goToHouseholdForms", true)) {
                        var formId: String? = call.argument<String>("formId")
                        Collect.getInstance().setValue("hh_id", UUID.randomUUID().toString())
                        Collect.getInstance().setValue("member_id", UUID.randomUUID().toString())
                        openOdkForm(formId)
                    } else {
                        startActivityFromFlutter(call.method)
                    }

                    database = SQLiteDatabase.openDatabase(getDatabasePath("app_builder.db").absolutePath,null, SQLiteDatabase.OPEN_READWRITE);
                }

                override fun denied() {
                    channelResult.error("Permission Required", "Failed", null)
                }
            })
        }
    }

    private fun openOdkForm(formId: String?) {

        /*val formMediaPath = "/storage/emulated/0/flutter_with_odk/forms/Household Registration-media" /*FormsDao().getFormMediaPath(formId, null)*/
        val instancePath = "/storage/emulated/0/flutter_with_odk/instances/Household Registration_2021-01-25_17-02-30/Household Registration_2021-01-25_17-02-30.xml" /*InstancesDao().getInstancePathForInstanceId(instanceId)*/

        val parseModels = parseXmlContent(formMediaPath, instancePath)*/

        var formCursor = FormsDao().getFormsCursorForFormId(formId)
        if(formCursor != null && formCursor.count > 0) {

            formCursor.moveToFirst()
            val idFormsTable = formCursor.getLong(formCursor.getColumnIndex(FormsProviderAPI.FormsColumns._ID))
            val formUri = ContentUris.withAppendedId(FormsProviderAPI.FormsColumns.CONTENT_URI, idFormsTable)
            openOdkForm(formUri)
        } else {
            channelResult.error("Related form not found", "failed", null)
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
            var value = data.getStringExtra("data");
            Log.v("SSLComerz","main>>>"+value.toString())
            if(channelResult!=null) channelResult.success(value)
        }

        if(requestCode == 101 && data!=null && data.data != null) {
            var value = data.data
            //val data = getDataFromUri(value!!)
            Log.v("SSLComerz","main>>>"+value.toString())
            if(channelResult!=null) channelResult.success("success")
        }
    }
}

