import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:just_audio/just_audio.dart';
import '../services/audio_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AudioManager _audioManager = AudioManager();

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'mp4', 'm4a'],
    );

    if (result != null) {
      String path = result.files.single.path!;
      await _audioManager.player.setFilePath(path);
      _audioManager.currentFilePath = path;
      // Vẫn cần để cập nhật đoạn text tên bài hát
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    String? filePath = _audioManager.currentFilePath;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trạm Phát Nhạc Offline'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                filePath != null
                    ? 'Đang nạp file:\n${filePath.split('/').last}'
                    : 'Chưa có file nào được chọn',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _pickFile,
              icon: const Icon(Icons.folder_open),
              label: const Text('Chọn File MP3/MP4'),
            ),
            const SizedBox(height: 20),

            // 💡 Dùng StreamBuilder lắng nghe trạng thái nhạc
            StreamBuilder<PlayerState>(
              stream: _audioManager.player.playerStateStream,
              builder: (context, snapshot) {
                // Lấy trạng thái playing từ stream
                final isPlaying = snapshot.data?.playing ?? false;

                return FilledButton.icon(
                  onPressed: filePath != null
                      ? () {
                          // Xử lý trực tiếp logic Play/Pause ở đây
                          if (isPlaying) {
                            _audioManager.player.pause();
                          } else {
                            _audioManager.player.play();
                          }
                        }
                      : null,
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  label: Text(isPlaying ? 'Tạm Dừng' : 'Phát Nhạc'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
