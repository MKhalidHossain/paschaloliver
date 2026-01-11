import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
            _TopBar(
              title: "Payments and Refunds",
              onBack: () => Get.back(),
            ),
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
                      icon: Icons.bookmark_border_rounded,
                      title: "My Bookings",
                      onTap: () {
                        TODO: Get.to(() => const MyBookingsScreen());
                      },
                    ),
                    const _RowDivider(),
                    _ListTileRow(
                      icon: Icons.payments_outlined,
                      title: "Payments",
                      onTap: () {
                        TODO: Get.to(() => const PaymentMethodsScreen());
                      },
                    ),
                    const _RowDivider(),
                    _ListTileRow(
                      icon: Icons.receipt_long_outlined,
                      title: "Invoices",
                      onTap: () {
                        TODO: Get.to(() => const InvoicesScreen());
                      },
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
              child: Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: _C.text),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w800,
                color: _C.text,
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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: _C.iconBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: _C.green),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12.8,
                    fontWeight: FontWeight.w700,
                    color: _C.text,
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
