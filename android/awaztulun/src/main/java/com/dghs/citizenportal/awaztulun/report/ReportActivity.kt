package com.dghs.citizenportal.awaztulun.report

import android.location.Location
import android.os.Bundle
import android.util.Log
import android.view.MenuItem
import androidx.appcompat.widget.Toolbar
import com.dghs.citizenportal.awaztulun.R
import com.dghs.citizenportal.awaztulun.databinding.ActivityReportBinding
import com.dghs.citizenportal.awaztulun.BaseLocationActivity
import com.google.android.gms.location.LocationListener

class ReportActivity: BaseLocationActivity(), LocationListener {
    private lateinit var binding: ActivityReportBinding
    private lateinit var reportFragment: ReportFragment
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        binding = ActivityReportBinding.inflate(layoutInflater)
        setContentView(binding.root)
        reportFragment = ReportFragment()
        supportFragmentManager
            .beginTransaction()
            .replace(R.id.flContainer, reportFragment)
            .commit()
        val toolbar = findViewById(R.id.tbReport) as Toolbar
        toolbar.title = getString(R.string.do_report)
        setSupportActionBar(toolbar)
        supportActionBar?.setDisplayShowHomeEnabled(true)
        supportActionBar?.setDisplayHomeAsUpEnabled(true)
        var lat = intent.getDoubleExtra("CURRENT_LATITUDE",0.0)
        var lng = intent.getDoubleExtra("CURRENT_LONGITUDE",0.0)
        setLocationListener(this)
        if(lat ==0.0 && lng ==0.0){
            getLastLocation()
        }else{
            reportFragment.updateLocation(lat.toString(),lng.toString())
        }

    }
    override fun onLocationChanged(location: Location) {
        if (location != null) {
            try {
                var latitude = String.format("%.4f", location.latitude).toDouble()
                var longitude = String.format("%.4f", location.longitude).toDouble()
                Log.v("LOCATION","latitude:"+latitude+":longitude:"+longitude)
                // Change Icon
                if (!isFinishing) {
                    reportFragment.viewmodel.reportData.latitude = location.latitude.toString()
                    reportFragment.viewmodel.reportData.longitude = location.longitude.toString()
                }
            } catch (ex: Exception) {
                ex.printStackTrace()
            }
        }
    }
    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        if(item.itemId == android.R.id.home) {
            finish()
            return true
        }

        return super.onOptionsItemSelected(item)
    }
}