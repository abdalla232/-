import 'package:flutter_test/flutter_test.dart';
import 'package:masroofi/main.dart';

void main() {
  testWidgets('shows the Arabic expense dashboard', (tester) async {
    await tester.pumpWidget(const MasroofiApp());
    expect(find.text('أهلًا يا سارة 👋'), findsOneWidget);
    expect(find.text('إجمالي مصروفات مارس'), findsOneWidget);
    expect(find.text('آخر العمليات'), findsOneWidget);
  });
}
