import 'package:flutter_test/flutter_test.dart';
import 'package:api_demo/main.dart';

void main() {
  testWidgets('Smoke test for PRO COMMERCE App', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Đợi dữ liệu sản phẩm (800ms delay) tải xong trong môi trường test
    await tester.pump(const Duration(seconds: 1));

    // Verify that our app name or catalog title is present.
    expect(find.text('PRO COMMERCE'), findsOneWidget);
  });
}
