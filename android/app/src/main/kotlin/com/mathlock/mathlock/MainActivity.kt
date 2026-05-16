package com.mathlock.mathlock

import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val channel = "com.mathlock/overlay"
    private var screenReceiver: ScreenReceiver? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "startService" -> {
                        OverlayService.start(this)
                        result.success(null)
                    }
                    "requestOverlayPermission" -> {
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                            val intent = Intent(
                                Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                                Uri.parse("package:$packageName")
                            )
                            startActivity(intent)
                        }
                        result.success(null)
                    }
                    "hasOverlayPermission" -> {
                        result.success(Settings.canDrawOverlays(this))
                    }
                    "dismissOverlay" -> {
                        OverlayService.dismiss(this)
                        result.success(null)
                    }
                    "setOverlayEnabled" -> {
                        val enabled = call.argument<Boolean>("enabled") ?: true
                        getSharedPreferences("mathlock_prefs", Context.MODE_PRIVATE)
                            .edit().putBoolean("overlay_enabled", enabled).apply()
                        result.success(null)
                    }
                    "uninstallApp" -> {
                        val intent = Intent(Intent.ACTION_DELETE, Uri.parse("package:$packageName"))
                        startActivity(intent)
                        result.success(null)
                    }
                    "isOverlayMode" -> {
                        result.success(intent?.action == ACTION_OVERLAY_QUIZ)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        registerScreenReceiver()

        // If launched as overlay quiz, make it full screen and above lock screen
        if (intent?.action == ACTION_OVERLAY_QUIZ) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
                setShowWhenLocked(true)
                setTurnScreenOn(true)
            } else {
                @Suppress("DEPRECATION")
                window.addFlags(
                    android.view.WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                            android.view.WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON or
                            android.view.WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON
                )
            }
            // Prevent back button from exiting
            onBackPressedDispatcher.addCallback(this,
                object : androidx.activity.OnBackPressedCallback(true) {
                    override fun handleOnBackPressed() { /* blocked */ }
                })
        }
    }

    private fun registerScreenReceiver() {
        if (screenReceiver != null) return
        screenReceiver = ScreenReceiver()
        val filter = IntentFilter(Intent.ACTION_SCREEN_ON)
        registerReceiver(screenReceiver, filter)
    }

    override fun onDestroy() {
        screenReceiver?.let { unregisterReceiver(it) }
        super.onDestroy()
    }

    companion object {
        const val ACTION_OVERLAY_QUIZ = "com.mathlock.OVERLAY_QUIZ"
    }
}
