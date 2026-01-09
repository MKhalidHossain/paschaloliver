import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paschaloliver/feature/user/service/view/service_flow_user_screen.dart';

import '../../core/constants/assets.dart';
import '../inbox/view/inbox_screen.dart';
import '../profile/view/profile_screen.dart';
import 'favourite/view/favourite_screen.dart';
import 'home/view/home_screen.dart';

class UserAppGround extends StatelessWidget {
  const UserAppGround({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(UserShellController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(
              () => IndexedStack(
            index: c.index.value,
            children: const [
              UserHomeScreen(),
              // _SearchPage(),
              // _FavoritesPage(),
              FavoritesScreen(),
              // _ServicesPage(),
              UserServicesScreen(),
              // _InboxPage(),
              InboxScreen(),
              // _ProfilePage(),
              ProfileScreen(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Obx(
            () => _UserBottomNav(
          index: c.index.value,
          onTap: c.setIndex,
        ),
      ),
    );
  }
}

/* ============================ CONTROLLER ============================ */

class UserShellController extends GetxController {
  final index = 0.obs;
  void setIndex(int i) => index.value = i;
}

/* ============================ BOTTOM NAV ============================ */

class _UserBottomNav extends StatelessWidget {
  const _UserBottomNav({
    required this.index,
    required this.onTap,
  });

  final int index;
  final ValueChanged<int> onTap;

  static const _green = Color(0xFF2FA86A);
  static const _grey = Color(0xFF1F1F1F);
  static const _line = Color(0xFFEDEDED);
  static const _red = Color(0xFFE53935);

  Color _labelColor(bool selected) => selected ? _green : _grey;

  Color _iconColorForTab(int tab, bool selected) {
    if (!selected) return _grey;

    // Favorites + Services are red in your design
    if (tab == 1) return _red;
    if (tab == 2) return _red;

    // Search + Inbox + Profile are green
    return _green;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 74,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: _line, width: 1)),
      ),
      child: Row(
        children: List.generate(5, (i) {
          final selected = index == i;
          final iconColor = _iconColorForTab(i, selected);
          final labelColor = _labelColor(selected);

          return Expanded(
            child: InkWell(
              onTap: () => onTap(i),
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _NavIcon(
                      tab: i,
                      selected: selected,
                      color: iconColor,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _labelFor(i),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: labelColor,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  String _labelFor(int i) {
    switch (i) {
      case 0:
        return "Search";
      case 1:
        return "Favorites";
      case 2:
        return "Services";
      case 3:
        return "Inbox";
      case 4:
        return "Profile";
      default:
        return "";
    }
  }
}

class _NavIcon extends StatelessWidget {
  const _NavIcon({
    required this.tab,
    required this.selected,
    required this.color,
  });

  final int tab;
  final bool selected;
  final Color color;

  @override
  Widget build(BuildContext context) {
    // Favorites uses Material icon (heart)
    if (tab == 1) {
      return Icon(
        selected ? Icons.favorite_rounded : Icons.favorite_border_rounded,
        size: 24,
        color: color,
      );
    }

    final String asset = switch (tab) {
      0 => Images.searchIcon,
      2 => Images.calenderIcon,
      3 => Images.messageIcon,
      4 => Images.userIcon,
      _ => Images.searchIcon,
    };

    // ✅ Special rule: Search icon stays original (black) when NOT selected.
    if (tab == 0 && !selected) {
      return Image.asset(
        asset,
        width: 24,
        height: 24,
        fit: BoxFit.contain,
      );
    }

    // ✅ Selected (or other tabs): apply tint
    return Image.asset(
      asset,
      width: 24,
      height: 24,
      fit: BoxFit.contain,
      color: color,
      colorBlendMode: BlendMode.srcIn,
    );
  }
}


/* ============================ PLACEHOLDER PAGES ============================ */

class _SearchPage extends StatelessWidget {
  const _SearchPage();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Search",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _FavoritesPage extends StatelessWidget {
  const _FavoritesPage();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Favorites",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _ServicesPage extends StatelessWidget {
  const _ServicesPage();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Services",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _InboxPage extends StatelessWidget {
  const _InboxPage();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Inbox",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _ProfilePage extends StatelessWidget {
  const _ProfilePage();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Profile",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
      ),
    );
  }
}
