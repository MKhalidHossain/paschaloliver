import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// ------------------------------------------------------------
/// ✅ MY BOOKINGS (UI like screenshot)
/// - Sections by month (November 2025, October 2025)
/// - Booking row: avatar + title + price (green)
/// - 2 lines: Paid on .. , Service date ..
/// - Optional red status: "Request not accepted"
///
/// Use:
/// Get.to(() => const MyBookingsScreen());
/// ------------------------------------------------------------

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(MyBookingsController());

    return Scaffold(
      backgroundColor: _B.bg,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 6),
            _TopBar(
              title: "MY Bookings",
              onBack: () => Get.back(),
            ),
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 18),
                  itemCount: c.sections.length,
                  itemBuilder: (_, s) {
                    final sec = c.sections[s];
                    return _MonthSection(section: sec);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------- CONTROLLER + MODELS ----------------

class MyBookingsController extends GetxController {
  final sections = <BookingSection>[
    BookingSection(
      monthLabel: "November 2025",
      items: const [
        BookingItem(
          title: "Cleaning-YERXON",
          priceText: "₦30.5",
          paidOn: "08/10",
          serviceDate: "09/10",
        ),
      ],
    ),
    BookingSection(
      monthLabel: "October 2025",
      items: const [
        BookingItem(
          title: "Cleaning-YERXON",
          priceText: "₦30.5",
          paidOn: "08/10",
          serviceDate: "09/10",
        ),
        BookingItem(
          title: "Cleaning-YERXON",
          priceText: "₦30.5",
          paidOn: "08/10",
          serviceDate: "09/10",
        ),
        BookingItem(
          title: "Cleaning-YERXON",
          priceText: "₦30.5",
          paidOn: "08/10",
          serviceDate: "09/10",
          statusText: "Request not accepted",
          statusColor: Color(0xFFE53935),
        ),
        BookingItem(
          title: "Cleaning-YERXON",
          priceText: "₦30.5",
          paidOn: "08/10",
          serviceDate: "09/10",
        ),
      ],
    ),
  ].obs;
}

class BookingSection {
  final String monthLabel;
  final List<BookingItem> items;

  BookingSection({required this.monthLabel, required this.items});
}

class BookingItem {
  final String title;
  final String priceText;
  final String paidOn;
  final String serviceDate;

  final String? statusText;
  final Color? statusColor;

  const BookingItem({
    required this.title,
    required this.priceText,
    required this.paidOn,
    required this.serviceDate,
    this.statusText,
    this.statusColor,
  });
}

/// ---------------- UI ----------------

class _MonthSection extends StatelessWidget {
  const _MonthSection({required this.section});
  final BookingSection section;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // month label
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
          child: Text(
            section.monthLabel,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: _B.muted,
              height: 1.1,
            ),
          ),
        ),

        // white card list
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _B.line),
            boxShadow: const [
              BoxShadow(
                color: _B.shadow,
                blurRadius: 14,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              for (int i = 0; i < section.items.length; i++) ...[
                _BookingRow(item: section.items[i]),
                if (i != section.items.length - 1)
                  const Divider(height: 1, thickness: 1, color: _B.line),
              ],
            ],
          ),
        ),

        const SizedBox(height: 10),
      ],
    );
  }
}

class _BookingRow extends StatelessWidget {
  const _BookingRow({required this.item});
  final BookingItem item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO: open booking details if needed
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // avatar with small badge (bottom-left)
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE6E6E6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person, size: 18, color: Color(0xFF666666)),
                ),
                Positioned(
                  left: -1,
                  bottom: -1,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4E7CF4),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.white, width: 1.4),
                    ),
                    child: const Icon(Icons.check_rounded, size: 10, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),

            // texts
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w900,
                            color: _B.text,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        item.priceText,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w900,
                          color: _B.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  Row(
                    children: [
                      const Icon(Icons.payments_outlined, size: 14, color: _B.muted),
                      const SizedBox(width: 6),
                      Text(
                        "Paid on ${item.paidOn}",
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: _B.muted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),

                  Row(
                    children: [
                      const Icon(Icons.event_note_outlined, size: 14, color: _B.muted),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          "Service date: ${item.serviceDate}",
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: _B.muted,
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (item.statusText != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      item.statusText!,
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: item.statusColor ?? const Color(0xFFE53935),
                      ),
                    ),
                  ],
                ],
              ),
            ),
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
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
      child: Row(
        children: [
          InkWell(
            onTap: onBack,
            borderRadius: BorderRadius.circular(10),
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: _B.green),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: _B.text,
              ),
            ),
          ),
          const SizedBox(width: 18),
        ],
      ),
    );
  }
}

/// ---------------- THEME ----------------

class _B {
  static const bg = Colors.white;
  static const text = Color(0xFF111111);
  static const muted = Color(0xFF8B8B8B);
  static const line = Color(0xFFEDEDED);
  static const green = Color(0xFF27AE60);
  static const shadow = Color(0x14000000);
}
