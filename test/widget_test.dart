import 'package:flutter_test/flutter_test.dart';
import 'package:skybook/main.dart';

void main() {
  testWidgets('SkyBookApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SkyBookApp());
    expect(find.byType(SkyBookApp), findsOneWidget);
  });
}
