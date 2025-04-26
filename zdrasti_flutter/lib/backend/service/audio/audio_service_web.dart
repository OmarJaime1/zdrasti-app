// lib/backend/service/audio/audio_service_web.dart
import 'package:web/web.dart' as web;
import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static Future<void> speak(String text) async {
    final utterance = web.SpeechSynthesisUtterance(text);
    //TODO: resolve issue because bg-BG is not supported
    utterance.lang = 'ru-RU';
    web.window.speechSynthesis.cancel();
    web.window.speechSynthesis.speak(utterance);
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
