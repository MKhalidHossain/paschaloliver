import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../profile/profile_screen.dart';
import '../../../professional/controller/professional_registration_controller.dart';

class WorkScheduleScreen extends StatefulWidget {
  const WorkScheduleScreen({super.key});

  @override
  State<WorkScheduleScreen> createState() => _WorkScheduleScreenState();
}

class _WorkScheduleScreenState extends State<WorkScheduleScreen> {
  Color get _brandGreen => const Color(0xFF27AE60);

  late List<DaySchedule> _days;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _days = [
      DaySchedule(label: 'Monday'),
      DaySchedule(label: 'Tuesday'),
      DaySchedule(label: 'Wednesday'),
      DaySchedule(label: 'Thursday'),
      DaySchedule(label: 'Friday'),
      DaySchedule(label: 'Saturday'),
      DaySchedule(label: 'Sunday'),
    ];
  }

  bool get _hasActiveDay => _days.any((d) => d.isActive && d.ranges.isNotEmpty);

  bool get _isFormValid => _days
      .where((d) => d.isActive)
      .every((d) => d.ranges.isNotEmpty && d.ranges.every((r) => r.isValid));

  int get _activeSlotsCount =>
      _days.fold(0, (sum, d) => sum + (d.isActive ? d.ranges.length : 0));

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              // TOP BAR + PROGRESS (ALIGNED)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  24,
                  12,
                  24,
                  4,
                ), // same as title/search
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 16,
                      width: double
                          .infinity, // fill inside the 24px padding => aligns perfectly
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(99),
                        child: LinearProgressIndicator(
                          value: 0.25,
                          minHeight: 16,
                          backgroundColor: const Color(0xFFE4E4E4),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _brandGreen,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => Get.back(),
                      child: const Padding(
                        padding: EdgeInsets.all(0),
                        child: Icon(Icons.arrow_back, size: 18),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),
              _buildTitle(),
              const SizedBox(height: 12),
              const Divider(height: 1),
              Expanded(
                child: ListView.separated(
                  itemCount: _days.length,
                  separatorBuilder: (_, __) =>
                      Divider(height: 1, color: Colors.grey.shade200),
                  itemBuilder: (context, index) {
                    final day = _days[index];
                    return _buildDayRow(day, index);
                  },
                ),
              ),
              const Divider(height: 1),
              _buildConfirmButton(),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- TITLE ----------------

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Work Schedule',
            style: GoogleFonts.urbanist(
              fontSize: 24,
              fontWeight: FontWeight.w600, // SemiBold
              height: 1.1,
              letterSpacing: 0,
              color: const Color(0xFF3FA96B),
            ),
          ),

          const SizedBox(height: 6),
          Text(
            'When are you available to offer your services?',
            style: GoogleFonts.urbanist(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.1,
              letterSpacing: 0,
              color: const Color(0xFF000000),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- DAY ROW ----------------

  Widget _buildDayRow(DaySchedule day, int index) {
    final isActive = day.isActive;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // top line
          Row(
            children: [
              Expanded(
                child: Text(
                  day.label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // ✅ toggle (figma size: 60x30)
              AppToggle(
                value: isActive,
                activeColor: _brandGreen,
                inactiveColor: const Color(0xFF727272),
                padding: 2,
                width: 60,
                height: 30,
                onChanged: (value) {
                  _hasChanges = true;
                  setState(() {
                    day.isActive = value;
                    if (!value) {
                      day.ranges.clear();
                    } else {
                      _openScheduleBottomSheet(index);
                    }
                  });
                },
              ),

              const SizedBox(width: 8),

              Text(
                isActive ? 'Available' : 'Not Activate',
                style: TextStyle(
                  fontSize: 12,
                  color: isActive ? _brandGreen : Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          // ✅ red portion fix (From – Until + X + Add hours)
          if (isActive) ...[
            const SizedBox(height: 10),

            // 🔥 Adjust this left padding to match your Figma (60~90)
            Padding(
              padding: const EdgeInsets.only(left: 70),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (day.ranges.isEmpty)
                    _ScheduleLine(
                      fromText: "From",
                      untilText: "Until",
                      isPlaceholder: true,
                      onTap: () {
                        _hasChanges = true;
                        _openScheduleBottomSheet(index);
                      },
                      onClear: () {
                        _hasChanges = true;
                        setState(() {
                          day.isActive = false;
                          day.ranges.clear();
                        });
                      },
                    )
                  else
                    ...List.generate(day.ranges.length, (i) {
                      final r = day.ranges[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _ScheduleLine(
                          fromText: r.formatStart(),
                          untilText: r.formatEnd(),
                          onTap: () {
                            _hasChanges = true;
                            _openScheduleBottomSheet(index);
                          },
                          onClear: () {
                            _hasChanges = true;
                            setState(() {
                              day.ranges.removeAt(i);
                              if (day.ranges.isEmpty) {
                                day.isActive = false;
                              }
                            });
                          },
                        ),
                      );
                    }),

                  const SizedBox(height: 6),

                  InkWell(
                    onTap: () {
                      _hasChanges = true;
                      _openScheduleBottomSheet(index);
                    },
                    child: Text(
                      'Add hours',
                      style: TextStyle(
                        fontSize: 12,
                        color: _brandGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ---------------- BOTTOM SHEET ----------------

  Future<void> _openScheduleBottomSheet(int dayIndex) async {
    final day = _days[dayIndex];

    TimeOfDay start = const TimeOfDay(hour: 8, minute: 0);
    TimeOfDay end = const TimeOfDay(hour: 18, minute: 0);

    if (day.ranges.isNotEmpty) {
      start = day.ranges.last.start;
      end = day.ranges.last.end;
    }

    final result = await showModalBottomSheet<TimeRange>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return _ScheduleBottomSheetContent(
          title: 'Schedule ${day.label}',
          initialStart: start,
          initialEnd: end,
          brandGreen: _brandGreen,
        );
      },
    );

    if (result != null && result.isValid) {
      _hasChanges = true;
      setState(() {
        day.isActive = true;
        day.ranges.add(result);
      });
    } else {
      if (day.ranges.isEmpty) {
        setState(() => day.isActive = false);
      }
    }
  }

  // ---------------- CONFIRM ----------------

  Widget _buildConfirmButton() {
    final enabled = _isFormValid && _hasActiveDay;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 20),
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: enabled ? _brandGreen : Colors.grey.shade300,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: enabled ? _handleConfirmPressed : null,
          child: const Text(
            'Confirm',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void _handleConfirmPressed() {
    if (_activeSlotsCount <= 2) {
      _showScheduleCheckSheet();
      return;
    }

    _hasChanges = false;
    _persistSchedule();
    Get.back(result: _days);
  }

  void _persistSchedule() {
    final regC = Get.find<ProfessionalRegistrationController>();
    final payload = _days
        .map(
          (d) => {
            'day': d.label,
            'isAvailable': d.isActive,
            'slots': d.ranges
                .map(
                  (r) => {
                    'startTime': r.formatStart(),
                    'endTime': r.formatEnd(),
                  },
                )
                .toList(),
          },
        )
        .toList();
    regC.setWorkSchedule(payload);
  }

  Future<void> _showScheduleCheckSheet() async {
    await showModalBottomSheet(
      context: context,
      useSafeArea: true, // ✅ important
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        final safeBottom = MediaQuery.of(context).padding.bottom;

        return Padding(
          padding: EdgeInsets.fromLTRB(24, 18, 24, 18 + safeBottom), // ✅ FIX
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Is your schedule correct?',
                      style: GoogleFonts.urbanist(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        height: 1.1,
                        letterSpacing: 0,
                        color: const Color(0xFF3FA96B),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, size: 18),
                    splashRadius: 20,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'You have selected very few hours as Available. '
                'Remember, the more hours available, the more options '
                'the client will have when booking your service.',
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.1,
                  letterSpacing: 0,
                  color: const Color(0xFF000000),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: _brandGreen),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: const Size(0, 48),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Edit Schedule',
                        style: TextStyle(
                          color: _brandGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _brandGreen,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: const Size(0, 48),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        _hasChanges = false;
                        _persistSchedule();
                        Get.to(() => const ProfilePictureScreen());
                      },
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  // ---------------- LEAVE WITHOUT SAVING ----------------

  Future<bool> _onWillPop() async {
    if (!_hasChanges) return true;

    final result = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        final safeBottom = MediaQuery.of(context).padding.bottom;

        return Padding(
          padding: EdgeInsets.fromLTRB(24, 18, 24, 18 + safeBottom),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Do you want to leave without saving?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context, false),
                    icon: const Icon(Icons.close, size: 18),
                    splashRadius: 20,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'If you leave without saving, you will lose all the '
                'information completed in this section.',
                style: TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: _brandGreen),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => Navigator.pop<bool>(context, true),
                      child: Text(
                        'Leave anyway',
                        style: TextStyle(
                          color: _brandGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _brandGreen,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => Navigator.pop<bool>(context, false),
                      child: const Text(
                        'Stay',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );

    return result ?? false;
  }
}

// ============================================================================
// MODELS
// ============================================================================

class TimeRange {
  TimeOfDay start;
  TimeOfDay end;

  TimeRange({required this.start, required this.end});

  bool get isValid =>
      start.hour < end.hour ||
      (start.hour == end.hour && start.minute < end.minute);

  String formatStart() => _formatTimeOfDay(start);
  String formatEnd() => _formatTimeOfDay(end);

  static String _formatTimeOfDay(TimeOfDay t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

class DaySchedule {
  final String label;
  bool isActive;
  final List<TimeRange> ranges;

  DaySchedule({
    required this.label,
    this.isActive = false,
    List<TimeRange>? ranges,
  }) : ranges = ranges ?? [];
}

// ============================================================================
// BOTTOM SHEET CONTENT W/ PICKERS
// ============================================================================

class _ScheduleBottomSheetContent extends StatefulWidget {
  final String title;
  final TimeOfDay initialStart;
  final TimeOfDay initialEnd;
  final Color brandGreen;

  const _ScheduleBottomSheetContent({
    required this.title,
    required this.initialStart,
    required this.initialEnd,
    required this.brandGreen,
  });

  @override
  State<_ScheduleBottomSheetContent> createState() =>
      _ScheduleBottomSheetContentState();
}

class _ScheduleBottomSheetContentState
    extends State<_ScheduleBottomSheetContent> {
  late int _startHourIndex;
  late int _startMinuteIndex;
  late int _endHourIndex;
  late int _endMinuteIndex;

  final List<int> _hours = List.generate(24, (i) => i);
  final List<int> _minutes = const [0, 15, 30, 45];

  @override
  void initState() {
    super.initState();
    _startHourIndex = _hours
        .indexOf(widget.initialStart.hour)
        .clamp(0, _hours.length - 1);
    _endHourIndex = _hours
        .indexOf(widget.initialEnd.hour)
        .clamp(0, _hours.length - 1);
    _startMinuteIndex = _minutes
        .indexOf(widget.initialStart.minute)
        .clamp(0, _minutes.length - 1);
    _endMinuteIndex = _minutes
        .indexOf(widget.initialEnd.minute)
        .clamp(0, _minutes.length - 1);
  }

  TimeOfDay get _startTime => TimeOfDay(
    hour: _hours[_startHourIndex],
    minute: _minutes[_startMinuteIndex],
  );

  TimeOfDay get _endTime =>
      TimeOfDay(hour: _hours[_endHourIndex], minute: _minutes[_endMinuteIndex]);

  @override
  Widget build(BuildContext context) {
    final keyboard = MediaQuery.of(context).viewInsets.bottom;
    final safeBottom = MediaQuery.of(context).viewPadding.bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 18,
        bottom: 18 + (keyboard > 0 ? keyboard : safeBottom), // ✅ FIX
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, size: 18),
                splashRadius: 20,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('From:', style: TextStyle(fontSize: 13)),
              Text('Until:', style: TextStyle(fontSize: 13)),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 170,
            child: Row(
              children: [
                Expanded(child: _buildTimePicker(isStart: true)),
                const SizedBox(width: 16),
                Expanded(child: _buildTimePicker(isStart: false)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.brandGreen,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                final range = TimeRange(start: _startTime, end: _endTime);
                Navigator.pop(context, range);
              },
              child: const Text(
                'Save',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimePicker({required bool isStart}) {
    final hourController = FixedExtentScrollController(
      initialItem: isStart ? _startHourIndex : _endHourIndex,
    );
    final minuteController = FixedExtentScrollController(
      initialItem: isStart ? _startMinuteIndex : _endMinuteIndex,
    );

    return Row(
      children: [
        Expanded(
          child: CupertinoPicker(
            scrollController: hourController,
            itemExtent: 32,
            onSelectedItemChanged: (idx) {
              setState(() {
                if (isStart) {
                  _startHourIndex = idx;
                } else {
                  _endHourIndex = idx;
                }
              });
            },
            children: _hours
                .map((h) => Center(child: Text(h.toString().padLeft(2, '0'))))
                .toList(),
          ),
        ),
        const Text(':', style: TextStyle(fontSize: 18)),
        Expanded(
          child: CupertinoPicker(
            scrollController: minuteController,
            itemExtent: 32,
            onSelectedItemChanged: (idx) {
              setState(() {
                if (isStart) {
                  _startMinuteIndex = idx;
                } else {
                  _endMinuteIndex = idx;
                }
              });
            },
            children: _minutes
                .map((m) => Center(child: Text(m.toString().padLeft(2, '0'))))
                .toList(),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// FIGMA-LIKE RED PORTION WIDGETS
// ============================================================================

class _ScheduleLine extends StatelessWidget {
  const _ScheduleLine({
    required this.fromText,
    required this.untilText,
    required this.onTap,
    required this.onClear,
    this.isPlaceholder = false,
  });

  final String fromText;
  final String untilText;
  final VoidCallback onTap;
  final VoidCallback onClear;
  final bool isPlaceholder;

  @override
  Widget build(BuildContext context) {
    final textColor = isPlaceholder ? Colors.grey.shade600 : Colors.black87;
    final lineColor = Colors.grey.shade300;

    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: _UnderlinedCell(
              text: fromText,
              textColor: textColor,
              lineColor: lineColor,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            "–",
            style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _UnderlinedCell(
              text: untilText,
              textColor: textColor,
              lineColor: lineColor,
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: onClear,
            borderRadius: BorderRadius.circular(999),
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: lineColor),
              ),
              child: Icon(Icons.close, size: 14, color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }
}

class _UnderlinedCell extends StatelessWidget {
  const _UnderlinedCell({
    required this.text,
    required this.textColor,
    required this.lineColor,
  });

  final String text;
  final Color textColor;
  final Color lineColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
        const SizedBox(height: 6),
        Container(height: 1, color: lineColor),
      ],
    );
  }
}

// ============================================================================
// FIGMA TOGGLE (60x30)
// ============================================================================

class AppToggle extends StatelessWidget {
  const AppToggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.width = 60,
    this.height = 30,
    this.padding = 2,
    this.activeColor = const Color(0xFF27AE60),
    this.inactiveColor = const Color(0xFF727272),
    this.thumbColor = Colors.white,
    this.duration = const Duration(milliseconds: 180),
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  final double width;
  final double height;
  final double padding;

  final Color activeColor;
  final Color inactiveColor;
  final Color thumbColor;

  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final thumbSize = height - (padding * 2);

    return SizedBox(
      width: width,
      height: height,
      child: GestureDetector(
        onTap: () => onChanged(!value),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: duration,
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: value ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(999),
          ),
          child: AnimatedAlign(
            duration: duration,
            curve: Curves.easeOut,
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: thumbSize,
              height: thumbSize,
              decoration: BoxDecoration(
                color: thumbColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(38),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
