package com.dghs.citizenportal.awaztulun.base

import android.view.View
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.dghs.citizenportal.awaztulun.CitizenApplication
import com.dghs.citizenportal.awaztulun.MainActivityViewModel
import com.dghs.citizenportal.awaztulun.home.HomeViewModel
import com.dghs.citizenportal.awaztulun.incident.IncidentViewModel
import com.dghs.citizenportal.awaztulun.report.ReportViewModel
import com.dghs.citizenportal.awaztulun.settings.SettingsViewModel

abstract class BaseViewModel: ViewModel() {
    val progressVisibility: MutableLiveData<Int> = MutableLiveData()
    val errorMessage: MutableLiveData<String> = MutableLiveData()
    val successMessage: MutableLiveData<String> = MutableLiveData()
    var data: MutableLiveData<Any?> = MutableLiveData()
    val retryMessage: MutableLiveData<String> = MutableLiveData()
    private val viewModelInjector = CitizenApplication.getInstance().getCitizenComponent()

    init {
        inject()
    }

    private fun inject() {
        when (this) {

            is HomeViewModel -> viewModelInjector.injectViewModel(this)
            is ReportViewModel -> viewModelInjector.injectViewModel(this)
            is IncidentViewModel -> viewModelInjector.injectViewModel(this)
            is SettingsViewModel -> viewModelInjector.injectViewModel(this)
            is MainActivityViewModel -> viewModelInjector.injectViewModel(this)
        }
    }

    fun onRetrieveStart() {
        progressVisibility.value = View.VISIBLE
    }

    fun onRetrieveFinish() {
        progressVisibility.value = View.GONE
    }
//    abstract fun onRetrieveSuccess(result: Any?, optName : String)
//    abstract fun onRetrieveError(error: Any?,  optName : String)
}