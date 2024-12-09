// lib/services/audio_service.dart

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioService extends ChangeNotifier {
  static final AudioService _instance = AudioService._internal();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  double _volume = 0.5;

  // Singleton pattern
  factory AudioService() {
    return _instance;
  }

  AudioService._internal() {
    _initAudioPlayer();
  }

  void _initAudioPlayer() {
    // 기본 설정
    _audioPlayer.setReleaseMode(ReleaseMode.loop); // 무한 반복 설정
    _audioPlayer.setVolume(_volume); // 기본 볼륨 설정

    // 상태 변화 감지
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      _isPlaying = state == PlayerState.playing;
      notifyListeners();
    });
  }

  Future<void> initBackgroundMusic(String assetPath) async {
    try {
      await _audioPlayer.setSource(AssetSource(assetPath));
      debugPrint('Background music initialized: $assetPath');
    } catch (e) {
      debugPrint('Error initializing background music: $e');
    }
  }

  Future<void> play() async {
    try {
      await _audioPlayer.resume();
      _isPlaying = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error playing audio: $e');
    }
  }

  Future<void> pause() async {
    try {
      await _audioPlayer.pause();
      _isPlaying = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error pausing audio: $e');
    }
  }

  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
      _isPlaying = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error stopping audio: $e');
    }
  }

  Future<void> setVolume(double volume) async {
    try {
      if (volume >= 0 && volume <= 1) {
        await _audioPlayer.setVolume(volume);
        _volume = volume;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error setting volume: $e');
    }
  }

  // getter 메서드들
  bool get isPlaying => _isPlaying;
  double get volume => _volume;

  // 앱 종료 시 리소스 해제
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
