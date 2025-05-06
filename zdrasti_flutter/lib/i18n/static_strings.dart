const Map<String, Map<String, String>> staticStrings = {
  //BOSS FLOW SECTION 
  // ✅ Buttons
  'button.submit': {
    'en': 'Submit',
    'es': 'Enviar',
    'tr': 'Gönder',
  },
  'button.next': {
    'en': 'Next',
    'es': 'Siguiente',
    'tr': 'Sonraki',
  },
  'button.submitAll': {
    'en': 'Submit All',
    'es': 'Enviar todo',
    'tr': 'Hepsini Gönder',
  },
  'button.submitAnswers': {
    'en': 'Submit Answers',
    'es': 'Enviar respuestas',
    'tr': 'Cevapları Gönder',
  },
  'boss.submitRoleplay': {
    'en': 'Submit Roleplay',
    'es': 'Entregar actuación',
    'tr': 'Rolü Gönder',
  },

  // ✅ Feedback
  'feedback.correct': {
    'en': '✅ Correct',
    'es': '✅ Correcto',
    'tr': '✅ Doğru',
  },
  'feedback.incorrect': {
    'en': '❌ Correct answer',
    'es': '❌ Respuesta correcta',
    'tr': '❌ Doğru cevap',
  },

  // ✅ Tracker / instructional
  'boss.sectionTracker': {
    'en': 'Section {current} of {total}',
    'es': 'Sección {current} de {total}',
    'tr': '{total} bölümden {current}',
  },

  'instruction.vocabTranslate': {
    'en': 'Translate this word into your language:',
    'es': 'Traduce esta palabra a tu idioma:',
    'tr': 'Bu kelimeyi kendi diline çevir:',
  },

  'instruction.readParagraph': {
    'en': 'Read this paragraph:',
    'es': 'Lee este párrafo:',
    'tr': 'Bu paragrafı oku:',
  },

  // ✅ Input field hints
  'input.translationHint': {
    'en': 'Type your translation...',
    'es': 'Escribe tu traducción...',
    'tr': 'Çevirinizi yazın...',
  },
  'input.answerHint': {
    'en': 'Type your answer...',
    'es': 'Escribe tu respuesta...',
    'tr': 'Cevabınızı yazın...',
  },
  'input.transcriptionHint': {
    'en': 'Type exactly what you hear...',
    'es': 'Escribe exactamente lo que escuchas...',
    'tr': 'Duyduğunuzu tam olarak yazın...',
  },
  'input.blank': {
    'en': '...',
    'es': '...',
    'tr': '...',
  },

  // ✅ Snackbars / system messages
  'snackbar.fillAllAnswers': {
    'en': 'Please fill in all answers before submitting.',
    'es': 'Por favor completa todas las respuestas antes de enviar.',
    'tr': 'Lütfen göndermeden önce tüm cevapları doldurun.',
  },
  'snackbar.fillAllBlanks': {
    'en': 'Please fill in all blanks before submitting.',
    'es': 'Por favor completa todos los espacios antes de enviar.',
    'tr': 'Lütfen göndermeden önce tüm boşlukları doldurun.',
  },

  'label.question': {
    'en': 'Q',
    'es': 'P',
    'tr': 'S',
  },

  //boss helpers
  'banner.practiceMode': {
    'en': 'Practice Mode: Writing locked.\nAvailable in {cooldown}',
    'es': 'Modo de práctica: Escritura bloqueada.\nDisponible en {cooldown}',
    'tr': 'Alıştırma modu: Yazma kilitli.\n{cooldown} içinde kullanılabilir',
  },

  //Tooltips
  'tooltip.playAudio': {
    'en': 'Play audio',
    'es': 'Reproducir audio',
    'tr': 'Sesi oynat',
  },

  // 📘 Lesson Screens
  'lesson.alphabetTitle': {
    'en': 'Alphabet Table',
    'es': 'Tabla del alfabeto',
    'tr': 'Alfabe Tablosu',
  },
  'lesson.exampleFormat': {
    'en': 'Example: {example} → {translation}',
    'es': 'Ejemplo: {example} → {translation}',
    'tr': 'Örnek: {example} → {translation}',
  },
  'lesson.done': {
    'en': 'Done',
    'es': 'Listo',
    'tr': 'Tamam',
  },
  'lesson.errorMarkingComplete': {
    'en': 'Failed to mark lesson complete.',
    'es': 'No se pudo marcar la lección como completada.',
    'tr': 'Ders tamamlandı olarak işaretlenemedi.',
  },

  'lesson.grammarTitle': {
    'en': 'Grammar',
    'es': 'Gramática',
    'tr': 'Dilbilgisi',
  },
  'lesson.examplesLabel': {
    'en': 'Examples:',
    'es': 'Ejemplos:',
    'tr': 'Örnekler:',
  },

  'lesson.listeningTitle': {
    'en': 'Listening',
    'es': 'Escucha',
    'tr': 'Dinleme',
  },
  'lesson.scriptLabel': {
    'en': 'Script:',
    'es': 'Guión:',
    'tr': 'Senaryo:',
  },

  'lesson.quizTitle': {
    'en': 'Lesson Quiz',
    'es': 'Quiz de la lección',
    'tr': 'Ders Sınavı',
  },
  'lesson.questionProgress': {
    'en': 'Question {current} of {total}',
    'es': 'Pregunta {current} de {total}',
    'tr': '{total} sorudan {current}',
  },
  'lesson.quizScore': {
    'en': 'You scored {correct} out of {total}',
    'es': 'Obtuviste {correct} de {total}',
    'tr': '{total} üzerinden {correct} puan aldınız',
  },
  'lesson.quizPassed': {
    'en': 'Great job! You understood the material.',
    'es': '¡Buen trabajo! Entendiste el material.',
    'tr': 'Aferin! Konuyu anladınız.',
  },
  'lesson.quizFailed': {
    'en': 'Nice effort! You can review and try again.',
    'es': '¡Buen intento! Puedes repasar y volver a intentarlo.',
    'tr': 'Güzel deneme! Gözden geçirip tekrar deneyebilirsin.',
  },
  'lesson.quizPrompt': {
    'en': 'Answer each question to continue.',
    'es': 'Responde cada pregunta para continuar.',
    'tr': 'Devam etmek için her soruyu yanıtlayın.',
  },

  'lesson.resultTitle': {
    'en': 'Lesson Complete',
    'es': 'Lección completada',
    'tr': 'Ders Tamamlandı',
  },

  'lesson.resultRepeat': {
    'en': 'You’ve completed this before — great review!',
    'es': 'Ya completaste esta lección — ¡buena revisión!',
    'tr': 'Bu dersi daha önce tamamladınız — harika bir tekrar!',
  },
  'lesson.resultFirstTime': {
    'en': 'Awesome! You completed this lesson for the first time.',
    'es': '¡Genial! Completaste esta lección por primera vez.',
    'tr': 'Harika! Bu dersi ilk kez tamamladınız.',
  },
  'lesson.resultTryAgain': {
    'en': 'You can review and try again — you’re almost there!',
    'es': 'Puedes repasar y volver a intentarlo — ¡ya casi llegas!',
    'tr': 'Gözden geçirip tekrar deneyebilirsin — neredeyse başardın!',
  },
  'lesson.resultPassed': {
    'en': '✅ You passed!',
    'es': '✅ ¡Aprobaste!',
    'tr': '✅ Başardınız!',
  },
  'lesson.resultFailed': {
    'en': '❌ Not quite!',
    'es': '❌ ¡Casi lo logras!',
    'tr': '❌ Henüz değil!',
  },
  'lesson.xpEarned': {
    'en': 'XP earned!',
    'es': 'XP ganados!',
    'tr': 'XP kazanıldı!',
  },
  'lesson.backToDashboard': {
    'en': 'Back to Dashboard',
    'es': 'Regresar al panel',
    'tr': 'Gösterge paneline dön',
  },
  'lesson.roleplayTitle': {
    'en': 'Roleplay Practice',
    'es': 'Práctica de diálogo',
    'tr': 'Rol Yapma Alıştırması',
  },
  'lesson.roleplayHint': {
    'en': 'Type your response...',
    'es': 'Escribe tu respuesta...',
    'tr': 'Cevabınızı yazın...',
  },
  'lesson.roleplayScore': {
    'en': 'You got {correct} of {total} correct.',
    'es': 'Obtuviste {correct} de {total} correctas.',
    'tr': '{total} üzerinden {correct} doğru yaptınız.',
  },
  'lesson.roleplayComplete': {
    'en': '🎉 Great job! You completed the dialogue.',
    'es': '🎉 ¡Buen trabajo! Completaste el diálogo.',
    'tr': '🎉 Aferin! Diyaloğu tamamladınız.',
  },

  'lesson.tipSlangTitle': {
    'en': 'Cultural Tip & Slang',
    'es': 'Consejo cultural y jerga',
    'tr': 'Kültürel İpucu ve Argo',
  },
  'lesson.slangLabel': {
    'en': '{region} Bulgarian Slang:',
    'es': 'Jerga búlgara de {region}:',
    'tr': '{region} Bulgar Argo:',
  },
  'lesson.slangRegionCommon': {
    'en': 'Common',
    'es': 'Común',
    'tr': 'Yaygın',
  },
  'lesson.vocabTitle': {
    'en': 'Vocabulary',
    'es': 'Vocabulario',
    'tr': 'Kelime Bilgisi',
  },

    'lesson.map.noLessons': {
    'en': 'No lessons found for this map.',
    'es': 'No se encontraron lecciones para este mapa.',
    'tr': 'Bu harita için ders bulunamadı.',
  },
  'lesson.map.followingPath': {
    'en': 'Following path...',
    'es': 'Siguiendo el camino...',
    'tr': 'Yol takip ediliyor...',
  },
  'boss.challengePrompt': {
    'en': 'Challenge the {boss}',
    'es': 'Desafía a {boss}',
    'tr': '{boss} ile savaş',
  },
  'tooltip.playScript': {
    'en': 'Play Script',
    'es': 'Reproducir guión',
    'tr': 'Senaryoyu oynat',
  },
  'tooltip.playPronunciation': {
    'en': 'Play pronunciation',
    'es': 'Reproducir pronunciación',
    'tr': 'Telaffuzu oynat',
  },

  'login.title': {
    'en': 'Log In',
    'es': 'Iniciar sesión',
    'tr': 'Giriş yap',
  },
  'login.email': {
    'en': 'Email',
    'es': 'Correo electrónico',
    'tr': 'E-posta',
  },
  'login.password': {
    'en': 'Password',
    'es': 'Contraseña',
    'tr': 'Şifre',
  },
  'login.button': {
    'en': 'Log In',
    'es': 'Iniciar sesión',
    'tr': 'Giriş yap',
  },
  'common.cancel': {
    'en': 'Cancel',
    'es': 'Cancelar',
    'tr': 'İptal',
  },
  'translation.show': {
    'en': 'Show translation',
    'es': 'Mostrar traducción',
    'tr': 'Çeviriyi göster',
  },
  'translation.hide': {
    'en': 'Hide translation',
    'es': 'Ocultar traducción',
    'tr': 'Çeviriyi gizle',
  },
};
