package com.mathlock.mathlock

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.provider.Settings

class ScreenReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action != Intent.ACTION_SCREEN_ON) return

        // Only show overlay if permission is granted and overlay is enabled
        val prefs = context.getSharedPreferences("mathlock_prefs", Context.MODE_PRIVATE)
        val enabled = prefs.getBoolean("overlay_enabled", true)
        if (!enabled) return

        if (!Settings.canDrawOverlays(context)) return

        OverlayService.show(context)
    }
}
