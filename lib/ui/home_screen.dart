import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:just_audio/just_audio.dart';
// Just_audio dùng để phát nhạc

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedFilePath;

  // Khởi tạo phát nhạc
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  @override
  void dispose() {
    // Luôn nhớ giải phóng bộ nhớ khi tắt màn hình
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'mp4', 'm4a'],
    );

    if (result != null) {
      String path = result.files.single.path!;

      // Nạp file nhạc vào audioplayer ngay khi chọn xong
      await _audioPlayer.setFilePath(path);

      setState(() {
        _selectedFilePath = path;
        // Reset trạng thái về chưa phát
        _isPlaying = false;
      });
      print("Đã nạp nhạc: $_selectedFilePath");
    }
  }

  // 3. Hàm xử lý Phát/Tạm dừng
  Future<void> _togglePlay() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }

    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                _selectedFilePath != null
                    ? 'Đang nạp file:\n${_selectedFilePath!.split('/').last}'
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

            // Nút bấm xịn sò tự đổi icon và text
            FilledButton.icon(
              onPressed: _selectedFilePath != null ? _togglePlay : null,
              icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
              label: Text(_isPlaying ? 'Tạm Dừng' : 'Phát Nhạc'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
