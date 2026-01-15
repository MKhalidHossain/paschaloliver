import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/assets.dart';
import 'PriceOfServiceScreen.dart';
import 'create_listing_screen.dart';

/// ✅ Home category details screen (matches your screenshot)
/// - Top progress bar
/// - Back arrow (green)
/// - Title + subtitle
/// - Search field
/// - "←  Home" row centered
/// - 3x2 bubbles + 1 centered bubble
///
/// Uses your Images paths:
/// cleaningIcon, ironingIcon, handyIcon, paintIcon, interiorIcon, pestIcon, kitchenIcon
class ListingHomeCategoryScreen extends StatelessWidget {
  const ListingHomeCategoryScreen({super.key});

  static const Color _green = Color(0xFF2FA86A);
  static const Color _muted = Color(0xFF6F6F6F);
  static const Color _fieldBorder = Color(0xFFBDBDBD);

  final double _progress = 0.06;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            16,
            10,
            16,
            0,
          ), // ✅ 16 makes width = 343
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),

              // Progress bar
              // Progress bar
              _TopProgress(value: _progress),

              const SizedBox(height: 12),

              // Back
              // ✅ Back button that is PERFECTLY aligned with the left edge (x = 16)
              Align(
                alignment: Alignment.centerLeft,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => Get.back(),
                    child: const SizedBox(
                      width: 40,
                      height: 40,
                      child: Align(
                        alignment: Alignment.centerLeft, // ✅ important
                        child: Icon(
                          Icons.arrow_back,
                          size: 22,
                          color: ListingHomeCategoryScreen._green,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Create your listing",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: _green,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Select or search for the service you want you offer",
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.1, // Figma 110%
                  letterSpacing: 0,
                  color: const Color(0xFF000000),
                ),
              ),

              const SizedBox(height: 14),

              _SearchField(
                hint: "Handyman, cleaning, ironing...",
                onChanged: (v) {},
              ),

              const SizedBox(height: 18),

              // Center "← Home"
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 14,
                      color: Color(0xFF6F6F6F),
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Home",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6F6F6F),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 320),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _ServiceBubble(
                              iconPath: Images.cleaningIcon,
                              label: "Cleaning",
                              onTap: () {
                                Get.to(() => const PriceOfServiceScreen());
                              },
                            ),
                            _ServiceBubble(
                              iconPath: Images.ironingIcon,
                              label: "Ironing",
                              onTap: () {},
                            ),
                            _ServiceBubble(
                              iconPath: Images.handyIcon,
                              label: "Handyman",
                              onTap: () {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _ServiceBubble(
                              iconPath: Images.paintIcon,
                              label: "Painting",
                              onTap: () {},
                            ),
                            _ServiceBubble(
                              iconPath: Images.interiorIcon,
                              label: "Interior\nDesign",
                              onTap: () {},
                            ),
                            _ServiceBubble(
                              iconPath: Images.pestIcon,
                              label: "Pest Control",
                              onTap: () {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),

                        // Bottom centered bubble
                        Center(
                          child: _ServiceBubble(
                            iconPath: Images.kitchenIcon,
                            label: "Kitchen\nInstallation",
                            onTap: () {},
                          ),
                        ),
                        const SizedBox(height: 22),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//======================PROGRESS BAR=================

class _TopProgress extends StatelessWidget {
  const _TopProgress({required this.value});
  final double value;

  @override
  Widget build(BuildContext context) {
    final v = value.clamp(0.0, 1.0);

    return Container(
      height: 16, // ✅ thicker track like screenshot
      decoration: BoxDecoration(
        color: CreateListingScreen.track, // light grey
        borderRadius: BorderRadius.circular(999),
      ),
      padding: const EdgeInsets.all(2), // ✅ inner gap (pill smaller)
      child: LayoutBuilder(
        builder: (context, c) {
          final w = c.maxWidth * v;

          return Align(
            alignment: Alignment.centerLeft,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              width: w < 8 ? 8 : w, // ✅ always show a small pill at start
              height: double.infinity,
              decoration: BoxDecoration(
                color: CreateListingScreen.green,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ===================== SEARCH =====================
class _SearchField extends StatelessWidget {
  const _SearchField({required this.hint, required this.onChanged});

  final String hint;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: TextField(
        onChanged: onChanged,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search_rounded, size: 20),
          hintText: hint,
          hintStyle: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w400,
            color: Color(0xFFB6B6B6),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: ListingHomeCategoryScreen._fieldBorder,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: ListingHomeCategoryScreen._fieldBorder,
              width: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}

// ===================== BUBBLE =====================
class _ServiceBubble extends StatelessWidget {
  const _ServiceBubble({
    required this.iconPath,
    required this.label,
    required this.onTap,
  });

  final String iconPath;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const size = 92.0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 12, 8, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  iconPath,
                  width: 30,
                  height: 30,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                    color: Color(0xFF1E1E1E),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
