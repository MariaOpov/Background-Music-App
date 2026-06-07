import 'package:flutter_test/flutter_test.dart';
import 'package:background_music_app/main.dart';

void main() {
  testWidgets('Kiểm tra giao diện màn hình chính', (WidgetTester tester) async {
    // Build app của chúng ta.
    await tester.pumpWidget(const BackgroundMusicApp());

    // Kiểm tra xem có chữ 'Trạm Phát Nhạc Offline' trên màn hình không.
    expect(find.text('Trạm Phát Nhạc Offline'), findsOneWidget);
  });
}
