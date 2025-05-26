import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('text scales with MediaQuery', (tester) async {
    const key = Key('test_text');

    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(textScaleFactor: 2.0),
          child: Scaffold(
            body: Text('Hello', key: key),
          ),
        ),
      ),
    );

    final richText = tester.widget<RichText>(find.descendant(
      of: find.byKey(key),
      matching: find.byType(RichText),
    ));

    expect(richText.textScaleFactor, 2.0);
  });
}
