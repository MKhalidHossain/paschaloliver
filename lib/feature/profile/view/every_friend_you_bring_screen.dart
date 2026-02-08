import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/assets.dart';

/// ------------------------------------------------------------
/// SHARE & EARN MONEY (UI LIKE YOUR SCREENSHOT) - GetX
/// - Back arrow
/// - Big illustration (placeholder)
/// - Title + bullet points
/// - "Discover code" button (disabled look like screenshot)
/// - Share icons row (WhatsApp / Facebook / Instagram / More)
///
/// Usage:
/// Get.to(() => const ShareAndEarnMoneyScreen());
/// ------------------------------------------------------------

class ShareAndEarnMoneyScreen extends StatelessWidget {
  const ShareAndEarnMoneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.bg,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Get.back(),
                    borderRadius: BorderRadius.circular(10),
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Share and earn money",
                    style: GoogleFonts.urbanist(
                      fontSize: 16,
                      fontWeight: FontWeight.w700, // Bold
                      height: 1.1, // 110%
                      letterSpacing: 0,
                      color: const Color(0xFF000000),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 6, 18, 16),
                children: [
                  const SizedBox(height: 6),

                  // Illustration (replace with your asset)
                  Center(
                    child: SizedBox(
                      height: 220,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 220,
                            height: 220,
                            decoration: BoxDecoration(
                              color: _C.soft,
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                          Container(
                            width: 190,
                            height: 190,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  _C.green.withOpacity(.18),
                                  Colors.white.withOpacity(.0),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                          // Placeholder icon (swap with Image.asset)
                          Image.asset(
                            Images.receiverIcon,
                            width: 375,
                            height: 300,
                            fit: BoxFit.contain,
                          ),

                          // small round avatars around (like screenshot)
                          Positioned(
                            left: 10,
                            top: 120,
                            child: _MiniUserBubble(),
                          ),
                          Positioned(
                            right: 4,
                            top: 40,
                            child: _MiniUserBubble(),
                          ),
                          Positioned(
                            right: 18,
                            bottom: 30,
                            child: _MiniUserBubble(isMasked: true),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "Receive \$10 and give\nothers \$10",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: _C.green,
                      height: 1.05,
                    ),
                  ),

                  const SizedBox(height: 14),

                  const _BulletRow(
                    emoji: "😁",
                    text:
                        "Earn \$10 discount for each friend\nyou bring to Handynaija",
                  ),
                  const SizedBox(height: 10),
                  const _BulletRow(
                    emoji: "🎁",
                    text:
                        "By registering with your code, your\nfriends will receive an additional \$10\nas a gift",
                  ),

                  const SizedBox(height: 18),

                  // Discover code button (grey like screenshot)
                  SizedBox(
                    height: 48,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: open discover / generate code
                        // Example: Get.to(() => const MyCodesScreen());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE9E9E9),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Discover code",
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w900,
                          color: _C.text,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    "Share code:",
                    style: GoogleFonts.urbanist(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                      color: const Color(0xFF181919),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _ShareIcon(
                        bg: const Color(0xFF25D366),
                        child: Image.asset(
                          Images.whatsappIcon,
                          width: 48,
                          height: 48,
                          fit: BoxFit.contain,
                        ),
                        onTap: () {},
                      ),
                      const SizedBox(width: 40),
                      _ShareIcon(
                        bg: const Color(0xFF1877F2),
                        child: Image.asset(
                          Images.facebookIcon1, // use your asset if you have
                          width: 48,
                          height: 48,
                          fit: BoxFit.contain,
                        ),
                        onTap: () {},
                      ),
                      const SizedBox(width: 40),
                      _ShareIcon(
                        bg: Colors.white,
                        child: Image.asset(
                          Images.instagramIcon,
                          width: 48,
                          height: 48,
                          fit: BoxFit.contain,
                        ),
                        onTap: () {},
                      ),
                      const SizedBox(width: 40),
                      _ShareIcon(
                        bg: const Color(0xFFE5E5E5),
                        child: const Icon(
                          Icons.more_horiz_rounded,
                          color: _C.text,
                          size: 24,
                        ),
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BulletRow extends StatelessWidget {
  const _BulletRow({required this.emoji, required this.text});
  final String emoji;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: _C.text,
              height: 1.25,
            ),
          ),
        ),
      ],
    );
  }
}

class _ShareIcon extends StatelessWidget {
  const _ShareIcon({
    required this.bg,
    required this.child,
    required this.onTap,
  });

  final Color bg;
  final Widget child; // ✅ icon OR image
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}

class _MiniUserBubble extends StatelessWidget {
  const _MiniUserBubble({this.isMasked = false});
  final bool isMasked;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: const Color(0xFFE6E6E6),
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            isMasked ? Icons.person : Icons.person_outline_rounded,
            size: 28,
            color: const Color(0xFF2F2F2F),
          ),
          Positioned(
            right: 6,
            bottom: 6,
            child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: _C.green,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add_rounded,
                size: 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _C {
  static const bg = Colors.white;
  static const green = Color(0xFF27AE60);
  static const text = Color(0xFF111111);
  static const soft = Color(0xFFF2F2F2);
}
