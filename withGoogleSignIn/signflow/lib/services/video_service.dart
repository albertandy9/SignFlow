import 'package:flutter/material.dart'; 
import 'package:video_player/video_player.dart';

class VideoService {
  VideoPlayerController? _controller;
  Function(VideoPlayerController?)? _onControllerChanged;

  VideoPlayerController? get controller => _controller;

  void setOnControllerChanged(Function(VideoPlayerController?) callback) {
    _onControllerChanged = callback;
  }

  Future<void> initializeVideo(String videoPath) async {
    try {
      _controller?.dispose(); 
      _controller = VideoPlayerController.asset(videoPath);
      await _controller!.initialize();
      _controller!.setLooping(true);
      _onControllerChanged?.call(_controller);
    } catch (e) {
      debugPrint('Error initializing video: $e');
      _onControllerChanged?.call(null);
    }
  }

  void playVideo() {
    if (_controller != null && _controller!.value.isInitialized) {
      _controller!.play();
    }
  }

  void pauseVideo() {
    if (_controller != null && _controller!.value.isPlaying) {
      _controller!.pause();
    }
  }

  void togglePlayPause() {
    if (_controller != null) {
      _controller!.value.isPlaying ? pauseVideo() : playVideo();
    }
  }

  void disposeVideo() {
    _controller?.dispose();
    _controller = null;
    _onControllerChanged?.call(null);
  }
}
