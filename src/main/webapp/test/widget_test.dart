import 'package:flutter_test/flutter_test.dart';

import 'package:tidraw/main.dart';

void main() {
  testWidgets('UI rendering test', (WidgetTester tester) async {
    await tester.pumpWidget(App());
  });
}
