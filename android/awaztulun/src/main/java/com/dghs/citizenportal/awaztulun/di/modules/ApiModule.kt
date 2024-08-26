package com.dghs.citizenportal.awaztulun.di.modules

import com.dghs.citizenportal.awaztulun.network.ApiService
import dagger.Module
import dagger.Provides
import retrofit2.Retrofit

/**
 * Created by mahmud
on 30 aug 2023
 */

@Module(includes = [NetworkModule::class])
object ApiModule {
    @Provides
    internal fun apiService(retrofit: Retrofit): ApiService {
        return retrofit.create(ApiService::class.java)
    }

}