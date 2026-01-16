import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'billing_screen.dart';

/// ------------------------------------------------------------
/// ✅ Invoices Screen (UI like your screenshot)
/// - Simple top bar: back + "Invoices"
/// - 2 rows: "Commission Invoices" + "Billing Details"
/// - Left icon in grey rounded square, right chevron
///
/// Use:
/// Get.to(() => const InvoicesScreen());
/// ------------------------------------------------------------

class InvoicesScreen extends StatelessWidget {
  const InvoicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.bg,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 6),
            _TopBar(title: "Invoices", onBack: () => Get.back()),
            const Divider(height: 1, thickness: 1, color: _C.divider),

            _MenuTile(
              icon: Icons.description_outlined,
              title: "Commission Invoices",
              onTap: () {
                // TODO: Get.to(() => const CommissionInvoicesScreen());
              },
            ),
            const _ThinDivider(),

            _MenuTile(
              icon: Icons.perm_identity_outlined,
              title: "Billing Details",
              onTap: () {
                TODO:
                Get.to(() => const BillingDetailsScreen());
              },
            ),

            const Divider(height: 1, thickness: 1, color: _C.divider),
            const Expanded(child: SizedBox()), // blank space like screenshot
          ],
        ),
      ),
    );
  }
}

/// -------------------- UI Widgets --------------------

class _TopBar extends StatelessWidget {
  const _TopBar({required this.title, required this.onBack});
  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 6, 10, 10),
      child: Row(
        children: [
          InkWell(
            onTap: onBack,
            borderRadius: BorderRadius.circular(10),
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: _C.green,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.urbanist(
                fontSize: 16,
                fontWeight: FontWeight.w700, // Bold
                height: 1.1, // 110%
                letterSpacing: 0,
                color: const Color(0xFF000000),
              ),
            ),
          ),

          const SizedBox(width: 18),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
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
              _LeadingIcon(child: Icon(icon, size: 18, color: _C.green)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title, // "Commission Invoices"
                  style: GoogleFonts.urbanist(
                    fontSize: 16, // ✅ 16px
                    fontWeight: FontWeight.w500, // ✅ Medium (500)
                    height: 1.1, // ✅ 110%
                    letterSpacing: 0, // ✅ 0%
                    color: const Color(0xFF181919), // ✅ #181919
                  ),
                ),
              ),

              const Icon(
                Icons.chevron_right_rounded,
                size: 22,
                color: Color.fromARGB(255, 24, 20, 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
      alignment: Alignment.center,
      child: child,
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

/// -------------------- THEME --------------------

class _C {
  static const green = Color(0xFF27AE60);

  static const bg = Colors.white;
  static const text = Color(0xFF111111);

  static const iconBg = Color(0xFFEDEDED);
  static const divider = Color(0xFFEDEDED);
  static const chev = Color(0xFF9A9A9A);
}
