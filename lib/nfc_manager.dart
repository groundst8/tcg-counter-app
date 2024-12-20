import 'dart:async';
import 'package:flutter/services.dart';

class NFCManager {
  static const MethodChannel _channel = MethodChannel('nfc_channel');
  static final StreamController<bool> _nfcStreamController = StreamController<bool>.broadcast();

  static Stream<bool> get nfcStream => _nfcStreamController.stream;

  static void initialize() {
    _channel.setMethodCallHandler(_methodCallHandler);
  }

  static Future<void> _methodCallHandler(MethodCall call) async {
    switch (call.method) {
      case 'onTagDiscovered':
        _nfcStreamController.add(true);
        break;
      case 'onTagLost':
        _nfcStreamController.add(false);
        break;
      default:
        break;
    }
  }

  static Future<List<int>?> sendNfcVCommand(List<int> command) async {
    try {
      final List<dynamic> result = await _channel.invokeMethod('sendNfcVCommand', {'command': command});
      return result.cast<int>();
    } catch (e) {
      print('Error sending NfcV command: $e');
      return null;
    }
  }

  static void dispose() {
    _nfcStreamController.close();
  }
}
