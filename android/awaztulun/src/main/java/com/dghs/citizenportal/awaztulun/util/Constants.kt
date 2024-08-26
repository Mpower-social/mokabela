package com.dghs.citizenportal.awaztulun.util


import java.text.SimpleDateFormat
import java.util.*

class Constants {
   companion object{
       const val brn: String = "brn"
       const val dob: String = "dob"
       const val gender: String = "gender"
       const val registrationData: String = "bundleData"
       const val loginData: String = "bundleData"
       const val isRegisterVaccine = "is_reg_vacc"
       const val profileData = "profile_data"
       const val noPauroshova = "No Paurasava"
       const val noUnion = "NO UNION"
       const val division = "division"
       const val district = "district"
       const val upazila = "upazila"
       const val pauroshova = "pauroshova"
       const val union = "union"
       const val ward = "ward"
       const val educationTypeSchool = "SCHOOL"
       const val educationTypeOutreach = "OUTREACH"
       const val API_KEY = "kzedsbsenaoarnlfxwyrzgxfmdskmnsiaxukkzhpagtuucdmllnvgkyuxwyiarvktbepvbfuoxssurwsxdkurnvhubvzebxjlbvvjfvsrvoyrgrunsjfewzwfqryycku"
       const val DEFAULT_UPDATE_TIME = 1000*60*30

       fun getAccessToken(sharedPreferenceUtil: SharedPreferenceUtil):String{
           return "Bearer "+sharedPreferenceUtil.getValue(SharedPreferenceUtil.ACCESS_TOKEN,"").toString()
       }

       fun calenderToString(cal: Calendar): String {
           val day = if(cal.get(Calendar.DAY_OF_MONTH)<10) ("0" + cal.get(Calendar.DAY_OF_MONTH)) else ("" + cal.get(Calendar.DAY_OF_MONTH))
           val month = if((cal.get(Calendar.MONTH) +1)<10) ("0" + (cal.get(Calendar.MONTH) +1)) else ("" + (cal.get(Calendar.MONTH) +1))

           return day+"-"+month+"-"+cal.get(Calendar.YEAR)
       }

       fun calenderToYYYYMMDD(cal: Calendar): String {
           val day = if(cal.get(Calendar.DAY_OF_MONTH)<10) ("0" + cal.get(Calendar.DAY_OF_MONTH)) else ("" + cal.get(Calendar.DAY_OF_MONTH))
           val month = if((cal.get(Calendar.MONTH) +1)<10) ("0" + (cal.get(Calendar.MONTH) +1)) else ("" + (cal.get(Calendar.MONTH) +1))
           return ""+cal.get(Calendar.YEAR)+"-"+month+"-"+day
       }

       fun calenderToYYYYMMDDFromString(date: String): String {
          val simpleDateFormat = SimpleDateFormat("yyyy-MM-dd", Locale("en"))
           return simpleDateFormat.parse(date)?.let { simpleDateFormat.format(it) }?:""
       }
       fun Date.toString(format: String, locale: Locale = Locale.getDefault()): String {
           val formatter = SimpleDateFormat(format, locale)
           return formatter.format(this)
       }

       fun getCurrentDateTime(): Date {
           return Calendar.getInstance().time
       }

   }
}