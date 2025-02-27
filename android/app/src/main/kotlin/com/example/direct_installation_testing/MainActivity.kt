package com.example.direct_installation_testing

import android.content.Intent
import android.net.Uri
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity(){
    private val CHANNEL = "samples.altero.dev/esim"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
                if (call.method == "launchESimSetup") {
                    val activationCode: String? = call.argument("activation_code")

                    activationCode?.let { code ->
                        launchESimSetup(code)
                    }
                } else {
                    result.notImplemented()
                }
        }
    }

    private fun launchESimSetup(activationCode: String) {
        val intent = Intent(Intent.ACTION_VIEW)
        intent.data = Uri.parse(activationCode)
        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
        context.startActivity(intent)
    }
}
