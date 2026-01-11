import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:paschaloliver/feature/profile/view/payment_and_refund_screen.dart';
import 'package:paschaloliver/feature/profile/view/per_details_screen.dart';
import 'package:paschaloliver/feature/profile/view/personal_details_screen.dart';
import 'package:paschaloliver/feature/profile/view/privacy_policy_screen.dart';
import 'package:paschaloliver/feature/profile/view/terms_and_condition_screen.dart';

import '../../../core/constants/assets.dart';
import '../../auth/view/sign_in_view.dart';
import '../../user/home/view/address/address_flow_screens.dart';
import 'about_screen.dart';
import 'change_password_screen.dart';
import 'choose_language_screen.dart';
import 'coupon_code_screen.dart';
import 'edit_profile_screen.dart';
import 'every_friend_you_bring_screen.dart';

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
                            Get.to(() => const PersonalDetailsScreen());
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
                child: Image.asset(
                  Images.giftIcon,
                  width: 23.25,
                  height: 23.25,
                  fit: BoxFit.contain,
                ),
              ),

              title: "# 10 for every friend you bring",
              onTap: () {
                Get.to(()=>const ShareAndEarnMoneyScreen());
              },
            ),
            const Divider(height: 1, thickness: 1, color: _C.divider),

            // =========================
            // YOUR ACCOUNT
            // =========================
            const _SectionTitle("ACCOUNT SETTINGS"),
            _TileRow(
              leading: const _LeadingIcon(
                child: Icon(Icons.person_outline_rounded, size: 18, color: _C.green),
              ),
              title: "Personal details",
              onTap: () {
                Get.to(() => const PerDetailsScreen());
              },
            ),
            const _ThinDivider(),
            _TileRow(
              leading: const _LeadingIcon(child: Icon(Icons.location_on_outlined, size: 18, color: _C.green)),
              title: "My addresses",
              onTap: () {
                Get.to(()=>const MyAddressesScreen());
              },
            ),
            const _ThinDivider(),
            _TileRow(
              leading: const _LeadingIcon(child: Icon(Icons.calendar_today_outlined, size: 18, color: _C.green)),
              title: "Payment and refunds",
              onTap: () {
                Get.to(()=>const PaymentsAndRefundsScreen());

              },
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

            const _SectionTitle("Codes and Promotions"),
            _TileRow(
              leading: _LeadingIcon(
                child: Image.asset(
                  Images.couponIcon,
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                ),
              ),
              title: "My Coupon codes",
              onTap: () {
                Get.to(()=>const MyCodesScreen());
              },
            ),

            // =========================
            // OFFER SERVICES
            // =========================
            const _SectionTitle("So you want to offer services?"),
            _TileRow(
              leading: const _LeadingIcon(child: Icon(Icons.swap_horiz_rounded, size: 23, color: _C.green)),
              title: "Switch to Client version",
              onTap: () {},
            ),
            const Divider(height: 1, thickness: 1, color: _C.divider),

            // =========================
            // LIKE THE APP
            // =========================
            const _SectionTitle("Do you like the app?"),
            _TileRow(
              leading: _LeadingIcon(
                child: Image.asset(
                  Images.starIcon,
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                ),
              ),

              title: "Will you give us 5 stars?😊",
              onTap: () {
                Get.dialog(
                  const _RateAppDialog(),
                  barrierDismissible: true,
                );
              },
            ),

            const _ThinDivider(),
            _TileRow(
              leading: const _LeadingIcon(child: Icon(Icons.share_outlined, size: 18, color: _C.green)),
              title: "Share the HandyNaija App",
              onTap: () {
                Get.dialog(
                  const ShareAppDialog(),
                  barrierDismissible: true,
                  barrierColor: Colors.black.withOpacity(.35),
                );
              },
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
              leading: const _LeadingIcon(child: Icon(Icons.lightbulb_outline, size: 18, color: _C.green)),
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
              leading: const _LeadingIcon(child: Icon(Icons.indeterminate_check_box_outlined, size: 18, color: _C.green)),
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
                  const _LogoutConfirmDialog(),
                  barrierDismissible: true,
                  barrierColor: Colors.black.withOpacity(.45),
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

/// ------------------------------------------------------------
/// ✅ Rate dialog (UI like your screenshot)
/// - 5 stars selectable
/// - Cancel (outlined) + Submit (green)
/// - Center white card with rounded corners
/// ------------------------------------------------------------
class _RateAppDialog extends StatefulWidget {
  const _RateAppDialog();

  @override
  State<_RateAppDialog> createState() => _RateAppDialogState();
}

class _RateAppDialogState extends State<_RateAppDialog> {
  int _rating = 3; // default like screenshot (3 selected)

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 22),
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.18),
              blurRadius: 24,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // top icon (cute star)
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: _C.green.withOpacity(.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.star_rounded, color: Color(0xFFF4B400), size: 28),
            ),

            const SizedBox(height: 10),

            const Text(
              "Rate Handynaija App",
              style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w900, color: Color(0xFF111111)),
            ),
            const SizedBox(height: 4),
            const Text(
              "Tap a star to give your rating.",
              style: TextStyle(fontSize: 11.2, fontWeight: FontWeight.w700, color: Color(0xFF8B8B8B)),
            ),

            const SizedBox(height: 12),

            // stars
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                final idx = i + 1;
                final selected = idx <= _rating;
                return InkWell(
                  onTap: () => setState(() => _rating = idx),
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    child: Icon(
                      selected ? Icons.star_rounded : Icons.star_border_rounded,
                      size: 26,
                      color: selected ? const Color(0xFFF4B400) : const Color(0xFFBDBDBD),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: _C.green.withOpacity(.55), width: 1.2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: _C.green),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () async {
                        // TODO: send rating to backend / store locally
                        // print("User rating: $_rating");

                        Get.back(); // close dialog
                        Get.snackbar(
                          "Thanks!",
                          "You rated $_rating star${_rating == 1 ? '' : 's'} ⭐",
                          snackPosition: SnackPosition.BOTTOM,
                          margin: const EdgeInsets.all(12),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _C.green,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text(
                        "Submit",
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}



class ShareAppDialog extends StatelessWidget {
  const ShareAppDialog({super.key});

  static const Color _green = Color(0xFF27AE60);
  static const Color _text = Color(0xFF111111);
  static const Color _muted = Color(0xFF8A8A8A);
  static const Color _line = Color(0xFFEDEDED);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * .86,
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.18),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // top icon
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.ios_share_rounded, size: 30, color: Color(0xFF2F80ED)),
              ),

              const SizedBox(height: 12),

              const Text(
                "Share HandyNaija App",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: _text,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                "Tap share to share this app with your friends.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: _muted,
                  height: 1.25,
                ),
              ),

              const SizedBox(height: 14),
              const Divider(height: 1, thickness: 1, color: _line),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _OutlineBtn(
                      label: "Cancel",
                      onTap: () => Get.back(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _GreenBtn(
                      label: "Share",
                      icon: Icons.share_rounded,
                      onTap: () async {
                        // Close dialog first (optional)
                        Get.back();

                        // ✅ Put your share action here
                        // Example (recommended): use share_plus package
                        // Share.share("Download HandyNaija App: https://your-link.com");
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }
}

class _OutlineBtn extends StatelessWidget {
  const _OutlineBtn({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFF27AE60), width: 1.2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: const Text(
          "Cancel",
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w800,
            color: Color(0xFF27AE60),
          ),
        ),
      ),
    );
  }
}

