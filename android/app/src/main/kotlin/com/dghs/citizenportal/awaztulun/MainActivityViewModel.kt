package com.dghs.citizenportal.awaztulun

import com.dghs.citizenportal.awaztulun.base.BaseViewModel
import com.dghs.citizenportal.awaztulun.util.SharedPreferenceUtil
import javax.inject.Inject

class MainActivityViewModel: BaseViewModel() {
    @Inject
    lateinit var sharedPreferenceUtil: SharedPreferenceUtil


}