import 'package:flutter_test/flutter_test.dart';
import 'package:my_first_app/main.dart';

void main() {
  testWidgets('NovaShop App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const NovaShopApp());
    expect(find.text('NovaShop'), findsOneWidget);
  });
}
