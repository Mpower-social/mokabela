/*
 * Copyright (C) 2017 University of Washington
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License
 * is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
 * or implied. See the License for the specific language governing permissions and limitations under
 * the License.
 */

package org.odk.collect.android.application;

import android.app.Application;
import android.content.Context;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.content.res.Configuration;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Build;
import android.os.Bundle;
import android.os.SystemClock;
import android.preference.PreferenceManager;
import android.util.Log;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatDelegate;
import androidx.multidex.MultiDex;

import com.dghs.citizenportal.awaztulun.di.components.CitizenComponent;
import com.dghs.citizenportal.awaztulun.di.components.DaggerCitizenComponent;
import com.dghs.citizenportal.awaztulun.di.modules.ApiModule;
import com.dghs.citizenportal.awaztulun.di.modules.NetworkModule;
import com.dghs.citizenportal.awaztulun.di.modules.OkHttpModule;
import com.evernote.android.job.JobManager;
import com.evernote.android.job.JobManagerCreateException;
import com.google.firebase.analytics.FirebaseAnalytics;
import com.mpower.appbuilder.app_builder.utills.FormUtil;
import com.squareup.leakcanary.LeakCanary;
import com.squareup.leakcanary.RefWatcher;

import net.danlew.android.joda.JodaTimeAndroid;

import org.odk.collect.android.BuildConfig;
import org.odk.collect.android.R;
import org.odk.collect.android.dao.FormsDao;
import org.odk.collect.android.external.ExternalDataManager;
import org.odk.collect.android.injection.config.AppDependencyComponent;
import org.odk.collect.android.injection.config.DaggerAppDependencyComponent;
import org.odk.collect.android.jobs.CollectJobCreator;
import org.odk.collect.android.logic.FormController;
import org.odk.collect.android.logic.PropertyManager;
import org.odk.collect.android.preferences.AdminSharedPreferences;
import org.odk.collect.android.preferences.AutoSendPreferenceMigrator;
import org.odk.collect.android.preferences.FormMetadataMigrator;
import org.odk.collect.android.preferences.GeneralKeys;
import org.odk.collect.android.preferences.GeneralSharedPreferences;
import org.odk.collect.android.preferences.PrefMigrator;
import org.odk.collect.android.storage.StoragePathProvider;
import org.odk.collect.android.tasks.sms.SmsNotificationReceiver;
import org.odk.collect.android.tasks.sms.SmsSentBroadcastReceiver;
import org.odk.collect.android.utilities.FileUtils;
import org.odk.collect.android.utilities.LocaleHelper;
import org.odk.collect.android.utilities.NotificationUtils;
import org.odk.collect.utilities.UserAgentProvider;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.util.Locale;
import java.util.Map;

import javax.inject.Inject;

import io.flutter.app.FlutterApplication;
import timber.log.Timber;

import static org.odk.collect.android.logic.PropertyManager.PROPMGR_USERNAME;
import static org.odk.collect.android.logic.PropertyManager.SCHEME_USERNAME;
import static org.odk.collect.android.preferences.GeneralKeys.KEY_APP_LANGUAGE;
import static org.odk.collect.android.preferences.GeneralKeys.KEY_FONT_SIZE;
import static org.odk.collect.android.preferences.GeneralKeys.KEY_USERNAME;
import static org.odk.collect.android.tasks.sms.SmsNotificationReceiver.SMS_NOTIFICATION_ACTION;
import static org.odk.collect.android.tasks.sms.SmsSender.SMS_SEND_ACTION;

/**
 * The Open Data Kit Collect application.
 *
 * @author carlhartung
 */
public class Collect extends FlutterApplication {

    public static final String DEFAULT_FONTSIZE = "17";
    public static final int DEFAULT_FONTSIZE_INT = 17;

    public static final int CLICK_DEBOUNCE_MS = 1000;

    public static String defaultSysLanguage;
    private static Collect singleton;
    private static long lastClickTime;
    private static String lastClickName;

