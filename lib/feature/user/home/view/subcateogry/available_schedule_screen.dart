import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../search/search_services_find_screen.dart';

/// ---------------------------------------------------------------------------
/// ✅ AVAILABILITY / SCHEDULE (UPDATED)
/// FIXES:
/// 1) Dropdown popup is rounded like your screenshot
/// 2) Leading icon changes:
///    - Weekly  -> refresh icon
///    - Biweekly/Just once -> clock/target icon (like your frame)
/// 3) Full replaceable code
/// ---------------------------------------------------------------------------

enum RepeatType { weekly, biweekly, once }

class AvailabilityController extends GetxController {
  final repeatType = RepeatType.weekly.obs;

  final durationMin = 135.0.obs; // 2h 15min
  final selectedDayIndex = 0.obs;

  final showBiweeklyStartTime = false.obs;
  final selectedStartTime = RxnString();

  final dayAvailability = <String, bool>{
    "Monday": true,
    "Tuesday": false,
    "Wednesday": false,
    "Thursday": false,
    "Friday": true,
    "Saturday": false,
    "Sunday": false,
  }.obs;

  final times = const [
    "6:00",
    "12.00",
    "18:00",
    "7:00",
    "13:00",
    "19:00",
    "8:00",
    "14:00",
    "20:00",
    "9:00",
    "15:00",
    "21:00",
    "10:00",
    "16:00",
    "22:00",
    "11:00",
    "17:00",
    "23:00",
  ];

  String get durationLabel {
    final mins = durationMin.value.round();
    final h = mins ~/ 60;
    final m = mins % 60;
    if (m == 0) return "${h}h";
    return "${h}h ${m}min";
  }

  String get monthLabel => "December";

  String get repeatLabel {
    switch (repeatType.value) {
      case RepeatType.weekly:
        return "Weekly";
      case RepeatType.biweekly:
        return "Biweekly";
      case RepeatType.once:
        return "Just once";
    }
  }

  void setRepeat(String v) {
    if (v == "Weekly") repeatType.value = RepeatType.weekly;
    if (v == "Biweekly") repeatType.value = RepeatType.biweekly;
    if (v == "Just once") repeatType.value = RepeatType.once;

    selectedStartTime.value = null;
    showBiweeklyStartTime.value = false;
  }

  bool get isWeeklyOrOnce =>
      repeatType.value == RepeatType.weekly ||
      repeatType.value == RepeatType.once;

  bool get isButtonEnabled => selectedStartTime.value != null;

  void selectTime(String t) => selectedStartTime.value = t;

  void selectMiniDay(int i) => selectedDayIndex.value = i;

  void openBiweeklyTimes() => showBiweeklyStartTime.value = true;

  IconData get leadingIcon {
    // ✅ match your frames: weekly uses refresh; others use a "target/clock" look
    if (repeatType.value == RepeatType.weekly) return Icons.refresh_rounded;
    return Icons.gps_fixed_rounded; // close to your icon style
  }
}

class AvailabilityScheduleScreen extends StatelessWidget {
  const AvailabilityScheduleScreen({super.key});

  static const Color _green = Color(0xFF2FA86A);
  static const Color _text = Color(0xFF1F1F1F);
  static const Color _muted = Color(0xFF8B8B8B);
  static const Color _line = Color(0xFFEDEDED);
  static const Color _pill = Color(0xFFF3F3F3);
  static const Color _chipBorder = Color(0xFF1F1F1F);

