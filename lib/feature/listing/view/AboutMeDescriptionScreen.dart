import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutMeScreen extends StatefulWidget {
  const AboutMeScreen({super.key});

  @override
  State<AboutMeScreen> createState() => _AboutMeScreenState();
}

class _AboutMeScreenState extends State<AboutMeScreen> {
  // Screenshot palette
  static const Color _green = Color(0xFF2FA86A);
  static const Color _muted = Color(0xFF8B8B8B);
  static const Color _text = Color(0xFF2B2B2B);
  static const Color _track = Color(0xFFEAEAEA);
  static const Color _border = Color(0xFFE5E5E5);
  static const Color _bgSoft = Color(0xFFF6F6F6);
  static const Color _danger = Color(0xFFE53935);

  static const int _requiredLen = 50; // must be at least 50
  static const int _maxLen = 50; // screenshot shows 0/50

  final _ctrl = TextEditingController();
  final _focus = FocusNode();

  bool _showEmptyError = false;
  bool _saved = false;
  String _initialText = "";

  final double _progress = 0.75; // adjust based on flow

  @override
  void initState() {
    super.initState();
    _initialText = _ctrl.text;
    _ctrl.addListener(() {
      // keep UI updated for counter + error clearing
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  bool get _isDirty => _ctrl.text.trim() != _initialText.trim();
  int get _count => _ctrl.text.characters.length;

  Future<bool> _handleExit() async {
    // if nothing changed, allow pop
    if (!_isDirty || _saved) return true;

    final leave = await _showLeaveWithoutSavingSheet();
    return leave == true;
  }

  void _onBack() async {
    final canLeave = await _handleExit();
    if (canLeave && mounted) Navigator.pop(context);
  }

  void _onSaveAndExit() async {
    final canLeave = await _handleExit();
    if (canLeave && mounted) Navigator.pop(context);
  }

  void _onSave() async {
    final t = _ctrl.text.trim();

    // empty check
    if (t.isEmpty) {
      setState(() => _showEmptyError = true);
      _focus.requestFocus();
      return;
    } else {
      setState(() => _showEmptyError = false);
    }

    // requirement check: must reach 50 chars
    if (_count < _requiredLen) {
      await _showRequirementsSheet();
      return;
    }

    // ✅ success (saved)
    setState(() {
      _saved = true;
      _initialText = _ctrl.text;
    });

    // TODO: navigate next screen OR pop result
    // Navigator.push(context, MaterialPageRoute(builder: (_) => const NextScreen()));
    Navigator.pop(context, _ctrl.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: WillPopScope(
        onWillPop: _handleExit,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                  child: Column(
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
                            onTap: _onBack,
                            borderRadius: BorderRadius.circular(10),
                            child: const Padding(
                              padding: EdgeInsets.all(2),
                              child: Icon(
                                Icons.arrow_back,
                                size: 22,
                                color: _green,
                              ),
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: _onSaveAndExit,
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(
                                0xFF727272,
                              ), // ✅ #727272
                              padding: EdgeInsets
                                  .zero, // ✅ keeps it tight like Figma
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              minimumSize: Size.zero,
                              textStyle: GoogleFonts.urbanist(
                                fontSize: 16, // ✅ 16px
                                fontWeight: FontWeight.w500, // ✅ Medium
                                height: 1.1, // ✅ 110%
                                letterSpacing: 0, // ✅ 0%
                              ),
                            ),
                            child: const Text(
                              "Save and exit",
                              textAlign: TextAlign.center, // ✅ center
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "About me",
                          style: GoogleFonts.urbanist(
                            fontSize: 24, // ✅ 24px
                            fontWeight: FontWeight.w600, // ✅ SemiBold (600)
                            height: 1.1, // ✅ 110%
                            letterSpacing: 0, // ✅ 0%
                            color: const Color(0xFF3FA96B), // ✅ #3FA96B
                          ),
                        ),

                        const SizedBox(height: 8),
                        SizedBox(
                          width: 343, // ✅ Figma width (optional)
                          child: Text(
                            "Write a brief description about yourself and your services. "
                            "This will be the first thing client see on your profile, so be as "
                            "professional as possible.",
                            style: GoogleFonts.urbanist(
                              fontSize: 14, // ✅ 14px
                              fontWeight: FontWeight.w400, // ✅ Regular
                              height: 1.1, // ✅ 110%
                              letterSpacing: 0, // ✅ 0%
                              color: const Color(0xFF000000), // ✅ #000000
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Textarea box
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: _border, width: 1),
                          ),
                          child: Stack(
                            children: [
                              TextField(
                                focusNode: _focus,
                                controller: _ctrl,
                                maxLength: _maxLen, // 50
                                maxLines: 6,
                                keyboardType: TextInputType.multiline,
                                style: const TextStyle(
                                  color: _text,
                                  fontSize: 13.5,
                                  height: 1.35,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: const InputDecoration(
                                  counterText:
                                      "", // ✅ hide default counter (outside)
                                  hintText:
                                      "Write a description about you.......",
                                  hintStyle: TextStyle(
                                    color: Color(0xFFB3B3B3),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  // ✅ give extra bottom padding for the inside counter
                                  contentPadding: EdgeInsets.fromLTRB(
                                    14,
                                    12,
                                    14,
                                    34,
                                  ),
                                  border: InputBorder.none,
                                ),
                                onChanged: (_) {
                                  if (_showEmptyError &&
                                      _ctrl.text.trim().isNotEmpty) {
                                    setState(() => _showEmptyError = false);
                                  }
                                },
                              ),

                              // ✅ Counter inside box (bottom-right)
                              Positioned(
                                right: 12,
                                bottom: 10,
                                child: IgnorePointer(
                                  child:
                                      ValueListenableBuilder<TextEditingValue>(
                                        valueListenable: _ctrl,
                                        builder: (_, v, __) {
                                          return Text(
                                            "${v.text.length}/$_maxLen",
                                            style: const TextStyle(
                                              fontSize: 12.5,
                                              fontWeight: FontWeight.w500,
                                              height: 1.1,
                                              color: Color(0xFF7A7A7A),
                                            ),
                                          );
                                        },
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 6),

                        // Empty error
                        if (_showEmptyError) ...[
                          const SizedBox(height: 6),
                          const Text(
                            "Please fill in the field",
                            style: TextStyle(
                              color: _danger,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],

                        const SizedBox(height: 12),

                        // Tips card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: _bgSoft,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: _border, width: 1),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "What's makes a good\ndescription?",
                                style: GoogleFonts.urbanist(
                                  fontSize: 20, // ✅ 20px
                                  fontWeight:
                                      FontWeight.w600, // ✅ SemiBold (600)
                                  height: 1.1, // ✅ 110%
                                  letterSpacing: 0, // ✅ 0%
                                  color: const Color(0xFF727272), // ✅ #727272
                                ),
                              ),

                              const SizedBox(height: 10),
                              const _TipRow(
                                ok: true,
                                text: "Brief your personal description",
                              ),
                              const SizedBox(height: 8),
                              const _TipRow(
                                ok: true,
                                text: "Working matehoods",
                              ),
                              const SizedBox(height: 8),
                              const _TipRow(
                                ok: true,
                                text: "Why they should book you",
                              ),
                              const SizedBox(height: 8),
                              const _TipRow(
                                ok: false,
                                text: "Links to web page",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom save button
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                    child: SizedBox(
                      height: 52,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _onSave,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _green,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        child: const Text("Save"),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // -------- Bottom Sheets --------

  Future<void> _showRequirementsSheet() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(.45),
      builder: (_) {
        return _BottomSheetShell(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Spacer(),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(999),
                      child: const Padding(
                        padding: EdgeInsets.all(6),
                        child: Icon(
                          Icons.close,
                          size: 18,
                          color: Color(0xFF6F6F6F),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "Your description doesn't meet\nthe requirements",
                  style: GoogleFonts.urbanist(
                    fontSize: 24, // ✅ 24px
                    fontWeight: FontWeight.w600, // ✅ SemiBold (600)
                    height: 1.1, // ✅ 110%
                    letterSpacing: 0, // ✅ 0%
                    color: const Color(0xFF3FA96B), // ✅ #3FA96B
                  ),
                ),

                const SizedBox(height: 10),
                Text(
                  "The description must be at least 50 character long",
                  style: GoogleFonts.urbanist(
                    fontSize: 14, // ✅ 14px
                    fontWeight: FontWeight.w400, // ✅ Regular
                    height: 1.1, // ✅ 110%
                    letterSpacing: 0, // ✅ 0%
                    color: const Color(0xFF000000), // ✅ #000000
                  ),
                ),

                const SizedBox(height: 18),
                SizedBox(
                  height: 48,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _green,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Accept",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool?> _showLeaveWithoutSavingSheet() async {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: false,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(.45),
      builder: (_) {
        return _BottomSheetShell(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Spacer(),
                    InkWell(
                      onTap: () => Navigator.pop(context, false),
                      borderRadius: BorderRadius.circular(999),
                      child: const Padding(
                        padding: EdgeInsets.all(6),
                        child: Icon(
                          Icons.close,
                          size: 18,
                          color: Color(0xFF6F6F6F),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  "Do you want to leave without\nsaving?",
                  style: GoogleFonts.urbanist(
                    fontSize: 24, // ✅ 24px
                    fontWeight: FontWeight.w600, // ✅ SemiBold (600)
                    height: 1.1, // ✅ 110%
                    letterSpacing: 0, // ✅ 0%
                    color: const Color(0xFF3FA96B), // ✅ #3FA96B
                  ),
                ),

                const SizedBox(height: 10),
                Text(
                  "If you leave without saving, you will loss all the\ninformation completed in this section.",
                  style: GoogleFonts.urbanist(
                    fontSize: 14, // ✅ 14px
                    fontWeight: FontWeight.w400, // ✅ Regular
                    height: 1.1, // ✅ 110%
                    letterSpacing: 0, // ✅ 0%
                    color: const Color(0xFF000000), // ✅ #000000
                  ),
                ),

                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 46,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _green,
                            side: const BorderSide(color: _green, width: 1.2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            "Leave anyway",
                            style: GoogleFonts.urbanist(
                              fontSize: 16, // ✅ 16px
                              fontWeight: FontWeight.w500, // ✅ Medium (500)
                              height: 1.1, // ✅ 110%
                              letterSpacing: 0, // ✅ 0%
                              color: const Color(0xFF3FA96B), // ✅ #3FA96B
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 46,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context, false),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _green,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            "Stay",
                            style: GoogleFonts.urbanist(
                              fontSize: 16, // ✅ 16px
                              fontWeight: FontWeight.w500, // ✅ Medium (500)
                              height: 1.1, // ✅ 110%
                              letterSpacing: 0, // ✅ 0%
                              color: Colors.white, // ✅ #FFFFFF
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
      },
    );
  }
}

/* ------------------ Helpers ------------------ */

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

class _TipRow extends StatelessWidget {
  const _TipRow({required this.ok, required this.text});
  final bool ok;
  final String text;

  @override
  Widget build(BuildContext context) {
    final icon = ok ? Icons.check_rounded : Icons.close_rounded;
    final iconColor = ok ? const Color(0xFF2FA86A) : const Color(0xFF9E9E9E);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.urbanist(
              fontSize: 14, // ✅ Figma
              fontWeight: FontWeight.w500, // ✅ Medium (500)
              height: 1.1, // ✅ 110%
              letterSpacing: 0, // ✅ 0%
              color: const Color(0xFF3B3B3B), // ✅ #3B3B3B
            ),
          ),
        ),
      ],
    );
  }
}

class _BottomSheetShell extends StatelessWidget {
  const _BottomSheetShell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    // ✅ Handles BOTH:
    // - Android navigation bar (viewPadding.bottom)
    // - Keyboard (viewInsets.bottom)
    final bottomInset = math.max(mq.viewInsets.bottom, mq.viewPadding.bottom);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Padding(
        // ✅ This is the main fix: adds space so button never goes under nav bar
        padding: EdgeInsets.only(bottom: bottomInset),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}
