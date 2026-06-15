import 'package:flutter_test/flutter_test.dart';
import 'package:mila_vendor/main.dart';

void main() {
  testWidgets('App launches smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MilaVendorApp());
    expect(find.byType(MilaVendorApp), findsOneWidget);
  });
}
