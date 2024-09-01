package com.dghs.citizenportal.awaztulun.settings

import androidx.lifecycle.MutableLiveData
import com.dghs.citizenportal.awaztulun.base.BaseViewModel
import com.dghs.citizenportal.awaztulun.util.SharedPreferenceUtil
import javax.inject.Inject

class SettingsViewModel:BaseViewModel() {
    @Inject
    lateinit var sharedPreferenceUtil: SharedPreferenceUtil
    var mutableNotification = MutableLiveData<Int>()
    var mutableAppUpdate = MutableLiveData<Boolean>()
    var mutablePrivacyPolicy= MutableLiveData<Boolean>()
    var appVersion = String()
    fun updateApp(){
        mutableAppUpdate.value = true
    }
    fun privacyPolicyClick(){
        mutablePrivacyPolicy.value = true
    }
}