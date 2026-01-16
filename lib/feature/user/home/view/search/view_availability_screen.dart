import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paschaloliver/feature/user/home/view/search/payment_screen.dart';

/// ---------------------------------------------------------------------------
/// ✅ Booking Details (View Availability) — FULL REPLACEABLE FILE (GetX)
/// Matches your screenshot:
/// - Top bar: back + "Booking details"
/// - Select Date (calendar with month arrows, Sundays red)
/// - Duration label + slider
/// - Start time: segmented (Flexible start / Exact start)
///   - Flexible: Morning/Evening chips grid
///   - Exact: From/Until dual time pick lists
/// - Bottom button: "Continue with ₦145"
///
/// Open:
/// Get.to(() => const BookingDetailsScreen());
/// ---------------------------------------------------------------------------

class _C {
  static const green = Color(0xFF2FA86A);
  static const text = Color(0xFF1F1F1F);
  static const muted = Color(0xFF8B8B8B);
  static const line = Color(0xFFEDEDED);
  static const chipBg = Color(0xFFF3F3F3);
  static const soft = Color(0xFFF6F6F6);
}

class BookingDetailsController extends GetxController {
  // Calendar
  final viewMonth = DateTime(2025, 12, 1).obs;
  final selectedDate = DateTime(2025, 12, 11).obs;

  // Duration (minutes)
  final durationMinutes = 135.obs; // 2h 15min

  // Start time mode
  final startType = "Flexible".obs; // Flexible | Exact

  // Flexible slots
  final selectedSlot = "6-9".obs; // e.g. 6-9, 9-12, 12-15, 15-18, 18-21, 21-00

  // Exact lists
  final fromTime = "08 : 00".obs;
  final untilTime = "18 : 00".obs;

  void prevMonth() {
    final m = viewMonth.value;
    viewMonth.value = DateTime(m.year, m.month - 1, 1);
  }

  void nextMonth() {
    final m = viewMonth.value;
    viewMonth.value = DateTime(m.year, m.month + 1, 1);
  }
}

class BookingDetailsScreen extends StatelessWidget {
  const BookingDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(BookingDetailsController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 4),

