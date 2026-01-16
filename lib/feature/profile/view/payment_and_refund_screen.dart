import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paschaloliver/core/constants/assets.dart';
import 'package:paschaloliver/feature/profile/view/payment_method_screen.dart';

import 'invoices_screen.dart';
import 'mybooking_screen.dart';

/// PaymentsAndRefundsScreen (matches your screenshot)
/// - 3 tiles: My Bookings, Payments, Invoices
/// - Simple iOS-like list + green icons + chevron
class PaymentsAndRefundsScreen extends StatelessWidget {
  const PaymentsAndRefundsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.bg,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 4),
            _TopBar(title: "Payments and Refunds", onBack: () => Get.back()),
            const SizedBox(height: 10),

            // list card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _C.line),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.06),
                      blurRadius: 14,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _ListTileRow(
                      iconAsset: Images.bookmarkIcon,
                      title: "My Bookings",
                      onTap: () => Get.to(() => const MyBookingsScreen()),
                    ),
                    const _RowDivider(),
                    _ListTileRow(
                      iconAsset: Images.paymentIcon,
                      title: "Payments",
                      onTap: () => Get.to(() => const PaymentMethodsScreen()),
                    ),
                    const _RowDivider(),
                    _ListTileRow(
                      iconAsset: Images.invoiceFileIcon,
                      title: "Invoices",
                      onTap: () => Get.to(() => const InvoicesScreen()),
                    ),
                  ],
                ),
              ),
            ),

            const Expanded(child: SizedBox()),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          InkWell(
            onTap: onBack,
            borderRadius: BorderRadius.circular(10),
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: Colors.green,
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
        ],
      ),
    );
  }
}

class _ListTileRow extends StatelessWidget {
  const _ListTileRow({
    required this.iconAsset,
    required this.title,
    required this.onTap,
  });

  final String iconAsset;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 40, // ✅ Figma
                height: 40, // ✅ Figma
                padding: const EdgeInsets.all(8), // ✅ Figma padding
                decoration: BoxDecoration(
                  color: const Color(0xFFE4E4E4), // ✅ Figma bg
                  borderRadius: BorderRadius.circular(4), // ✅ Figma radius
                ),
                child: Image.asset(
                  iconAsset,
                  fit: BoxFit.contain,
                  color: _C.green, // keep tint if single-color icon
                  colorBlendMode: BlendMode.srcIn,
                ),
              ),

              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1.1,
                    letterSpacing: 0,
                    color: const Color(0xFF181919),
                  ),
                ),
              ),

              const Icon(
                Icons.chevron_right_rounded,
                size: 22,
                color: Color.fromARGB(255, 27, 22, 22),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, thickness: 1, color: _C.line);
  }
}

class _C {
  static const green = Color(0xFF27AE60);

  static const bg = Colors.white;
  static const text = Color(0xFF111111);

  static const chev = Color(0xFF9A9A9A);
  static const line = Color(0xFFEDEDED);
  static const iconBg = Color(0xFFEDEDED);
}
