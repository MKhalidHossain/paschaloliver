import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:paschaloliver/feature/user/home/controllers/category_controller.dart';
import 'package:paschaloliver/feature/user/home/view/search/search_screen.dart';
import 'package:paschaloliver/feature/user/home/view/subcategory_screen.dart';

import '../../../../core/constants/assets.dart';
import 'address/address_flow_screens.dart';

/// ✅ FULL REPLACEABLE HOME SCREEN (MATCHES YOUR SCREENSHOT)
class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  static const Color _green = Color(0xFF3AAE6E);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: _green,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: _green,

        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const SizedBox(height: 14),

              // ✅ Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "HandyNaija",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          height: 1.1,
                        ),
                      ),
                    ),
                    _WhiteCircleIcon(
                      icon: Icons.search,
                      onTap: () async {
                        final result = await Get.to<String>(
                          () => const HandySearchPage(),
                        );
                        if (result != null) {
                          // use your selected value here
                          debugPrint("Selected: $result");
                          // example: controller.searchCtrl.text = result;
                        }
                      },
                    ),

                    const SizedBox(width: 10),
                    _WhiteCircleIcon(
                      icon: Icons.notifications_none_rounded,
                      onTap: () {},
                      showDot: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // ✅ Cluster centered
              const Expanded(child: Center(child: UserHomeCluster())),

              // ✅ Add address button
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 6, 18, 14),
                child: SizedBox(
                  height: 46,
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Get.to(() => const MyAddressesScreen());
                    },
                    icon: const Icon(Icons.add, size: 18, color: Colors.white),
                    label: const Text(
                      "Add address",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: Colors.white.withOpacity(.85),
                        width: 1.2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class UserHomeCluster extends StatelessWidget {
  const UserHomeCluster({super.key});

  static const Color _green = Color(0xFF3AAE6E);
  static const double _w = 342;
  static const double _h = 432;

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

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.white),
        );
      }

      if (controller.error.isNotEmpty) {
        return Center(
          child: Text(
            controller.error.value,
            style: const TextStyle(color: Colors.white),
          ),
        );
      }

      final items = controller.categories.take(positions.length).toList();

      return FittedBox(
        fit: BoxFit.contain,
        child: SizedBox(
          width: _w,
          height: _h,
          child: Stack(
            children: [
              const Positioned.fill(child: ColoredBox(color: _green)),
              Positioned.fill(
                child: Image.asset(Images.homeNBg, fit: BoxFit.fill),
              ),

              for (int i = 0; i < items.length; i++)
                _pos(
                  positions[i].dx,
                  positions[i].dy,
                  _CircleNetworkContent(
                    imageUrl: items[i].image,
                    label: items[i].title,
                    onTap: () {
                      Get.to(() => SubCategoryScreen(categoryId: items[i].id));
                    },
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }
}

class _CircleNetworkContent extends StatelessWidget {
  const _CircleNetworkContent({
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
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                    color: Color(0xFF111111),
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

/// ✅ top right buttons
class _WhiteCircleIcon extends StatelessWidget {
  const _WhiteCircleIcon({
    required this.icon,
    required this.onTap,
    this.showDot = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool showDot;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Material(
          color: Colors.white,
          shape: const CircleBorder(),
          elevation: 2,
          shadowColor: Colors.black.withOpacity(.12),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: SizedBox(
              width: 40,
              height: 40,
              child: Center(
                child: Icon(icon, color: const Color(0xFF1E1E1E), size: 26),
              ),
            ),
          ),
        ),
        if (showDot)
          Positioned(
            right: -0.1,
            top: -0.1,
            child: Container(
              width: 9,
              height: 9,
              decoration: BoxDecoration(
                color: const Color(0xFFFF3B30),
                borderRadius: BorderRadius.circular(99),
                border: Border.all(color: Colors.white, width: 1.2),
              ),
            ),
          ),
      ],
    );
  }
}

// class SubCategoryScreen extends StatelessWidget {
//   final String categoryId;
//   const SubCategoryScreen({super.key, required this.categoryId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Subcategories")),
//       body: Center(child: Text("Category ID: $categoryId")),
//     );
//   }
// }
