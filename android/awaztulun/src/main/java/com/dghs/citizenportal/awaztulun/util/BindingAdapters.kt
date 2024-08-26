package com.dghs.citizenportal.awaztulun.util


import android.view.View
import android.widget.ArrayAdapter
import android.widget.ImageView
import android.widget.Spinner
import androidx.appcompat.app.AppCompatActivity
import androidx.databinding.BindingAdapter
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.Observer
import com.bumptech.glide.Glide
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.dghs.citizenportal.awaztulun.CitizenApplication
import com.dghs.citizenportal.awaztulun.model.IncidentTypeList

@BindingAdapter("mutableVisibility")
fun setMutableVisibility(view: View, visibility: MutableLiveData<Int>?) {
    val parentActivity: AppCompatActivity = view.context as AppCompatActivity
    visibility?.observe(parentActivity) { value -> view.visibility = value ?: View.VISIBLE }
}
@BindingAdapter("app:setupIncidentSpinnerData")
fun setupIncidentSpinnerData(spinner: Spinner, sourceList: MutableLiveData<List<IncidentTypeList>>?) {
    val parentActivity: AppCompatActivity = spinner.context as AppCompatActivity
    sourceList?.observe(parentActivity, Observer { it ->
        if (it.isNotEmpty()) {
            val items = ArrayList<String>()
            items.addAll(it!!.map { it.name })
            val spinnerAdapter =
                ArrayAdapter<String>(
                    spinner.context,
                    android.R.layout.simple_spinner_dropdown_item,
                    items
                )
            spinner.adapter = spinnerAdapter
        }

    })


}


@BindingAdapter("imageResource")
fun setImageResource(view: ImageView, resource: Int) {
    view.setImageResource(resource)
}

@BindingAdapter("imageUrl")
fun setImageUrl(imgView: ImageView, url: String?) {
    if(!url.isNullOrEmpty()) {
        Glide.with(imgView.context)
            .load(getImgAbsUrl(url))
            .dontAnimate()
            .diskCacheStrategy(DiskCacheStrategy.ALL)
            .into(imgView)
    }
}

/**
 * checking image is base64 or not
 */
private fun isBase64Image(picture: String?): Boolean {
    return try {
        picture!!.split(":")[0] == "data"
    } catch (e: Exception) {
        false
    }
}

fun getImgAbsUrl(url: String?):String{
    return CitizenApplication.getInstance().getServerBaseUrl() + url + ".jpg"
}