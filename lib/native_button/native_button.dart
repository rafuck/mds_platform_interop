import 'dart:io';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import '../ffi/ffi.dart';

const _kChannelPrefix = 'mds_native_button';

class NativeButton extends StatefulWidget {
  static const _viewType = 'native_button';
  final bool useHybridComposition;
  final String text;

  const NativeButton({
    Key? key,
    this.useHybridComposition = true,
    required this.text,
  }) : super(key: key);

  @override
  State<NativeButton> createState() => _NativeButtonState();
}

class _NativeButtonState extends State<NativeButton> {
  MethodChannel? _methodChannel;
  int _counter = 0;

  void _onPlatformViewCreated(int viewId) {
    _methodChannel = MethodChannel('${_kChannelPrefix}_$viewId');
    _methodChannel?.setMethodCallHandler((call) async {
      if (call.method == "onClick") {
        _counter = incrementWithFFI(_counter);
        return '$_counter';
      }
    });
  }

  @override
  void dispose() {
    _methodChannel?.setMethodCallHandler(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return UiKitView(
        onPlatformViewCreated: _onPlatformViewCreated,
        viewType: NativeButton._viewType,
        layoutDirection: TextDirection.ltr,
        creationParams: widget.text,
        creationParamsCodec: const StandardMessageCodec(),
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
          Factory(() => LongPressGestureRecognizer())
        },
      );
    } else if (Platform.isAndroid) {
      if (widget.useHybridComposition) {
        return PlatformViewLink(
          viewType: NativeButton._viewType,
          surfaceFactory: (
            BuildContext context,
            PlatformViewController controller,
          ) {
            return AndroidViewSurface(
              controller: controller as AndroidViewController,
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                Factory(() => LongPressGestureRecognizer())
              },
              hitTestBehavior: PlatformViewHitTestBehavior.opaque,
            );
          },
          onCreatePlatformView: (PlatformViewCreationParams params) {
            return PlatformViewsService.initExpensiveAndroidView(
              id: params.id,
              viewType: params.viewType,
              onFocus: () => params.onFocusChanged(true),
              layoutDirection: TextDirection.ltr,
              creationParams: widget.text,
              creationParamsCodec: const StandardMessageCodec(),
            )
              ..addOnPlatformViewCreatedListener(_onPlatformViewCreated)
              ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
              ..create();
          },
        );
      } else {
        return AndroidView(
          viewType: NativeButton._viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: widget.text,
          onPlatformViewCreated: _onPlatformViewCreated,
          creationParamsCodec: const StandardMessageCodec(),
          gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
            Factory(() => LongPressGestureRecognizer())
          },
        );
      }
    } else {
      return const Center(
        child: Text("Platform is not supported"),
      );
    }
  }
}
