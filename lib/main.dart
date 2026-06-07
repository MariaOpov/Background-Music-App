import 'package:flutter/material.dart';
import 'ui/home_screen.dart';

void main() {
  runApp(const BackgroundMusicApp());
}

class BackgroundMusicApp extends StatelessWidget {
  const BackgroundMusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Background Music App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
