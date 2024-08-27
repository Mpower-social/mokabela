package com.dghs.citizenportal.awaztulun.home

import android.app.Dialog
import android.content.Context.MODE_PRIVATE
import android.content.Intent
import android.graphics.Rect
import android.graphics.drawable.Drawable
import android.location.Location
import android.net.Uri
import android.os.Bundle
import android.text.TextUtils
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.Window
import android.widget.Button
import android.widget.TextView
import android.widget.Toast
import androidx.fragment.app.Fragment
import androidx.lifecycle.Observer
import androidx.lifecycle.ViewModelProvider
import org.odk.collect.android.R
import org.odk.collect.android.databinding.FragmentAwaztulunHomeBinding
import com.dghs.citizenportal.awaztulun.model.IncidentList
import com.dghs.citizenportal.awaztulun.incident.IncidentActivity
import com.dghs.citizenportal.awaztulun.model.Comments
import com.dghs.citizenportal.awaztulun.report.ReportActivity
import com.dghs.citizenportal.awaztulun.util.PermissionUtil
import com.dghs.citizenportal.awaztulun.util.Constants
import org.osmdroid.api.IMapController
import org.osmdroid.config.Configuration
import org.osmdroid.events.MapListener
import org.osmdroid.events.ScrollEvent
import org.osmdroid.events.ZoomEvent
import org.osmdroid.tileprovider.tilesource.TileSourceFactory
import org.osmdroid.util.GeoPoint
import org.osmdroid.views.MapView
import org.osmdroid.views.overlay.Marker
import org.osmdroid.views.overlay.mylocation.GpsMyLocationProvider
import org.osmdroid.views.overlay.mylocation.IMyLocationProvider
import org.osmdroid.views.overlay.mylocation.MyLocationNewOverlay
import java.util.*


class NewHomeFragment : Fragment(), MapListener {

    private var _binding: FragmentAwaztulunHomeBinding? = null

    // This property is only valid between onCreateView and
    // onDestroyView.
    private val binding get() = _binding!!
    lateinit var viewModel: HomeViewModel
    private lateinit var mapView: MapView
    private lateinit var mapController: IMapController
    private lateinit var myLocationOverlay: MyLocationNewOverlay
    private var currentGeoPoint = GeoPoint(0.0, 0.0)
    /*private val locationListener = LocationListener { location ->
        val latitude = String.format(Locale.getDefault(), "%.4f", location.latitude).toDouble()
        val longitude = String.format(Locale.getDefault(), "%.4f", location.longitude).toDouble()

        if(latitude != currentGeoPoint.latitude || longitude != currentGeoPoint.longitude) {
            Toast.makeText(requireActivity(), "Current Location: $latitude - $longitude", Toast.LENGTH_LONG).show()

            currentGeoPoint = GeoPoint(latitude, longitude)
            mapController.setCenter(currentGeoPoint)
            mapController.animateTo(currentGeoPoint)
        }
    }*/

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        viewModel = ViewModelProvider(this)[HomeViewModel::class.java]
        _binding = FragmentAwaztulunHomeBinding.inflate(layoutInflater)
        val root: View = binding.root
        _binding!!.fragment = this

        Configuration.getInstance().load(requireActivity().applicationContext, requireActivity().getSharedPreferences(getString(R.string.app_name), MODE_PRIVATE))
        Configuration.getInstance().userAgentValue = " com.dghs.citizenportal.awaztulun"

        mapView = binding.osmMap
        mapView.setTileSource(TileSourceFactory.MAPNIK)
        mapView.mapCenter
        mapView.setMultiTouchControls(true)
        mapView.getLocalVisibleRect(Rect())
        mapController = mapView.controller

