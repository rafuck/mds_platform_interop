package ru.yandex.mds_stopwatch

import android.content.Context
import android.view.View
import android.widget.Button
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

class ButtonPlatformView(
    context: Context,
    id: Int,
    creationParams: String,
    flutterPluginBinding: FlutterPlugin.FlutterPluginBinding
) :
    PlatformView {
    private val methodChannel =
        MethodChannel(flutterPluginBinding.binaryMessenger, "mds_native_button_$id")

    private val button = Button(context).apply {
        text = creationParams
        setOnClickListener {
            methodChannel.invokeMethod(
                "onClick", null,
                object : MethodChannel.Result {
                    override fun success(result: Any?) {
                        if (result is String) {
                            text = result
                        }
                    }

                    override fun error(
                        errorCode: String,
                        errorMessage: String?,
                        errorDetails: Any?
                    ) {

                    }

                    override fun notImplemented() {

                    }
                },
            )
        }
    }

    override fun getView(): View {
        return button
    }

    override fun dispose() {

    }
}