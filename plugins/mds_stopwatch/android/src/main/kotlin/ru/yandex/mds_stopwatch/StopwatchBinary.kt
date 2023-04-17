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
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.BinaryMessenger.BinaryMessageHandler;
import io.flutter.plugin.common.BinaryMessenger.BinaryReply;

class StopwatchBinary{
  private var accuracyMilliseconds: Long = 1.toLong()
  var isRunned: Boolean = false
    private set
  var expiredMilliseconds: Long = 0.toLong()
    private set
  private var timerTask: TimerTask? = null;

  fun start(binaryMessenger: BinaryMessenger){
    if (isRunned || accuracyMilliseconds < 1){
      return
    }

    stop()
    timerTask = Timer().scheduleAtFixedRate(0, accuracyMilliseconds){
      expiredMilliseconds += accuracyMilliseconds
      sendElapsed(binaryMessenger)
    }
    isRunned = true
  }

  fun stop(){
    if (!isRunned){
      return;
    }
    timerTask?.cancel()
    timerTask = null
    isRunned = false
  }

  fun reset(binaryMessenger: BinaryMessenger){
    expiredMilliseconds = 0
    sendElapsed(binaryMessenger)
  }

  private fun sendElapsed(binaryMessenger: BinaryMessenger){
    Handler(Looper.getMainLooper()).post {
      val message = ByteBuffer.allocateDirect(8)
      message.putLong(expiredMilliseconds)
      binaryMessenger.send("mds_stopwatch_binary_event", message);
    }
  }
}
