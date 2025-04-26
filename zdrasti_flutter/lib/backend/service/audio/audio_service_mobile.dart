import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final FlutterTts _tts = FlutterTts();

  static Future<void> speak(String text) async {
    await _tts.setLanguage("bg-BG");
    await _tts.setSpeechRate(0.5);
    await _tts.speak(text);
  }

  static Future<void> playSound(String assetPath) async {
    try {
      final player = AudioPlayer();
      await player.play(AssetSource(assetPath));
    } catch (e) {
      print('🔇 Audio play error: $e');
    }
  }
}