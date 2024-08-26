package com.dghs.citizenportal.awaztulun.di.modules

import android.content.Context
import com.dghs.citizenportal.awaztulun.CitizenApplication
import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.jakewharton.retrofit2.adapter.kotlin.coroutines.CoroutineCallAdapterFactory
import dagger.Module
import dagger.Provides
import okhttp3.OkHttpClient
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

/**
 * Created by mahmud
on 30 aug 2023
 */

@Module(includes = [OkHttpModule::class])
object NetworkModule {

    @Provides
    internal fun retrofit(context: Context, okHttpClient: OkHttpClient,coroutineCallAdapterFactory: CoroutineCallAdapterFactory, gsonConverterFactory: GsonConverterFactory, gson: Gson): Retrofit {
        return Retrofit.Builder()
                .client(okHttpClient)
                .baseUrl((context.applicationContext as CitizenApplication).getServerBaseUrl())
                .addConverterFactory(gsonConverterFactory)
                .addCallAdapterFactory(coroutineCallAdapterFactory)
                .build()
    }

    @Provides
    internal fun GsonConverterFactory(gson: Gson): GsonConverterFactory {
        return GsonConverterFactory.create(gson)
    }

    @Provides
    internal fun  GetCoroutineCallAdapterFactory (): CoroutineCallAdapterFactory {
        return CoroutineCallAdapterFactory()
    }

    @Provides
    internal fun Gson(): Gson {
        return GsonBuilder().setLenient().serializeNulls().setPrettyPrinting().create()
    }

}