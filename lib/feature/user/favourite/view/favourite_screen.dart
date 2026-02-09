import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/assets.dart';
import '../../app_ground_user.dart';
import '../controller/favorite_controller.dart';
import '../models/favorite_api_models.dart';
import 'handyman_profile_screen.dart';

/// ✅ Favorites screen (matches your screenshot)
/// - Green title "Favorites"
/// - 2 list items with divider lines
/// - Left circular service icon
/// - Title + subtitle (professionals count)
/// - Small avatar stack under subtitle (overlap) + "+1" bubble
/// - Right chevron
///
/// Replace avatar/service icons with your real assets if needed.

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  static const _green = Color(0xFF2FA86A);
  static const _text = Color(0xFF1F1F1F);
  static const _muted = Color(0xFF8B8B8B);
  static const _line = Color(0xFFEDEDED);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FavoriteController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 14),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Text(
                "Favorites",
                style: TextStyle(
                  fontFamily: "Urbanist",
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: _green,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Divider(height: 1, thickness: 1, color: _line),

            // List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.error.isNotEmpty) {
                  return Center(
                    child: Text(
                      controller.error.value,
                      style: const TextStyle(color: _muted),
                    ),
                  );
                }

                if (controller.items.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 30, 24, 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 260),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  Images.noFavIcon,
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(height: 14),
                                const Text(
                                  "No favorites",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: _text,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: const TextSpan(
                                    style: TextStyle(
                                      color: _muted,
                                      fontSize: 12.5,
                                      height: 1.35,
                                    ),
                                    children: [
                                      TextSpan(
                                        text:
                                            "To save a professional, tap the heart icon",
                                      ),
                                      TextSpan(
                                        text: "♥",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 14),
                                SizedBox(
                                  width: double.infinity,
                                  height: 42,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Get.offAll(() => const UserAppGround());
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _green,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text(
                                      "Find professional",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: controller.items.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, thickness: 1, color: _line),
                  itemBuilder: (context, i) {
                    final it = controller.items[i];
                    final visibleCount =
                        it.professionals.length > 3 ? 3 : it.professionals.length;
                    final extraCount =
                        it.professionals.length > 3 ? it.professionals.length - 3 : 0;
                    return _FavoriteRow(
                      title: it.subcategory,
                      subtitle:
                          "${it.count} ${it.count == 1 ? 'professional' : 'professionals'}",
                      imageUrl: it.image,
                      professionals: it.professionals,
                      avatarCount: visibleCount,
                      extraCount: extraCount,
                      onTap: () {
                        Get.to(
                          () => HandymanProfileScreen(
                            title: it.subcategory,
                            professionals: it.professionals,
                          ),
                        );
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

/* ------------------------- Model ------------------------- */



/* ------------------------- Row UI ------------------------- */

class _FavoriteRow extends StatelessWidget {
  const _FavoriteRow({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.professionals,
    required this.avatarCount,
    required this.extraCount,
    required this.onTap,
  });

  static const _text = Color(0xFF1F1F1F);
  static const _muted = Color(0xFF8B8B8B);

  final String title;
  final String subtitle;
  final String imageUrl;
  final List<FavoriteProfessional> professionals;
  final int avatarCount; // number of visible avatars
  final int extraCount; // +N bubble (0 => hidden)
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Row(
          children: [
            // Left service icon circle
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                // color: const Color(0xFFF6F6F6),
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        width: 32,
                        height: 32,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Image.asset(
                          Images.cleaningAndhandymanIcon,
                          width: 32,
                          height: 32,
                        ),
                      )
                    : Image.asset(
                        Images.cleaningAndhandymanIcon,
                        width: 32,
                        height: 32,
                      ),
              ),

            ),
            const SizedBox(width: 12),

            // Title + subtitle + avatars
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.urbanist(
                      fontSize: 18,
                      fontWeight: FontWeight.w500, // Medium
                      height: 1.1, // 110%
                      letterSpacing: 0,
                      color: const Color(0xFF18191A),
                    ),
                  ),

                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      fontWeight: FontWeight.w400, // Regular
                      height: 1.1, // 110%
                      letterSpacing: 0,
                      color: const Color(0xFF6D6F73),
                    ),
                  ),

                  const SizedBox(height: 8),
                  _AvatarStack(
                    visibleCount: avatarCount,
                    extraCount: extraCount,
                    professionals: professionals,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),
            const Icon(Icons.chevron_right_rounded, color: Color.fromARGB(255, 26, 22, 22), size: 22),
          ],
        ),
      ),
    );
  }
}

/* ------------------------- Avatar Stack ------------------------- */

class _AvatarStack extends StatelessWidget {
  const _AvatarStack({
    required this.visibleCount,
    required this.extraCount,
    required this.professionals,
  });

  final int visibleCount;
  final int extraCount;
  final List<FavoriteProfessional> professionals;

  @override
  Widget build(BuildContext context) {
    // Tune these to match screenshot
    const double size = 18;
    const double overlap = 10;

    final total = visibleCount + (extraCount > 0 ? 1 : 0);
    final width = total <= 0 ? 0.0 : (size + (total - 1) * overlap);

    return SizedBox(
      height: size,
      width: width,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (int i = 0; i < visibleCount; i++)
            Positioned(
              left: i * overlap,
              child: _AvatarCircle(
                size: size,
                imageUrl: professionals[i].gallery.isNotEmpty
                    ? professionals[i].gallery.first
                    : '',
                fallbackColor: _demoAvatarColor(i),
              ),
            ),

          if (extraCount > 0)
            Positioned(
              left: visibleCount * overlap,
              child: _PlusBubble(size: size, count: extraCount),
            ),
        ],
      ),
    );
  }

  Color _demoAvatarColor(int i) {
    const colors = [
      Color(0xFFFFC107),
      Color(0xFF4FC3F7),
      Color(0xFFE57373),
      Color(0xFF81C784),
    ];
    return colors[i % colors.length];
  }
}

class _AvatarCircle extends StatelessWidget {
  const _AvatarCircle({
    required this.size,
    required this.imageUrl,
    required this.fallbackColor,
  });

  final double size;
  final String imageUrl;
  final Color fallbackColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: fallbackColor,
        border: Border.all(color: Colors.white, width: 2),
      ),
      clipBehavior: Clip.antiAlias,
      child: imageUrl.isNotEmpty
          ? Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            )
          : const SizedBox.shrink(),
    );
  }
}

class _PlusBubble extends StatelessWidget {
  const _PlusBubble({required this.size, required this.count});

  final double size;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Center(
        child: Text(
          "+$count",
          style: const TextStyle(
            fontFamily: "Urbanist",
            fontSize: 9.5,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1F1F1F),
            height: 1.0,
          ),
        ),
      ),
    );
  }
}
