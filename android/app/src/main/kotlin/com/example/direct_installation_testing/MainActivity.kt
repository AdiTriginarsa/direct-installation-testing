package com.example.direct_installation_testing

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity(){
    private val CHANNEL = "samples.altero.dev/esim"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            if (call.method == "launchESimSetup") {
                val activationCode = call.arguments as String
                Log.d("ACTIVATION_CODE", activationCode)
                launchESimSetup(activationCode)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun launchESimSetup(activationCode: String) {
        val intent = Intent(Intent.ACTION_VIEW)
        intent.data = Uri.parse(activationCode)
        startActivity(intent)
    }
}
