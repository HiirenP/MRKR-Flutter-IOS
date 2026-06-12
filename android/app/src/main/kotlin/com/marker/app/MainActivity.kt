package com.marker.app

import android.app.ActivityManager
import android.content.Context
import android.content.Intent
import android.nfc.NfcAdapter
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.view.WindowInsets
import android.view.WindowInsetsController
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.system_ui"
    private val CALL_CHANNEL = "com.marker.app/call_kit"
    private val NFC_CHANNEL = "marker.app/nfc"

    private var pendingCallAction: String? = null
    private var pendingCallExtras: HashMap<String, Any?>? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        handleCallIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleCallIntent(intent)
    }

    private fun handleCallIntent(intent: Intent?) {
        // Check if the app was opened from a call notification
        val fromNotification = intent?.getBooleanExtra("from_notification", false)
        val callAction = intent?.getStringExtra("call_action")
        val callData = intent?.getStringExtra("call_data") // Complete JSON data

        if (fromNotification == true && callAction == "call_resume" && callData != null) {
            // Store the complete call data to be retrieved by Flutter
            pendingCallAction = "call_resume"
            pendingCallExtras = hashMapOf(
                "from_notification" to true,
                "call_data" to callData,
                "uid" to intent.getStringExtra("call_uid"),
                "channel" to intent.getStringExtra("call_channel"),
                "token" to intent.getStringExtra("call_token"),
                "randomID" to intent.getStringExtra("call_random_id"),
                "fromChat" to intent.getStringExtra("call_from_chat")
            )
        }

        // Existing code for other call intents
        val otherCallAction = intent?.getStringExtra("call_action")
        val otherCallData = intent?.getStringExtra("call_data")

        if (otherCallAction != null && otherCallData != null) {
            pendingCallAction = otherCallAction
            pendingCallExtras = hashMapOf("data" to otherCallData)
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            if (call.method == "hideBottomBar") {
                hideBottomBar()
                result.success(null)
            }
        }

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CALL_CHANNEL
        ).setMethodCallHandler { call, result ->
            Log.e("MY_SERV", "call.method>${call.method}")
            when (call.method) {
                "getInitialCallEvent" -> {
                    try {
                        val response = hashMapOf<String, Any?>()
                        response["action"] = pendingCallAction
                        response["extras"] = pendingCallExtras
                        // Clear after read so it isn't handled twice
                        pendingCallAction = null
                        pendingCallExtras = null
                        result.success(response)
                    } catch (e: Exception) {
                        Log.e("MainActivity", "Error getting initial call event: ${e.message}")
                        result.error(
                            "INITIAL_EVENT_ERROR",
                            "Failed to get initial call event",
                            null
                        )
                    }
                }

                "startForegroundService" -> {
                    try {
                        val running =
                            isServiceRunning(this, CallForeGroundService::class.java)
                        Log.e("MY_SERV", "000>startForegroundService")
                        if (running) {
                            Log.e("MY_SERV", "000>running not start")
                            result.success(null)
                        } else {
                            val callDataJson = call.argument<String>("callData")
                            if (callDataJson != null) {
                                Log.e("MY_SERV", "0000>callDataJson")
                                CallForeGroundService.start(this, callDataJson)
                                result.success(null)
                            } else {
                                result.error("INVALID_DATA", "Call data cannot be null", null)
                            }
                        }
                    } catch (e: Exception) {
                        Log.e("MainActivity", "Error starting foreground service: ${e.message}")
                        result.error(
                            "SERVICE_ERROR",
                            "Failed to start foreground service: ${e.message}",
                            null
                        )
                    }
                }

                "stopForegroundService" -> {
                    try {
                        val running =
                            isServiceRunning(this, CallForeGroundService::class.java)
                        Log.e("MY_SERV", "stopForegroundService>>$running")
                        if (running) CallForeGroundService.stop(this)
                        result.success(null)
                    } catch (e: Exception) {
                        Log.e("MainActivity", "Error stopping foreground service: ${e.message}")
                        result.error(
                            "SERVICE_ERROR",
                            "Failed to stop foreground service: ${e.message}",
                            null
                        )
                    }
                }

                "isServiceRunning" -> {
                    val running = isServiceRunning(this, CallForeGroundService::class.java)
                    Log.e("MY_SERV", "$running")
                    result.success(running)
                }

                else -> result.notImplemented()
            }
        }

        // NFC Channel for checking NFC status
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            NFC_CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "isNfcEnabled" -> {
                    try {
                        val nfcAdapter = NfcAdapter.getDefaultAdapter(this)
                        val isEnabled = nfcAdapter?.isEnabled ?: false
                        result.success(isEnabled)
                    } catch (e: Exception) {
                        Log.e("MainActivity", "Error checking NFC status: ${e.message}")
                        result.error("NFC_ERROR", "Failed to check NFC status: ${e.message}", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    fun isServiceRunning(context: Context, serviceClass: Class<*>): Boolean {
        val manager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        for (service in manager.getRunningServices(Int.MAX_VALUE)) {
            if (serviceClass.name == service.service.className) {
                return true
            }
        }
        return false
    }


    private fun hideBottomBar() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            window.insetsController?.let { controller ->
                controller.hide(WindowInsets.Type.navigationBars())
                controller.systemBarsBehavior =
                    WindowInsetsController.BEHAVIOR_SHOW_TRANSIENT_BARS_BY_SWIPE
            }
        }
    }
}
