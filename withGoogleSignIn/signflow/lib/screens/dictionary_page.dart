import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:signflow/style/app_color.dart';
import 'package:signflow/style/text.dart';
import 'package:signflow/services/video_service.dart';

class DictionaryPage extends StatefulWidget {
  const DictionaryPage({super.key});

  @override
  State<DictionaryPage> createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  final List<String> _alphabet = List.generate(
    26,
    (i) => String.fromCharCode(65 + i),
  );
  String? _activeLetter;
  final VideoService _videoService = VideoService();
  VideoPlayerController? _currentVideoController;

  @override
  void initState() {
    super.initState();
    _videoService.setOnControllerChanged((controller) {
      setState(() {
        _currentVideoController = controller;
      });
    });
  }

  void _onLetterTap(String letter) async {
    final String videoPath = 'assets/alphabet/$letter.mp4';

    if (_activeLetter == letter) {
      _videoService.disposeVideo();
      setState(() {
        _activeLetter = null;
      });
    } else {
      await _videoService.initializeVideo(videoPath);
      _videoService.playVideo();
      setState(() {
        _activeLetter = letter;
      });
    }
  }

  @override
  void dispose() {
    _videoService.disposeVideo();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gradientStart, 
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.gradientStart,
              AppColors.gradientEnd,
            ], // Consistent gradient
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  AppText.enText['alphabet_title']!,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ..._alphabet.map(
                (letter) => Column(
                  children: [
                    _buildWordItem(letter),
                    if (_activeLetter == letter &&
                        _currentVideoController != null &&
                        _currentVideoController!.value.isInitialized)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: AspectRatio(
                            aspectRatio:
                                _currentVideoController!.value.aspectRatio,
                            child: VideoPlayer(_currentVideoController!),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWordItem(String word) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.tileBackground,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: AppColors.tileShadow.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          word,
          style: const TextStyle(fontSize: 18, color: AppColors.textPrimary),
          textAlign: TextAlign.center,
        ),
        trailing: Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: AppColors.playButton,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.play_arrow, color: AppColors.icon),
        ),
        onTap: () => _onLetterTap(word),
      ),
    );
  }
}
