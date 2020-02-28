package com.liugl.light_player

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant



class MainActivity: FlutterActivity() {
    // 字符串常量，回到手机桌面
    private val channel = "back/desktop"
    // 返回到桌面事件
    private val backDesktopEvent = "backDesktop"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel).setMethodCallHandler { methodCall, result ->
            if (methodCall.method == backDesktopEvent) {
                moveTaskToBack(false)
                result.success(true)
            }
        }
    }
}