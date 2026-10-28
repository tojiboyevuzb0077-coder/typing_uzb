import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:typing_culub/main.dart';

void main() {
  testWidgets('TypeUz app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: TypeUzApp(),
      ),
    );

    // Verify that app title or navbar appears.
    expect(find.text('TypeUz'), findsWidgets);
  });
}
