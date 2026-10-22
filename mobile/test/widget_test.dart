import 'package:flutter_test/flutter_test.dart';
import 'package:vetledger_mobile/main.dart';

void main() {
  testWidgets('VetLedger app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const VetLedgerApp());
    expect(find.text('VetLedger AI'), findsWidgets);
    expect(find.text('Dashboard'), findsWidgets);
  });
}
