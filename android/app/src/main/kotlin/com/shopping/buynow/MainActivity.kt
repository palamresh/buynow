package com.shopping.buynow

import android.content.Context
import android.os.BatteryManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity(){
    private val CHANNEL = "com.example/battery"

    override fun configureFlutterEngine(flutterEngine: io.flutter.embedding.engine.FlutterEngine){
        super.configureFlutterEngine(flutterEngine)

       MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        .setMethodCallHandler{call,result->
         when (call.method) {
            "getBatteryLevel" -> {
                val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
                val batteryLevel: Int = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
                result.success(batteryLevel)
            }
            "getDeviceInfo" -> {
                val manufacturer = android.os.Build.MANUFACTURER
                val model = android.os.Build.MODEL
                val version = android.os.Build.VERSION.RELEASE
                result.success("Android $version ($manufacturer $model)")
            }
            "getSum" -> {
                val args = call.arguments as Map<String, Int>
                val a = args["a"] ?: 0
                val b = args["b"] ?: 0
                val sum = a + b
                result.success(sum)
            }
            else -> result.notImplemented()
        }
        }

    }

}
