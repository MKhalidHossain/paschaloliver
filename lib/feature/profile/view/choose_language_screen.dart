import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChooseLanguageScreen extends StatefulWidget {
  const ChooseLanguageScreen({
    super.key,
    this.initialLocale = "en",
  });

  /// Example: "en", "fr", "ar", "bn", "es", "pt", "zh", "zh_Hant"
  final String initialLocale;

  @override
  State<ChooseLanguageScreen> createState() => _ChooseLanguageScreenState();
}

class _ChooseLanguageScreenState extends State<ChooseLanguageScreen> {
  late String _selectedLocale;

  @override
  void initState() {
    super.initState();
    _selectedLocale = widget.initialLocale;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _LC.bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: _LC.green),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Choose Language",
          style: GoogleFonts.urbanist(
            fontSize: 16,
            fontWeight: FontWeight.w700, // Bold
            height: 1.1, // 110%
            letterSpacing: 0,
            color: const Color(0xFF000000),
          ),
        ),

        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: _LC.divider),
        ),
      ),
      body: ListView.separated(
        itemCount: kSupportedLanguages.length,
        separatorBuilder: (_, __) => const Divider(height: 1, thickness: 1, color: _LC.divider),
        itemBuilder: (context, i) {
          final lang = kSupportedLanguages[i];
          final isSelected = lang.locale == _selectedLocale;

          return InkWell(
            onTap: () {
              setState(() => _selectedLocale = lang.locale);
              // return selected language to previous screen
              Navigator.pop(context, lang);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // Flag
                  Container(
                    width: 26,
                    height: 18,
                    alignment: Alignment.center,
                    child: Text(
                      lang.flag,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Name
                  Expanded(
                    child: Text(
                      lang.name,
                      style: const TextStyle(
                        fontSize: 13.2,
                        fontWeight: FontWeight.w600,
                        color: _LC.text,
                      ),
                    ),
                  ),

                  // Right check (green circle like screenshot)
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: isSelected ? _LC.green : Colors.transparent,
                      borderRadius: BorderRadius.circular(11),
                      border: Border.all(
                        color: isSelected ? _LC.green : _LC.green,
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Returned model when user selects a language
class LanguageOption {
  final String name;   // English
  final String locale; // en, fr, ar, bn, zh_Hant
  final String flag;   // 🇬🇧

  const LanguageOption({
    required this.name,
    required this.locale,
    required this.flag,
  });
}

/// ✅ “All supported” list (you can add/remove anytime)
/// Note: Flutter can support ANY language — this list is what your app will show.
const List<LanguageOption> kSupportedLanguages = [
  // Popular
  LanguageOption(name: "English", locale: "en", flag: "🇬🇧"),
  LanguageOption(name: "Arabic", locale: "ar", flag: "🇸🇦"),
  LanguageOption(name: "Bengali", locale: "bn", flag: "🇧🇩"),
  LanguageOption(name: "French", locale: "fr", flag: "🇫🇷"),
  LanguageOption(name: "Spanish", locale: "es", flag: "🇪🇸"),
  LanguageOption(name: "Portuguese", locale: "pt", flag: "🇵🇹"),
  LanguageOption(name: "Hindi", locale: "hi", flag: "🇮🇳"),
  LanguageOption(name: "Urdu", locale: "ur", flag: "🇵🇰"),

  // Asia
  LanguageOption(name: "Chinese (Simplified)", locale: "zh", flag: "🇨🇳"),
  LanguageOption(name: "Chinese (Traditional)", locale: "zh_Hant", flag: "🇹🇼"),
  LanguageOption(name: "Japanese", locale: "ja", flag: "🇯🇵"),
  LanguageOption(name: "Korean", locale: "ko", flag: "🇰🇷"),
  LanguageOption(name: "Thai", locale: "th", flag: "🇹🇭"),
  LanguageOption(name: "Vietnamese", locale: "vi", flag: "🇻🇳"),
  LanguageOption(name: "Indonesian", locale: "id", flag: "🇮🇩"),
  LanguageOption(name: "Malay", locale: "ms", flag: "🇲🇾"),
  LanguageOption(name: "Filipino", locale: "fil", flag: "🇵🇭"),
  LanguageOption(name: "Tamil", locale: "ta", flag: "🇮🇳"),
  LanguageOption(name: "Telugu", locale: "te", flag: "🇮🇳"),
  LanguageOption(name: "Marathi", locale: "mr", flag: "🇮🇳"),
  LanguageOption(name: "Kannada", locale: "kn", flag: "🇮🇳"),
  LanguageOption(name: "Malayalam", locale: "ml", flag: "🇮🇳"),
  LanguageOption(name: "Gujarati", locale: "gu", flag: "🇮🇳"),
  LanguageOption(name: "Punjabi", locale: "pa", flag: "🇮🇳"),
  LanguageOption(name: "Nepali", locale: "ne", flag: "🇳🇵"),
  LanguageOption(name: "Sinhala", locale: "si", flag: "🇱🇰"),
  LanguageOption(name: "Burmese", locale: "my", flag: "🇲🇲"),
  LanguageOption(name: "Khmer", locale: "km", flag: "🇰🇭"),
  LanguageOption(name: "Lao", locale: "lo", flag: "🇱🇦"),
  LanguageOption(name: "Mongolian", locale: "mn", flag: "🇲🇳"),

  // Europe
  LanguageOption(name: "German", locale: "de", flag: "🇩🇪"),
  LanguageOption(name: "Italian", locale: "it", flag: "🇮🇹"),
  LanguageOption(name: "Dutch", locale: "nl", flag: "🇳🇱"),
  LanguageOption(name: "Russian", locale: "ru", flag: "🇷🇺"),
  LanguageOption(name: "Ukrainian", locale: "uk", flag: "🇺🇦"),
  LanguageOption(name: "Polish", locale: "pl", flag: "🇵🇱"),
  LanguageOption(name: "Romanian", locale: "ro", flag: "🇷🇴"),
  LanguageOption(name: "Greek", locale: "el", flag: "🇬🇷"),
  LanguageOption(name: "Czech", locale: "cs", flag: "🇨🇿"),
  LanguageOption(name: "Hungarian", locale: "hu", flag: "🇭🇺"),
  LanguageOption(name: "Slovak", locale: "sk", flag: "🇸🇰"),
  LanguageOption(name: "Slovenian", locale: "sl", flag: "🇸🇮"),
  LanguageOption(name: "Croatian", locale: "hr", flag: "🇭🇷"),
  LanguageOption(name: "Serbian", locale: "sr", flag: "🇷🇸"),
  LanguageOption(name: "Bulgarian", locale: "bg", flag: "🇧🇬"),
  LanguageOption(name: "Swedish", locale: "sv", flag: "🇸🇪"),
  LanguageOption(name: "Norwegian", locale: "no", flag: "🇳🇴"),
  LanguageOption(name: "Danish", locale: "da", flag: "🇩🇰"),
  LanguageOption(name: "Finnish", locale: "fi", flag: "🇫🇮"),

  // Middle East / Others
  LanguageOption(name: "Hebrew", locale: "he", flag: "🇮🇱"),
  LanguageOption(name: "Persian", locale: "fa", flag: "🇮🇷"),
  LanguageOption(name: "Turkish", locale: "tr", flag: "🇹🇷"),

  // Africa (common)
  LanguageOption(name: "Swahili", locale: "sw", flag: "🇰🇪"),
  LanguageOption(name: "Hausa", locale: "ha", flag: "🇳🇬"),
  LanguageOption(name: "Yoruba", locale: "yo", flag: "🇳🇬"),
  LanguageOption(name: "Igbo", locale: "ig", flag: "🇳🇬"),
  LanguageOption(name: "Amharic", locale: "am", flag: "🇪🇹"),
  LanguageOption(name: "Somali", locale: "so", flag: "🇸🇴"),
];

class _LC {
  static const bg = Colors.white;
  static const green = Color(0xFF27AE60);

  static const text = Color(0xFF111111);
  static const divider = Color(0xFFEDEDED);
}
