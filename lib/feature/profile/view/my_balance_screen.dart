import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyBalanceScreen extends StatelessWidget {
  const MyBalanceScreen({
    super.key,
    this.balance = 0, // ✅ default 0
    this.pendingPayments = 0, // ✅ default 0
    this.minWithdrawal = 50, // ✅ default 50
    this.history = const [], // ✅ default empty list
  });

  final double balance;
  final double pendingPayments;
  final double minWithdrawal;
  final List<_PaymentHistoryItem> history;

  bool get _hasHistory => history.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final bool canWithdraw = balance >= minWithdrawal;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            /// Top bar: back + title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => Navigator.of(context).maybePop(),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(Icons.arrow_back, size: 20, color: _C.green),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "My Balance",
                    style: GoogleFonts.urbanist(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1.1,
                      color: const Color(0xFF3B3B3B),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            /// Balance header block
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Text(
                    "₦${balance.toStringAsFixed(2)}",
                    style: GoogleFonts.urbanist(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      height: 1.1,
                      color: const Color(0xFF3B3B3B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Available Balance",
                    style: GoogleFonts.urbanist(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      height: 1.2,
                      color: _C.subText,
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// Transfer button (green when enabled, grey when disabled)
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: canWithdraw ? () {} : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: canWithdraw
                            ? _C.green
                            : const Color(0xFFE6E6E6),
                        disabledBackgroundColor: const Color(0xFFE6E6E6),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Text(
                        "Transfer to my account",
                        style: GoogleFonts.urbanist(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          height: 1.1,
                          color: canWithdraw
                              ? Colors.white
                              : const Color(0xFF9B9B9B),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),
                  Text(
                    "Minimum withdrawal amount ₦${minWithdrawal.toStringAsFixed(2)}",
                    style: GoogleFonts.urbanist(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 1.2,
                      color: _C.subText,
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// Pending payments row
                  Row(
                    children: [
                      Text(
                        "Pending Payments",
                        style: GoogleFonts.urbanist(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                          color: _C.subTextDark,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "₦${pendingPayments.toStringAsFixed(2)}",
                        style: GoogleFonts.urbanist(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                          color: _C.subTextDark,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.info_outline,
                        size: 14,
                        color: _C.subTextDark,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),

            const Divider(height: 1, thickness: 1, color: _C.divider),

            /// Body: empty state OR history
            Expanded(
              child: _hasHistory
                  ? _PaymentHistorySection(items: history)
                  : const _EmptyState(),
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------------- Empty state (left screen) ----------------------

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 38),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Placeholder illustration – replace with your asset if needed
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.receipt_long_outlined,
                size: 40,
                color: _C.green,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "You haven’t received any payment yet. When you complete a service, the received money will appear here.",
              textAlign: TextAlign.center,
              style: GoogleFonts.urbanist(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                height: 1.3,
                color: _C.subTextDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------------- History section (right screen) ----------------------

class _PaymentHistorySection extends StatelessWidget {
  const _PaymentHistorySection({required this.items});

  final List<_PaymentHistoryItem> items;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Payment history",
            style: GoogleFonts.urbanist(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.2,
              color: const Color(0xFF181919),
            ),
          ),
          const SizedBox(height: 14),
          Column(
            children: [
              for (final item in items) ...[
                _PaymentCard(item: item),
                const SizedBox(height: 10),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  const _PaymentCard({required this.item});

  final _PaymentHistoryItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon bubble
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: item.iconBg,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(item.icon, size: 18, color: item.iconColor),
          ),
          const SizedBox(width: 10),

          // Description
          Expanded(
            child: Text(
              item.text,
              style: GoogleFonts.urbanist(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                height: 1.3,
                color: const Color(0xFF181919),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------------------- Models + demo data ----------------------

class _PaymentHistoryItem {
  const _PaymentHistoryItem({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.text,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String text;
}

/// You can use these for a quick demo of the “right” state:
const demoHistoryItems = <_PaymentHistoryItem>[
  _PaymentHistoryItem(
    icon: Icons.attach_money,
    iconBg: Color(0xFFFFE9E9),
    iconColor: Color(0xFFE53935),
    text: "₦50.00 already cut from your account as service commission",
  ),
  _PaymentHistoryItem(
    icon: Icons.home_outlined,
    iconBg: Color(0xFFE9F3FF),
    iconColor: Color(0xFF1E88E5),
    text:
        "You have successfully received ₦10.00 on your account via Referral & complete registration as professional in Handynaja app",
  ),
  _PaymentHistoryItem(
    icon: Icons.attach_money,
    iconBg: Color(0xFFFFE9E9),
    iconColor: Color(0xFFE53935),
    text: "MAD 10.00 already cut from your account as service commission",
  ),
  _PaymentHistoryItem(
    icon: Icons.account_balance_outlined,
    iconBg: Color(0xFFE9F3FF),
    iconColor: Color(0xFF1E88E5),
    text: "You have successfully withdraw ₦50.00 on your account via Bank",
  ),
];

class _C {
  static const green = Color(0xFF3FA96B);
  static const subText = Color(0xFF8B8B8B);
  static const subTextDark = Color(0xFF666666);
  static const divider = Color(0xFFE0E0E0);
}
