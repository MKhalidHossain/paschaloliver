import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paschaloliver/feature/listing/view/list_home_category_screen.dart';
import 'package:paschaloliver/feature/user/home/controllers/category_controller.dart';
import 'package:paschaloliver/feature/user/home/models/category_model.dart';

import '../../../core/constants/assets.dart';

/// ✅ FULL REPLACEABLE: CreateListingScreen
/// ✅ Fixes your mismatch:
/// - Uses SAME coordinate system as your PNG (342x432 + 100 circle)
/// - Uses your PNG as background (contains circles)
/// - DOES NOT draw new white circles (only icon+text on top)
class CreateListingScreen extends StatefulWidget {
  const CreateListingScreen({super.key});

  static const Color green = Color(0xFF2FA86A);
  static const Color muted = Color(0xFF6F6F6F);
  static const Color border = Color(0xFFBDBDBD);
  static const Color track = Color(0xFFE7E7E7);

  @override
  State<CreateListingScreen> createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends State<CreateListingScreen> {
  final _searchCtrl = TextEditingController();
  final double _progress = 0.06;
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _openCategory(CategoryModel category) {
    Get.to(
      () => ListingHomeCategoryScreen(
        categoryId: category.id,
        categoryTitle: category.title,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CategoryController>();
    final positions = <Offset>[
      const Offset(59.4, 59.4),
      const Offset(282.3, 59.4),
      const Offset(59.4, 216.6),
      const Offset(170.9, 216.6),
      const Offset(282.3, 216.6),
      const Offset(59.4, 373.8),
      const Offset(282.3, 373.8),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),

              // Progress bar
              _TopProgress(value: _progress),
              const SizedBox(height: 16),

              // Back
              InkWell(
                onTap: () => Get.back(),
                borderRadius: BorderRadius.circular(10),
                child: const Padding(
                  padding: EdgeInsets.all(2),
                  child: Icon(
                    Icons.arrow_back,
                    size: 20,
                    color: CreateListingScreen.green,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Create your listing",
                style: GoogleFonts.urbanist(
                  fontSize: 24,
                  fontWeight: FontWeight.w600, // SemiBold
                  height: 1.1, // 110%
                  letterSpacing: 0,
                  color: const Color(0xFF3FA96B),
                ),
              ),

              const SizedBox(height: 6),
              Text(
                "Select or search for the service you want you offer",
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  fontWeight: FontWeight.w400, // Regular
                  height: 1.1, // 110%
                  letterSpacing: 0,
                  color: const Color(0xFF000000),
                ),
              ),

              const SizedBox(height: 14),

              _SearchField(
                controller: _searchCtrl,
                hint: "Handyman, cleaning, ironing...",
                onChanged: (value) {
                  setState(() => _query = value.trim().toLowerCase());
                },
              ),

              const SizedBox(height: 18),

              // ✅ Cluster area (MUST be 342x432)
              Expanded(
                child: Center(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: CreateListingScreen.green,
                        ),
                      );
                    }

                    if (controller.error.isNotEmpty) {
                      return Center(
                        child: Text(
                          controller.error.value,
                          style: const TextStyle(color: Colors.black54),
                        ),
                      );
                    }

                    final filtered = _query.isEmpty
                        ? controller.categories.toList()
                        : controller.categories
                            .where(
                              (c) => c.title.toLowerCase().contains(_query),
                            )
                            .toList();

                    if (filtered.isEmpty) {
                      return const Center(
                        child: Text(
                          'No categories found',
                          style: TextStyle(color: Colors.black54),
                        ),
                      );
                    }

                    final items =
                        filtered.take(positions.length).toList(growable: false);

                    return FittedBox(
                      fit: BoxFit.contain,
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        width: 342,
                        height: 432,
                        child: _CategoryCluster(
                          items: items,
                          positions: positions,
                          onTap: _openCategory,
                        ),
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

/* ------------------------ Top progress ------------------------ */

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

/* ------------------------ Search field ------------------------ */

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.hint,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1E1E1E),
        ),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search_rounded, size: 20),
          prefixIconColor: const Color(0xFF7B7B7B),
          hintText: hint,
          hintStyle: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
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
              color: CreateListingScreen.border,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: CreateListingScreen.border,
              width: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}

/* ------------------------ Cluster (PNG + exact overlay) ------------------------ */

class _CategoryCluster extends StatelessWidget {
  const _CategoryCluster({
    required this.items,
    required this.positions,
    required this.onTap,
  });

  final List<CategoryModel> items;
  final List<Offset> positions;
  final void Function(CategoryModel category) onTap;

  static const double _w = 342;
  static const double _h = 432;

  // ✅ exact circle diameter from your PNG
  static const double _d = 100;
  static const double _r = _d / 2;

  Positioned _pos(double cx, double cy, Widget child) {
    return Positioned(
      left: cx - _r,
      top: cy - _r,
      width: _d,
      height: _d,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _w,
      height: _h,
      child: Stack(
        children: [
          // ✅ Your PNG background (contains circles)
          Positioned.fill(
            child: Image.asset(
              Images.homeNBg, // assets/calender/Frame 2147230306.png
              fit: BoxFit.fill,
            ),
          ),
          for (int i = 0; i < items.length; i++)
            _pos(
              positions[i].dx,
              positions[i].dy,
              _BubbleNetworkContent(
                imageUrl: items[i].image,
                label: items[i].title,
                onTap: () => onTap(items[i]),
              ),
            ),
        ],
      ),
    );
  }
}

/// ✅ ONLY content overlay (NO new white circle!)
class _BubbleNetworkContent extends StatelessWidget {
  const _BubbleNetworkContent({
    required this.imageUrl,
    required this.label,
    required this.onTap,
  });

  final String imageUrl;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(
                  imageUrl,
                  width: 34,
                  height: 34,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.image_not_supported, size: 28),
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.2,
                    fontWeight: FontWeight.w800,
                    height: 1.12,
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
