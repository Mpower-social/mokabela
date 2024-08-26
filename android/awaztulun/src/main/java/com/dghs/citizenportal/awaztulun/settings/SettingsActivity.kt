package com.dghs.citizenportal.awaztulun.settings

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.view.MenuItem
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.widget.Toolbar
import androidx.lifecycle.Observer
import androidx.lifecycle.ViewModelProvider
import com.dghs.citizenportal.awaztulun.BuildConfig
import com.dghs.citizenportal.awaztulun.R
import com.dghs.citizenportal.awaztulun.databinding.ActivitySettingsBinding
import com.dghs.citizenportal.awaztulun.util.SharedPreferenceUtil.Companion.IS_NOTIFY

class SettingsActivity: AppCompatActivity() {
    private lateinit var binding: ActivitySettingsBinding
    lateinit var viewmodel: SettingsViewModel
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivitySettingsBinding.inflate(layoutInflater)
        setContentView(binding.root)
        viewmodel = ViewModelProvider(this)[SettingsViewModel::class.java]
        binding.viewmodel = viewmodel
        val toolbar = findViewById(R.id.tbReport) as Toolbar
        toolbar.title = getString(R.string.action_settings)
        setSupportActionBar(toolbar)
        supportActionBar?.setDisplayShowHomeEnabled(true)
        supportActionBar?.setDisplayHomeAsUpEnabled(true)
        var versionName = /*BuildConfig.VERSION_NAME*/"1"
        viewmodel.appVersion = versionName
        viewmodel.mutableAppUpdate.observe(this, Observer {
            if (it) {
                val i = Intent(Intent.ACTION_VIEW, Uri.parse(getString(R.string.app_url)))
                startActivity(i)
            }
        })
        viewmodel.mutablePrivacyPolicy.observe(this, Observer {
            if (it) {
                val i = Intent(Intent.ACTION_VIEW, Uri.parse(getString(R.string.privacy_url)))
                startActivity(i)
            }
        })
        viewmodel.mutableNotification.observe(this, Observer {

            if (it == R.id.yes_rb) {
                viewmodel.sharedPreferenceUtil.setValue(IS_NOTIFY,true)
            }else if(it == R.id.no_rb){
                viewmodel.sharedPreferenceUtil.setValue(IS_NOTIFY,false)
            }
        })
        var isNotify = viewmodel.sharedPreferenceUtil.getValue(IS_NOTIFY,true)
        if(isNotify as Boolean) viewmodel.mutableNotification.value = R.id.yes_rb
    }
    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        if(item.itemId == android.R.id.home) {
            finish()
            return true
        }

        return super.onOptionsItemSelected(item)
    }
}