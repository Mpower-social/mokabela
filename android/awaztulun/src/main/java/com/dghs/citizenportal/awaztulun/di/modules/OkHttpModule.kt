package com.dghs.citizenportal.awaztulun.di.modules

import android.content.Context
import android.util.Log
import dagger.Module
import dagger.Provides
import okhttp3.Cache
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import timber.log.Timber
import java.io.File
import java.util.concurrent.TimeUnit

/**
 * Created by mahmud
on 30 aug 2023
 */

@Module(includes = [ContextModule::class])
object OkHttpModule {
    @Provides
    internal fun okHttpClient(cache: Cache, interceptor: HttpLoggingInterceptor): OkHttpClient {
        return OkHttpClient().newBuilder()
                .addInterceptor(interceptor)
//                .addInterceptor(Interceptor {
//                    chain ->
//                    val builder = chain.request().newBuilder()
//                    builder.header("Cache-control", "no-cache")
//                    builder.header("Content-Type", "application/x-www-form-urlencoded")
//                    return@Interceptor chain.proceed(builder.build())
//                })
                .connectTimeout(30, TimeUnit.SECONDS)
                .readTimeout(30, TimeUnit.SECONDS)
                .writeTimeout(30, TimeUnit.SECONDS)
                .cache(cache)
                .build()
    }

    @Provides
    internal fun cache(file: File): Cache {
        return Cache(file, (10 * 1000 * 1000).toLong()) //10 MB
    }

    @Provides
    internal fun file(context: Context): File {
        val file = File(context.cacheDir, "HttpCache")
        file.mkdirs()
        return file
    }

    @Provides
    internal fun loggingInterceptor(): HttpLoggingInterceptor {
        val loggingInterceptor = HttpLoggingInterceptor(HttpLoggingInterceptor.Logger {
            Timber.d(it)
            Log.v("LOG",it);
        })
        loggingInterceptor.level = HttpLoggingInterceptor.Level.BODY
        return loggingInterceptor
    }
}