  @override
  Widget build(BuildContext context) {
    final c = Get.put(AvailabilityController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ✅ top bar (custom rounded dropdown + close)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              child: Row(
                children: [
                  Expanded(child: _RepeatPickerButton(c: c)),
                  const SizedBox(width: 12),
                  _CircleBtn(
                    icon: Icons.close_rounded,
                    onTap: () => Get.back(),
                  ),
                ],
              ),
            ),
            Container(height: 1, color: _line),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Duration
                    Obx(() {
                      return RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w900,
                            color: _text,
                          ),
                          children: [
                            const TextSpan(text: "Duration "),
                            TextSpan(
                              text: c.durationLabel,
                              style: const TextStyle(color: _green),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 10),

                    // Slider
                    Obx(() {
                      return SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: _green,
                          inactiveTrackColor: _line,
                          trackHeight: 5,
                          thumbColor: Colors.white,
                          overlayColor: _green.withOpacity(.12),
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 7,
                          ),
                          overlayShape: const RoundSliderOverlayShape(
                            overlayRadius: 16,
                          ),
                        ),
                        child: Slider(
                          value: c.durationMin.value,
                          min: 60,
                          max: 240,
                          divisions: ((240 - 60) ~/ 15),
                          onChanged: (v) => c.durationMin.value = v,
                        ),
                      );
                    }),

                    const SizedBox(height: 12),
                    Container(height: 1, color: _line),
                    const SizedBox(height: 14),

                    // Weekly/Once => month chips
                    Obx(() {
                      if (!c.isWeeklyOrOnce) return const SizedBox.shrink();
                      return _MonthSection(c: c);
                    }),

                    // Biweekly => list
                    Obx(() {
                      if (c.repeatType.value != RepeatType.biweekly)
                        return const SizedBox.shrink();
                      return _BiweeklyDays(c: c);
                    }),

                    // Start time section:
                    Obx(() {
                      final showStart =
                          c.isWeeklyOrOnce || c.showBiweeklyStartTime.value;
                      if (!showStart) return const SizedBox.shrink();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 6),
                          const Text(
                            "Start time",
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w900,
                              color: _text,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _TimeGrid(c: c),
                        ],
                      );
                    }),

                    const SizedBox(height: 14),

                    const Center(
                      child: Text(
                        "Reach 3h to avoid a surcharge of ₦11.00",
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          color: _muted,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Button
                    Obx(() {
                      final enabled = c.isButtonEnabled;
                      return SizedBox(
                        height: 46,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: enabled
                              ? () {
                                  Get.to(() => const HandyManServicesScreen());
                                }
                              : null,

                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: enabled
                                ? _green
                                : const Color(0xFFE6E6E6),
                            foregroundColor: enabled
                                ? Colors.white
                                : const Color(0xFF8B8B8B),
                            disabledBackgroundColor: const Color(0xFFE6E6E6),
                            disabledForegroundColor: const Color(0xFF8B8B8B),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "Select start time",
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ====================== CUSTOM ROUNDED DROPDOWN POPUP ====================== */

class _RepeatPickerButton extends StatelessWidget {
  const _RepeatPickerButton({required this.c});

  final AvailabilityController c;

  static const Color _text = Color(0xFF1F1F1F);
  static const Color _line = Color(0xFFEDEDED);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _openRepeatSheet(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _line),
        ),
        child: Obx(() {
          return Row(
            children: [
              Icon(c.leadingIcon, size: 18, color: _text),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  c.repeatLabel,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w900,
                    color: _text,
                  ),
                ),
              ),
              const Icon(Icons.keyboard_arrow_down_rounded, color: _text),
            ],
          );
        }),
      ),
    );
  }

  void _openRepeatSheet(BuildContext context) {
    // ✅ rounded popup like your screenshot
    Get.bottomSheet(
      _RepeatSheet(
        current: c.repeatLabel,
        onSelect: (v) {
          c.setRepeat(v);
          Get.back();
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}

class _RepeatSheet extends StatelessWidget {
  const _RepeatSheet({required this.current, required this.onSelect});

  final String current;
  final ValueChanged<String> onSelect;

  static const Color _text = Color(0xFF1F1F1F);
  static const Color _line = Color(0xFFEDEDED);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin: const EdgeInsets.fromLTRB(18, 72, 18, 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14), // ✅ rounded card
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.18),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _RepeatTile(
                title: "Weekly",
                selected: current == "Weekly",
                onTap: () => onSelect("Weekly"),
              ),
              const Divider(height: 1, thickness: 1, color: _line),
              _RepeatTile(
                title: "Biweekly",
                selected: current == "Biweekly",
                onTap: () => onSelect("Biweekly"),
              ),
              const Divider(height: 1, thickness: 1, color: _line),
              _RepeatTile(
                title: "Just once",
                selected: current == "Just once",
                onTap: () => onSelect("Just once"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RepeatTile extends StatelessWidget {
  const _RepeatTile({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;

  static const Color _text = Color(0xFF1F1F1F);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
            color: _text,
          ),
        ),
      ),
    );
  }
}

/* =============================== SMALL BUTTON ============================== */

class _CircleBtn extends StatelessWidget {
  const _CircleBtn({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  static const Color _pill = Color(0xFFF3F3F3);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: _pill,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Icon(icon, size: 18, color: const Color(0xFF1F1F1F)),
      ),
    );
  }
}

/* =============================== MONTH SECTION ============================== */

class _MonthSection extends StatelessWidget {
  const _MonthSection({required this.c});

  final AvailabilityController c;

  static const Color _green = Color(0xFF2FA86A);
  static const Color _text = Color(0xFF1F1F1F);
  static const Color _muted = Color(0xFF8B8B8B);
  static const Color _line = Color(0xFFEDEDED);
  static const Color _pill = Color(0xFFF3F3F3);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              c.monthLabel,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w900,
                color: _text,
              ),
            ),
            const Spacer(),
            Container(
              height: 30,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: _pill,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  "Show month",
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                    color: _muted,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        SizedBox(
          height: 44,
          child: Obx(() {
            final selected = c.selectedDayIndex.value;

            return ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, i) {
                final isSelected = selected == i;
                final dow = ["Wed", "Thu", "Fri", "Sat"][i];
                final day = ["10", "11", "12", "13"][i];

                return InkWell(
                  onTap: () => c.selectMiniDay(i),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 56,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? _green.withOpacity(.12)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? _green.withOpacity(.55) : _line,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          dow,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            color: isSelected
                                ? _green
                                : const Color(0xFF6E6E6E),
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          day,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            color: isSelected
                                ? _green
                                : const Color(0xFF1F1F1F),
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ),
        const SizedBox(height: 14),
      ],
    );
  }
}

