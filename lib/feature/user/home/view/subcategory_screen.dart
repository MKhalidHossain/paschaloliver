import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:paschaloliver/feature/user/app_ground_user.dart';
import 'package:paschaloliver/feature/user/widgets/user_bottom_nav.dart';

import '../controllers/subcategory_controller.dart';
import 'address/address_flow_screens.dart';
import 'search/search_screen.dart';
import 'subcateogry/available_schedule_screen.dart';

class SubCategoryScreen extends StatefulWidget {
  const SubCategoryScreen({super.key, required this.categoryId});
  final String categoryId;

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  static const Color _green = Color(0xFF3AAE6E);

  late final SubCategoryController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<SubCategoryController>();
    controller.fetchByCategoryId(widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: _green,
        bottomNavigationBar: UserBottomNav(
          index: 0,
          onTap: (i) {
            if (i == 0) {
              Get.offAll(() => const UserAppGround(initialIndex: 0));
              return;
            }
            Get.offAll(() => UserAppGround(initialIndex: i));
          },
        ),
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
                        await Get.to(() => const HandySearchPage());
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

              const SizedBox(height: 18),

              // ✅ Back
              InkWell(
                onTap: () => Get.back(),
                borderRadius: BorderRadius.circular(20),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.arrow_back, size: 20, color: Colors.white),
                    SizedBox(width: 6),
                    Text(
                      "Back",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // ✅ Subcategories
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }

                  if (controller.error.isNotEmpty) {
                    return Center(
                      child: Text(
                        controller.error.value,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    );
                  }

                  if (controller.items.isEmpty) {
                    return const Center(
                      child: Text(
                        "No subcategories found",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 22,
                        runSpacing: 22,
                        children: controller.items.map((e) {
                          return _CategoryCircleNetwork(
                            title: e.title,
                            imageUrl: e.image,
                            onTap: () {
                              Get.to(() => AvailabilityScheduleScreen());
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  );
                }),
              ),

              // ✅ Add address
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 8, 18, 14),
                  child: SizedBox(
                    height: 46,
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Get.to(() => const MyAddressesScreen());
                      },
                      icon: const Icon(
                        Icons.add,
                        size: 18,
                        color: Colors.white,
                      ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryCircleNetwork extends StatelessWidget {
  const _CategoryCircleNetwork({
    required this.title,
    required this.imageUrl,
    required this.onTap,
  });

  final String title;
  final String imageUrl;
  final VoidCallback onTap;

  static const double _size = 92;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          width: _size,
          height: _size,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(999),
            boxShadow: [
              BoxShadow(
                blurRadius: 14,
                offset: const Offset(0, 6),
                color: Colors.black.withOpacity(.12),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
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
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11.5,
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
            right: -1,
            top: -1,
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
