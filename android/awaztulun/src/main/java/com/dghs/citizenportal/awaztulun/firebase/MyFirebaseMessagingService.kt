package com.dghs.citizenportal.awaztulun.firebase

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.ContentResolver
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.media.AudioAttributes
import android.net.Uri
import android.os.Build
import android.text.Html
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationCompat.PRIORITY_HIGH
import com.dghs.citizenportal.awaztulun.CitizenApplication
import com.dghs.citizenportal.awaztulun.NewMainAwaztulunActivity
import com.dghs.citizenportal.awaztulun.R
import com.dghs.citizenportal.awaztulun.network.ApiService
import com.dghs.citizenportal.awaztulun.util.SharedPreferenceUtil
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import io.reactivex.disposables.Disposable
import javax.inject.Inject

/**
 * Created by Mahmud
on 2024
 */
class MyFirebaseMessagingService : FirebaseMessagingService() {

    @Inject
    lateinit var apiService: ApiService
    @Inject
    lateinit var preferenceUtil: SharedPreferenceUtil

    var subscription: Disposable? = null

    override fun onCreate() {
        super.onCreate()
        (application as CitizenApplication).getCitizenComponent().injectService(this)
    }

    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        Log.v("FIREBASE_MESSAGE","remoteMessage"+remoteMessage)
        Log.v("FIREBASE_MESSAGE",remoteMessage.data.toString());
        if (remoteMessage.data.isNotEmpty()) {
            sendNotification(remoteMessage)
        }

    }

    override fun onNewToken(token: String) {
        super.onNewToken(token)
        if(token.isEmpty()) return
        preferenceUtil.setValue(SharedPreferenceUtil.KEY_FIREBASE_TOKEN, token)
        preferenceUtil.setValue(SharedPreferenceUtil.KEY_FIREBASE_TOKEN_SYNCED, false)
    }

    private fun sendNotification(remoteMessage: RemoteMessage) {

        remoteMessage.data["incidentId"]?.let {
            val alarmSound = R.raw.alarm
            val defaultSoundUri = Uri.parse(ContentResolver.SCHEME_ANDROID_RESOURCE+"://$packageName/$alarmSound")

            val title = remoteMessage.data["title"] ?: ""
            val incidentId = remoteMessage.data["incidentId"]
            val message = remoteMessage.data["message"] ?: ""

            val mNotificationId = System.currentTimeMillis() / 1000
            val launchIntent = Intent(this, NewMainAwaztulunActivity::class.java).apply {
                putExtra("CURRENT_INCIDENT_ID", incidentId)
            }


            val pendingIntent = PendingIntent.getActivity(this, 0, launchIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
            val notificationBuilder = NotificationCompat.Builder(CitizenApplication.getInstance(), getString(R.string.notification_channel_id))
                .setContentTitle(title)
                .setContentText(Html.fromHtml(message))
                .setSmallIcon(R.drawable.dghs_govt)
                .setColor(resources.getColor(R.color.blue))
                .setBadgeIconType(NotificationCompat.BADGE_ICON_SMALL)
//            .setDefaults(NotificationCompat.DEFAULT_ALL)
                .setStyle(NotificationCompat.BigTextStyle().bigText(Html.fromHtml(message)))
                .setContentIntent(pendingIntent)
                .setPriority(PRIORITY_HIGH)
                .setAutoCancel(true)
                .setSound(defaultSoundUri)

            val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val pattern = longArrayOf(500, 500, 500, 500, 500, 500, 500, 500, 500)
                val audioAttributes = AudioAttributes.Builder()
                    .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .setUsage(AudioAttributes.USAGE_NOTIFICATION)
                    .build()
                val notificationChannel = NotificationChannel(
                    getString(R.string.notification_channel_id),
                    getString(R.string.notification_channel_name),
                    NotificationManager.IMPORTANCE_HIGH)
                notificationChannel.setSound(defaultSoundUri, audioAttributes)
                notificationChannel.enableLights(true)
                notificationChannel.enableVibration(true)
                notificationChannel.lightColor = Color.RED
                notificationManager.createNotificationChannel(notificationChannel)
            }
            val mNotification: android.app.Notification = notificationBuilder.build()
            notificationManager.notify(mNotificationId.toInt(), mNotification)
        }
    }

}