package com.dghs.citizenportal.awaztulun

import android.content.Context
import androidx.multidex.MultiDex
import androidx.multidex.MultiDexApplication
import com.dghs.citizenportal.awaztulun.di.components.CitizenComponent
import com.dghs.citizenportal.awaztulun.di.components.DaggerCitizenComponent
import com.dghs.citizenportal.awaztulun.di.modules.*
import com.dghs.citizenportal.awaztulun.util.SharedPreferenceUtil
import javax.inject.Inject

class CitizenApplication: MultiDexApplication() {
    @Inject lateinit var preferenceUtil: SharedPreferenceUtil

    private lateinit var citizenComponent: CitizenComponent
    companion object {
        private lateinit var citizenApplication: CitizenApplication
        fun getInstance(): CitizenApplication {
            return citizenApplication
        }
    }
    override fun onCreate() {
        super.onCreate()
        citizenApplication = this
        citizenComponent = DaggerCitizenComponent.builder()
            .apiModule(ApiModule)
            .contextModule(ContextModule(this))
            .okHttpClientModule(OkHttpModule)
            .networkModule(NetworkModule)
            .build()
        citizenComponent.injectApplication(this)
    }

    override fun attachBaseContext(base: Context?) {
        super.attachBaseContext(base)
        MultiDex.install(this)
    }

    fun getServerBaseUrl():String{
        return getString(R.string.default_server_url);
    }

    fun getCitizenComponent(): CitizenComponent = citizenComponent
}