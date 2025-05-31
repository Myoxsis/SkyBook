import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skybook/screens/add_flight_screen.dart';
import 'package:skybook/widgets/premium_badge.dart';

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

  testWidgets('wallet import available for premium users', (tester) async {
    final premium = ValueNotifier<bool>(true);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AddFlightScreen(flights: const [], premiumNotifier: premium),
        ),
      ),
    );

    expect(find.text('Import from Wallet'), findsOneWidget);
    expect(find.byType(PremiumBadge), findsNothing);

    await tester.tap(find.text('Import from Wallet'));
    await tester.pumpAndSettle();

    final state = tester.state(find.byType(AddFlightScreen)) as dynamic;
    expect(state._flightNumberController.text, 'AA123');
    expect(state._originController.text, 'JFK');
    expect(state._destinationController.text, 'LAX');
  });

  testWidgets('wallet import gated for free users', (tester) async {
    final premium = ValueNotifier<bool>(false);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AddFlightScreen(flights: const [], premiumNotifier: premium),
        ),
      ),
    );

    expect(find.byType(PremiumBadge), findsOneWidget);
    expect(find.text('Import from Wallet'), findsNothing);
  });
}
