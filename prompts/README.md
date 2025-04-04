# Zdrasti Prompt Manager

This folder contains all the GPT prompt templates used in the Zdrasti app. Prompts are designed based on the final design specification and support variables such as:

- `{cefr_level}`: The user's CEFR language level (A1–C2)
- `{native_language}`: User's preferred language (e.g., English, Spanish, Turkish)
- `{topic}`: Lesson topic or theme
- `{safe_mode}`: Boolean for child-friendly content
- `{result}`: Boss battle result ("Passed", "Failed")
- `{region}` and `{theme}`: For Kukeri personality prompts

## Files

| File                          | Description |
|-------------------------------|-------------|
| `lesson_generator.json`       | Generates full lessons (vocab, grammar, dialogue, culture) |
| `placement_test.json`         | Estimates CEFR level from user's answers |
| `boss_battle_generator.json`  | Creates a multi-part boss test |
| `writing_evaluator.json`      | Gives feedback and score for user writing |
| `kukeri_response_template.txt`| Generates personality-driven Kukeri boss dialogue |