        myLocationOverlay = object: MyLocationNewOverlay(GpsMyLocationProvider(requireActivity()), mapView) {
            override fun onLocationChanged(location: Location?, source: IMyLocationProvider?) {
                super.onLocationChanged(location, source)

                location?.let {
                    if(System.currentTimeMillis() - viewModel.lastRefreshTime > Constants.DEFAULT_UPDATE_TIME){
                        viewModel.lastRefreshTime = System.currentTimeMillis()
                        val latitude = String.format(Locale.getDefault(), "%.4f", location.latitude).toDouble()
                        val longitude = String.format(Locale.getDefault(), "%.4f", location.longitude).toDouble()

                        if(latitude != viewModel.latitude || longitude != viewModel.longitude) {
                            currentGeoPoint = GeoPoint(latitude,longitude)
                            viewModel.latitude = latitude
                            viewModel.longitude = longitude
                            Toast.makeText(activity,"$latitude:$longitude",Toast.LENGTH_LONG).show()
                            viewModel.sendFirebaseTokenToServer()

                        }
                    }

              }
            }
        }
        myLocationOverlay.enableMyLocation()
        myLocationOverlay.enableFollowLocation()
        myLocationOverlay.isDrawAccuracyEnabled = true
        myLocationOverlay.runOnFirstFix {
            requireActivity().runOnUiThread {
                currentGeoPoint = myLocationOverlay.myLocation
                mapController.setCenter(currentGeoPoint)
                mapController.animateTo(currentGeoPoint)

                viewModel.latitude = currentGeoPoint.latitude
                viewModel.longitude = currentGeoPoint.longitude

               // addDummyMarker()
            }
        }

        mapController.setZoom(19.0)

        // controller.animateTo(mapPoint)
        mapView.overlays.add(myLocationOverlay)

        mapView.addMapListener(this)

        /*val locationManager = requireActivity().getSystemService(LOCATION_SERVICE) as LocationManager
        locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 0, 0f, locationListener)
        locationManager.requestLocationUpdates(LocationManager.NETWORK_PROVIDER, 0, 0f, locationListener)*/


        if(!PermissionUtil.isLocationPermissionGranted(requireActivity())) {
            PermissionUtil.requestLocationPermission(requireActivity(), object: PermissionUtil.PermissionListener {
                override fun granted() {
                    myLocationOverlay.enableMyLocation()
                    checkNotificationPermission()
                }

                override fun denied() {
                    requireActivity().finish()
                    Toast.makeText(requireActivity(), "Location Permission is Required", Toast.LENGTH_LONG).show()
                }
            })
        }

        arguments?.getString("CURRENT_INCIDENT_ID")?.let {
            viewModel.getIncidentById(it)
        }

        return root
    }

    private fun checkNotificationPermission() {
        if(!PermissionUtil.isNotificationPermissionGranted(requireActivity())) {
            PermissionUtil.requestNotificationPermission(requireActivity(), object: PermissionUtil.PermissionListener {
                override fun granted() {

                }

                override fun denied() {
                    Toast.makeText(requireActivity(), "Notification Permission is Required", Toast.LENGTH_LONG).show()
                }
            })
        }
    }


