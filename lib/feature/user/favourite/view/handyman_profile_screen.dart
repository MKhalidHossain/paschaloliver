import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/assets.dart';

/// ✅ Handyman Profile Card Screen
/// ✅ NEW: Tap the RED PORTION (left info area) => FavoritesEmptyScreen
class HandymanProfileScreen extends StatelessWidget {
  const HandymanProfileScreen({super.key});

  static const _line = Color(0xFFEDEDED);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(title: "Handyman", onBack: () => Get.back()),
            const Divider(height: 1, thickness: 1, color: _line),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                children: const [_ProfileCard()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ----------------------------- TOP BAR ----------------------------- */

class _TopBar extends StatelessWidget {
  const _TopBar({required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  static const _green = Color(0xFF2FA86A);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: onBack,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 18,
                    color: _green,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "Profile",
                    style: GoogleFonts.urbanist(
                      fontSize: 16,
                      fontWeight: FontWeight.w400, // Regular
                      height: 1.1,
                      letterSpacing: 0,
                      color: const Color(0xFF3FA96B),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "Handyman",
                style: GoogleFonts.urbanist(
                  fontSize: 16,
                  fontWeight: FontWeight.w700, // Bold
                  height: 1.1, // 110%
                  letterSpacing: 0,
                  color: const Color(0xFF000000),
                ),
              ),
            ),
          ),
          const SizedBox(width: 72),
        ],
      ),
    );
  }
}

/* ----------------------------- CARD ----------------------------- */

class _ProfileCard extends StatelessWidget {
  const _ProfileCard();

  static const _green = Color(0xFF2FA86A);
  static const _text = Color(0xFF1F1F1F);
  static const _muted = Color(0xFF8B8B8B);

  @override
  Widget build(BuildContext context) {
    final photos = <String>[
      Images.men,
      Images.men,
      Images.men,
      Images.men,
      Images.men,
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE9E9E9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ RED PORTION = avatar + info area (clickable)
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Get.to(() => const FavoritesEmptyScreen());
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            Images.men,
                            width: 52,
                            height: 52,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      "Nicolas bond",
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.urbanist(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400, // Regular
                                        height: 1.1,
                                        color: const Color(0xFF727272),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const _VerifiedDot(),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Handyman",
                                style: GoogleFonts.urbanist(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500, // Medium
                                  height: 1.1,
                                  color: const Color(0xFF181919),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: const [
                                  Text(
                                    "₦20.50",
                                    style: TextStyle(
                                      fontFamily: "Urbanist",
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w800,
                                      color: _green,
                                      height: 1.1,
                                    ),
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    "Per hour",
                                    style: TextStyle(
                                      fontFamily: "Urbanist",
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w600,
                                      color: _muted,
                                      height: 1.1,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const _Stars(rating: 4.8),
                                  const SizedBox(width: 6),
                                  Text(
                                    "4.8",
                                    style: GoogleFonts.urbanist(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400, // Regular
                                      height: 1.1,
                                      color: const Color(0xFF727272),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "|",
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      height: 1.2,
                                      color: const Color(0xFF727272),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    "4,323 Reviews",
                                    style: TextStyle(
                                      fontFamily: "Urbanist",
                                      fontSize: 11.2,
                                      fontWeight: FontWeight.w600,
                                      color: _muted,
                                      height: 1.1,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // right side remains non-clickable
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Icon(Icons.favorite_rounded, color: _green, size: 18),
                    const SizedBox(height: 18),
                    Text(
                      "656 Services", // or your dynamic value
                      style: GoogleFonts.urbanist(
                        fontSize: 12,
                        fontWeight: FontWeight.w500, // Medium
                        height: 1.1,
                        color: const Color(0xFF727272),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // chips
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _InfoChip(
                        icon: Icons.badge_outlined,
                        text: "Business Profile",
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _InfoChip(
                        icon: Icons.repeat_rounded,
                        text: "7 have repeated",
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _InfoChip(
                        icon: Icons.calendar_month_outlined,
                        text: "Updated schedule",
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _InfoChip(
                        icon: Icons.attach_money_rounded,
                        text: "Minimum charge ₦30",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(
            width: 350,
            child: Divider(
              height: 0,
              thickness: 0.7,
              color: Color.fromARGB(255, 22, 17, 17),
            ),
          ),

          const SizedBox(height: 4),

          // photos
          SizedBox(
            height: 66,
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              scrollDirection: Axis.horizontal,
              itemCount: photos.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, i) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    photos[i],
                    width: 66,
                    height: 54,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/* ----------------------------- FAVORITES EMPTY SCREEN ----------------------------- */

class FavoritesEmptyScreen extends StatelessWidget {
  const FavoritesEmptyScreen({super.key});

  static const _green = Color(0xFF2FA86A);
  static const _line = Color(0xFFEDEDED);
  static const _muted = Color(0xFF8B8B8B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Title like your screenshot: "Favorites" in green + divider line
            Container(
              height: 54,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerLeft,
              child: Text(
                "Favorites",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w500, // Medium
                  height: 1.2,
                  color: const Color(0xFF3FA96B),
                ),
              ),
            ),
            const Divider(height: 1, thickness: 2, color: Color(0xFFE5EEFF)),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "No favorites",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        height: 1.2,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF727272),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Illustration (use your asset)
                    Image.asset(
                      Images.noFavIcon, // ✅ set this in assets.dart
                      width: 160,
                      height: 140,
                      fit: BoxFit.contain,
                    ),

                    const SizedBox(height: 14),
                    Text(
                      "To save a professional, tap the heart icon(❤)",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.urbanist(
                        fontSize: 16,
                        fontWeight: FontWeight.w500, // Medium
                        height: 1.2, // 120%
                        color: const Color(0xFF727272),
                      ),
                    ),
                    const SizedBox(height: 18),

                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back(); // or Get.to(SearchScreen())
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _green,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Find professional",
                          style: GoogleFonts.urbanist(
                            fontSize: 16,
                            fontWeight: FontWeight.w500, // Medium
                            height: 1.1,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ----------------------------- SMALL WIDGETS ----------------------------- */

class _VerifiedDot extends StatelessWidget {
  const _VerifiedDot();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      Images.checkBadgeIcon,
      width: 8,
      height: 8,
      fit: BoxFit.contain,
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE6E6E6)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // ✅ center like Figma
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF727272)),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.urbanist(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 1.1,
                color: const Color(0xFF727272),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Stars extends StatelessWidget {
  const _Stars({required this.rating});
  final double rating;

  @override
  Widget build(BuildContext context) {
    final full = rating.floor().clamp(0, 5);
    final half = (rating - full) >= 0.5 && full < 5;

    final stars = <Widget>[];
    for (int i = 0; i < 5; i++) {
      if (i < full) {
        stars.add(
          const Icon(Icons.star_rounded, size: 14, color: Color(0xFFF4B400)),
        );
      } else if (i == full && half) {
        stars.add(
          const Icon(
            Icons.star_half_rounded,
            size: 14,
            color: Color(0xFFF4B400),
          ),
        );
      } else {
        stars.add(
          const Icon(
            Icons.star_border_rounded,
            size: 14,
            color: Color(0xFFF4B400),
          ),
        );
      }
    }
    return Row(children: stars);
  }
}
