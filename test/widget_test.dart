import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tiktok_clone/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: TikTokCloneApp()),
    );

    // 앱이 정상적으로 빌드되는지 확인
    expect(find.byType(TikTokCloneApp), findsOneWidget);
  });
}
