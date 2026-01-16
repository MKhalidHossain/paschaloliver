import 'package:flutter/material.dart';
// If you use SVG path, uncomment this:
// import 'package:flutter_svg/flutter_svg.dart';

import 'core/constants/assets.dart';
import 'feature/calender/view/calender_screen.dart';
import 'feature/inbox/view/inbox_screen.dart';
import 'feature/listing/view/my_listing_screen.dart';
import 'feature/profile/view/profile_screen.dart';
import 'feature/requests/view/new_requests_screen.dart';

class AppGround extends StatefulWidget {
  const AppGround({super.key});

  @override
  State<AppGround> createState() => _AppGroundState();
}

class _AppGroundState extends State<AppGround> {
  int _index = 0;

  // ✅ RequestsHistoryScreen at index 1
  final _pages = const [
    // _StubPage(title: "Search"),
    // _StubPage(title: "Calender"),
    CalendarHomeShell(),
    RequestsHistoryScreen(),
    // _StubPage(title: "Services"),
    MyListingScreen(),

    InboxScreen(),
    // _StubPage(title: "Profile"),
    ProfileScreen(),
  ];

  static const Color _activeGreen = Color(0xFF27AE60);
  static const Color _inactive = Color(0xFF111111);
  static const Color _favRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          Positioned.fill(
            child: IndexedStack(index: _index, children: _pages),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _BottomBar(
              currentIndex: _index,
              onChanged: (i) => setState(() => _index = i),
              activeGreen: _activeGreen,
              inactive: _inactive,
              favRed: _favRed,
            ),
          ),
        ],
      ),
    );
  }
}

/// ------------------------
/// Bottom Nav (custom) - fills bottom safe area ✅
/// ------------------------
class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.currentIndex,
    required this.onChanged,
    required this.activeGreen,
    required this.inactive,
    required this.favRed,
  });

  final int currentIndex;
  final ValueChanged<int> onChanged;

  final Color activeGreen;
  final Color inactive;
  final Color favRed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 0,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFFE9E9E9), width: 1)),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 62,
            child: Row(
              children: [
                _NavItem(
                  label: "Calender",
                  icon: Images.calenderIcon,
                  isActive: currentIndex == 0,
                  activeColor: activeGreen,
                  inactiveColor: inactive,
                  onTap: () => onChanged(0),
                ),
                _NavItem(
                  label: "Requests",
                  icon: Images.requestsIcon,
                  activeIcon: Images.requestsIcon,
                  activeIconColor: favRed,
                  isActive: currentIndex == 1,
                  activeColor: activeGreen,
                  inactiveColor: inactive,
                  onTap: () => onChanged(1),
                ),

                /// ✅ Inbox icon: works for IconData OR asset path String OR widget
                _NavItem(
                  label: "Inbox",
                  icon: Images
                      .messageIcon, // can be IconData OR String(asset path) OR Widget
                  activeIcon: Images.messageIcon,
                  isActive: currentIndex == 3,
                  activeColor: activeGreen,
                  inactiveColor: inactive,
                  onTap: () => onChanged(3),
                ),
                _NavItem(
                  label: "Listing",
                  icon: Images.listingIcon,
                  activeIcon: Images.listingIcon,
                  isActive: currentIndex == 2,
                  activeColor: activeGreen,
                  inactiveColor: inactive,
                  onTap: () => onChanged(2),
                ),

                _NavItem(
                  label: "Profile",
                  icon: Images
                      .userIcon, // can be IconData OR String(asset path) OR Widget
                  activeIcon: Images.userIcon,
                  isActive: currentIndex == 4,
                  activeColor: activeGreen,
                  inactiveColor: inactive,
                  onTap: () => onChanged(4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    super.key,
    required this.label,
    required this.icon,
    this.activeIcon,
    this.activeIconColor,
    required this.isActive,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
  });

  final String label;

  /// Can be:
  /// - IconData
  /// - String (asset path)
  /// - Widget (Image, SvgPicture, etc.)
  final dynamic icon;
  final dynamic activeIcon;

  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;

  /// Optional: use a different color for the active icon (e.g. red heart)
  final Color? activeIconColor;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color iconColor = isActive
        ? (activeIconColor ?? activeColor)
        : inactiveColor;
    final Color textColor = isActive ? activeColor : inactiveColor;

    final dynamic picked = isActive ? (activeIcon ?? icon) : icon;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _SmartIcon(value: picked, color: iconColor, size: 22),
              const SizedBox(height: 4),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  height: 1.1,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ✅ This widget makes ANY icon type colorable
class _SmartIcon extends StatelessWidget {
  const _SmartIcon({required this.value, required this.color, this.size = 22});

  final dynamic value;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    // 1) IconData
    if (value is IconData) {
      return Icon(value, size: size, color: color);
    }

    // 2) If it’s already a widget (SvgPicture/Image/etc)
    if (value is Widget) {
      // Try to colorize via ColorFiltered so even image widgets can be tinted
      return SizedBox(
        width: size,
        height: size,
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          child: FittedBox(fit: BoxFit.contain, child: value),
        ),
      );
    }

    // 3) String asset path (png/jpg/svg)
    if (value is String) {
      final path = value.toLowerCase();

      // PNG/JPG -> colorize using ColorFiltered
      return SizedBox(
        width: size,
        height: size,
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          child: Image.asset(value, fit: BoxFit.contain),
        ),
      );
    }

    // fallback
    return Icon(Icons.help_outline, size: size, color: color);
  }
}

/// ------------------------
/// Placeholder pages
/// ------------------------
class _StubPage extends StatelessWidget {
  final String title;
  const _StubPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
      ),
    );
  }
}
