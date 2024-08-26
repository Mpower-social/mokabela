package com.dghs.citizenportal.awaztulun.incident

import android.os.Bundle
import android.view.MenuItem
import androidx.appcompat.app.AppCompatActivity
import com.dghs.citizenportal.awaztulun.R
import com.dghs.citizenportal.awaztulun.databinding.ActivityIncidentBinding

class IncidentActivity: AppCompatActivity() {
  private lateinit var binding: ActivityIncidentBinding

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    binding = ActivityIncidentBinding.inflate(layoutInflater)
    setContentView(binding.root)

    val toolbar = binding.incidentDetail.toolbar
    toolbar.title = getString(R.string.incident_details)
    setSupportActionBar(toolbar)
    supportActionBar?.setDisplayShowHomeEnabled(true)
    supportActionBar?.setDisplayHomeAsUpEnabled(true)

    val incidentId = intent.getStringExtra("INCIDENT_ID")
    IncidentFragment().apply {
      arguments =  Bundle().apply {
        putString("INCIDENT_ID", incidentId)
      }

      supportFragmentManager
        .beginTransaction()
        .replace(R.id.flContainer, this)
        .commit()
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