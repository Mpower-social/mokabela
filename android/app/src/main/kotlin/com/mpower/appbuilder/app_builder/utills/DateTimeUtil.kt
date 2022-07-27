package com.mpower.appbuilder.app_builder.utills

import java.text.SimpleDateFormat
import java.util.*

object DateTimeUtil {
    fun getTimeMillis(dateString: String?): Long {
        if(dateString.isNullOrEmpty())
            return 0

        val dateFormat = SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault())
        val calendar = GregorianCalendar()

        try {
            calendar.time = dateFormat.parse(dateString)
            return calendar.timeInMillis
        } catch (ex:Exception) {
            ex.stackTrace
        }

        return 0
    }

    fun getTimeMillis(dateString: String?, format: String): Long {
        if(dateString.isNullOrEmpty())
            return 0

        val dateFormat = SimpleDateFormat(format, Locale.getDefault())
        val calendar = GregorianCalendar()

        try {
            calendar.time = dateFormat.parse(dateString)
            return calendar.timeInMillis
        } catch (ex:Exception) {
            ex.stackTrace
        }

        return 0
    }

    fun getDateString(timeMillis: Long): String {
        val dateFormat = SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault())
        val calendar = GregorianCalendar()
        calendar.timeInMillis = timeMillis

        return dateFormat.format(calendar.time)
    }

    fun getDateString(timeMillis: Long, format: String): String {
        val dateFormat = SimpleDateFormat(format, Locale.getDefault())
        val calendar = GregorianCalendar()
        calendar.timeInMillis = timeMillis

        return dateFormat.format(calendar.time)
    }

    fun getDateString(srcDate: String?, srcFormat: String, destFormat: String): String {
        val srcDateFormat = SimpleDateFormat(srcFormat, Locale.getDefault())
        val destDateFormat = SimpleDateFormat(destFormat, Locale.getDefault())
        val calendar = GregorianCalendar()

        try {
            calendar.time = srcDateFormat.parse(srcDate)
        } catch (ex:Exception) {
            ex.stackTrace
        }

        return destDateFormat.format(calendar.time)
    }

    fun getCurrentTimeString(): String {
        val dateFormat = SimpleDateFormat("yyyy-MM-dd_HH-mm-ss", Locale.getDefault())
        val calendar = GregorianCalendar()

        return dateFormat.format(calendar.time)
    }

    fun getDateParts(eventDate: String?): Array<Int> {
        val dateParts = arrayOf(0, 0, 0)

        if(eventDate.isNullOrEmpty())
            return dateParts

        val dateFormat = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
        val calendar = GregorianCalendar()

        try {
            calendar.time = dateFormat.parse(eventDate)
            dateParts[0] = calendar.get(Calendar.YEAR)
            dateParts[1] = calendar.get(Calendar.MONTH)
            dateParts[2] = calendar.get(Calendar.DAY_OF_MONTH)
            return dateParts
        } catch (ex:Exception) {
            ex.stackTrace
        }

        return dateParts
    }

    fun getCurrentTimeInMillis(): Long {
        return GregorianCalendar().timeInMillis
    }

    fun getCurrentMonthDateString(): String {
        val c = Calendar.getInstance()
        c.set(Calendar.DAY_OF_MONTH, 1)
        val df = SimpleDateFormat("yyyy-MM-dd")
        return df.format(c.time)
    }
}