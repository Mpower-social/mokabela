package com.dghs.citizenportal.awaztulun.util

import android.content.Context
import android.net.Uri
import android.provider.MediaStore

fun Uri.getFilePath(context: Context): String? {
  var filePath: String? = null
  val projection = arrayOf(MediaStore.Images.Media.DATA)
  val cursor = context.contentResolver.query(this, projection, null, null, null)
  cursor?.let {
    if (cursor.moveToFirst()) {
      val columnIndex = cursor.getColumnIndexOrThrow(projection[0])
      filePath = cursor.getString(columnIndex)
    }

    cursor.close()
  }

  return filePath
}