import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/assets.dart';
import 'list_home_category_screen.dart'; // ✅ update path if needed

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

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _openCategory(String category) {
    // ✅ You can pass category if you want
    Get.to(() => const ListingHomeCategoryScreen());
  }

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

              // Progress bar
              _TopProgress(value: _progress),
              const SizedBox(height: 16),

              // Back
              InkWell(
                onTap: () => Get.back(),
                borderRadius: BorderRadius.circular(10),
                child: const Padding(
                  padding: EdgeInsets.all(6),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 18,
                    color: CreateListingScreen.green,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Create your listing",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: CreateListingScreen.green,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Select or search for the service you want you offer",
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: CreateListingScreen.muted,
                  height: 1.25,
                ),
              ),

              const SizedBox(height: 14),

              _SearchField(
                controller: _searchCtrl,
                hint: "Handyman, cleaning, ironing...",
                onChanged: (_) {},
              ),

              const SizedBox(height: 18),

              // ✅ Cluster area (MUST be 342x432)
              Expanded(
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: 342,
                      height: 432,
                      child: _CategoryCluster(
                        onTap: _openCategory,
                      ),
                    ),
                  ),
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: SizedBox(
        height: 10,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(color: CreateListingScreen.track),
            ),
            FractionallySizedBox(
              widthFactor: v,
              child: Container(color: CreateListingScreen.green),
            ),
          ],
        ),
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: CreateListingScreen.border, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: CreateListingScreen.border, width: 1.2),
          ),
        ),
      ),
    );
  }
}

/* ------------------------ Cluster (PNG + exact overlay) ------------------------ */

class _CategoryCluster extends StatelessWidget {
  const _CategoryCluster({required this.onTap});
  final void Function(String category) onTap;

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

          _pos(
            59.4,
            59.4,
            _BubbleContent(
              iconPath: Images.homeIcon,
              label: "Home",
              onTap: () => onTap("Home"),
            ),
          ),
          _pos(
            282.3,
            59.4,
            _BubbleContent(
              iconPath: Images.techItIcon,
              label: "Tech & IT\nSupport",
              onTap: () => onTap("Tech & IT Support"),
            ),
          ),
          _pos(
            59.4,
            216.6,
            _BubbleContent(
              iconPath: Images.beautyIcon,
              label: "Beauty",
              onTap: () => onTap("Beauty"),
            ),
          ),
          _pos(
            170.9,
            216.6,
            _BubbleContent(
              iconPath: Images.maintanceIcon,
              label: "Repair &\nMaintenance",
              onTap: () => onTap("Repair & Maintenance"),
            ),
          ),
          _pos(
            282.3,
            216.6,
            _BubbleContent(
              iconPath: Images.automactionIcon,
              label: "Automobile",
              onTap: () => onTap("Automobile"),
            ),
          ),
          _pos(
            59.4,
            373.8,
            _BubbleContent(
              iconPath: Images.mediaIcon,
              label: "Media &\nEvents",
              onTap: () => onTap("Media & Events"),
            ),
          ),
          _pos(
            282.3,
            373.8,
            _BubbleContent(
              iconPath: Images.othersIcon,
              label: "Others",
              onTap: () => onTap("Others"),
            ),
          ),
        ],
      ),
    );
  }
}

/// ✅ ONLY content overlay (NO new white circle!)
class _BubbleContent extends StatelessWidget {
  const _BubbleContent({
    required this.iconPath,
    required this.label,
    required this.onTap,
  });

  final String iconPath;
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
                Image.asset(iconPath, width: 34, height: 34, fit: BoxFit.contain),
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
