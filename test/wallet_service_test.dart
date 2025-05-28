import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skybook/services/wallet_service.dart';

void main() {
  const channel = MethodChannel('skybook/wallet');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'getBoardingPass') {
        return 'M1DOE/JANE           AA123 JFK LAX 2024-02-01';
      }
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('importFromWallet parses flight from wallet data', () async {
    final flight = await WalletService.importFromWallet();
    expect(flight, isNotNull);
    expect(flight!.callsign, 'AA123');
    expect(flight.origin, 'JFK');
    expect(flight.destination, 'LAX');
  });
}
