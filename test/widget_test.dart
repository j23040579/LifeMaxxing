import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:life_maxxing/main.dart';

void main() {
  testWidgets('App smoke test - loads shell with tabs',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: LifeMaxxingApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify the tabs are present
    expect(find.text('Today'), findsWidgets);
    expect(find.text('Goals'), findsWidgets);
    expect(find.text('Library'), findsWidgets);
    expect(find.text('Review'), findsWidgets);
  });
}
