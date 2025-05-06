import 'package:zdrasti_flutter/i18n/static_strings.dart';

class LocalizationService {
  static String nativeLanguage = 'en'; // default fallback

  static void setLanguage(String langCode) {
    nativeLanguage = langCode;
  }

  static String getLocalizedText(Map<String, String> localizedMap) {
    return localizedMap[nativeLanguage] ?? localizedMap['en'] ?? '';
  }

  static String getStaticText(String key) {
    final map = staticStrings[key];
    if (map == null) return key;
    return map[nativeLanguage] ?? map['en'] ?? key;
  }

}
