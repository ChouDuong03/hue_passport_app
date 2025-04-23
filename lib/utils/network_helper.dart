import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../widgets/no_wifi_alert.dart'; // import nếu bạn tách dialog riêng

Future<bool> checkConnectionAndShowDialog(BuildContext context) async {
  var result = await Connectivity().checkConnectivity();
  if (result == ConnectivityResult.none) {
    showDialog(
      context: context,
      builder: (_) => const NoInternetDialog(),
    );
    return false;
  }
  return true;
}
