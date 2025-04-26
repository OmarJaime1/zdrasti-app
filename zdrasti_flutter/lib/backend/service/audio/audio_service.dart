// lib/backend/service/audio/audio_service.dart
export 'audio_service_mobile.dart'
  if (dart.library.js_interop) 'audio_service_web.dart';