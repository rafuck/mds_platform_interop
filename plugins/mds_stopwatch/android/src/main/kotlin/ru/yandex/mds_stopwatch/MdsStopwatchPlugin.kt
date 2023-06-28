package ru.yandex.mds_stopwatch

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import android.util.Log;
import android.os.Handler;
import android.os.Looper;

import java.nio.ByteBuffer;
import java.nio.charset.Charset;
import java.util.Timer;
import java.util.TimerTask;
import kotlin.concurrent.scheduleAtFixedRate;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.EventChannel.EventSink;
import io.flutter.plugin.common.EventChannel.StreamHandler;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.BinaryMessenger.BinaryMessageHandler;
import io.flutter.plugin.common.BinaryMessenger.BinaryReply;

import ru.yandex.mds_stopwatch.ButtonPlatformViewFactory

/** MdsStopwatchPlugin */
class MdsStopwatchPlugin: FlutterPlugin, MethodCallHandler, StreamHandler {
  private lateinit var channel : MethodChannel
  private lateinit var eventChannel : EventChannel
  private var eventSink: EventSink? = null
  private var stopwatchChannel = StopwatchChannel()

  private var stopwatchBinary = StopwatchBinary()
  private lateinit var binaryMessenger: BinaryMessenger;

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    binaryMessenger = flutterPluginBinding.binaryMessenger;
    binaryMessenger.setMessageHandler("mds_stopwatch_binary") { message, reply ->
      binaryMessageHandler(message, reply);
    }

    channel = MethodChannel(binaryMessenger, "mds_stopwatch")
    channel.setMethodCallHandler(this)

    eventChannel = EventChannel(binaryMessenger, "mds_stopwatch_event")
    eventChannel.setStreamHandler(this)

    flutterPluginBinding.platformViewRegistry.registerViewFactory(
        ButtonPlatformViewFactory.TYPE,
        ButtonPlatformViewFactory(flutterPluginBinding),
    )
  }

  // EventChannel.StreamHandler methods
  override fun onListen(arguments: Any?, eventSink: EventSink?) {
    this.eventSink = eventSink
  }
  override fun onCancel(arguments: Any?) {
    eventSink = null
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "start") {
      stopwatchChannel.start(eventSink);
      result.success(null)
    } 
    else if (call.method == "stop") {
      stopwatchChannel.stop();
      result.success(null)
    }
    else if (call.method == "reset") {
      stopwatchChannel.reset(eventSink);
      result.success(null)
    }
    else if (call.method == "trigger_error"){
      result.error("Error code", "Error message", "Error description");
    }
    else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    binaryMessenger.setMessageHandler("mds_stopwatch_binary", null)
    eventChannel.setStreamHandler(null)
  }

  private fun binaryMessageHandler(message: ByteBuffer?, @NonNull reply: BinaryReply){
    if (message == null){
      Log.e("MSG", "Received: NULL")
      reply.reply(null)
      return
    }
    
    val cmd = decodeMessage(message)
    Log.i("MSG", "Received: $cmd")
    if (cmd == "start"){
      stopwatchBinary.start(binaryMessenger)
    }
    else if (cmd == "stop"){
      stopwatchBinary.stop()
    }
    else if (cmd == "reset"){
      stopwatchBinary.reset(binaryMessenger)
    }
    reply.reply(null)
  }

  private fun decodeMessage(message: ByteBuffer?): String {
    if (message == null) {
      return String()
    }

    return Charsets.UTF_8.decode(message).toString()
  }
}
