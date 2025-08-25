import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkInfo {
  final Connectivity connectivity;
  NetworkInfo(this.connectivity);

  Future<bool> get isOnline async {
    final result = await connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }
}
