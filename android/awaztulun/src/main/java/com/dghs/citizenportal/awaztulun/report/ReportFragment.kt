package com.dghs.citizenportal.awaztulun.report

import android.app.ProgressDialog
import android.net.Uri
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.activity.result.PickVisualMediaRequest
import androidx.activity.result.contract.ActivityResultContracts
import androidx.core.content.FileProvider
import androidx.fragment.app.Fragment
import androidx.lifecycle.Observer
import androidx.lifecycle.ViewModelProvider
import com.dghs.citizenportal.awaztulun.databinding.FragmentAddReportBinding
import com.dghs.citizenportal.awaztulun.report.ReportViewModel
import com.dghs.citizenportal.awaztulun.util.PermissionUtil
import com.dghs.citizenportal.awaztulun.util.getFilePath
import java.io.File

class ReportFragment : Fragment()  {
    private var _binding : FragmentAddReportBinding? = null
    private val binding get() = _binding!!
    var latitude: String = ""
    var longitude: String = ""
    lateinit var viewmodel: ReportViewModel
    lateinit var progressDialog: ProgressDialog
    private var captureImagePath: String? = null
    private lateinit var captureImageUri: Uri
    private val imageCaptureLauncher = registerForActivityResult(
        ActivityResultContracts.TakePicture()) { result ->
        if(result) {
            binding.selectedIncidentImage.setImageURI(null)
            binding.selectedIncidentImage.setImageURI(captureImageUri)

            captureImagePath?.let {
                viewmodel.selectedIncidentImage = it
                captureImagePath = null
            }
        }
    }

    private val imagePickerLauncher = registerForActivityResult(
        ActivityResultContracts.PickVisualMedia()) { result ->
        result?.let {
            binding.selectedIncidentImage.setImageURI(null)
            binding.selectedIncidentImage.setImageURI(result)

            result.getFilePath(requireActivity())?.let {
                viewmodel.selectedIncidentImage = it
            }
        }
    }

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        viewmodel =
            ViewModelProvider(this)[ReportViewModel::class.java]
        _binding = FragmentAddReportBinding.inflate(inflater, container, false)
        val root: View = binding.root
        binding.viewmodel = viewmodel
        return root
    }
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        observeViewModelData()
        viewmodel.reportData.latitude =  latitude
        viewmodel.reportData.longitude =  longitude
        viewmodel.getIncidentTypeList()

        binding.captureImage.setOnClickListener {
            checkPermissionAndOpenCamera()
        }

        binding.pickImage.setOnClickListener {
            openGallery()
        }
    }
    fun updateLocation(latitude: String, longitude: String) {
        this.latitude =  latitude
        this.longitude =  longitude
    }
    private fun observeViewModelData() {
        viewmodel.mutableProgressDialog.observe(viewLifecycleOwner,Observer{
            if(it){
                showProgressDialog()
            }else{
                hideProgressDialog()
            }
        })

        viewmodel.errorMessage.observe(viewLifecycleOwner, Observer {
            Toast.makeText(activity, it, Toast.LENGTH_LONG).show()

        })
        viewmodel.retryMessage.observe(viewLifecycleOwner, Observer {
            Toast.makeText(activity, it, Toast.LENGTH_LONG).show()

        })

        viewmodel.mutableCloseScreen.observe(viewLifecycleOwner, Observer {
            if (it) {
                activity?.finish()
            }
        })

        viewmodel.successMessage.observe(viewLifecycleOwner, Observer {
            if(it.isNotEmpty()){
               Toast.makeText(activity,"Successfully reported",Toast.LENGTH_LONG).show()
                activity?.finish()
            }
        })
    }

    private fun checkPermissionAndOpenCamera() {
        if(PermissionUtil.isCameraPermissionGranted(requireActivity())) {
            openCamera()
        } else {
            PermissionUtil.requestCameraPermission(requireActivity(), object: PermissionUtil.PermissionListener {
                override fun granted() {
                    openCamera()
                }

                override fun denied() {
                    Toast.makeText(requireActivity(), "Permission required to access Camera", Toast.LENGTH_SHORT).show()
                }
            })
        }
    }

    private fun openCamera() {
        val file = File(requireActivity().filesDir, "${System.currentTimeMillis()}.jpg")
        captureImagePath = file.absolutePath
        captureImageUri = FileProvider.getUriForFile(
            requireActivity(),
            requireActivity().applicationContext.packageName + ".provider",
            file,
        )

        imageCaptureLauncher.launch(captureImageUri)
    }

    private fun openGallery() {
        imagePickerLauncher.launch(
            PickVisualMediaRequest.Builder()
                .setMediaType(ActivityResultContracts.PickVisualMedia.ImageOnly)
                .build()
        )
    }

    private fun showProgressDialog(){
            progressDialog = ProgressDialog(activity)
            progressDialog.show()

    }
    private fun hideProgressDialog(){
        progressDialog.let {
            if(progressDialog.isShowing){
                progressDialog.dismiss()
            }
        }

    }
}