import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paschaloliver/feature/user/home/controllers/subcategory_controller.dart';
import 'package:paschaloliver/feature/user/home/models/subcategory_model.dart';
import 'package:paschaloliver/feature/listing/controller/listing_create_controller.dart';

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
class ListingHomeCategoryScreen extends StatefulWidget {
  const ListingHomeCategoryScreen({
    super.key,
    required this.categoryId,
    required this.categoryTitle,
  });

  final String categoryId;
  final String categoryTitle;

  static const Color _green = Color(0xFF2FA86A);
  static const Color _muted = Color(0xFF6F6F6F);
  static const Color _fieldBorder = Color(0xFFBDBDBD);

  final double _progress = 0.06;

  @override
  State<ListingHomeCategoryScreen> createState() =>
      _ListingHomeCategoryScreenState();
}

class _ListingHomeCategoryScreenState extends State<ListingHomeCategoryScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  late final SubCategoryController _controller;
  late final ListingCreateController _listingController;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<SubCategoryController>();
    _listingController = Get.find<ListingCreateController>();
    _controller.fetchByCategoryId(widget.categoryId);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

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
              _TopProgress(value: widget._progress),

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
                  color: ListingHomeCategoryScreen._green,
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
                controller: _searchCtrl,
                onChanged: (v) {
                  setState(() => _query = v.trim().toLowerCase());
                },
              ),

              const SizedBox(height: 18),

              // Center "← Home"
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.arrow_back,
                      size: 20,
                      color: Color(0xFF6F6F6F),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.categoryTitle.isEmpty
                          ? "Category"
                          : widget.categoryTitle,
                      style: const TextStyle(
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
                child: Obx(() {
                  if (_controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: ListingHomeCategoryScreen._green,
                      ),
                    );
                  }

                  if (_controller.error.isNotEmpty) {
                    return Center(
                      child: Text(
                        _controller.error.value,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.black54),
                      ),
                    );
                  }

                  final List<SubCategoryModel> filtered = _query.isEmpty
                      ? _controller.items.toList()
                      : _controller.items
                          .where(
                            (e) => e.title.toLowerCase().contains(_query),
                          )
                          .toList();

                  if (filtered.isEmpty) {
                    return const Center(
                      child: Text(
                        "No subcategories found",
                        style: TextStyle(color: Colors.black54),
                      ),
                    );
                  }

                  return Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 320),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 22,
                        runSpacing: 22,
                        children: filtered
                            .map(
                              (e) => _ServiceBubbleNetwork(
                                imageUrl: e.image,
                                label: e.title,
                                onTap: () {
                                  _listingController.setSubcategory(e.id);
                                  Get.to(() => const PriceOfServiceScreen());
                                },
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  );
                }),
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
  const _SearchField({
    required this.hint,
    required this.onChanged,
    required this.controller,
  });

  final String hint;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: TextField(
        controller: controller,
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
class _ServiceBubbleNetwork extends StatelessWidget {
  const _ServiceBubbleNetwork({
    required this.imageUrl,
    required this.label,
    required this.onTap,
  });

  final String imageUrl;
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
                Image.network(
                  imageUrl,
                  width: 30,
                  height: 30,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.image_not_supported, size: 26),
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
