import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionService {
  static final Connectivity connectivity = Connectivity();
  static Future<bool> isConnected() async {
    final ConnectivityResult result = await connectivity.checkConnectivity();
    return verifyConnectivityResult(result);
  }

  static Stream<bool> stream() {
    return connectivity.onConnectivityChanged
        .map(verifyConnectivityResult)
        .asBroadcastStream();
  }

  static bool verifyConnectivityResult(ConnectivityResult result) {
    var connected = false;
    if (result == ConnectivityResult.wifi) {
      connected = true;
    } else if (result == ConnectivityResult.mobile) {
      connected = true;
    }
    return connected;
  }
}
