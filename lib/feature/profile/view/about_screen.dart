import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutHandyNaijaScreen extends StatelessWidget {
  const AboutHandyNaijaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.bg,
      appBar: AppBar(
        backgroundColor: _C.bg,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: _C.text),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "About HandyNaija App",
          style: TextStyle(
            color: _C.text,
            fontWeight: FontWeight.w700,
            fontSize: 14.5,
            height: 1.1,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
            // decoration: BoxDecoration(
            //   color: Colors.white,
            //   borderRadius: BorderRadius.circular(12),
            //   border: Border.all(color: _C.border, width: 1),
            // ),
            child: Text(
              _demoAboutText,
              style: GoogleFonts.poppins(
                fontSize: 16, // ✅ 16px
                fontWeight: FontWeight.w400, // ✅ Regular
                height: 1.5, // ✅ 150%
                letterSpacing: 0, // ✅ 0%
                color: const Color(0xFF000000), // ✅ #000000
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _C {
  static const bg = Colors.white;
  static const text = Color(0xFF111111);
  static const border = Color(0xFFEDEDED);
}

const String _demoAboutText = '''
Lorem ipsum is simply dummy text of the printing and typesetting industry. Lorem ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.

Lorem ipsum is simply dummy text of the printing and typesetting industry. Lorem ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.

Lorem ipsum is simply dummy text of the printing and typesetting industry. Lorem ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.

Lorem ipsum is simply dummy text of the printing and typesetting industry. Lorem ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.

Lorem ipsum is simply dummy text of the printing and typesetting industry. Lorem ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.
''';
