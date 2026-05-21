import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zeetech26/widgets/zeetech_bottom_nav.dart';

void main() {
  testWidgets('Bottom navigation bar displays items', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: ZeetechBottomNav(
            activeTab: 'home',
            onTabChange: (tab) {},
          ),
        ),
      ),
    );

    // Verify that the bottom nav items are shown.
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Services'), findsOneWidget);
    expect(find.text('About'), findsOneWidget);
    expect(find.text('Contact'), findsOneWidget);
  });
}