    @Nullable
    private FormController formController;
    private ExternalDataManager externalDataManager;
    private FirebaseAnalytics firebaseAnalytics;
    private AppDependencyComponent applicationComponent;
    private CitizenComponent citizenComponent;
    private Context activityContext;

    @Inject
    UserAgentProvider userAgentProvider;

    @Inject
    public
    CollectJobCreator collectJobCreator;

    public static Collect getInstance() {
        return singleton;
    }

    public static int getQuestionFontsize() {
        // For testing:
        Collect instance = Collect.getInstance();
        if (instance == null) {
            return Collect.DEFAULT_FONTSIZE_INT;
        }

        return Integer.parseInt(String.valueOf(GeneralSharedPreferences.getInstance().get(KEY_FONT_SIZE)));
    }

    /**
     * Predicate that tests whether a directory path might refer to an
     * ODK Tables instance data directory (e.g., for media attachments).
     */
    public static boolean isODKTablesInstanceDataDirectory(File directory) {
        /*
         * Special check to prevent deletion of files that
         * could be in use by ODK Tables.
         */
        String dirPath = directory.getAbsolutePath();
        StoragePathProvider storagePathProvider = new StoragePathProvider();
        if (dirPath.startsWith(storagePathProvider.getStorageRootDirPath())) {
            dirPath = dirPath.substring(storagePathProvider.getStorageRootDirPath().length());
            String[] parts = dirPath.split(File.separatorChar == '\\' ? "\\\\" : File.separator);
            // [appName, instances, tableId, instanceId ]
            if (parts.length == 4 && parts[1].equals("instances")) {
                return true;
            }
        }
        return false;
    }

    @Nullable
    public FormController getFormController() {
        return formController;
    }

    public void setFormController(@Nullable FormController controller) {
        formController = controller;
    }

    public ExternalDataManager getExternalDataManager() {
        return externalDataManager;
    }

    public void setExternalDataManager(ExternalDataManager externalDataManager) {
        this.externalDataManager = externalDataManager;
    }

    /**
     * Get a User-Agent string that provides the platform details followed by the application ID
     * and application version name: {@code Dalvik/<version> (platform info) org.odk.collect.android/v<version>}.
     *
     * This deviates from the recommended format as described in https://github.com/opendatakit/collect/issues/3253.
     */

    public boolean isNetworkAvailable() {
        ConnectivityManager manager = (ConnectivityManager) getInstance()
                .getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo currentNetworkInfo = manager.getActiveNetworkInfo();
        return currentNetworkInfo != null && currentNetworkInfo.isConnected();
    }

    /*
        Adds support for multidex support library. For more info check out the link below,
        https://developer.android.com/studio/build/multidex.html
    */
    @Override
    protected void attachBaseContext(Context base) {
        super.attachBaseContext(base);
        MultiDex.install(this);
    }

    @Override
    public void onCreate() {
        super.onCreate();
        singleton = this;
        firebaseAnalytics = FirebaseAnalytics.getInstance(this);

        setupDagger();

        NotificationUtils.createNotificationChannel(singleton);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            registerReceiver(new SmsSentBroadcastReceiver(), new IntentFilter(SMS_SEND_ACTION), Context.RECEIVER_NOT_EXPORTED);
            registerReceiver(new SmsNotificationReceiver(), new IntentFilter(SMS_NOTIFICATION_ACTION), Context.RECEIVER_NOT_EXPORTED);
        } else {
            registerReceiver(new SmsSentBroadcastReceiver(), new IntentFilter(SMS_SEND_ACTION));
            registerReceiver(new SmsNotificationReceiver(), new IntentFilter(SMS_NOTIFICATION_ACTION));
        }

        try {
            JobManager
                    .create(this)
                    .addJobCreator(collectJobCreator);
        } catch (JobManagerCreateException e) {
            Timber.e(e);
        }

