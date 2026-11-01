import 'package:flutter_test/flutter_test.dart';
import 'package:bed_assistant/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const BedAssistantApp());
  });
}
