package com.marker.app

import android.app.*
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.os.Build
import android.os.IBinder
import android.util.Log
import androidx.core.app.NotificationCompat

class CallForeGroundService : Service() {

    companion object {
        private const val CHANNEL_ID = "call_channel_v1" // bump this if you change settings
        private const val NOTIF_ID = 1508

        const val ACTION_START = "CALL_START"
        const val ACTION_STOP = "CALL_STOP"
        const val EXTRA_DATA = "call_data"

        fun start(context: Context, callData: String) {
            val intent = Intent(context, CallForeGroundService::class.java).apply {
                action = ACTION_START
                putExtra(EXTRA_DATA, callData)
            }

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
                context.startForegroundService(intent)
            else
                context.startService(intent)
        }

        fun stop(context: Context) {
            val intent = Intent(context, CallForeGroundService::class.java).apply {
                action = ACTION_STOP
            }
            context.startService(intent)
        }
    }

    override fun onBind(i: Intent?): IBinder? = null

    override fun onCreate() {
        super.onCreate()
        Log.e("CALL_SERVICE", "onCreate")
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.e("CALL_SERVICE", "onStartCommand action=${intent?.action}")

        when (intent?.action) {
            ACTION_START -> {
                // Ensure channel exists with the desired importance BEFORE posting notification
                ensureNotificationChannel()

                val data = intent.getStringExtra(EXTRA_DATA)
                val notification = buildNotification(data)

                // Immediately promote to foreground — required
                if (Build.VERSION.SDK_INT >= 34) {
                    val serviceType = ServiceInfo.FOREGROUND_SERVICE_TYPE_CAMERA or
                                     ServiceInfo.FOREGROUND_SERVICE_TYPE_MICROPHONE or
                                     ServiceInfo.FOREGROUND_SERVICE_TYPE_PHONE_CALL
                    startForeground(NOTIF_ID, notification, serviceType)
                } else {
                    startForeground(NOTIF_ID, notification)
                }
                Log.e("CALL_SERVICE", "Started foreground with notification")
            }

            ACTION_STOP -> {
                Log.e("CALL_SERVICE", "Stopping service")
                stopForeground(STOP_FOREGROUND_REMOVE)
                stopSelf()
                return START_NOT_STICKY
            }
        }

        return START_STICKY
    }

    private fun buildNotification(data: String?): Notification {
        Log.e("CALL_SERVICE", "buildNotification() data=$data")
//        val tapIntent = Intent(this, MainActivity::class.java).apply {
//            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
//            putExtra("call_data", data)
//        }
        val tapIntent = createLaunchIntent(data)
        val tapPending = PendingIntent.getActivity(
            this, 100, tapIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val builder = NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("Ongoing Call")
            .setContentText("Tap to return to call")
            .setSmallIcon(android.R.drawable.ic_menu_call)
            .setContentIntent(tapPending)
            .setOngoing(true)
            .setAutoCancel(false)
            .setOnlyAlertOnce(true)
            .setCategory(NotificationCompat.CATEGORY_CALL)

        // Use as low importance channel (no heads-up)
        val notification = builder.build()

        // Make it sticky / not clearable
        notification.flags = notification.flags or
                Notification.FLAG_ONGOING_EVENT or Notification.FLAG_NO_CLEAR

        return notification
    }

    private fun ensureNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val nm = getSystemService(NotificationManager::class.java)
            val existing = nm.getNotificationChannel(CHANNEL_ID)

            // If channel exists but importance is not LOW, delete + recreate.
            val desiredImportance = NotificationManager.IMPORTANCE_LOW

            if (existing != null && existing.importance != desiredImportance) {
                Log.e("CALL_SERVICE", "Existing channel importance=${existing.importance} != $desiredImportance. Deleting and recreating.")
                nm.deleteNotificationChannel(CHANNEL_ID)
            }

            // Create channel if missing
            if (nm.getNotificationChannel(CHANNEL_ID) == null) {
                val channel = NotificationChannel(
                    CHANNEL_ID,
                    "Call Service",
                    desiredImportance
                ).apply {
                    description = "Notifications for ongoing calls"
                    setShowBadge(false)
                    lockscreenVisibility = Notification.VISIBILITY_PUBLIC
                }
                nm.createNotificationChannel(channel)
                Log.e("CALL_SERVICE", "Notification channel created with importance=$desiredImportance")
            } else {
                Log.e("CALL_SERVICE", "Notification channel already exists with correct importance")
            }
        }
    }
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
}
