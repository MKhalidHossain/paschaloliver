import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../core/constants/assets.dart';
import 'address/address_flow_screens.dart';
import 'subcategory_screen.dart'; // ✅ update path if needed

/// ✅ FULL REPLACEABLE HOME SCREEN (MATCHES YOUR SCREENSHOT)
class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  static const Color _green = Color(0xFF3AAE6E);

  int _navIndex = 0;

  void _onBottomTap(int i) {
    setState(() => _navIndex = i);

    // ✅ Optional GetX navigation for bottom tabs (add your screens)
    // switch (i) {
    //   case 0: break; // Search (current)
    //   case 1: Get.to(() => const FavoritesScreen()); break;
    //   case 2: Get.to(() => const ServicesScreen()); break;
    //   case 3: Get.to(() => const InboxScreen()); break;
    //   case 4: Get.to(() => const ProfileScreen()); break;
    // }
  }

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
                    _WhiteCircleIcon(icon: Icons.search, onTap: () {}),
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
              const Expanded(
                child: Center(
                  child: UserHomeCluster(),
                ),
              ),

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
                      side: BorderSide(color: Colors.white.withOpacity(.85), width: 1.2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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

/// ✅ The N cluster widget (with GetX navigation)
class UserHomeCluster extends StatelessWidget {
  const UserHomeCluster({super.key});

  static const Color _green = Color(0xFF3AAE6E);

  static const double _w = 342;
  static const double _h = 432;

  // circle size from your PNG
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
    return FittedBox(
      fit: BoxFit.contain,
      child: SizedBox(
        width: _w,
        height: _h,
        child: Stack(
          children: [
            // ✅ ensure green behind image
            const Positioned.fill(child: ColoredBox(color: _green)),

            // ✅ your N PNG (should be transparent around it)
            Positioned.fill(
              child: Image.asset(
                Images.homeNBg,
                fit: BoxFit.fill,
              ),
            ),

            // Home
            _pos(
              59.4,
              59.4,
              _CircleContent(
                icon: Images.homeIcon,
                label: "Home",
                onTap: () => Get.to(() => const SubCategoryScreen(category: HomeCategory.home)),
              ),
            ),

            // Tech & IT Support
            _pos(
              282.3,
              59.4,
              _CircleContent(
                icon: Images.techItIcon,
                label: "Tech & IT\nSupport",
                onTap: () => Get.to(() => const SubCategoryScreen(category: HomeCategory.techIt)),
              ),
            ),

            // Beauty
            _pos(
              59.4,
              216.6,
              _CircleContent(
                icon: Images.beautyIcon,
                label: "Beauty",
                onTap: () => Get.to(() => const SubCategoryScreen(category: HomeCategory.beauty)),
              ),
            ),

            // Repair & Maintenance
            _pos(
              170.9,
              216.6,
              _CircleContent(
                icon: Images.maintanceIcon,
                label: "Repair &\nMaintenance",
                onTap: () => Get.to(() => const SubCategoryScreen(category: HomeCategory.repairMaintenance)),
              ),
            ),

            // Automobile
            _pos(
              282.3,
              216.6,
              _CircleContent(
                icon: Images.automactionIcon,
                label: "Automobile",
                onTap: () => Get.to(() => const SubCategoryScreen(category: HomeCategory.automobile)),
              ),
            ),

            // Media & Events
            _pos(
              59.4,
              373.8,
              _CircleContent(
                icon: Images.mediaIcon,
                label: "Media &\nEvents",
                onTap: () => Get.to(() => const SubCategoryScreen(category: HomeCategory.mediaEvents)),
              ),
            ),

            // Others
            _pos(
              282.3,
              373.8,
              _CircleContent(
                icon: Images.othersIcon,
                label: "Others",
                onTap: () => Get.to(() => const SubCategoryScreen(category: HomeCategory.others)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleContent extends StatelessWidget {
  const _CircleContent({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final String icon;
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
                Image.asset(icon, width: 34, height: 34, fit: BoxFit.contain),
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
                child: Icon(icon, color: const Color(0xFF1E1E1E), size: 20),
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

/// ✅ Bottom nav like screenshot
class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.currentIndex,
    required this.onTap,
    required this.activeColor,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            offset: const Offset(0, -2),
            color: Colors.black.withOpacity(.08),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: activeColor,
        unselectedItemColor: const Color(0xFF8B8B8B),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search_rounded), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border_rounded), label: "Favorites"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), label: "Services"),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline_rounded), label: "Inbox"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: "Profile"),
        ],
      ),
    );
  }
}
