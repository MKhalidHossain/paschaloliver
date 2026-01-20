import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../search/loading_screen.dart';

class AvailabilityController extends GetxController {
  // ✅ Default duration = 1h (60 minutes)
  final durationMin = 60.0.obs;

  final selectedDayIndex = 0.obs;
  final selectedStartTime = RxnString();

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

  // ✅ Fixed label (Weekly/Biweekly removed)
  String get repeatLabel => "Just once";

  String get monthLabel => "December";

  bool get isButtonEnabled => selectedStartTime.value != null;

  void selectTime(String t) => selectedStartTime.value = t;

  void selectMiniDay(int i) => selectedDayIndex.value = i;

  IconData get leadingIcon => Icons.gps_fixed_rounded; // ✅ fixed icon
}

class AvailabilityScheduleScreen extends StatelessWidget {
  const AvailabilityScheduleScreen({super.key});

  static const Color _green = Color(0xFF2FA86A);
  static const Color _line = Color(0xFFEDEDED);

  @override
  Widget build(BuildContext context) {
    final c = Get.put(AvailabilityController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ✅ top bar (Just once fixed + close)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              child: Row(
                children: [
                  Expanded(child: _FixedRepeatPill(c: c)),
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
                    // ✅ Duration label
                    Obx(() {
                      return RichText(
                        text: TextSpan(
                          style: GoogleFonts.urbanist(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            height: 1.1,
                            letterSpacing: 0,
                            color: const Color(0xFF000000),
                          ),
                          children: [
                            const TextSpan(text: "Duration "),
                            TextSpan(
                              text: c.durationLabel,
                              style: GoogleFonts.urbanist(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                height: 1.1,
                                letterSpacing: 0,
                                color: _green,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    const SizedBox(height: 10),

                    // ✅ Slider with bubble thumb at start (NOT clipped)
                    Obx(() {
                      return SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: _green,
                          inactiveTrackColor: _line,
                          trackHeight: 10,

                          // ✅ bubble point thumb
                          thumbShape: const _BubbleThumbShape(radius: 9),
                          overlayShape: SliderComponentShape.noOverlay,
                          tickMarkShape: SliderTickMarkShape.noTickMark,

                          // ✅ keep full-width look but safe for thumb at edges
                          trackShape: const _EdgeSafeFullWidthTrackShape(),
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

                    // ✅ Month section (always shown because Just once fixed)
                    _MonthSection(c: c),

                    // ✅ Start time section
                    const SizedBox(height: 6),
                    Text(
                      "Start time",
                      style: GoogleFonts.urbanist(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        height: 1.1,
                        letterSpacing: 0,
                        color: const Color(0xFF000000),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _TimeGrid(c: c),

                    const SizedBox(height: 24),

                    // ✅ Button
                    Obx(() {
                      final enabled = c.isButtonEnabled;
                      return SizedBox(
                        height: 46,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: enabled
                              ? () => Get.to(
                                  () => const SearchTimeLoadingScreen(),
                                )
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
                          child: Text(
                            "Search Professionals",
                            style: GoogleFonts.urbanist(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              height: 1.1,
                              letterSpacing: 0,
                              color: enabled
                                  ? Colors.white
                                  : const Color(0xFF3D3E40),
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

/* ====================== FIXED TOP PILL (NO DROPDOWN) ====================== */

class _FixedRepeatPill extends StatelessWidget {
  const _FixedRepeatPill({required this.c});

  final AvailabilityController c;

  static const Color _line = Color(0xFFEDEDED);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _line),
      ),
      child: Row(
        children: [
          Icon(c.leadingIcon, size: 18, color: const Color(0xFF1F1F1F)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              c.repeatLabel, // ✅ always "Just once"
              style: GoogleFonts.urbanist(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                height: 1.2,
                letterSpacing: 0,
                color: const Color(0xFF181919),
              ),
            ),
          ),
          // ✅ keep arrow look if you want same UI; it's not clickable now
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Color(0xFF1F1F1F),
          ),
        ],
      ),
    );
  }
}

/* ====================== SLIDER SHAPES ====================== */

class _EdgeSafeFullWidthTrackShape extends RoundedRectSliderTrackShape {
  const _EdgeSafeFullWidthTrackShape();

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight ?? 2;

    // ✅ get thumb radius so the bubble is never clipped at left/right
    final thumbSize =
        sliderTheme.thumbShape?.getPreferredSize(isEnabled, isDiscrete) ??
        const Size(18, 18);
    final thumbRadius = thumbSize.width / 2;

    final trackLeft = offset.dx + thumbRadius;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final trackWidth = parentBox.size.width - (thumbRadius * 2);

    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

class _BubbleThumbShape extends SliderComponentShape {
  final double radius;
  const _BubbleThumbShape({this.radius = 9});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      Size.fromRadius(radius);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;

    final active = sliderTheme.activeTrackColor ?? const Color(0xFF2FA86A);

    // shadow
    canvas.drawShadow(
      Path()..addOval(Rect.fromCircle(center: center, radius: radius)),
      Colors.black.withOpacity(0.15),
      3,
      true,
    );

    // white fill
    final fill = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // green border
    final stroke = Paint()
      ..color = active
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(center, radius, fill);
    canvas.drawCircle(center, radius, stroke);
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
  static const Color _line = Color(0xFFEDEDED);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              c.monthLabel,
              style: GoogleFonts.urbanist(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                height: 1.1,
                letterSpacing: 0,
                color: const Color(0xFF000000),
              ),
            ),
            const Spacer(),
            InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 38,
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAEAEA),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    "Show month",
                    style: GoogleFonts.urbanist(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.1,
                      letterSpacing: 0,
                      color: const Color(0xFF181919),
                    ),
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
                          style: GoogleFonts.urbanist(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            height: 1.1,
                            letterSpacing: 0,
                            color: isSelected
                                ? _green
                                : const Color(0xFF6E6E6E),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          day,
                          style: GoogleFonts.urbanist(
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
                  style: GoogleFonts.urbanist(
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
