import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'HangingScreen.dart';

/// ✅ Price of your service (matches screenshot)
/// - Top progress bar
/// - Back arrow (green)
/// - "Save and exit" on right
/// - Title + subtitle
/// - Green link text (underline)
/// - List rows with left icon, label, right chevron + dividers
class PriceOfServiceScreen extends StatelessWidget {
  const PriceOfServiceScreen({super.key});

  static const Color _green = Color(0xFF2FA86A);
  static const Color _muted = Color(0xFF6F6F6F);
  static const Color _text = Color(0xFF1E1E1E);
  static const Color _divider = Color(0xFFE6E6E6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),

              // ✅ Progress bar (left green fill + grey)
              const _TopProgress(value: 0.16),

              const SizedBox(height: 16),

              // Back + Save and exit
              Row(
                children: [
                  // ✅ Back arrow perfectly left-aligned
                  Padding(
                    padding: const EdgeInsets.all(
                      0,
                    ), // ✅ match your screen left padding
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => Get.back(),
                        child: SizedBox(
                          width: 32,
                          height: 32,
                          child: Center(
                            child: Transform.translate(
                              offset: const Offset(
                                -2,
                                0,
                              ), // ✅ perfect visual align
                              child: const Icon(
                                Icons.arrow_back,
                                size: 20,
                                color: PriceOfServiceScreen._green,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  TextButton(
                    onPressed: () => Get.back(),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: Size.zero,
                    ),
                    child: SizedBox(
                      width: 97,
                      height: 18,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Save and exit",
                          maxLines: 1,
                          overflow: TextOverflow.visible,
                          style: GoogleFonts.urbanist(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 1.1,
                            letterSpacing: 0,
                            color: const Color(0xFF727272),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Title
              SizedBox(
                width: 343, // ✅ Figma
                child: Text(
                  "Price of your service",
                  style: GoogleFonts.urbanist(
                    fontSize: 24, // ✅ Figma
                    fontWeight: FontWeight.w600, // ✅ SemiBold
                    height: 1.1, // ✅ 110%
                    letterSpacing: 0,
                    color: const Color(0xFF3FA96B), // ✅ Figma green primary
                  ),
                ),
              ),

              const SizedBox(height: 6),

              // Subtitle
              Text(
                "Set the price and duration of the services you want to offer",
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  fontWeight: FontWeight.w400, // Regular
                  height: 1.1, // 110%
                  letterSpacing: 0,
                  color: const Color(0xFF000000),
                ),
              ),

              const SizedBox(height: 10),

              // Green link
              InkWell(
                onTap: () {
                  // TODO: open info page / bottom sheet
                },
                child: SizedBox(
                  width: 343, // ✅ Figma
                  child: Text(
                    "How much you will make for my services?",
                    textAlign: TextAlign.center, // ✅ Figma center
                    style: GoogleFonts.urbanist(
                      fontSize: 16, // ✅ Figma
                      fontWeight: FontWeight.w600, // ✅ SemiBold
                      height: 1.1, // ✅ 110%
                      letterSpacing: 0,
                      color: const Color(0xFF3FA96B), // ✅ Green Primary
                      decoration: TextDecoration.underline,
                      decorationStyle: TextDecorationStyle.solid,
                      decorationThickness: 1, // keep clean like Figma
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),
              const Divider(color: _divider, height: 1),

              // List
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _ServiceRow(
                      icon: Icons.construction_outlined,
                      title: "Hanging",
                      onTap: () {
                        Get.to(() => const HangingScreen());
                      },
                    ),
                    const Divider(color: _divider, height: 1),

                    _ServiceRow(
                      icon: Icons.build_outlined,
                      title: "Small Repair",
                      onTap: () {},
                    ),
                    const Divider(color: _divider, height: 1),

                    _ServiceRow(
                      icon: Icons.chair_alt_outlined,
                      title: "Furniture assembly",
                      onTap: () {},
                    ),
                    const Divider(color: _divider, height: 1),

                    _ServiceRow(
                      icon: Icons.handyman_outlined,
                      title: "Installation",
                      onTap: () {},
                    ),
                    const Divider(color: _divider, height: 1),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===================== PROGRESS =====================
class _TopProgress extends StatelessWidget {
  const _TopProgress({required this.value});

  final double value; // 0..1

  @override
  Widget build(BuildContext context) {
    final v = value.clamp(0.0, 1.0);

    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;
        const h = 12.0;
        final fillW = (w * v).clamp(h, w);

        return ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: Container(
            height: h,
            color: const Color(0xFFE7E7E7),
            alignment: Alignment.centerLeft,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: fillW,
              height: h,
              decoration: BoxDecoration(
                color: PriceOfServiceScreen._green,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ===================== LIST ROW =====================
class _ServiceRow extends StatelessWidget {
  const _ServiceRow({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 32, color: PriceOfServiceScreen._text),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.urbanist(
                  fontSize: 18, // ✅ Figma
                  fontWeight: FontWeight.w500, // ✅ Medium
                  height: 1.1, // ✅ 110%
                  letterSpacing: 0,
                  color: const Color(0xFF727272), // ✅ Figma black text
                ),
              ),
            ),

            Transform.rotate(
              angle: math.pi, // ✅ 180° (same as -180°)
              child: const Icon(
                Icons
                    .arrow_back_ios_new_rounded, // looks like "arrow-back-simple"
                size: 24, // ✅ 24x24
                color: Color(
                  0xFF9E9E9E,
                ), // keep your grey (change if Figma says)
              ),
            ),
          ],
        ),
      ),
    );
  }
}
