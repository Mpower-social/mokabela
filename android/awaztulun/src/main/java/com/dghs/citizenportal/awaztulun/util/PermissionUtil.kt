package com.dghs.citizenportal.awaztulun.util

import android.Manifest
import android.Manifest.*
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import androidx.core.content.ContextCompat
import com.karumi.dexter.Dexter
import com.karumi.dexter.MultiplePermissionsReport
import com.karumi.dexter.PermissionToken
import com.karumi.dexter.listener.PermissionDeniedResponse
import com.karumi.dexter.listener.PermissionGrantedResponse
import com.karumi.dexter.listener.PermissionRequest
import timber.log.Timber

object PermissionUtil {
  fun isCameraPermissionGranted(context: Context) = isPermissionGranted(context, permission.CAMERA)

  fun requestCameraPermission(context: Context, action: PermissionListener) {
    Dexter.withContext(context)
      .withPermission(permission.CAMERA)
      .withListener(object: com.karumi.dexter.listener.single.PermissionListener {
        override fun onPermissionGranted(response: PermissionGrantedResponse?) {
          action.granted()
        }

        override fun onPermissionDenied(response: PermissionDeniedResponse?) {
          action.denied()
        }

        override fun onPermissionRationaleShouldBeShown(
          permission: PermissionRequest?,
          token: PermissionToken?
        ) {
          token?.continuePermissionRequest()
        }
      })
      .withErrorListener {
        Timber.i(it.name)
      }
      .check()
  }

  fun isNotificationPermissionGranted(context: Context): Boolean {
    return if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
      isPermissionGranted(context, permission.POST_NOTIFICATIONS)
    } else {
      true
    }
  }

  fun requestNotificationPermission(context: Context, action: PermissionListener) {
    if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
      Dexter.withContext(context)
        .withPermission(permission.POST_NOTIFICATIONS)
        .withListener(object : com.karumi.dexter.listener.single.PermissionListener {
          override fun onPermissionGranted(response: PermissionGrantedResponse?) {
            action.granted()
          }

          override fun onPermissionDenied(response: PermissionDeniedResponse?) {
            action.denied()
          }

          override fun onPermissionRationaleShouldBeShown(
            permission: PermissionRequest?,
            token: PermissionToken?
          ) {
            token?.continuePermissionRequest()
          }
        })
        .withErrorListener {
          Timber.i(it.name)
        }
        .check()
    }
  }

  fun isLocationPermissionGranted(context: Context) = isPermissionGranted(context, permission.ACCESS_FINE_LOCATION, permission.ACCESS_COARSE_LOCATION)

  fun requestLocationPermission(context: Context, action: PermissionListener? = null) {
    Dexter.withContext(context)
      .withPermissions(permission.ACCESS_FINE_LOCATION, permission.ACCESS_COARSE_LOCATION)
      .withListener(object: com.karumi.dexter.listener.multi.MultiplePermissionsListener {
        override fun onPermissionsChecked(report: MultiplePermissionsReport?) {
          report?.let {
            if(it.areAllPermissionsGranted())
              action?.granted()
            else
              action?.denied()
          } ?: action?.denied()
        }

        override fun onPermissionRationaleShouldBeShown(
          permissions: MutableList<PermissionRequest>?,
          token: PermissionToken?
        ) {
          token?.continuePermissionRequest()
        }
      })
      .withErrorListener {
        Timber.i(it.name)
      }
      .check()
  }

  private fun isPermissionGranted(context: Context, vararg permissions: String): Boolean {
    permissions.forEach {
      if(ContextCompat.checkSelfPermission(context, it) != PackageManager.PERMISSION_GRANTED) {
        return false
      }
    }

    return true
  }

  interface PermissionListener {
    fun granted()
    fun denied()
  }
}