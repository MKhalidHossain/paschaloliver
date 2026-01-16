import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  static const route = '/privacy-policy';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.bg,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar (back + centered title like screenshot)
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 6),
              child: SizedBox(
                height: 44,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          if (Get.isOverlaysOpen) {
                            Get.back();
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            size: 18,
                            color: _C.text,
                          ),
                        ),
                      ),
                    ),
                    const Text(
                      "Privacy policy",
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w800,
                        color: _C.text,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // const Divider(height: 1, thickness: 1, color: _C.divider),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
                child: Text(
                  _DemoText.privacy,
                  style: GoogleFonts.poppins(
                    fontSize: 16, // ✅ 16px
                    fontWeight: FontWeight.w400, // ✅ Regular
                    height: 1.5, // ✅ 150%
                    letterSpacing: 0, // ✅ 0%
                    color: const Color(0xFF000000), // ✅ black
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _C {
  static const bg = Colors.white;
  static const text = Color(0xFF111111);
  static const divider = Color(0xFFEDEDED);
}

class _DemoText {
  static const privacy = """
Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.

Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.

Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.

Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.

Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.
""";
}
