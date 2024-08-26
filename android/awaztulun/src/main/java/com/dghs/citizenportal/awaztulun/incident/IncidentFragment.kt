package com.dghs.citizenportal.awaztulun.incident

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.fragment.app.Fragment
import androidx.lifecycle.Observer
import androidx.lifecycle.ViewModelProvider
import com.dghs.citizenportal.awaztulun.databinding.FragmentIncidentDetailsBinding
import com.dghs.citizenportal.awaztulun.incident.IncidentViewModel

class IncidentFragment: Fragment() {
  private var _binding : FragmentIncidentDetailsBinding? = null
  private val binding get() = _binding!!
  lateinit var viewModel: IncidentViewModel
  private var incidentId: String? = null

  override fun onCreateView(
    inflater: LayoutInflater,
    container: ViewGroup?,
    savedInstanceState: Bundle?
  ): View {
    viewModel =
      ViewModelProvider(this)[IncidentViewModel::class.java]
    _binding = FragmentIncidentDetailsBinding.inflate(inflater, container, false)

    arguments?.getString("INCIDENT_ID")?.let {
      incidentId = it
      viewModel.getIncidentById(it)
    }

    binding.viewModel = viewModel

    return binding.root
  }

  override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
    super.onViewCreated(view, savedInstanceState)
    observeViewModelData()
  }

  private fun observeViewModelData() {
    viewModel.errorMessage.observe(viewLifecycleOwner, Observer {
      Toast.makeText(activity, it, Toast.LENGTH_LONG).show()
      viewModel.progressVisibility.value = View.GONE
    })

    viewModel.successMessage.observe(viewLifecycleOwner, Observer {
      if(it.isNotEmpty()){
        Toast.makeText(activity, it, Toast.LENGTH_LONG).show()
        binding.addComment.text?.clear()
        viewModel.getIncidentCommentsById(incidentId!!)
      }
    })

    viewModel.mutableCloseScreen.observe(viewLifecycleOwner, Observer {
      if (it) {
        activity?.finish()
      }
    })

    viewModel.mutableIncident.observe(viewLifecycleOwner, Observer {
      if (it != null) {
        binding.incident = it
        binding.executePendingBindings()
      }
    })

    viewModel.mutableIncidentComments.observe(viewLifecycleOwner, Observer {
      if (it.isNotEmpty()) {
        val newIncident = binding.incident?.apply {
          comments = it
        }

        binding.incident = newIncident
        binding.executePendingBindings()
      }
    })
  }
}