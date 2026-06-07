import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'home_screen.dart';
import '../services/audio_manager.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const Center(child: Text('Màn hình Thư Viện')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: _screens[_selectedIndex]),
          _buildMiniPlayer(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.radio), label: 'Trạm Phát'),
          NavigationDestination(
            icon: Icon(Icons.queue_music),
            label: 'Thư Viện',
          ),
        ],
      ),
    );
  }

  // Khối Mini Player đã được bọc StreamBuilder
  Widget _buildMiniPlayer() {
    final AudioManager audioManager = AudioManager();

    // Lắng nghe sự thay đổi trạng thái của AudioPlayer (Play/Pause/Load)
    return StreamBuilder<PlayerState>(
      stream: audioManager.player.playerStateStream,
      builder: (context, snapshot) {
        final isPlaying = snapshot.data?.playing ?? false;
        final filePath = audioManager.currentFilePath;
        final fileName = filePath != null
            ? filePath.split('/').last
            : 'Chưa có bài hát';

        return Container(
          height: 70,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 70,
                height: 70,
                color: Theme.of(context).colorScheme.primaryContainer,
                child: const Icon(Icons.music_note, size: 30),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fileName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      filePath != null ? 'Đang phát' : 'Nhấn để chọn nhạc',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 32,
                ),
                onPressed: () {
                  if (filePath != null) {
                    if (isPlaying) {
                      audioManager.player.pause();
                    } else {
                      audioManager.player.play();
                    }
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.skip_next, size: 32),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
          ),
        );
      },
    );
  }
}
