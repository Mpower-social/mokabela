package com.dghs.citizenportal.awaztulun
import android.annotation.SuppressLint
import android.content.Intent
import android.os.Bundle
import android.view.Menu
import android.view.MenuItem
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.widget.Toolbar
import androidx.lifecycle.ViewModelProvider
import androidx.navigation.fragment.NavHostFragment
import com.dghs.citizenportal.awaztulun.databinding.ActivityMainAwaztulunBinding
import com.dghs.citizenportal.awaztulun.settings.SettingsActivity
import com.dghs.citizenportal.awaztulun.util.SharedPreferenceUtil


class NewMainAwaztulunActivity : AppCompatActivity() {

    private lateinit var binding: ActivityMainAwaztulunBinding
    private lateinit var viewModel: MainActivityViewModel

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        binding = ActivityMainAwaztulunBinding.inflate(layoutInflater)
        viewModel = ViewModelProvider(this)[MainActivityViewModel::class.java]
        setContentView(binding.root)
        val toolbar = findViewById(R.id.tbReport) as Toolbar
        toolbar.title = getString(R.string.app_name)
        setSupportActionBar(toolbar)
        @SuppressLint("HardwareIds")
        val mId = android.provider.Settings.Secure.getString(contentResolver, android.provider.Settings.Secure.ANDROID_ID)
        viewModel.sharedPreferenceUtil.setValue(SharedPreferenceUtil.DEVICE_ID, mId)

        val notificationIncidentId = intent.getStringExtra("CURRENT_INCIDENT_ID")

        val navHostFragment = supportFragmentManager.findFragmentById(R.id.nav_host_fragment_content_main) as NavHostFragment
        val navController = navHostFragment.navController

        navController.setGraph(
            R.navigation.mobile_awaztulun_navigation,
            Bundle().apply {
                putString("CURRENT_INCIDENT_ID", notificationIncidentId)
            },
        )
    }
    override fun onCreateOptionsMenu(menu: Menu): Boolean {
        // Inflate the menu; this adds items to the action bar if it is present.
        menuInflater.inflate(R.menu.awaztulun_menu, menu)
        return true
    }
    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        return when (item.itemId) {
            R.id.nav_settings ->
            {
                startActivity(Intent(this@NewMainAwaztulunActivity, SettingsActivity::class.java))
                true
            }

            else -> super.onOptionsItemSelected(item)
        }
    }
}