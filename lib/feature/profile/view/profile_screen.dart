import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paschaloliver/core/network/api_service/token_meneger.dart';
import 'package:paschaloliver/feature/profile/view/my_balance_screen.dart';
import 'package:paschaloliver/feature/profile/view/payment_and_refund_screen.dart';
import 'package:paschaloliver/feature/profile/view/per_details_screen.dart';
import 'package:paschaloliver/feature/profile/view/privacy_policy_screen.dart';
import 'package:paschaloliver/feature/profile/view/terms_and_condition_screen.dart';
import 'package:paschaloliver/feature/user/app_ground_user.dart';
import 'package:paschaloliver/feature/auth/controller/auth_controller.dart';
import 'package:paschaloliver/app_ground.dart';
import 'package:paschaloliver/feature/profile/controller/user_profile_controller.dart';

import '../../../core/constants/assets.dart';
import '../../auth/view/sign_in_view.dart';
import 'about_screen.dart';
import 'change_password_screen.dart';
import 'choose_language_screen.dart';
import 'coupon_code_screen.dart';
import 'every_friend_you_bring_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final profile = Get.find<UserProfileController>();

    // your bottom bar height (you used 62 in AppGround)
    const bottomBarHeight = 62.0;

    return Scaffold(
      backgroundColor: _C.bg,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.only(bottom: 18 + bottomBarHeight + bottomInset),
          children: [
            const SizedBox(height: 8),

            // =========================
            // TOP PROFILE HEADER
            // =========================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [
                  Obx(() {
                    final path = profile.avatarPath.value;
                    final imageUrl = profile.imageUrl.value;
                    if (path.isNotEmpty) {
                      return CircleAvatar(
                        radius: 28,
                        backgroundColor: const Color(0xFFD9D9D9),
                        backgroundImage: FileImage(File(path)),
                      );
                    }
                    if (imageUrl.isNotEmpty) {
                      return CircleAvatar(
                        radius: 28,
                        backgroundColor: const Color(0xFFD9D9D9),
                        backgroundImage: NetworkImage(imageUrl),
                        onBackgroundImageError: (_, __) {},
                      );
                    }
                    return const CircleAvatar(
                      radius: 28,
                      backgroundColor: Color(0xFFD9D9D9),
                      child: Icon(
                        Icons.person,
                        color: Color(0xFF666666),
                        size: 28,
                      ),
                    );
                  }),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {
                          final name = profile.displayName.value.trim().isEmpty
                              ? "Unknown"
                              : profile.displayName.value.trim();
                          return Text(
                            name,
                            style: GoogleFonts.urbanist(
                              fontSize: 18,
                              fontWeight: FontWeight.w400, // Regular
                              height: 1.1, // 110%
                              letterSpacing: 0,
                              color: const Color(0xFF181919),
                            ),
                          );
                        }),
                        const SizedBox(height: 3),
                        InkWell(
                          onTap: () {
                            Get.to(() => const PerDetailsScreen());
                          },
                          borderRadius: BorderRadius.circular(6),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 2,
                              horizontal: 2,
                            ),
                            child: Text(
                              "View Profile",
                              style: GoogleFonts.urbanist(
                                fontSize: 14,
                                fontWeight: FontWeight.w400, // Regular
                                height: 1.1, // 110%
                                letterSpacing: 0,
                                color: const Color(0xFF3FA96B),
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
            const Divider(height: 1, thickness: 1, color: _C.divider),
            _ShadowWrap(
              child: _TileRow(
                leading: _LeadingIcon(
                  child: Image.asset(
                    Images.giftIcon,
                    width: 50,
                    height: 50,
                    fit: BoxFit.contain,
                  ),
                ),
                title: "\$ 10 for every friend you bring",
                onTap: () {
                  Get.to(() => const ShareAndEarnMoneyScreen());
                },
              ),
            ),
            const Divider(height: 1.5, thickness: 1.5, color: _C.divider),

            // =========================
            // YOUR ACCOUNT
            // =========================
            const _SectionTitle("ACCOUNT SETTINGS"),
            const Divider(height: 1.5, thickness: 1.5, color: _C.divider),
            _ShadowWrap(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _TileRow(
                    leading: const _LeadingIcon(
                      child: Icon(
                        Icons.person_outline_rounded,
                        size: 18,
                        color: _C.green,
                      ),
                    ),
                    title: "Personal details",
                    onTap: () {
                      Get.to(() => const PerDetailsScreen());
                    },
                  ),
                  const _ThinDivider(),
                  _TileRow(
                    leading: const _LeadingIcon(
                      child: Image(
                        image: AssetImage(Images.dollerIcon),
                        width: 18,
                        height: 18,
                        fit: BoxFit.contain,
                      ),
                    ),
                    title: "My Balance",
                    onTap: () => Get.to(() => const MyBalanceScreen()),
                  ),

                  const _ThinDivider(),
                  _TileRow(
                    leading: const _LeadingIcon(
                      child: Image(
                        image: AssetImage(Images.paymentIcon),
                        width: 18,
                        height: 18,
                        fit: BoxFit.contain,
                      ),
                    ),
                    title: "Payment and refunds",
                    onTap: () => Get.to(() => const PaymentsAndRefundsScreen()),
                  ),

                  const _ThinDivider(),
                  _TileRow(
                    leading: const _LeadingIcon(
                      child: Icon(
                        Icons.lock_outline_rounded,
                        size: 18,
                        color: _C.green,
                      ),
                    ),
                    title: "Change password",
                    onTap: () => Get.to(() => const ChangePasswordScreen()),
                  ),
                  const _ThinDivider(),
                  _TileRow(
                    leading: const _LeadingIcon(
                      child: Icon(
                        Icons.language_rounded,
                        size: 18,
                        color: _C.green,
                      ),
                    ),
                    title: "Language",
                    onTap: () async {
                      final result = await Get.to<LanguageOption>(
                        () => const ChooseLanguageScreen(initialLocale: "en"),
                      );

                      if (result != null) {
                        // TODO: save locale and update app locale
                      }
                    },
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: _C.divider),

            // =========================
            // Codes and Promotions
            // =========================
            // const _SectionTitle("Codes and Promotions"),
            // const Divider(height: 1.5, thickness: 1.5, color: _C.divider),
            // _ShadowWrap(
            //   child: _TileRow(
            //     leading: _LeadingIcon(
            //       child: Image.asset(
            //         Images.couponIcon,
            //         width: 20,
            //         height: 20,
            //         fit: BoxFit.contain,
            //       ),
            //     ),
            //     title: "My Coupon codes",
            //     onTap: () {
            //       Get.to(() => const MyCodesScreen());
            //     },
            //   ),
            // ),

            // =========================
            // OFFER SERVICES
            // =========================
            const _SectionTitle("So you want to offer services?"),
            const Divider(height: 1.5, thickness: 1.5, color: _C.divider),
            _ShadowWrap(
              child: _TileRow(
                leading: const _LeadingIcon(
                  child: Icon(
                    Icons.swap_horiz_rounded,
                    size: 23,
                    color: _C.green,
                  ),
                ),
                title: "Switch to Client version",
                onTap: () async {
                  final authC = Get.find<AuthController>();

                  try {
                    final newRole = await authC.switchRole(
                      role: "client", // only if backend needs it
                    );

                    if (newRole == "client" || newRole == "user") {
                      Get.offAll(() => const UserAppGround());
                      return;
                    }

                    Get.snackbar(
                      "Switch role",
                      newRole.isEmpty
                          ? "Role switch failed. Please try again."
                          : "Server returned role: $newRole",
                      snackPosition: SnackPosition.TOP,
                    );
                  } catch (e) {
                    Get.snackbar(
                      "Switch role",
                      e.toString().replaceFirst("Exception: ", ""),
                      snackPosition: SnackPosition.TOP,
                    );
                  }
                },
              ),
            ),
            const Divider(height: 1, thickness: 1, color: _C.divider),

            // =========================
            // LIKE THE APP
            // =========================
            const _SectionTitle("Do you like the app?"),
            const Divider(height: 1.5, thickness: 1.5, color: _C.divider),
            _ShadowWrap(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                    leading: const _LeadingIcon(
                      child: Icon(
                        Icons.share_outlined,
                        size: 18,
                        color: _C.green,
                      ),
                    ),
                    title: "Share the HandyNaija App",
                    onTap: () {
                      Get.dialog(
                        const ShareAppDialog(),
                        barrierDismissible: true,
                        barrierColor: Colors.black.withOpacity(.35),
                      );
                    },
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: _C.divider),

            // =========================
            // SUPPORT CENTRE
            // =========================
            const _SectionTitle("SUPPORT CENTRE"),
            const Divider(height: 1.5, thickness: 1.5, color: _C.divider),
            _ShadowWrap(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _TileRow(
                    leading: const _LeadingIcon(
                      child: Icon(
                        Icons.headset_mic_outlined,
                        size: 18,
                        color: _C.green,
                      ),
                    ),
                    title: "Help",
                    onTap: () {},
                  ),
                  const _ThinDivider(),
                  _TileRow(
                    leading: const _LeadingIcon(
                      child: Image(
                        image: AssetImage(Images.aboutIcon),
                        width: 18,
                        height: 18,
                        fit: BoxFit.contain,
                      ),
                    ),
                    title: "How can we improve?",
                    onTap: () {},
                  ),

                  const _ThinDivider(),
                  _TileRow(
                    leading: const _LeadingIcon(
                      child: Image(
                        image: AssetImage(Images.helpIcon),
                        width: 18,
                        height: 18,
                        fit: BoxFit.contain,
                      ),
                    ),
                    title: "About HandyNaija App",
                    onTap: () => Get.to(() => const AboutHandyNaijaScreen()),
                  ),

                  const _ThinDivider(),
                  _TileRow(
                    leading: _LeadingIcon(
                      child: Image.asset(
                        Images.shieldIcon,
                        width: 18,
                        height: 18,
                        fit: BoxFit.contain,
                        // if you want it tinted green like the icon:
                        color: _C.green,
                      ),
                    ),
                    title: "Privacy Policy",
                    onTap: () => Get.to(() => const PrivacyPolicyScreen()),
                  ),

                  const _ThinDivider(),
                  _TileRow(
                    leading: _LeadingIcon(
                      child: Image.asset(
                        Images.privacyIcon,
                        width: 18,
                        height: 18,
                        fit: BoxFit.contain,
                        color: _C.green, // tint like the old icon
                      ),
                    ),
                    title: "Terms And Condition", // or "Terms and Conditions"
                    onTap: () => Get.to(() => const TermsConditionsScreen()),
                  ),

                  const _ThinDivider(),
                  _TileRow(
                    leading: const _LeadingIcon(
                      child: Icon(
                        Icons.logout_rounded,
                        size: 18,
                        color: _C.green,
                      ),
                    ),
                    title: "Log out",
                    onTap: () {
                      Get.dialog(
                        const _LogoutConfirmDialog(),
                        barrierDismissible: true,
                        barrierColor: Colors.black.withOpacity(.45),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

/// ✅ ONLY shadow wrapper
class _ShadowWrap extends StatelessWidget {
  const _ShadowWrap({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.10),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// ------------------------------------------------------------
/// ✅ Rate dialog (UI like your screenshot)
/// ------------------------------------------------------------
class _RateAppDialog extends StatefulWidget {
  const _RateAppDialog();

  @override
  State<_RateAppDialog> createState() => _RateAppDialogState();
}

class _RateAppDialogState extends State<_RateAppDialog> {
  int _rating = 3;

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
            SizedBox(
              width: 46,
              height: 46,

              child: Image.asset(
                Images.star2Icon,
                width: 28,
                height: 28,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Rate Handynaija App",
              textAlign: TextAlign.center,
              style: GoogleFonts.urbanist(
                fontSize: 16, // ✅ 16px
                fontWeight: FontWeight.w700, // ✅ Bold
                height: 1.1, // ✅ 110%
                letterSpacing: 0, // ✅ 0%
                color: const Color(0xFF000000), // ✅ #000000
              ),
            ),

            const SizedBox(height: 4),
            Text(
              "Tap a star to give your rating.",
              textAlign: TextAlign.center,
              style: GoogleFonts.urbanist(
                fontSize: 12, // ✅ 12px
                fontWeight: FontWeight.w400, // ✅ Regular
                height: 1.2, // ✅ 120%
                letterSpacing: 0, // ✅ 0%
                color: const Color(0xFF000000), // ✅ #000000
              ),
            ),

            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                final idx = i + 1;
                final selected = idx <= _rating;

                return InkWell(
                  onTap: () => setState(() => _rating = idx),
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 4,
                    ),
                    child: Icon(
                      selected ? Icons.star_rounded : Icons.star_border_rounded,
                      size: 32, // ✅ Figma
                      color: selected
                          ? const Color(0xFFFFC34D) // ✅ selected
                          : const Color(0xFF727272), // ✅ unselected
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
                        side: BorderSide(
                          color: _C.green.withOpacity(.55),
                          width: 1.2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: GoogleFonts.urbanist(
                          fontSize: 16, // ✅ 16px
                          fontWeight: FontWeight.w500, // ✅ Medium (500)
                          height: 1.1, // ✅ 110%
                          letterSpacing: 0,
                          color: const Color(0xFF3FA96B), // ✅ #3FA96B
                        ),
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
                        Get.back();
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Submit",
                        style: GoogleFonts.urbanist(
                          fontSize: 16, // ✅ 16px
                          fontWeight: FontWeight.w500, // ✅ Medium (500)
                          height: 1.1, // ✅ 110%
                          letterSpacing: 0, // ✅ 0%
                          color: const Color(0xFFFFFFFF), // ✅ #FFFFFF
                        ),
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
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Image.asset(
                    Images.shareIcon,
                    width: 30,
                    height: 30,
                    fit: BoxFit.contain,
                  ),
                ),
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
                      leading: ImageIcon(
                        AssetImage(Images.shareIcon),
                        size: 16,
                        color: Colors.white,
                      ),
                      onTap: () async {
                        Get.back();
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
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
  const _GreenBtn({
    required this.label,
    required this.leading,
    required this.onTap,
  });

  final String label;
  final Widget leading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: leading,
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF27AE60),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

// class _LogoutConfirmDialog extends StatelessWidget {
//   const _LogoutConfirmDialog();

//   static const Color _red = Color(0xFFFF2D2D);

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Material(
//         color: Colors.transparent,
//         child: Container(
//           width: 340,
//           margin: const EdgeInsets.symmetric(horizontal: 18),
//           padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(14),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 48,
//                 height: 48,
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF3FA96B).withOpacity(.12),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 2.55,
//                   ), // ✅ left & right
//                   child: SizedBox(
//                     width: 42.9, // ✅ 48 - (2.55*2)
//                     height: 48,
//                     child: Image.asset(
//                       Images.logoutIcon, // PNG
//                       fit: BoxFit.contain,
//                       // ✅ tint (only if your PNG is single-color)
//                       color: const Color(0xFF3FA96B),
//                       colorBlendMode: BlendMode.srcIn,
//                     ),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 10),
//               Text(
//                 "Are you sure want to Log out",
//                 textAlign: TextAlign.center,
//                 style: GoogleFonts.urbanist(
//                   fontSize: 16, // ✅ 16px
//                   fontWeight: FontWeight.w700, // ✅ Bold
//                   height: 1.1, // ✅ 110%
//                   letterSpacing: 0, // ✅ 0%
//                   color: const Color(0xFF000000), // ✅ #000000
//                 ),
//               ),

//               const SizedBox(height: 6),
//               Text(
//                 "Tap log out to Log out from this app.",
//                 textAlign: TextAlign.center,
//                 style: GoogleFonts.urbanist(
//                   fontSize: 12, // ✅ 12px
//                   fontWeight: FontWeight.w400, // ✅ Regular
//                   height: 1.2, // ✅ 120%
//                   letterSpacing: 0, // ✅ 0%
//                   color: const Color(0xFF000000), // ✅ #000000
//                 ),
//               ),

//               const SizedBox(height: 14),
//               Row(
//                 children: [
//                   Expanded(
//                     child: SizedBox(
//                       height: 42,
//                       child: OutlinedButton(
//                         onPressed: () => Get.back(),
//                         style: OutlinedButton.styleFrom(
//                           side: const BorderSide(color: _red, width: 1.2),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           backgroundColor: Colors.white,
//                           elevation: 0,
//                         ),
//                         child: Text(
//                           "Cancel",
//                           style: GoogleFonts.urbanist(
//                             fontSize: 16, // ✅ 16px
//                             fontWeight: FontWeight.w500, // ✅ Medium (500)
//                             height: 1.1, // ✅ 110%
//                             letterSpacing: 0, // ✅ 0%
//                             color: const Color.fromARGB(
//                               255,
//                               16,
//                               17,
//                               16,
//                             ), // ✅ #3FA96B
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: SizedBox(
//                       height: 42,
//                       child: ElevatedButton.icon(
//                         onPressed: () async {
//                           Get.back();
//                           Get.offAll(() => HandyEmailLoginScreen());
//                         },
//                         icon: Image.asset(
//                           Images.logout2Icon,
//                           width: 18,
//                           height: 18,
//                           // ✅ tint to white (works best if icon is single-color)
//                           color: Colors.white,
//                           colorBlendMode: BlendMode.srcIn,
//                         ),

//                         label: Text(
//                           "Log out",
//                           style: GoogleFonts.urbanist(
//                             fontSize: 16, // ✅ 16px
//                             fontWeight: FontWeight.w500, // ✅ Medium (500)
//                             height: 1.1, // ✅ 110%
//                             letterSpacing: 0, // ✅ 0%
//                             color: Colors.white, // ✅ #FFFFFF
//                           ),
//                         ),

//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: _red,
//                           elevation: 0,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class _LogoutConfirmDialog extends StatefulWidget {
  const _LogoutConfirmDialog();

  @override
  State<_LogoutConfirmDialog> createState() => _LogoutConfirmDialogState();
}

class _LogoutConfirmDialogState extends State<_LogoutConfirmDialog> {
  static const Color _red = Color(0xFFFF2D2D);
  bool _loading = false;

  Future<void> _doLogout() async {
    if (_loading) return;
    setState(() => _loading = true);

    try {
      // ✅ Clear secure storage (tokens, role, email, serviceType, everything)
      await TokenManager.clearAll();

      // ✅ (Optional) clear GetX instances to avoid “old state”
      // Remove these lines if you don’t want to delete dependencies.
      Get.delete(force: true); // deletes all registered controllers/services

      // ✅ Go to Sign In screen and remove all previous pages
      Get.offAll(() => const HandyEmailLoginScreen());
      // If you want to go to HandyEmailLoginScreen instead:
      // Get.offAll(() => const HandyEmailLoginScreen());
    } catch (e) {
      setState(() => _loading = false);
      Get.snackbar(
        "Logout failed",
        e.toString(),
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(12),
      );
    }
  }

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
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF3FA96B).withOpacity(.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.55),
                  child: SizedBox(
                    width: 42.9,
                    height: 48,
                    child: Image.asset(
                      Images.logoutIcon,
                      fit: BoxFit.contain,
                      color: const Color(0xFF3FA96B),
                      colorBlendMode: BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              Text(
                "Are you sure want to Log out",
                textAlign: TextAlign.center,
                style: GoogleFonts.urbanist(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                  letterSpacing: 0,
                  color: const Color(0xFF000000),
                ),
              ),

              const SizedBox(height: 6),
              Text(
                "Tap log out to Log out from this app.",
                textAlign: TextAlign.center,
                style: GoogleFonts.urbanist(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 1.2,
                  letterSpacing: 0,
                  color: const Color(0xFF000000),
                ),
              ),

              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 42,
                      child: OutlinedButton(
                        onPressed: _loading ? null : () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: _red, width: 1.2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.white,
                          elevation: 0,
                        ),
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.urbanist(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 1.1,
                            letterSpacing: 0,
                            color: const Color(0xFF101110),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: SizedBox(
                      height: 42,
                      child: ElevatedButton.icon(
                        onPressed: _loading ? null : _doLogout,
                        icon: _loading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Image.asset(
                                Images.logout2Icon,
                                width: 18,
                                height: 18,
                                color: Colors.white,
                                colorBlendMode: BlendMode.srcIn,
                              ),
                        label: Text(
                          _loading ? "Logging out..." : "Log out",
                          style: GoogleFonts.urbanist(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 1.1,
                            letterSpacing: 0,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _red,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
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
/// TILE ROW
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: FontWeight.w400, // Regular
                    height: 1.1, // 110%
                    letterSpacing: 0,
                    color: const Color(0xFF181919),
                  ),
                ),
              ),
              Transform.rotate(
                angle: 3.1415926535, // 180° (same as -180°)
                child: const Icon(
                  Icons.chevron_left_rounded,
                  size: 24,
                  color: _C.chev,
                ),
              ),
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
        style: GoogleFonts.urbanist(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.1,
          letterSpacing: 0,
          color: const Color(0xFF3B3B3B),
        ),
      ),
    );
  }
}

/// ✅ full width divider (no left indent)
class _ThinDivider extends StatelessWidget {
  const _ThinDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, thickness: 1, color: _C.divider);
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
