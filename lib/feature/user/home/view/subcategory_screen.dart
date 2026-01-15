import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:paschaloliver/feature/user/home/view/address/address_flow_screens.dart';
import 'package:paschaloliver/feature/user/home/view/search/search_services_find_screen.dart';
import 'package:paschaloliver/feature/user/home/view/subcateogry/available_schedule_screen.dart';

import '../../../../core/constants/assets.dart';

/// ✅ MAIN: call this screen with:
/// Get.to(() => SubCategoryScreen(category: HomeCategory.beauty));
///
/// It auto-loads the right sub categories based on selected category.
class SubCategoryScreen extends StatefulWidget {
  const SubCategoryScreen({super.key, required this.category});

  final HomeCategory category;

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  static const Color _green = Color(0xFF3AAE6E);

  int _navIndex = 0;

  List<SubCategoryItem> get _items => SubCategoryData.items(widget.category);

  String get _title {
    // optional: show category name on top if you want
    return "HandyNaija";
  }

  void _onBottomTap(int i) {
    setState(() => _navIndex = i);
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
        // bottomNavigationBar: _BottomNav(
        //   currentIndex: _navIndex,
        //   onTap: _onBottomTap,
        //   activeColor: _green,
        // ),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const SizedBox(height: 12),

              // ✅ Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _title,
                        style: const TextStyle(
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
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // ✅ Sub categories
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 22,
                      runSpacing: 22,
                      children: _items.map((e) {
                        return _CategoryCircle(
                          title: e.title,
                          iconPath: e.icon,
                          onTap: () {
                            // ✅ navigate to service list/details
                            // Get.to(() => SearchTimeLoadingScreen());
                            Get.to(() => AvailabilityScheduleScreen());
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),

              // ✅ Add address
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 14),
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
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
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

/// ----------------------------
/// ✅ Category Enum
/// ----------------------------
enum HomeCategory {
  home,
  beauty,
  mediaEvents,
  techIt,
  repairMaintenance,
  automobile,
  others,
}

/// ----------------------------
/// ✅ Model
/// ----------------------------
class SubCategoryItem {
  final String title;
  final String icon;

  const SubCategoryItem({required this.title, required this.icon});
}

/// ----------------------------
/// ✅ Data map (Category -> Subcategories)
/// Replace icon names with your Images.* paths.
/// ----------------------------
class SubCategoryData {
  static List<SubCategoryItem> items(HomeCategory c) {
    switch (c) {
      case HomeCategory.home:
        return [
          const SubCategoryItem(title: "Cleaning", icon: Images.cleaningIcon),
          const SubCategoryItem(title: "Ironing", icon: Images.ironingIcon),
          SubCategoryItem(title: "Handyman", icon: Images.handyIcon),
          SubCategoryItem(title: "Painting", icon: Images.paintIcon),
          SubCategoryItem(title: "Interior\nDesign", icon: Images.interiorIcon),
          SubCategoryItem(title: "Pest Control", icon: Images.pestIcon),
          SubCategoryItem(title: "Kitchen\nInstallation", icon: Images.kitchenIcon),
        ];

      case HomeCategory.beauty:
        return [
          SubCategoryItem(title: "Salon at\nHome", icon: Images.salonIcon),
          SubCategoryItem(title: "Manicure &\nPedicure", icon: Images.manicureIcon),
          SubCategoryItem(title: "Haircut &\nStyling", icon: Images.haircutIcon),
        ];

      case HomeCategory.mediaEvents:
        return [
          SubCategoryItem(title: "Photo/Video\ngraphy", icon: Images.photoIcon),
          SubCategoryItem(title: "Birthday\nEvents", icon: Images.birthdayIcon),
          SubCategoryItem(title: "DJ & Sound\nSetup", icon: Images.djIcon),
          SubCategoryItem(title: "Makeup\nArtist", icon: Images.comedianIcon),
          SubCategoryItem(title: "Caterers", icon: Images.comedianIcon1),
          SubCategoryItem(title: "Wedding\nCoordination", icon: Images.mcIcon),
        ];

      case HomeCategory.techIt:
        return [
          SubCategoryItem(title: "Computer\nRepair", icon: Images.mcIcon),
          SubCategoryItem(title: "Mobile\nRepair", icon: Images.comedianIcon),
          SubCategoryItem(title: "Software\nInstallation", icon: Images.birthdayIcon),
          SubCategoryItem(title: "Internet\nSetup", icon: Images.comedianIcon1),
        ];

      case HomeCategory.repairMaintenance:
        return [
          SubCategoryItem(title: "Electrician", icon: Images.comedianIcon1),
          SubCategoryItem(title: "Plumber", icon: Images.birthdayIcon),
          SubCategoryItem(title: "Appliances", icon: Images.mcIcon),
          SubCategoryItem(title: "AC Servicing", icon: Images.djIcon),
        ];

      case HomeCategory.automobile:
        return [
          SubCategoryItem(title: "Car Wash", icon: Images.birthdayIcon),
          SubCategoryItem(title: "Bike Service", icon: Images.mcIcon),
          SubCategoryItem(title: "Car Repair", icon: Images.comedianIcon1),
          SubCategoryItem(title: "Battery\nJumpstart", icon: Images.djIcon),
        ];

      case HomeCategory.others:
        return [
          SubCategoryItem(title: "House\nShifting", icon: Images.comedianIcon1),
          SubCategoryItem(title: "Pickup and\nDelivery", icon: Images.birthdayIcon),
        ];
    }
  }
}

/// ----------------------------
/// UI widgets
/// ----------------------------
class _CategoryCircle extends StatelessWidget {
  const _CategoryCircle({
    required this.title,
    required this.iconPath,
    required this.onTap,
  });

  final String title;
  final String iconPath;
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
                Image.asset(iconPath, width: 30, height: 30, fit: BoxFit.contain),
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
