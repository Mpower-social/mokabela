package com.dghs.citizenportal.awaztulun.util

import android.content.Context
import android.content.SharedPreferences
import javax.inject.Inject

class SharedPreferenceUtil @Inject constructor(private var context: Context) {

    private val sharedPreferences: SharedPreferences = context.getSharedPreferences("com.dghs.citizenportal.awaztulun", Context.MODE_PRIVATE);

    companion object {
        const val DOB = "dob"
        const val BRN = "brn"
        const val ACCESS_TOKEN = "access_token"
        const val REFRESH_TOKEN = "refresh_token"
        const val FIRST_NAME = "firstName"
        const val GENDER = "gender"
        const val MOTHER_NAME = "motherName"
        const val PASSPORT = "passport"
        const val EMAIL = "email"
        const val MOBILE = "mobile"
        const val DIVISION = "division"
        const val DISTRICT = "district"
        const val UPAZILA = "upazila"
        const val UNION = "union"
        const val KEY_FIREBASE_TOKEN = "firebase_token"
        const val KEY_FIREBASE_TOKEN_SYNCED = "firebase_token_synced"
        const val DEVICE_ID = "device_id"
        const val IS_NOTIFY = "is_notify"
   }

    fun getValue(key: String, default: Any?): Any? {
        return when(default) {
            is Boolean -> sharedPreferences.getBoolean(key, default)
            is String -> sharedPreferences.getString(key, default)
            is Int -> sharedPreferences.getInt(key, default)
            is Float -> sharedPreferences.getFloat(key,default)
            else -> sharedPreferences.getString(key, default as String?)
        }
    }

    fun setValue(key: String, value: Any?) {
        when(value) {
            is Boolean -> sharedPreferences.edit().putBoolean(key, value).apply()
            is String -> sharedPreferences.edit().putString(key, value).commit()
            is Float -> sharedPreferences.edit().putFloat(key,value).apply()
            is Int -> sharedPreferences.edit().putInt(key, value).apply()
        }
    }
    fun clear(key: String){
        sharedPreferences.edit().remove(key).apply()
    }
    fun clearAll(){
        sharedPreferences.edit().clear().commit()
    }
}