class _GreenBtn extends StatelessWidget {
  const _GreenBtn({required this.label, required this.icon, required this.onTap});

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 16, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF27AE60),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}


class _LogoutConfirmDialog extends StatelessWidget {
  const _LogoutConfirmDialog();

  static const Color _red = Color(0xFFFF2D2D);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 340,
          margin: const EdgeInsets.symmetric(horizontal: 18),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // top icon
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: _C.green.withOpacity(.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.logout_rounded, color: _C.green, size: 24),
              ),
              const SizedBox(height: 10),

              const Text(
                "Are you sure want to Log out",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: _C.text,
                ),
              ),
              const SizedBox(height: 6),

              const Text(
                "Tap log out to Log out from this app.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF8B8B8B),
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 14),

              Row(
                children: [
                  // Cancel (white + red border)
                  Expanded(
                    child: SizedBox(
                      height: 42,
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: _red, width: 1.2),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          backgroundColor: Colors.white,
                          elevation: 0,
                        ),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            color: _C.text,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Log out (red filled)
                  Expanded(
                    child: SizedBox(
                      height: 42,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          // close dialog first
                          Get.back();

                          // TODO: clear storage/session here

                          Get.offAll(() => const HandyEmailLoginScreen());
                        },
                        icon: const Icon(Icons.logout_rounded, size: 18, color: Colors.white),
                        label: const Text(
                          "Log out",
                          style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _red,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
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
