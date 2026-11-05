import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:intl/intl.dart';

Future<bool> isOnMeteredNetwork() async {
  final connections = await Connectivity().checkConnectivity();
  final hasUnmeteredLink = connections.any((connection) => connection == ConnectivityResult.wifi || connection == ConnectivityResult.ethernet);
  return !hasUnmeteredLink && connections.contains(ConnectivityResult.mobile);
}

String megabytesLabel(int bytes, String localeName) => '${NumberFormat.decimalPatternDigits(locale: localeName, decimalDigits: 1).format(bytes / 1000000)} ${localeName.startsWith('fr') ? 'Mo' : 'MB'}';