        SharedPreferences prefs = PreferenceManager.getDefaultSharedPreferences(this);
        FormMetadataMigrator.migrate(prefs);
        PrefMigrator.migrateSharedPrefs();
        AutoSendPreferenceMigrator.migrate();

        reloadSharedPreferences();

        AppCompatDelegate.setCompatVectorFromResourcesEnabled(true);
        JodaTimeAndroid.init(this);

        defaultSysLanguage = "bn";
        new LocaleHelper().updateLocale(this);

        initializeJavaRosa();

        if (BuildConfig.BUILD_TYPE.equals("odkCollectRelease")) {
            Timber.plant(new CrashReportingTree());
        } else {
            Timber.plant(new Timber.DebugTree());
        }

        setupRemoteAnalytics();
        //setupLeakCanary();
        //setupOSMDroid();

        // Force inclusion of scoped storage strings so they can be translated
        Timber.i("%s %s", getString(R.string.scoped_storage_banner_text),
                                   getString(R.string.scoped_storage_learn_more));
    }

    private void setupRemoteAnalytics() {
        SharedPreferences settings = PreferenceManager.getDefaultSharedPreferences(this);
        boolean isAnalyticsEnabled = settings.getBoolean(GeneralKeys.KEY_ANALYTICS, true);
        setAnalyticsCollectionEnabled(isAnalyticsEnabled);
    }

    private void setupDagger() {

        applicationComponent = DaggerAppDependencyComponent.builder()
                .application(this)
                .build();

        citizenComponent = DaggerCitizenComponent.builder()
                .appComponent(applicationComponent)
                .apiModule(ApiModule.INSTANCE)
                .okHttpClientModule(OkHttpModule.INSTANCE)
                .networkModule(NetworkModule.INSTANCE)
                .build();

        applicationComponent.inject(this);
    }

    protected RefWatcher setupLeakCanary() {
        if (LeakCanary.isInAnalyzerProcess(this)) {
            return RefWatcher.DISABLED;
        }
        return LeakCanary.install(this);
    }

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);

        //noinspection deprecation
        defaultSysLanguage = newConfig.locale.getLanguage();
        boolean isUsingSysLanguage = GeneralSharedPreferences.getInstance().get(KEY_APP_LANGUAGE).equals("");
        if (!isUsingSysLanguage) {
            new LocaleHelper().updateLocale(this);
        }
    }

    public void logRemoteAnalytics(String event, String action, String label) {
        Bundle bundle = new Bundle();
        bundle.putString("action", action);
        bundle.putString("label", label);
        firebaseAnalytics.logEvent(event, bundle);
    }

    public void setAnalyticsCollectionEnabled(boolean isAnalyticsEnabled) {
        firebaseAnalytics.setAnalyticsCollectionEnabled(isAnalyticsEnabled);
    }

    public Object getPreferenceValue(String reference, Object selectedValue) {

        if (selectedValue instanceof Integer) {
            return PreferenceManager.getDefaultSharedPreferences(this).getInt(reference, (Integer) selectedValue);
        } else if(selectedValue instanceof String) {
            return PreferenceManager.getDefaultSharedPreferences(this).getString(reference, (String) selectedValue);
        } else if(selectedValue instanceof Float) {
            return PreferenceManager.getDefaultSharedPreferences(this).getFloat(reference, (Float) selectedValue);
        } else if(selectedValue instanceof Boolean) {
            return PreferenceManager.getDefaultSharedPreferences(this).getBoolean(reference, (Boolean) selectedValue);
        } else if(selectedValue instanceof Long) {
            return PreferenceManager.getDefaultSharedPreferences(this).getLong(reference, (Long) selectedValue);
        }

        return PreferenceManager.getDefaultSharedPreferences(this).getString(reference, (String) selectedValue);
    }

    private static class CrashReportingTree extends Timber.Tree {
        @Override
        protected void log(int priority, String tag, String message, Throwable t) {
            if (priority == Log.VERBOSE || priority == Log.DEBUG || priority == Log.INFO) {
                return;
            }
        }
    }

    public void initializeJavaRosa() {
        PropertyManager mgr = new PropertyManager(this);

        // Use the server username by default if the metadata username is not defined
        if (mgr.getSingularProperty(PROPMGR_USERNAME) == null || mgr.getSingularProperty(PROPMGR_USERNAME).isEmpty()) {
            mgr.putProperty(PROPMGR_USERNAME, SCHEME_USERNAME, (String) GeneralSharedPreferences.getInstance().get(KEY_USERNAME));
        }

        FormController.initializeJavaRosa(mgr);
    }

    // This method reloads shared preferences in order to load default values for new preferences
    private void reloadSharedPreferences() {
        GeneralSharedPreferences.getInstance().reloadPreferences();
        AdminSharedPreferences.getInstance().reloadPreferences();
    }

    // Debounce multiple clicks within the same screen
    public static boolean allowClick(String className) {
        long elapsedRealtime = SystemClock.elapsedRealtime();
        boolean isSameClass = className.equals(lastClickName);
        boolean isBeyondThreshold = elapsedRealtime - lastClickTime > CLICK_DEBOUNCE_MS;
        boolean isBeyondTestThreshold = lastClickTime == 0 || lastClickTime == elapsedRealtime; // just for tests
        boolean allowClick = !isSameClass || isBeyondThreshold || isBeyondTestThreshold;
        if (allowClick) {
            lastClickTime = elapsedRealtime;
            lastClickName = className;
        }
        return allowClick;
    }

    public AppDependencyComponent getComponent() {
        return applicationComponent;
    }

    public void setComponent(AppDependencyComponent applicationComponent) {
        this.applicationComponent = applicationComponent;
        applicationComponent.inject(this);
    }

    /**
     * Gets a unique, privacy-preserving identifier for the current form.
     *
     * @return md5 hash of the form title, a space, the form ID
     */
    public static String getCurrentFormIdentifierHash() {
        FormController formController = getInstance().getFormController();
        if (formController != null) {
            return formController.getCurrentFormIdentifierHash();
        }

        return "";
    }

    /**
     * Gets a unique, privacy-preserving identifier for a form based on its id and version.
     * @param formId id of a form
     * @param formVersion version of a form
     * @return md5 hash of the form title, a space, the form ID
     */
    public static String getFormIdentifierHash(String formId, String formVersion) {
        String formIdentifier = new FormsDao().getFormTitleForFormIdAndFormVersion(formId, formVersion) + " " + formId;
        return FileUtils.getMd5Hash(new ByteArrayInputStream(formIdentifier.getBytes()));
    }


    public Context getActivityContext() {
        return activityContext;
    }

    public void setActivityContext(Context context) {
        activityContext = context;
    }

    public String getServerBaseAddress() {
        return PreferenceManager
                .getDefaultSharedPreferences(this)
                .getString(
                        GeneralKeys.KEY_SERVER_URL,
                        getString(R.string.default_server_url)
                );
    }

    public String getMokabelaServerBaseAddress() {
        return getString(R.string.mokabela_server_url);
    }

    public String getUsername() {
        String userName = PreferenceManager
                .getDefaultSharedPreferences(this)
                .getString(GeneralKeys.KEY_USERNAME, "ocms_admin");

        if(userName == null || userName.length() == 0)
            userName = "ocms_admin";

        return userName;
    }

    public void setValue(String key, String value) {
        PreferenceManager.getDefaultSharedPreferences(this).edit().putString(key, value).apply();
    }

    public Map<String, String> getInstanceContent(String instancePath) {
        return FormUtil.INSTANCE.getInstanceContent(instancePath);
    }

    public Map<String, String> addMetaDataToSurveyForm(String instancePath, String formId) {
        return FormUtil.INSTANCE.addMetaDataToSurveyForm(instancePath, formId);
    }

    public CitizenComponent getCitizenComponent() {
        return citizenComponent;
    }
}
