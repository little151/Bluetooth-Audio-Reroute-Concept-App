package com.example.bluetooth_audio_router

import android.content.Context
import android.media.AudioManager
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "audio_router"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "routeAudio") {
                val appName = call.argument<String>("appName")
                val useBluetooth = call.argument<Boolean>("useBluetooth") ?: false
                routeAudio(appName, useBluetooth)
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun routeAudio(appName: String?, useBluetooth: Boolean) {
        val audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager

        if (useBluetooth) {
            audioManager.startBluetoothSco()
            audioManager.isBluetoothScoOn = true
            audioManager.mode = AudioManager.MODE_IN_CALL
        } else {
            audioManager.stopBluetoothSco()
            audioManager.isBluetoothScoOn = false
            audioManager.mode = AudioManager.MODE_NORMAL
        }
    }
}
