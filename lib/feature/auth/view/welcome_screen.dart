import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:paschaloliver/app_ground.dart';
import 'package:paschaloliver/core/constants/app_colors.dart';

import '../../../core/constants/assets.dart';
import 'account_type_view.dart';
import 'handy_login_screen.dart';

class WelcomeScreenView extends StatelessWidget {
  const WelcomeScreenView({super.key});

  // ✅ change to your real logo path
  // static const String _logoPath = 'assets/images/app_logo.png';
  // static const String _bgPath = 'assets/images/Wellcome.png';

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light, // Android
        statusBarBrightness: Brightness.dark, // iOS
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          fit: StackFit.expand,
          children: [
            // ✅ wallpaper
            Image.asset(
              Images.welcome,
              fit: BoxFit.cover, // ✅ don't stretch
              alignment: Alignment.topCenter,
            ),




            // ✅ logo + texts on wallpaper (top)
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 18),
                child: Column(
                  children: [
                    // you can change top spacing by changing this value
                    const SizedBox(height: 32),

                    // logo + title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          Images.wellcomeappLogo,
                          width: 64,  // ✅ Figma: 80
                          height: 46, // ✅ Figma: 58
                          fit: BoxFit.contain,
                          // if your logo is black and you need white:
                          // color: Colors.white,
                          // colorBlendMode: BlendMode.srcIn,
                        ),
                        // const SizedBox(width: 10),
                        Text(
                          'HandyNaija',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.notoSansTaiTham(
                            fontSize: 24,                 // ✅ Figma: 24px
                            fontWeight: FontWeight.w600,  // ✅ closest to 586 (SemiBold)
                            height: 1.2,                  // ✅ 120%
                            letterSpacing: 0,             // ✅ 0%
                            color: Colors.white,          // ✅ #FFFFFF
                          ),
                        ),


                      ],
                    ),

                    const SizedBox(height: 4),

                    // subtitle
                    Text(
                      'Doorstep convenience,\nfor any service',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.schoolbell(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        height: 1.2,
                        letterSpacing: 0,
                        color: Colors.white,
                      ),
                    ),





                  ],
                ),
              ),
            ),

            // ✅ bottom card
            _bottomCard(context),
          ],
        ),
      ),
    );
  }

  /// ===================== BOTTOM CARD =====================
  Widget _bottomCard(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 5.5,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),

              _primaryButton(
                title: 'Create new account',
                color: AppColors.appColor,
                onTap: () => Get.to(() => ChooseAccountTypeView()),
              ),
              const SizedBox(height: 16),

              _primaryButton(
                title: 'Log in',
                color: const Color(0xFF0D1B3E),
                onTap: () => Get.to(() => HandyLoginScreen()),
              ),
              const SizedBox(height: 20),

              TextButton(
                onPressed: () => Get.to(() => AppGround()),
                child: Text(
                  'Continue as a guest',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1.1,
                    letterSpacing: 0,
                    color: const Color(0xFF181919),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ===================== BUTTON =====================
  Widget _primaryButton({
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 48,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          title,
          style: GoogleFonts.urbanist(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 1.1,
            letterSpacing: 0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
