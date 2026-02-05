import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../listing/view/create_listing_screen.dart';

/// ---------------------------------------------------------------------------
/// CalendarHomeShell
/// ✅ If listing is EMPTY => show "You're not visible yet" screen (3rd screenshot)
/// ✅ Else => show Calendar month view + "Update Calendar" button (2nd screenshot)
/// ✅ Tap "Update Calendar" => bottom sheet (toastr) like your screenshot
/// ✅ Tap "Update" on sheet => navigate to UpdateEventScreen (different screen)
/// ---------------------------------------------------------------------------
class CalendarHomeShell extends StatefulWidget {
  const CalendarHomeShell({super.key, this.isListingEmpty = true});

  /// Pass your real value from API/state
  final bool isListingEmpty;

  @override
  State<CalendarHomeShell> createState() => _CalendarHomeShellState();
}

class _CalendarHomeShellState extends State<CalendarHomeShell> {
  // Palette (match screenshots)
  static const Color _green = Color(0xFF3FA96B);
  static const Color _line = Color(0xFFEDEDED);

  int _index = 0;

  // Calendar demo state
  DateTime _month = DateTime(2025, 12, 1);
  int _selectedDay = 13;

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      widget.isListingEmpty
          ? _CalendarEmptyListing(onCompleteListing: _onCompleteListing)
          : _CalendarMonthView(
              month: _month,
              selectedDay: _selectedDay,
              onPrevMonth: () => setState(() {
                _month = DateTime(_month.year, _month.month - 1, 1);
                _selectedDay = 13;
              }),
              onNextMonth: () => setState(() {
                _month = DateTime(_month.year, _month.month + 1, 1);
                _selectedDay = 13;
              }),
              onSelectDay: (d) => setState(() => _selectedDay = d),
              onUpdateCalendar: _openUpdateScheduleSheet,
              onSync: () {},
            ),
      const _PlaceholderTab(title: "Requests"),
      const _PlaceholderTab(title: "Inbox"),
      const _PlaceholderTab(title: "Listings"),
      const _PlaceholderTab(title: "Profile"),
    ];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(child: pages[_index]),
        bottomNavigationBar: Container(
          height: 72,
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: _line, width: 1)),
          ),
          child: Row(
            children: [
              _NavItem(
                icon: Icons.calendar_month_outlined,
                label: "Calendar",
                selected: _index == 0,
                selectedColor: _green,
                onTap: () => setState(() => _index = 0),
              ),
              _NavItem(
                icon: Icons.receipt_long_outlined,
                label: "Requests",
                selected: _index == 1,
                onTap: () => setState(() => _index = 1),
              ),
              _NavItem(
                icon: Icons.chat_bubble_outline_rounded,
                label: "Inbox",
                selected: _index == 2,
                onTap: () => setState(() => _index = 2),
              ),
              _NavItem(
                icon: Icons.format_list_bulleted_rounded,
                label: "Listings",
                selected: _index == 3,
                onTap: () => setState(() => _index = 3),
              ),
              _NavItem(
                icon: Icons.person_outline_rounded,
                label: "Profile",
                selected: _index == 4,
                onTap: () => setState(() => _index = 4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Replace this with your route:
  void _onCompleteListing() {
    Get.to(() => const CreateListingScreen());
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(content: Text("Complete listing tapped")),
    // );
  }

  void _openUpdateScheduleSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      barrierColor: Colors.black.withAlpha(89),
      builder: (_) {
        return _UpdateScheduleSheet(
          onClose: () => Get.back(),
          onCancel: () => Get.back(),
          onUpdate: () {
            Get.back();
            Get.to(() => const UpdateEventScreen());
          },
        );
      },
    );
  }
}

/// ============================
/// EMPTY LISTING (3rd screenshot)
/// ============================
class _CalendarEmptyListing extends StatelessWidget {
  const _CalendarEmptyListing({required this.onCompleteListing});

  final VoidCallback onCompleteListing;

  static const Color _green = Color(0xFF3FA96B);
  static const Color _cardBg = Color(0xFFE4E4E4);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 0),
      child: Column(
        children: [
          const SizedBox(height: 34),
          Text(
            "Calendar",
            textAlign: TextAlign.center,
            style: GoogleFonts.urbanist(
              fontSize: 24,
              fontWeight: FontWeight.w500, // Medium
              height: 1.2, // 120%
              letterSpacing: 0,
              color: const Color(0xFF000000),
            ),
          ),

          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Your services will appear here",
              style: GoogleFonts.urbanist(
                fontSize: 16,
                fontWeight: FontWeight.w400, // Regular
                height: 1.1, // 110%
                letterSpacing: 0,
                color: const Color(0xFF000000),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // grey card + button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            decoration: BoxDecoration(
              color: _cardBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Icon(
                        Icons
                            .warning_amber_outlined, // outlined = closer to 2px stroke look
                        size: 21,
                        color: Color(0xFFFFC34D),
                      ),
                    ),

                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "You're not visible yet",
                            style: GoogleFonts.urbanist(
                              fontSize: 18,
                              fontWeight: FontWeight.w700, // Bold
                              height: 1.2, // 120%
                              letterSpacing: 0,
                              color: const Color(0xFF000000),
                            ),
                          ),

                          const SizedBox(height: 4),
                          Text(
                            "Remember that you must complete\nyour listing in order to be booked",
                            style: GoogleFonts.urbanist(
                              fontSize: 16,
                              fontWeight: FontWeight.w400, // Regular
                              height: 1.1, // 110%
                              letterSpacing: 0,
                              color: const Color(0xFF000000),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 46,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onCompleteListing,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _green,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Complete listing",
                      style: GoogleFonts.urbanist(
                        fontSize: 16,
                        fontWeight: FontWeight.w500, // Medium
                        height: 1.1, // 110%
                        letterSpacing: 0,
                        color: const Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// =======================================
/// CALENDAR VIEW (2nd screenshot - fixed)
/// =======================================
class _CalendarMonthView extends StatelessWidget {
  const _CalendarMonthView({
    required this.month,
    required this.selectedDay,
    required this.onPrevMonth,
    required this.onNextMonth,
    required this.onSelectDay,
    required this.onUpdateCalendar,
    required this.onSync,
  });

  final DateTime month;
  final int selectedDay;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;
  final ValueChanged<int> onSelectDay;
  final VoidCallback onUpdateCalendar;
  final VoidCallback onSync;

  static const Color _green = Color(0xFF3FA96B);
  static const Color _muted = Color(0xFF6B6B6B);

  @override
  Widget build(BuildContext context) {
    final title = "${_monthName(month.month)} ${month.year}";
    final first = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;

    // Monday=1..Sunday=7  -> convert to 0..6 for grid offset (Mon start)
    final startOffset = (first.weekday - 1).clamp(0, 6);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // top row: Calendar + Sync (right)
          Row(
            children: [
              const Text(
                "Calendar",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1E1E1E),
                ),
              ),
              const Spacer(),
              _SyncButton(onTap: onSync),
            ],
          ),

          const SizedBox(height: 18),

          // month header with arrows
          Row(
            children: [
              InkWell(
                onTap: onPrevMonth,
                borderRadius: BorderRadius.circular(10),
                child: const Padding(
                  padding: EdgeInsets.all(6),
                  child: Icon(
                    Icons.chevron_left_rounded,
                    size: 24,
                    color: _muted,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E1E1E),
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: onNextMonth,
                borderRadius: BorderRadius.circular(10),
                child: const Padding(
                  padding: EdgeInsets.all(6),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    size: 24,
                    color: _muted,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // week labels
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _Dow("M"),
              _Dow("T"),
              _Dow("W"),
              _Dow("T"),
              _Dow("F"),
              _Dow("S"),
              _Dow("S", isSunday: true),
            ],
          ),

          const SizedBox(height: 10),

          // calendar grid
          _CalendarGrid(
            daysInMonth: daysInMonth,
            startOffset: startOffset,
            selectedDay: selectedDay,
            onSelectDay: onSelectDay,
          ),

          const SizedBox(height: 10),

          // small chevron up + availability pill
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 36,
              height: 22,
              alignment: Alignment.center,
              child: const Icon(
                Icons.keyboard_arrow_up_rounded,
                size: 22,
                color: Color(0xFF9B9B9B),
              ),
            ),
          ),
          Container(
            height: 32,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFEDEDED), width: 1),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "13:45 – 20:00   Available",
                style: TextStyle(
                  color: Color(0xFF8B8B8B),
                  fontSize: 11.8,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          const Spacer(),

          // Update Calendar button (centered like screenshot)
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 170,
              height: 44,
              child: ElevatedButton(
                onPressed: onUpdateCalendar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _green,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Update Calendar",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 18),
        ],
      ),
    );
  }

  static String _monthName(int m) {
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
    return names[m - 1];
  }
}

class _Dow extends StatelessWidget {
  const _Dow(this.text, {this.isSunday = false});
  final String text;
  final bool isSunday;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 34,
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: isSunday ? Colors.red : const Color(0xFF6B6B6B),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid({
    required this.daysInMonth,
    required this.startOffset,
    required this.selectedDay,
    required this.onSelectDay,
  });

  final int daysInMonth;
  final int startOffset;
  final int selectedDay;
  final ValueChanged<int> onSelectDay;

  static const Color _green = Color(0xFF3FA96B);

  @override
  Widget build(BuildContext context) {
    final totalCells = startOffset + daysInMonth;
    final rows = ((totalCells) / 7).ceil();

    int day = 1;

    return Column(
      children: List.generate(rows, (r) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (c) {
              final index = r * 7 + c;

              // empty before month start
              if (index < startOffset) {
                return const SizedBox(width: 34, height: 34);
              }
              // empty after month end
              if (day > daysInMonth) {
                return const SizedBox(width: 34, height: 34);
              }

              final current = day;
              day++;

              final isSunday = c == 6;
              final isSelected = current == selectedDay;

              return InkWell(
                onTap: () => onSelectDay(current),
                borderRadius: BorderRadius.circular(999),
                child: SizedBox(
                  width: 34,
                  height: 34,
                  child: Center(
                    child: isSelected
                        ? Container(
                            width: 28,
                            height: 28,
                            decoration: const BoxDecoration(
                              color: _green,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "$current",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          )
                        : Text(
                            "$current",
                            style: TextStyle(
                              color: isSunday
                                  ? Colors.red
                                  : const Color(0xFF8B8B8B),
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }
}

class _SyncButton extends StatelessWidget {
  const _SyncButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Color(0xFF3FA96B), width: 1),
        foregroundColor: const Color(0xFF3FA96B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        visualDensity: VisualDensity.compact,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          _GoogleG(),
          SizedBox(width: 6),
          Text(
            "Sync",
            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _GoogleG extends StatelessWidget {
  const _GoogleG();

  @override
  Widget build(BuildContext context) {
    // simple "G" circle (no extra package)
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE6E6E6)),
      ),
      alignment: Alignment.center,
      child: const Text(
        "G",
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: Color(0xFF4285F4),
        ),
      ),
    );
  }
}

/// =======================================
/// BOTTOM SHEET (2nd toastr screenshot)
/// =======================================
class _UpdateScheduleSheet extends StatelessWidget {
  const _UpdateScheduleSheet({
    required this.onClose,
    required this.onCancel,
    required this.onUpdate,
  });

  final VoidCallback onClose;
  final VoidCallback onCancel;
  final VoidCallback onUpdate;

  static const Color _green = Color(0xFF3FA96B);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // drag handle + close
            Row(
              children: [
                const Spacer(),
                Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: onClose,
                  borderRadius: BorderRadius.circular(999),
                  child: const Padding(
                    padding: EdgeInsets.all(6),
                    child: Icon(
                      Icons.close_rounded,
                      size: 20,
                      color: Color(0xFF4A4A4A),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: _green.withAlpha(31),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.event_busy_rounded,
                color: _green,
                size: 28,
              ),
            ),

            const SizedBox(height: 14),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Update your schedule",
                style: TextStyle(
                  color: _green,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
              ),
            ),
            const SizedBox(height: 8),

            const Text(
              "It’s been a while since you created an event, keeping\n"
              "your schedule up to date will help you avoid declining\n"
              "requests. Otherwise, you may lose visibility and miss out\n"
              "on new clients.",
              style: TextStyle(
                color: Color(0xFF6B6B6B),
                fontSize: 12.4,
                fontWeight: FontWeight.w500,
                height: 1.35,
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: OutlinedButton(
                      onPressed: onCancel,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: _green, width: 1),
                        foregroundColor: _green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: ElevatedButton(
                      onPressed: onUpdate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _green,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Update",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// =======================================
/// UPDATE EVENT SCREEN (3rd screenshot)
/// =======================================
class UpdateEventScreen extends StatefulWidget {
  const UpdateEventScreen({super.key});

  @override
  State<UpdateEventScreen> createState() => _UpdateEventScreenState();
}

class _UpdateEventScreenState extends State<UpdateEventScreen> {
  static const Color _green = Color(0xFF3FA96B);
  static const Color _muted = Color(0xFF6B6B6B);
  static const Color _fieldBg = Color(0xFFEDEDED);

  int _tab = 0; // 0 One day, 1 Several days, 2 Weekly
  bool _allDay = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // top row
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Get.back(),
                    borderRadius: BorderRadius.circular(999),
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: Color(0xFF1F1F1F),
                      ),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: _muted,
                      textStyle: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: const Text("my schedule"),
                  ),
                ],
              ),
            ),

            // title
            const Padding(
              padding: EdgeInsets.fromLTRB(18, 0, 18, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "When will you be unavailable?",
                  style: TextStyle(
                    color: _green,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                  ),
                ),
              ),
            ),

            // tabs
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 10),
              child: Row(
                children: [
                  _TopTab(
                    text: "One day",
                    selected: _tab == 0,
                    onTap: () => setState(() => _tab = 0),
                  ),
                  const SizedBox(width: 18),
                  _TopTab(
                    text: "Several days",
                    selected: _tab == 1,
                    onTap: () => setState(() => _tab = 1),
                  ),
                  const SizedBox(width: 18),
                  _TopTab(
                    text: "Weekly",
                    selected: _tab == 2,
                    onTap: () => setState(() => _tab = 2),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 6, 18, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Title (optional)", style: _LabelStyle()),
                    const SizedBox(height: 6),
                    _GreyField(text: "Lack of availability", bg: _fieldBg),

                    const SizedBox(height: 12),

                    Text("Date:", style: _LabelStyle()),
                    const SizedBox(height: 6),
                    _GreyField(text: "Sat, 11 Oct 2025", bg: _fieldBg),

                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Expanded(
                          child: Text("Book all day", style: _LabelStyle()),
                        ),
                        Switch(
                          value: _allDay,
                          activeThumbColor: _green,
                          onChanged: (v) => setState(() => _allDay = v),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Text("Hours you wish to unavailable", style: _LabelStyle()),
                    const SizedBox(height: 6),
                    _GreyField(text: "From 12:00  to  15:00", bg: _fieldBg),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 14),
              child: SizedBox(
                height: 52,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _green,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Update Event",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopTab extends StatelessWidget {
  const _TopTab({
    required this.text,
    required this.selected,
    required this.onTap,
  });
  final String text;
  final bool selected;
  final VoidCallback onTap;

  static const Color _muted = Color(0xFF6B6B6B);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          children: [
            Text(
              text,
              style: TextStyle(
                color: selected ? const Color(0xFF1F1F1F) : _muted,
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: 2.2,
              width: 46,
              decoration: BoxDecoration(
                color: selected ? const Color(0xFF3FA96B) : Colors.transparent,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GreyField extends StatelessWidget {
  const _GreyField({required this.text, required this.bg});
  final String text;
  final Color bg;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      width: double.infinity,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF1F1F1F),
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _LabelStyle extends TextStyle {
  const _LabelStyle()
    : super(
        // color: Color(0xFF1F1F1F),
        fontSize: 12.5,
        fontWeight: FontWeight.w700,
      );
}

/// ====================== Bottom Nav item ======================
class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.selectedColor,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? selectedColor;

  static const Color _muted = Color(0xFF9B9B9B);

  @override
  Widget build(BuildContext context) {
    final c = selected ? (selectedColor ?? const Color(0xFF3FA96B)) : _muted;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            children: [
              Icon(icon, color: c, size: 22),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  color: c,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  const _PlaceholderTab({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
      ),
    );
  }
}
