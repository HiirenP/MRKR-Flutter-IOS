package com.marker.app

import android.app.*
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.IBinder
import android.util.Log
import androidx.core.app.NotificationCompat
import android.os.Handler
import android.os.Looper

class CustomCallForegroundService : Service() {

    companion object {
        private const val CHANNEL_ID = "ongoing_call_channel"
        private const val NOTIFICATION_ID = 1002

        const val ACTION_START = "START_CALL_SERVICE"
        const val ACTION_STOP = "STOP_CALL_SERVICE"
        const val EXTRA_CALL_DATA = "call_data"

        fun startService(context: Context, callData: String) {
            val intent = Intent(context, CustomCallForegroundService::class.java)
            // IMPORTANT: STOP must never use startForegroundService
            if (intent.action == ACTION_STOP) {
                context.startService(intent)
                return
            }

            intent.action = ACTION_START
            intent.putExtra(EXTRA_CALL_DATA, callData)

            try {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    context.startForegroundService(intent)
                } else {
                    context.startService(intent)
                }
            } catch (e: Exception) {
                Log.e("MY_SERV", "startService error: $e")
            }
        }

        fun stopService(context: Context) {
            Log.e("MY_SERV", "Sending STOP action")

            val intent = Intent(context, CustomCallForegroundService::class.java)
            intent.action = ACTION_STOP

            // IMPORTANT: startService(), NOT stopService()
            context.startService(intent)
        }
    }

    override fun onBind(intent: Intent?): IBinder? = null

    private val handler = Handler(Looper.getMainLooper())
    private var currentCallData: String? = null
    private val appStateCheckRunnable = Runnable { checkAppStateAndUpdateNotification() }
    /*private val checkRunnable: Runnable by lazy {
        Runnable {
            updateNotificationState()
            handler.postDelayed(checkRunnable, 1000)
        }
    }*/

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {

        Log.e("MY_SERV", "onStartCommand action=${intent?.action}")

        when (intent?.action) {

            ACTION_START -> {
                currentCallData = intent.getStringExtra(EXTRA_CALL_DATA)
                startForegroundNotification(currentCallData)
                handler.postDelayed(appStateCheckRunnable, 1000)
            }

            ACTION_STOP -> {
                stopCallForeground()
                return START_NOT_STICKY
            }
        }

        return START_STICKY
    }

    // ---- START FOREGROUND ----
    private fun startForegroundNotification(callData: String?) {
        // Only show notification if app is in background
        Log.e("MY_SERV", "1")
        createNotificationChannel()

        if (!isAppInBackground()) {
            Log.e("MY_SERV", "2")
//            stopForeground(true)
            return
        }


        // Create intent to reopen the app to the specific call screen
        val launchIntent = createLaunchIntent(callData)

        val pendingIntent = PendingIntent.getActivity(
            this, 0, launchIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val notification = NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("Ongoing Call")
            .setContentText("Tap to return to call")
            .setSmallIcon(android.R.drawable.ic_menu_call)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setOngoing(true)
            .setContentIntent(pendingIntent)
            .setAutoCancel(false)
            .setOnlyAlertOnce(true)
            .build()

        startForeground(NOTIFICATION_ID, notification)
    }

    private fun checkAppStateAndUpdateNotification() {
        Log.e("MY_SERV", "checkAppStateAndUpdateNotification")
        startForegroundNotification(currentCallData)
        // Check every 1 seconds
        handler.postDelayed(appStateCheckRunnable, 1000)
    }

    private fun createNotificationChannel() {
        Log.e("MY_SERV", "3")
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Log.e("MY_SERV", "4")
            val channel = NotificationChannel(
                CHANNEL_ID,
                "Ongoing Calls",
                NotificationManager.IMPORTANCE_HIGH
            ).apply {
                description = "Channel for ongoing call notifications"
                setShowBadge(false)
            }

            val notificationManager =
                getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
            Log.e("MY_SERV", "5")
        }
    }

    // Add this method to check if app is in background
    private fun isAppInBackground(): Boolean {
        Log.e("MY_SERV", "6")
        val activityManager = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val runningProcesses = activityManager.runningAppProcesses ?: return false

        for (processInfo in runningProcesses) {
            if (processInfo.importance == ActivityManager.RunningAppProcessInfo.IMPORTANCE_FOREGROUND &&
                processInfo.processName == packageName
            ) {
                Log.e("MY_SERV", "7")
                return false // App is in foreground
            }
        }
        Log.e("MY_SERV", "8")
        return true // App is in background
    }

    // Add this method to check if app is alive
    private fun isAppAlive(): Boolean {
        return try {
            Log.e("MY_SERV", "8")
            // Try to get the main activity
            val activityManager = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
            val runningProcesses = activityManager.runningAppProcesses ?: return false

            for (processInfo in runningProcesses) {
                if (processInfo.importance <= ActivityManager.RunningAppProcessInfo.IMPORTANCE_VISIBLE &&
                    processInfo.processName == packageName
                ) {
                    Log.e("MY_SERV", "9")
                    return true // App is alive
                }
            }
            false // App is dead
        } catch (e: Exception) {
            false
        }
    }
    // Update the notification intent creation
    private fun createLaunchIntent(callData: String?): Intent {
        Log.e("MY_SERV", "10")
        val isAppAlive = isAppAlive()

        if (isAppAlive) {
            Log.e("MY_SERV", "11")
            // App is in background - bring it to foreground
            return Intent(this, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
                putExtra("from_notification", true)
                putExtra("call_action", "call_resume")
                putExtra("call_data", callData)
                putExtra("app_state", "background")
            }
        } else {
            Log.e("MY_SERV", "12")
            // App is killed - start from splash but with special flags
            return packageManager.getLaunchIntentForPackage(packageName)?.apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
                putExtra("from_notification", true)
                putExtra("call_action", "call_resume")
                putExtra("call_data", callData)
                putExtra("app_state", "killed")
            } ?: Intent(this, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
                putExtra("from_notification", true)
                putExtra("call_action", "call_resume")
                putExtra("call_data", callData)
                putExtra("app_state", "killed")
            }
        }
    }

    // ---- STOP FOREGROUND ----
    private fun stopCallForeground() {
        handler.removeCallbacks(appStateCheckRunnable)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            stopForeground(STOP_FOREGROUND_REMOVE) // FORCE remove
        } else {
            @Suppress("DEPRECATION")
            stopForeground(true)
        }
        stopSelf()
    }
}
