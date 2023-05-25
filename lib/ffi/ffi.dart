import 'dart:ffi';
import 'dart:io';

final _library = Platform.isAndroid
    ? DynamicLibrary.open('libnative_inc.so')
    : DynamicLibrary.process();

final incrementWithFFI = _library
    .lookupFunction<Int32 Function(Int32), int Function(int)>('native_inc');
