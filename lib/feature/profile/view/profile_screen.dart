import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:paschaloliver/feature/profile/view/personal_details_screen.dart';
import 'package:paschaloliver/feature/profile/view/privacy_policy_screen.dart';
import 'package:paschaloliver/feature/profile/view/terms_and_condition_screen.dart';

import '../../auth/view/sign_in_view.dart';
import 'about_screen.dart';
import 'change_password_screen.dart';
import 'choose_language_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final bottomInset = MediaQuery.of(context).padding.bottom;

    // your bottom bar height (you used 62 in AppGround)
    const bottomBarHeight = 62.0;

    return Scaffold(
      backgroundColor: _C.bg,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.only(bottom: 18 + bottomBarHeight + bottomInset,),
          children: [
            const SizedBox(height: 8),

            // =========================
            // TOP PROFILE HEADER
            // =========================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: Color(0xFFD9D9D9),
                    child: Icon(Icons.person, color: Color(0xFF666666), size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Paschaloliver",
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: _C.text,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 3),
                        // inside your ProfileScreen header (replace only "View Profile" Text part)

                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                            );
                          },
                          borderRadius: BorderRadius.circular(6),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                            child: Text(
                              "View Profile",
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: _C.green,
                                height: 1.15,
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),
            const Divider(height: 1, thickness: 1, color: _C.divider),

            // =========================
            // SHARE & EARN
            // =========================
            const _SectionTitle("SHARE AND EARN MONEY!"),
            _TileRow(
              leading: _LeadingIcon(
                child: Icon(Icons.card_giftcard_rounded, size: 18, color: _C.green),
              ),
              title: "# 10 for every friend you bring",
              onTap: () {},
            ),
            const Divider(height: 1, thickness: 1, color: _C.divider),

            // =========================
            // YOUR ACCOUNT
            // =========================
            const _SectionTitle("Your Account"),
            _TileRow(
              leading: const _LeadingIcon(
                child: Icon(Icons.person_outline_rounded, size: 18, color: _C.green),
              ),
              title: "Personal details",
              onTap: () {
                Get.to(() => const PersonalDetailsScreen());
              },
            ),
            const _ThinDivider(),
            _TileRow(
              leading: const _LeadingIcon(child: Icon(Icons.attach_money_rounded, size: 18, color: _C.green)),
              title: "My Balance",
              onTap: () {},
            ),
            const _ThinDivider(),
            _TileRow(
              leading: const _LeadingIcon(child: Icon(Icons.calendar_today_outlined, size: 18, color: _C.green)),
              title: "Booking Preference",
              onTap: () {},
            ),
            const _ThinDivider(),
            _TileRow(
              leading: const _LeadingIcon(child: Icon(Icons.lock_outline_rounded, size: 18, color: _C.green)),
              title: "Change password",
              onTap: () => Get.to(() => const ChangePasswordScreen()),
            ),
            const _ThinDivider(),
            _TileRow(
              leading: const _LeadingIcon(
                child: Icon(Icons.language_rounded, size: 18, color: _C.green),
              ),
              title: "Language",
              onTap: () async {
                final result = await Get.to<LanguageOption>(
                      () => const ChooseLanguageScreen(initialLocale: "en"),
                );

                if (result != null) {
                  // result.locale -> "en", "fr", "ar" ...
                  // TODO: save to controller/storage and update app locale
                  // Example:
                  // Get.find<SettingsController>().setLocale(result.locale);
                  // Get.updateLocale(Locale(result.locale)); // if you use GetX localization
                }
              },
            ),

            const Divider(height: 1, thickness: 1, color: _C.divider),

            // =========================
            // OFFER SERVICES
            // =========================
            const _SectionTitle("So you want to offer services?"),
            _TileRow(
              leading: const _LeadingIcon(child: Icon(Icons.swap_horiz_rounded, size: 18, color: _C.green)),
              title: "Switch to Client version",
              onTap: () {},
            ),
            const Divider(height: 1, thickness: 1, color: _C.divider),

            // =========================
            // LIKE THE APP
            // =========================
            const _SectionTitle("Do you like the app?"),
            _TileRow(
              leading: const _LeadingIcon(child: Icon(Icons.star_border_rounded, size: 18, color: _C.green)),
              title: "Will you give us 5 stars?😊",
              onTap: () {},
            ),
            const _ThinDivider(),
            _TileRow(
              leading: const _LeadingIcon(child: Icon(Icons.share_outlined, size: 18, color: _C.green)),
              title: "Share the HandyNaija App",
              onTap: () {},
            ),
            const Divider(height: 1, thickness: 1, color: _C.divider),

            // =========================
            // SUPPORT CENTRE
            // =========================
            const _SectionTitle("SUPPORT CENTRE"),
            _TileRow(
              leading: const _LeadingIcon(child: Icon(Icons.headset_mic_outlined, size: 18, color: _C.green)),
              title: "Help",
              onTap: () {},
            ),
            const _ThinDivider(),
            _TileRow(
              leading: const _LeadingIcon(child: Icon(Icons.emoji_objects_outlined, size: 18, color: _C.green)),
              title: "How can we improve?",
              onTap: () {},
            ),
            const _ThinDivider(),
            _TileRow(
              leading: const _LeadingIcon(child: Icon(Icons.emoji_objects_outlined, size: 18, color: _C.green)),
              title: "Privacy Policy",
              onTap: () => Get.to(() => const PrivacyPolicyScreen()),
            ),
            const _ThinDivider(),
            _TileRow(
              leading: const _LeadingIcon(child: Icon(Icons.emoji_objects_outlined, size: 18, color: _C.green)),
              title: "Terms And Condition",
              onTap: () => Get.to(() => const TermsConditionsScreen()),
            ),
            const _ThinDivider(),
            _TileRow(
              leading: const _LeadingIcon(
                child: Icon(Icons.info_outline_rounded, size: 18, color: _C.green),
              ),
              title: "About HandyNaija App",
              onTap: () => Get.to(() => const AboutHandyNaijaScreen()),
            ),

            const _ThinDivider(),
            _TileRow(
              leading: const _LeadingIcon(child: Icon(Icons.logout_rounded, size: 18, color: _C.green)),
              title: "Log out",
              onTap: () {
                Get.dialog(
                  AlertDialog(
                    title: const Text("Log out?"),
                    content: const Text("You will need to sign in again."),
                    actions: [
                      TextButton(onPressed: Get.back, child: const Text("Cancel")),
                      ElevatedButton(
                        onPressed: () async {
                          // clear storage then:
                          Get.offAll(() => const HandyEmailLoginScreen());
                        },
                        child: const Text("Log out"),
                      ),
                    ],
                  ),
                );
              },

            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

/// =========================
/// TILE ROW (matches screenshot)
/// =========================
class _TileRow extends StatelessWidget {
  const _TileRow({
    required this.leading,
    required this.title,
    required this.onTap,
  });

  final Widget leading;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Row(
            children: [
              leading,
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _C.text,
                    height: 1.2,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right_rounded, size: 22, color: _C.chev),
            ],
          ),
        ),
      ),
    );
  }
}

/// grey square icon holder like screenshot
class _LeadingIcon extends StatelessWidget {
  const _LeadingIcon({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: _C.iconBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(child: child),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 10),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: _C.section,
          letterSpacing: .4,
        ),
      ),
    );
  }
}

class _ThinDivider extends StatelessWidget {
  const _ThinDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 18),
      child: Divider(height: 1, thickness: 1, color: _C.divider),
    );
  }
}

class _C {
  static const green = Color(0xFF27AE60);

  static const bg = Colors.white;
  static const text = Color(0xFF111111);

  static const section = Color(0xFF8A8A8A);
  static const chev = Color(0xFF9A9A9A);

  static const iconBg = Color(0xFFEDEDED);
  static const divider = Color(0xFFEDEDED);
}
