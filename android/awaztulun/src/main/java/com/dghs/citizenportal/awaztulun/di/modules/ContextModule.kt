package com.dghs.citizenportal.awaztulun.di.modules

import android.app.Application
import android.content.Context
import dagger.Module
import dagger.Provides

/**
 * Created by mahmud
on 30 aug 2023
 */

@Module
class ContextModule(private val context: Application) {
    @Provides
    internal fun context(): Context {
        return context
    }
}