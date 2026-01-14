import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paschaloliver/feature/auth/view/sign_in_view.dart';
import '../../../core/constants/assets.dart'; // Images.welcome, Images.google

class HandyLoginScreen extends StatelessWidget {
  const HandyLoginScreen({super.key});

  Color get _green => const Color(0xFF19A94A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background illustration
          Positioned.fill(
            child: Image.asset(
              Images.welcome,
              fit: BoxFit.cover,
            ),
          ),

          // Dark overlay
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.10),
                    Colors.black.withOpacity(0.55),
                  ],
                ),
              ),
            ),
          ),

          // Bottom sheet
          SafeArea(
            top: true,
            bottom: false,
            child: Column(
              children: [
                const Spacer(),
                _BottomSheet(green: _green),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// BOTTOM SHEET CONTENT
/// ---------------------------------------------------------------------------
class _BottomSheet extends StatelessWidget {
  const _BottomSheet({required this.green});

  final Color green;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(24, 16, 24, 16 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 50,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(height: 18),

          // Header row
          Row(
            children: [
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => Navigator.of(context).maybePop(),
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(
                    Icons.close,
                    size: 22,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ✅ Apple (always visible like your screenshot)
          _SocialLoginButton(
            background: Colors.black,
            borderColor: Colors.black,
            textColor: Colors.white,
            label: 'Continue with Apple',
            icon: const Icon(Icons.apple, color: Colors.white, size: 20),
            onTap: () {
              // TODO: implement Apple login
            },
          ),
          const SizedBox(height: 12),

          // Facebook
          _SocialLoginButton(
            background: const Color(0xFF1877F2),
            borderColor: const Color(0xFF1877F2),
            textColor: Colors.white,
            label: 'Continue with Facebook',
            icon: const Icon(Icons.facebook, color: Colors.white, size: 20),
            onTap: () {
              // TODO: implement Facebook login
            },
          ),
          const SizedBox(height: 12),

          // Google
          _SocialLoginButton(
            background: Colors.white,
            borderColor: const Color(0xFFDDDDDD),
            textColor: Colors.black87,
            label: 'Continue with Google',
            icon: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Image.asset(
                Images.google,
                height: 15,
                width: 15,
                fit: BoxFit.contain,
              ),
            ),
            onTap: () {
              // TODO: implement Google login
            },
          ),
          const SizedBox(height: 18),

          // "or" divider
          Row(
            children: const [
              Expanded(child: _DividerLine()),
              SizedBox(width: 8),
              Text(
                'or',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 8),
              Expanded(child: _DividerLine()),
            ],
          ),
          const SizedBox(height: 18),

          // Log in with email
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const HandyEmailLoginScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: green,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Log in with email',
                style: GoogleFonts.urbanist(
                  fontSize: 16,
                  fontWeight: FontWeight.w500, // Medium
                  height: 1.1, // 110%
                  color: const Color(0xFFFFFFFF),
                  letterSpacing: 0,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Terms text
          const _TermsAndPrivacyText(),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// REUSABLE WIDGETS
/// ---------------------------------------------------------------------------

class _SocialLoginButton extends StatelessWidget {
  const _SocialLoginButton({
    required this.background,
    required this.borderColor,
    required this.textColor,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final Color background;
  final Color borderColor;
  final Color textColor;
  final String label;
  final Widget icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min, // ✅ icon+text stay together
              children: [
                SizedBox(width: 24, height: 24, child: Center(child: icon)),
                const SizedBox(width: 10), // ✅ gap between icon & text
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textColor,
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



class _DividerLine extends StatelessWidget {
  const _DividerLine();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: const Color(0xFFE0E0E0),
    );
  }
}

class _TermsAndPrivacyText extends StatelessWidget {
  const _TermsAndPrivacyText();

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: 'By creating an account, I accept the ',
        style: const TextStyle(
          fontFamily: 'Urbanist',
          fontSize: 11,
          color: Colors.black54,
          height: 1.4,
        ),
        children: [
          TextSpan(
            text: 'Terms and Conditions',
            style: TextStyle(
              color: Colors.blue.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
          const TextSpan(text: ' and\nconfirm that I have read the '),
          TextSpan(
            text: 'Privacy policy.',
            style: TextStyle(
              color: Colors.blue.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
