class LocalizationService {
  static String nativeLanguage = 'en'; // default fallback

  static void setLanguage(String langCode) {
    nativeLanguage = langCode;
  }

  static String getLocalizedText(Map<String, String> localizedMap) {
    return localizedMap[nativeLanguage] ?? localizedMap['en'] ?? '';
  }
}
