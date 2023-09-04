import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkStatusService {
  StreamController<bool> networkStatusController =
  StreamController<bool>();

  NetworkStatusService() {
    Connectivity().onConnectivityChanged.listen((status){
      networkStatusController.add(_getNetworkStatus(status));
    });
  }

  bool _getNetworkStatus(ConnectivityResult status) {
    return status == ConnectivityResult.mobile || status == ConnectivityResult.wifi ? true : false;
  }
}
