import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketUtil {
  static String uri = 'http://polivalka.ddns.net';
  static late String path;
  static late Socket socket;
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<void> connect(
      String path, String event, dynamic function) async {
    try {
      socket = io(
          uri + path,
          OptionBuilder()
              .setTransports(['websocket'])
              .disableAutoConnect()
              .setExtraHeaders(
                  {'cookie': 'token=${await _storage.read(key: 'token')}'})
              .disableForceNew()
              .disableForceNewConnection()
              .disableReconnection()
              .build());
      socket.on(event, function);
      socket.connect();
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<void> dispose() async {
    socket.dispose();
  }
}
