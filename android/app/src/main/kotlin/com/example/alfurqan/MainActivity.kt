package com.example.alfurqan

import android.content.Context
import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
	private val CHANNEL = "com.alfurqan/vibrate"

	override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
		super.configureFlutterEngine(flutterEngine)
		MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
			if (call.method == "vibrate") {
				val durationArg = call.argument<Number>("duration")
				val duration = (durationArg?.toLong() ?: 80L)
				try {
					val vibrator = getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
					if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
						vibrator.vibrate(VibrationEffect.createOneShot(duration, VibrationEffect.DEFAULT_AMPLITUDE))
					} else {
						@Suppress("DEPRECATION")
						vibrator.vibrate(duration)
					}
					result.success(null)
				} catch (e: Exception) {
					result.error("VIBRATE_FAILED", e.message, null)
				}
			} else {
				result.notImplemented()
			}
		}
	}
}