//    private fun addDummyMarker() {
//        for(point in 1..10) {
//            val random = (-10..10).random()
//            val geoPoint = GeoPoint(myLocationOverlay.myLocation.latitude + (random * 0.001), myLocationOverlay.myLocation.longitude + (point * 0.001))
//            val marker = Marker(mapView)
//            marker.position = geoPoint
//            marker.setAnchor(Marker.ANCHOR_CENTER, Marker.ANCHOR_BOTTOM)
//            marker.title = "Hello Marker $point"
//            /*marker.setOnMarkerClickListener { marker, mapView ->
//                TODO("Add you code")
//            }*/
//
//            mapView.overlays.add(marker)
//        }
//    }
    private fun addMarker(incidentList: IncidentList){
        val geoPoint = GeoPoint(incidentList.latitude.toDouble(), incidentList.longitude.toDouble())
        val marker = Marker(mapView)
        marker.position = geoPoint
        marker.icon = getMarkerIconByType(incidentList.incidentTypeId.id,marker)

        marker.setAnchor(Marker.ANCHOR_CENTER, Marker.ANCHOR_BOTTOM)

        marker.setOnMarkerClickListener { _, mapView ->
            mapView.controller.animateTo(marker.position)
            showMarkerDetails(incidentList,false)
            true
        }

        mapView.overlays.add(marker)
    }

    private fun getMarkerIconByType(id: String, marker: Marker): Drawable? {
        when (id){
            "43358421-064c-48f3-a5d0-72b5e8ea3513" -> return resources.getDrawable(R.drawable.ic_virus,activity?.theme)
            else -> {
                return  marker.icon
            }
        }
        return marker.icon
    }

    private fun showMarkerDetails(incidentList: IncidentList, showComments: Boolean) {
        val dialog = activity?.let { Dialog(it) }
        if (dialog!=null){
            dialog.setCancelable(false)
            dialog.requestWindowFeature(Window.FEATURE_NO_TITLE)
            dialog.setContentView(R.layout.marker_details)
            val name = dialog.findViewById<TextView>(R.id.marker_crime_name)
            val dateTimed = dialog.findViewById<TextView>(R.id.marker_date_time)

            val details = dialog.findViewById<TextView>(R.id.marker_details)
            val comments = dialog.findViewById<TextView>(R.id.coments_details)
            val commentsTv = dialog.findViewById<TextView>(R.id.textView13)
            val cancelBtn = dialog.findViewById<Button>(R.id.cancelbtn)
            cancelBtn.setOnClickListener { dialog.dismiss() }
            val detailsBtn = dialog.findViewById<Button>(R.id.reportbtn)
            detailsBtn.setOnClickListener {
                dialog.dismiss()
                showDetailsReport(incidentList.id)
            }
            name.text = incidentList.incidentTypeId.name
            details.text = incidentList.description
            dateTimed.text = incidentList.createdAt
            if(showComments){
                comments.visibility = View.VISIBLE
                commentsTv.visibility = View.VISIBLE
                comments.text = appendComment(incidentList.comments)
                detailsBtn.visibility = View.GONE
            }


            dialog.show()
        }

    }

    private fun appendComment(comments: List<Comments>?): String? {
        var stringBuilder = StringBuilder()
        if (comments != null) {
            for (comment in comments){
                stringBuilder.append("\n")
                stringBuilder.append(comment.comment)
                stringBuilder.append("\n --- at ")
                stringBuilder.append(comment.createdAt)
            }
        }
        return stringBuilder.toString()
    }

    private fun showDetailsReport(id: String) {
        Intent(requireActivity(), IncidentActivity::class.java).apply {
            putExtra("INCIDENT_ID", id)
            startActivity(this)
        }
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        viewModel.getIncidentList()
        viewModel.getAppVersion()
        observeViewModelData()


    }
    private fun observeViewModelData() {

        viewModel.errorMessage.observe(viewLifecycleOwner, Observer {
            Toast.makeText(activity, it, Toast.LENGTH_LONG).show()
            viewModel.progressVisibility.value = View.GONE
        })
        viewModel.retryMessage.observe(viewLifecycleOwner, Observer {
            Toast.makeText(activity, it, Toast.LENGTH_LONG).show()

        })
        viewModel.mutableIncidentList.observe(viewLifecycleOwner,Observer{
            for (incident in it){
                addMarker(incident)
            }
        })
        viewModel.mutableIncident.observe(viewLifecycleOwner,Observer{
            val geoPoint = GeoPoint(it.latitude.toDouble(), it.longitude.toDouble())
            mapController.animateTo(geoPoint)

            showMarkerDetails(it,false)
        })
        viewModel.successMessage.observe(viewLifecycleOwner, Observer {
            if(it.isNotEmpty()){
                Toast.makeText(activity,"Successfully reported",Toast.LENGTH_LONG).show()
                activity?.finish()
            }
        })
        viewModel.mutableAppVersion.observe(viewLifecycleOwner,Observer{
            val versionName = /*BuildConfig.VERSION_NAME*/"com.dghs.citizenportal.awaztulun"
            var serverVersion = it as String
            Log.v("APP_Version","versionName>>"+versionName+":"+serverVersion)
            if(!TextUtils.isEmpty(it) && !serverVersion.equals(versionName)){
                showAppUpdateDialog()
            }
        })
    }

    private fun showAppUpdateDialog() {
        val dialog = activity?.let { Dialog(it) }
        if (dialog!=null){
            dialog.setCancelable(false)
            dialog.requestWindowFeature(Window.FEATURE_NO_TITLE)
            dialog.setContentView(R.layout.app_update_dialog)

            val cancelBtn = dialog.findViewById<Button>(R.id.cancelbtn)
            cancelBtn.setOnClickListener { dialog.dismiss() }
            val updateBtn = dialog.findViewById<Button>(R.id.updatebtn)
            updateBtn.setOnClickListener {
                dialog.dismiss()
                val i = Intent(Intent.ACTION_VIEW, Uri.parse(getString(R.string.app_url)))
                startActivity(i)
            }
            dialog.show()
        }
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }

    fun goToRegistration() {
        Intent(activity, ReportActivity::class.java).apply {
           if(myLocationOverlay.myLocation!=null) {
               putExtra("CURRENT_LATITUDE", myLocationOverlay.myLocation.latitude)
               putExtra("CURRENT_LONGITUDE", myLocationOverlay.myLocation.longitude)
           }
            startActivity(this)
        }
    }

    override fun onScroll(event: ScrollEvent?): Boolean {
        return true
    }

    override fun onZoom(event: ZoomEvent?): Boolean {
        return false
    }
}