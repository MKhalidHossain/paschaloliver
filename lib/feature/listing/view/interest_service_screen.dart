import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:paschaloliver/feature/listing/controller/listing_create_controller.dart';
import 'package:paschaloliver/feature/listing/view/portfolio_screen.dart';

class InformationOfInterestScreen extends StatefulWidget {
  const InformationOfInterestScreen({super.key});

  @override
  State<InformationOfInterestScreen> createState() =>
      _InformationOfInterestScreenState();
}

class _InformationOfInterestScreenState
    extends State<InformationOfInterestScreen> {
  // Screenshot palette
  static const Color _green = Color(0xFF2FA86A);
  static const Color _muted = Color(0xFF8B8B8B);
  static const Color _text = Color(0xFF2B2B2B);
  static const Color _track = Color(0xFFEAEAEA);

  static const Color _radioFill = Color(0xFFE6E6E6);
  static const Color _radioBorder = Color(0xFF9E9E9E);

  static const Color _boxFill = Color(0xFFE6E6E6);
  static const Color _boxBorder = Color(0xFF9E9E9E);

  final double _progress = 0.42; // adjust if your step changes

  // --------- Data (same as screenshot) ----------
  final List<String> _experience = const [
    "0-2 years of experience",
    "2-5 years of experience",
    "5-15 years of experience",
    "+15 years of experience",
  ];
  int? _experienceIndex;

  final List<String> _cleaningTypes = const [
    "General household cleaning (bedrooms,\nbathrooms and kitchen)",
    "Deep cleaning",
    "Post-renovation cleaning",
    "Window cleaning",
    "Blinds cleaning",
    "Oven cleaning",
    "Fridge cleaning",
    "Garage/storage cleaning",
    "Carpet cleaning",
    "Upholstery cleaning",
    "Sofa cleaning",
  ];
  late final List<bool> _cleaningSelected = List<bool>.filled(
    _cleaningTypes.length,
    false,
  );

  final List<String> _tasks = const [
    "Laundry",
    "Ironing",
    "Cooking",
    "Childcare",
  ];
  late final List<bool> _taskSelected = List<bool>.filled(_tasks.length, false);

  bool? _petsYes; // null / true / false
  bool? _workProYes; // null / true / false

  final List<String> _employmentStatus = const [
    "I work professionally in cleaning.",
    "I work professionally in another sector.",
    "I am a student",
  ];
  int? _employmentIndex;

  final List<String> _situation = const [
    "I am currently unemployed and looking for an\nextra income until I find a permanent job.",
    "I already have a permanent job, and I am looking\nfor an extra income in my free time.",
    "I already have my own clients and want\nhandynija to help me fill my free slots.",
    "Do not have my own clients and want handynija\nto help me fill my free Schedule.",
  ];
  int? _situationIndex;

  late final ListingCreateController _listingController;

  // ---------------------------------------------

  void _onContinue() {
    if (_experienceIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select your experience level')),
      );
      return;
    }
    if (_workProYes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select your industry experience')),
      );
      return;
    }
    if (_employmentIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select your employment status')),
      );
      return;
    }
    if (_situationIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select your current situation')),
      );
      return;
    }

    _listingController.setProfileDetails(
      experience: _experience[_experienceIndex!],
      hasIndustryExp: _workProYes!,
      employment: _employmentStatus[_employmentIndex!],
      situation: _situation[_situationIndex!],
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const GalleryScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 90),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _TopProgressBar(
                        value: _progress,
                        track: _track,
                        fill: _green,
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            borderRadius: BorderRadius.circular(10),
                            child: const Padding(
                              padding: EdgeInsets.all(6),
                              child: Icon(
                                Icons.arrow_back,
                                size: 22,
                                color: _green,
                              ),
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              foregroundColor: _muted,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              textStyle: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            child: const Text("Save and exit"),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      const Text(
                        "Information of interest",
                        style: TextStyle(
                          color: _green,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Tell us more about yourself",
                        style: TextStyle(
                          color: _text,
                          fontSize: 12.8,
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      const SizedBox(height: 14),

                      const Text(
                        "How much experience do you have as a\nService name?",
                        style: TextStyle(
                          color: _text,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Experience radios
                      ...List.generate(_experience.length, (i) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _RadioRow(
                            selected: _experienceIndex == i,
                            title: _experience[i],
                            onTap: () => setState(() => _experienceIndex = i),
                            fill: _radioFill,
                            border: _radioBorder,
                            active: _green,
                            textColor: _text,
                          ),
                        );
                      }),

                      // const SizedBox(height: 6),

                      // const Text(
                      //   "Indicate the types of cleaning that you can\nperform",
                      //   style: TextStyle(
                      //     color: _text,
                      //     fontSize: 16,
                      //     fontWeight: FontWeight.w600,
                      //     height: 1.25,
                      //   ),
                      // ),
                      const SizedBox(height: 10),

                      // Cleaning types checkboxes
                      // ...List.generate(_cleaningTypes.length, (i) {
                      //   return Padding(
                      //     padding: const EdgeInsets.only(bottom: 10),
                      //     child: _CheckRow(
                      //       value: _cleaningSelected[i],
                      //       title: _cleaningTypes[i],
                      //       onTap: () => setState(() => _cleaningSelected[i] = !_cleaningSelected[i]),
                      //       fill: _boxFill,
                      //       border: _boxBorder,
                      //       active: _green,
                      //       textColor: _text,
                      //     ),
                      //   );
                      // }),

                      // const SizedBox(height: 10),

                      // const Text(
                      //   "Indicate the tasks you can perform during\nthe service",
                      //   style: TextStyle(
                      //     color: _text,
                      //     fontSize: 16,
                      //     fontWeight: FontWeight.w600,
                      //     height: 1.25,
                      //   ),
                      // ),
                      // const SizedBox(height: 10),

                      // Tasks checkboxes
                      // ...List.generate(_tasks.length, (i) {
                      //   return Padding(
                      //     padding: const EdgeInsets.only(bottom: 12),
                      //     child: _CheckRow(
                      //       value: _taskSelected[i],
                      //       title: _tasks[i],
                      //       onTap: () => setState(() => _taskSelected[i] = !_taskSelected[i]),
                      //       fill: _boxFill,
                      //       border: _boxBorder,
                      //       active: _green,
                      //       textColor: _text,
                      //     ),
                      //   );
                      // }),
                      // const SizedBox(height: 6),

                      // const Text(
                      //   "Do you clean houses  where pets live?",
                      //   style: TextStyle(
                      //     color: _text,
                      //     fontSize: 16,
                      //     fontWeight: FontWeight.w600,
                      //     height: 1.25,
                      //   ),
                      // ),
                      // const SizedBox(height: 10),

                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: _RadioInline(
                      //         selected: _petsYes == true,
                      //         label: "Yes",
                      //         onTap: () => setState(() => _petsYes = true),
                      //         fill: _radioFill,
                      //         border: _radioBorder,
                      //         active: _green,
                      //         textColor: _text,
                      //       ),
                      //     ),
                      //     Expanded(
                      //       child: _RadioInline(
                      //         selected: _petsYes == false,
                      //         label: "No",
                      //         onTap: () => setState(() => _petsYes = false),
                      //         fill: _radioFill,
                      //         border: _radioBorder,
                      //         active: _green,
                      //         textColor: _text,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // const SizedBox(height: 14),
                      const Text(
                        "Do you currently work professionally in the\nservice industry?",
                        style: TextStyle(
                          color: _text,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Expanded(
                            child: _RadioInline(
                              selected: _workProYes == true,
                              label: "Yes",
                              onTap: () => setState(() => _workProYes = true),
                              fill: _radioFill,
                              border: _radioBorder,
                              active: _green,
                              textColor: _text,
                            ),
                          ),
                          Expanded(
                            child: _RadioInline(
                              selected: _workProYes == false,
                              label: "No",
                              onTap: () => setState(() => _workProYes = false),
                              fill: _radioFill,
                              border: _radioBorder,
                              active: _green,
                              textColor: _text,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      const Text(
                        "Indicate your current employment status (If\nyou are currently Unemployed select what\nyou are doing before)",
                        style: TextStyle(
                          color: _text,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 10),

                      ...List.generate(_employmentStatus.length, (i) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _RadioRow(
                            selected: _employmentIndex == i,
                            title: _employmentStatus[i],
                            onTap: () => setState(() => _employmentIndex = i),
                            fill: _radioFill,
                            border: _radioBorder,
                            active: _green,
                            textColor: _text,
                          ),
                        );
                      }),

                      const SizedBox(height: 10),

                      const Text(
                        "Select the best statement that best\ndescribes your situation.",
                        style: TextStyle(
                          color: _text,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 10),

                      ...List.generate(_situation.length, (i) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _RadioRow(
                            selected: _situationIndex == i,
                            title: _situation[i],
                            onTap: () => setState(() => _situationIndex = i),
                            fill: _radioFill,
                            border: _radioBorder,
                            active: _green,
                            textColor: _text,
                            dense: true,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),

              // Fixed bottom button
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
                  child: SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _onContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _green,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text(
                        "Continue",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _listingController = Get.find<ListingCreateController>();
  }
}

/* ------------------ small reusable widgets ------------------ */

class _TopProgressBar extends StatelessWidget {
  const _TopProgressBar({
    required this.value,
    required this.track,
    required this.fill,
  });

  final double value;
  final Color track;
  final Color fill;

  @override
  Widget build(BuildContext context) {
    final v = value.clamp(0.0, 1.0);
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 10,
        color: track,
        child: Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: v,
            child: Container(color: fill),
          ),
        ),
      ),
    );
  }
}

class _RadioRow extends StatelessWidget {
  const _RadioRow({
    required this.selected,
    required this.title,
    required this.onTap,
    required this.fill,
    required this.border,
    required this.active,
    required this.textColor,
    this.dense = false,
  });

  final bool selected;
  final String title;
  final VoidCallback onTap;
  final Color fill;
  final Color border;
  final Color active;
  final Color textColor;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: dense
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          _RadioCircle(
            selected: selected,
            fill: fill,
            border: border,
            active: active,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: dense ? 2 : 0),
              child: Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontSize: 13.8,
                  fontWeight: FontWeight.w400,
                  height: 1.25,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RadioInline extends StatelessWidget {
  const _RadioInline({
    required this.selected,
    required this.label,
    required this.onTap,
    required this.fill,
    required this.border,
    required this.active,
    required this.textColor,
  });

  final bool selected;
  final String label;
  final VoidCallback onTap;
  final Color fill;
  final Color border;
  final Color active;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _RadioCircle(
            selected: selected,
            fill: fill,
            border: border,
            active: active,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 13.8,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _RadioCircle extends StatelessWidget {
  const _RadioCircle({
    required this.selected,
    required this.fill,
    required this.border,
    required this.active,
  });

  final bool selected;
  final Color fill;
  final Color border;
  final Color active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: fill,
        border: Border.all(color: selected ? active : border, width: 1.2),
      ),
      child: selected
          ? Center(
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: active,
                ),
                child: const Icon(Icons.check, size: 11, color: Colors.white),
              ),
            )
          : null,
    );
  }
}

class _CheckRow extends StatelessWidget {
  const _CheckRow({
    required this.value,
    required this.title,
    required this.onTap,
    required this.fill,
    required this.border,
    required this.active,
    required this.textColor,
  });

  final bool value;
  final String title;
  final VoidCallback onTap;
  final Color fill;
  final Color border;
  final Color active;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _GreySquareCheck(
            value: value,
            onTap: onTap,
            fill: fill,
            border: border,
            active: active,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontSize: 13.6,
                  fontWeight: FontWeight.w400,
                  height: 1.25,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GreySquareCheck extends StatelessWidget {
  const _GreySquareCheck({
    required this.value,
    required this.onTap,
    required this.fill,
    required this.border,
    required this.active,
  });

  final bool value;
  final VoidCallback onTap;
  final Color fill;
  final Color border;
  final Color active;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(2),
      child: Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: fill, // always grey like screenshot
          borderRadius: BorderRadius.circular(2),
          border: Border.all(color: border, width: 1.2),
        ),
        child: value
            ? Icon(Icons.check_rounded, size: 16, color: active)
            : null,
      ),
    );
  }
}