/* ============================== BIWEEKLY DAYS ============================== */

class _BiweeklyDays extends StatelessWidget {
  const _BiweeklyDays({required this.c});

  final AvailabilityController c;

  static const Color _text = Color(0xFF1F1F1F);
  static const Color _muted = Color(0xFF8B8B8B);
  static const Color _line = Color(0xFFEDEDED);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: c.dayAvailability.entries.map((e) {
          final day = e.key;
          final available = e.value;

          return Column(
            children: [
              Row(
                children: [
                  Text(
                    day,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: (day == "Monday" || day == "Friday")
                          ? FontWeight.w900
                          : FontWeight.w700,
                      color: _text,
                    ),
                  ),
                  const Spacer(),
                  if (!available)
                    const Text(
                      "Not Available",
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: _muted,
                      ),
                    )
                  else
                    InkWell(
                      onTap: c.openBiweeklyTimes,
                      borderRadius: BorderRadius.circular(8),
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(Icons.add, size: 20, color: _text),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(height: 1, thickness: 1, color: _line),
              const SizedBox(height: 10),
            ],
          );
        }).toList(),
      );
    });
  }
}

/* ============================== START TIME GRID ============================= */

class _TimeGrid extends StatelessWidget {
  const _TimeGrid({required this.c});

  final AvailabilityController c;

  static const Color _green = Color(0xFF2FA86A);
  static const Color _text = Color(0xFF1F1F1F);
  static const Color _border = Color(0xFF1F1F1F);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selected = c.selectedStartTime.value;

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: c.times.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 3.0,
        ),
        itemBuilder: (_, i) {
          final t = c.times[i];
          final isSelected = selected == t;

          return InkWell(
            onTap: () => c.selectTime(t),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? _green : _border,
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  t,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w900,
                    color: isSelected ? _green : _text,
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
