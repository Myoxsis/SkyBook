import 'package:flutter/services.dart';

import '../models/flight.dart';
import 'import_service.dart';

/// Provides integration with Apple Wallet to import boarding passes.
class WalletService {
  static const MethodChannel _channel = MethodChannel('skybook/wallet');

  /// Retrieves the raw boarding pass data from Apple Wallet via a platform
  /// channel and parses it into a [Flight]. Returns `null` if no pass was
  /// retrieved or parsing failed.
  static Future<Flight?> importFromWallet() async {
    try {
      final data = await _channel.invokeMethod<String>('getBoardingPass');
      if (data == null || data.isEmpty) return null;
      return ImportService.parseBarcodeData(data);
    } on PlatformException {
      return null;
    }
  }
}