            // Top bar
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 10),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Get.back(),
                    borderRadius: BorderRadius.circular(10),
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: _C.text,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      "Booking details",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: _C.text,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, thickness: 1, color: _C.line),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Select Date",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: _C.text,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Month row
                    Obx(() {
                      return Row(
                        children: [
                          InkWell(
                            onTap: c.prevMonth,
                            borderRadius: BorderRadius.circular(10),
                            child: const Padding(
                              padding: EdgeInsets.all(6),
                              child: Icon(
                                Icons.chevron_left_rounded,
                                color: _C.muted,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              _monthTitle(c.viewMonth.value),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: _C.text,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: c.nextMonth,
                            borderRadius: BorderRadius.circular(10),
                            child: const Padding(
                              padding: EdgeInsets.all(6),
                              child: Icon(
                                Icons.chevron_right_rounded,
                                color: _C.muted,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),

                    const SizedBox(height: 10),

                    // Week header
                    const Row(
                      children: [
                        _WeekHead("M"),
                        _WeekHead("T"),
                        _WeekHead("W"),
                        _WeekHead("T"),
                        _WeekHead("F"),
                        _WeekHead("S"),
                        _WeekHead("S", sunday: true),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Calendar grid
                    Obx(() {
                      final days = _buildMonthDays(c.viewMonth.value);
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: days.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 7,
                              mainAxisExtent: 32,
                            ),
                        itemBuilder: (_, i) {
                          final d = days[i];
                          if (d == null) return const SizedBox.shrink();

                          final isSunday = d.weekday == DateTime.sunday;
                          final isSel = _sameDate(d, c.selectedDate.value);

                          return InkWell(
                            onTap: () => c.selectedDate.value = d,
                            borderRadius: BorderRadius.circular(10),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${d.day}",
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w800,
                                      color: isSunday
                                          ? Colors.red
                                          : (isSel
                                                ? _C.green
                                                : _C.text.withOpacity(.70)),
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 150),
                                    width: 5,
                                    height: 5,
                                    decoration: BoxDecoration(
                                      color: isSel
                                          ? _C.green
                                          : Colors.transparent,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }),

                    const SizedBox(height: 18),

                    // Duration label
                    Obx(() {
                      return Row(
                        children: [
                          const Text(
                            "Duration ",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: _C.text,
                            ),
                          ),
                          Text(
                            _durationLabel(c.durationMinutes.value),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: _C.green,
                            ),
                          ),
                        ],
                      );
                    }),
                    const SizedBox(height: 10),

                    // Duration slider
                    Obx(() {
                      return SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: _C.green,
                          inactiveTrackColor: _C.line,
                          thumbColor: Colors.white,
                          overlayColor: _C.green.withOpacity(.12),
                          trackHeight: 6,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 8,
                          ),
                        ),
                        child: Slider(
                          value: c.durationMinutes.value.toDouble(),
                          min: 60,
                          max: 240,
                          onChanged: (v) => c.durationMinutes.value = v.round(),
                        ),
                      );
                    }),

                    const SizedBox(height: 14),

                    const Text(
                      "Start time",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: _C.text,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Segmented (Flexible/Exact)
                    Obx(() {
                      return Container(
                        height: 40,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: _C.chipBg,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: _Segment(
                                label: "Flexible start",
                                selected: c.startType.value == "Flexible",
                                onTap: () => c.startType.value = "Flexible",
                              ),
                            ),
                            Expanded(
                              child: _Segment(
                                label: "Exact Start",
                                selected: c.startType.value == "Exact",
                                onTap: () => c.startType.value = "Exact",
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    const SizedBox(height: 12),

                    // Body (Flexible vs Exact)
                    Obx(() {
                      if (c.startType.value == "Exact") {
                        return _ExactPicker(c: c);
                      }
                      return _FlexibleSlots(c: c);
                    }),

                    const SizedBox(height: 18),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom button
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: _C.line)),
          ),
          child: SizedBox(
            height: 46,
            child: ElevatedButton(
              onPressed: () {
                Get.to(() => const ConfirmAndPayScreen());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _C.green,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Continue with ₦145",
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// --------------------------- FLEXIBLE SLOTS ---------------------------

class _FlexibleSlots extends StatelessWidget {
  const _FlexibleSlots({required this.c});
  final BookingDetailsController c;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Morning",
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w900,
            color: _C.muted,
          ),
        ),
        const SizedBox(height: 8),

        Obx(() {
          return _SlotGrid(
            selected: c.selectedSlot.value,
            slots: const [
              _Slot(icon: Icons.wb_sunny_outlined, label: "6-9"),
              _Slot(icon: Icons.wb_sunny_outlined, label: "9-12"),
              _Slot(icon: Icons.wb_sunny_outlined, label: "12-15"),
            ],
            onPick: (v) => c.selectedSlot.value = v,
          );
        }),

        const SizedBox(height: 14),
        const Text(
          "Evening",
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w900,
            color: _C.muted,
          ),
        ),
        const SizedBox(height: 8),

        Obx(() {
          return _SlotGrid(
            selected: c.selectedSlot.value,
            slots: const [
              _Slot(icon: Icons.wb_twilight_outlined, label: "15-18"),
              _Slot(icon: Icons.nightlight_outlined, label: "18-21"),
              _Slot(icon: Icons.nights_stay_outlined, label: "21-00"),
            ],
            onPick: (v) => c.selectedSlot.value = v,
          );
        }),
      ],
    );
  }
}

class _Slot {
  final IconData icon;
  final String label;
  const _Slot({required this.icon, required this.label});
}

class _SlotGrid extends StatelessWidget {
  const _SlotGrid({
    required this.slots,
    required this.selected,
    required this.onPick,
  });
  final List<_Slot> slots;
  final String selected;
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < slots.length; i++) ...[
          Expanded(
            child: _SlotChip(
              icon: slots[i].icon,
              label: slots[i].label,
              selected: slots[i].label == selected,
              onTap: () => onPick(slots[i].label),
            ),
          ),
          if (i != slots.length - 1) const SizedBox(width: 10),
        ],
      ],
    );
  }
}

class _SlotChip extends StatelessWidget {
  const _SlotChip({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: selected ? _C.green.withOpacity(.10) : _C.chipBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: selected ? _C.green : _C.line),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: _C.muted),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w900,
                color: selected ? _C.green : _C.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ----------------------------- EXACT PICKER -----------------------------

class _ExactPicker extends StatelessWidget {
  const _ExactPicker({required this.c});
  final BookingDetailsController c;

  @override
  Widget build(BuildContext context) {
    final list = const [
      "05 : 00",
      "06 : 00",
      "07 : 00",
      "08 : 00",
      "09 : 00",
      "10 : 00",
      "11 : 00",
      "12 : 00",
      "13 : 00",
      "14 : 00",
      "15 : 00",
      "16 : 00",
      "17 : 00",
      "18 : 00",
      "19 : 00",
      "20 : 00",
    ];

    return SizedBox(
      height: 220,
      child: Row(
        children: [
          Expanded(
            child: _TimeColumn(
              title: "From:",
              items: list,
              selected: c.fromTime,
              onPick: (v) => c.fromTime.value = v,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _TimeColumn(
              title: "Until:",
              items: list,
              selected: c.untilTime,
              onPick: (v) => c.untilTime.value = v,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeColumn extends StatelessWidget {
  const _TimeColumn({
    required this.title,
    required this.items,
    required this.selected,
    required this.onPick,
  });

  final String title;
  final List<String> items;
  final RxString selected;
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w900,
            color: _C.text,
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Obx(() {
            final sel = selected.value; // ✅ IMPORTANT: read Rx here

            return ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: items.length,
              itemBuilder: (_, i) {
                final v = items[i];
                final isSel = v == sel;

                return InkWell(
                  onTap: () => onPick(v),
                  child: Container(
                    height: 26,
                    margin: const EdgeInsets.only(bottom: 6),
                    decoration: BoxDecoration(
                      color: isSel ? _C.chipBg : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      v,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w900,
                        color: isSel ? _C.text : _C.text.withOpacity(.55),
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}

/// ------------------------------ SEGMENT ------------------------------

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          border: selected ? Border.all(color: _C.line) : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w900,
            color: _C.text,
          ),
        ),
      ),
    );
  }
}

/// ------------------------------ WEEK HEAD ------------------------------

class _WeekHead extends StatelessWidget {
  const _WeekHead(this.t, {this.sunday = false});
  final String t;
  final bool sunday;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          t,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            color: sunday ? Colors.red : _C.muted,
          ),
        ),
      ),
    );
  }
}

/// ------------------------------ HELPERS ------------------------------

String _monthTitle(DateTime d) {
  const names = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];
  return "${names[d.month - 1]} ${d.year}";
}

bool _sameDate(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

String _durationLabel(int m) {
  final h = m ~/ 60;
  final mm = m % 60;
  return "${h}h ${mm.toString().padLeft(2, '0')}min";
}

List<DateTime?> _buildMonthDays(DateTime month) {
  final first = DateTime(month.year, month.month, 1);
  final last = DateTime(month.year, month.month + 1, 0);

  // Monday based
  final leading = first.weekday - 1; // 0..6
  final total = leading + last.day;
  final trailing = (7 - (total % 7)) % 7;

  final out = <DateTime?>[];
  for (int i = 0; i < leading; i++) {
    out.add(null);
  }
  for (int d = 1; d <= last.day; d++) {
    out.add(DateTime(month.year, month.month, d));
  }
  for (int i = 0; i < trailing; i++) {
    out.add(null);
  }
  return out;
}
