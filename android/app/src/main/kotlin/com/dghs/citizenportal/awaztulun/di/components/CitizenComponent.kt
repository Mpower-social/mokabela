package com.dghs.citizenportal.awaztulun.di.components

import com.dghs.citizenportal.awaztulun.MainActivityViewModel
import com.dghs.citizenportal.awaztulun.home.HomeViewModel
import com.dghs.citizenportal.awaztulun.di.modules.ApiModule
import com.dghs.citizenportal.awaztulun.di.modules.NetworkModule
import com.dghs.citizenportal.awaztulun.di.modules.OkHttpModule
import com.dghs.citizenportal.awaztulun.di.scope.CitizenScope
import com.dghs.citizenportal.awaztulun.firebase.MyFirebaseMessagingService
import com.dghs.citizenportal.awaztulun.incident.IncidentViewModel
import com.dghs.citizenportal.awaztulun.report.ReportViewModel
import com.dghs.citizenportal.awaztulun.settings.SettingsViewModel
import dagger.Component
import org.odk.collect.android.injection.config.AppDependencyComponent

/**
 * Created by mahmud
on 30 aug 2023
 */

@CitizenScope
@Component(modules = [ApiModule::class], dependencies = [AppDependencyComponent::class])
interface CitizenComponent {

    fun injectService(activity: MyFirebaseMessagingService)
    fun injectViewModel(viewModel: HomeViewModel)
    fun injectViewModel(viewModel: ReportViewModel)
    fun injectViewModel(viewModel: IncidentViewModel)
    fun injectViewModel(viewModel: SettingsViewModel)
    fun injectViewModel(viewModel: MainActivityViewModel)
    @Component.Builder
    interface Builder {
        fun build(): CitizenComponent
        fun appComponent(appComponent: AppDependencyComponent): Builder
        fun apiModule(apiModule: ApiModule): Builder
        fun networkModule(networkModule: NetworkModule): Builder
        fun okHttpClientModule(okHttpClientModule: OkHttpModule): Builder
    }
}