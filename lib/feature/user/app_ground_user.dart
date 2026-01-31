import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paschaloliver/feature/profile/view/profile_screen_user.dart';
import 'package:paschaloliver/feature/user/service/view/service_flow_user_screen.dart';
import 'package:paschaloliver/feature/user/widgets/user_bottom_nav.dart';

import '../inbox/view/inbox_screen.dart';
import 'favourite/view/favourite_screen.dart';
import 'home/view/home_screen.dart';

class UserAppGround extends StatelessWidget {
  const UserAppGround({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    final c = Get.put(UserShellController());
    c.ensureIndex(initialIndex);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(
          () => IndexedStack(
            index: c.index.value,
            children: const [
              UserHomeScreen(),
              FavoritesScreen(),
              UserServicesScreen(),
              InboxScreen(),
              ProfileScreenUser(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Obx(
        () => SafeArea(
          top: false,
          child: UserBottomNav(index: c.index.value, onTap: c.setIndex),
        ),
      ),
    );
  }
}

/* ============================ CONTROLLER ============================ */

class UserShellController extends GetxController {
  final index = 0.obs;
  void setIndex(int i) => index.value = i;
  bool _initialized = false;

  void ensureIndex(int i) {
    if (_initialized) return;
    index.value = i;
    _initialized = true;
  }
}
