import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'InstallationScreen.dart';

class FurnitureAssemblyScreen extends StatefulWidget {
  const FurnitureAssemblyScreen({super.key});

  @override
  State<FurnitureAssemblyScreen> createState() =>
      _FurnitureAssemblyScreenState();
}

class _FurnitureAssemblyScreenState extends State<FurnitureAssemblyScreen> {
  // Screenshot colors
  static const Color _green = Color(0xFF2FA86A);
  static const Color _muted = Color(0xFF8B8B8B);
  static const Color _divider = Color(0xFFD9D9D9);
  static const Color _track = Color(0xFFEAEAEA);

  static const Color _boxBorder = Color(0xFFBDBDBD);
  static const Color _boxFill = Color(0xFFE6E6E6);

  final List<_RowItem> _items = [
    _RowItem("Cabinets and similar items"),
    _RowItem("Bed"),
    _RowItem("Sideboard/chest of drawers"),
    _RowItem("Mirror"),
    _RowItem("Table"),
  ];

  final double _progress = 0.16;
  bool _navigating = false;

  void _goNext() {
    if (_navigating) return;
    _navigating = true;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const InstallationScreen()),
    ).then((_) => _navigating = false);
  }

  void _toggleAndMaybeGo(int i, bool nextValue) {
    setState(() => _items[i].checked = nextValue);
    if (nextValue) _goNext();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ top progress
              _TopProgressBar(value: _progress, track: _track, fill: _green),
              const SizedBox(height: 12),

              // ✅ back + save and exit
              Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(10),
                    child: const Padding(
                      padding: EdgeInsets.all(2),
                      child: Icon(Icons.arrow_back, size: 22, color: _green),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero, // ✅ don’t change layout
                      minimumSize: Size.zero, // ✅ remove default min size
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      "Save and exit",
                      style: GoogleFonts.urbanist(
                        fontSize: 16, // ✅ Figma
                        fontWeight: FontWeight.w500, // ✅ Medium
                        height: 1.1, // ✅ 110%
                        letterSpacing: 0,
                        color: const Color(0xFF727272),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              // ✅ title
              Text(
                "Furniture assembly",
                style: GoogleFonts.urbanist(
                  fontSize: 24, // ✅ Figma
                  fontWeight: FontWeight.w600, // ✅ SemiBold
                  height: 1.1, // ✅ 110%
                  letterSpacing: 0,
                  color: const Color(0xFF3FA96B),
                ),
              ),

              const SizedBox(height: 10),

              // ✅ list area like screenshot (top border line + row dividers)
              const Divider(height: 1, thickness: 1, color: _divider),

              Column(
                children: List.generate(_items.length, (i) {
                  final item = _items[i];

                  return Column(
                    children: [
                      InkWell(
                        onTap: () => _toggleAndMaybeGo(i, !item.checked),
                        child: SizedBox(
                          height: 46,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item.title,
                                    style: GoogleFonts.urbanist(
                                      fontSize: 18, // ✅ Figma
                                      fontWeight: FontWeight.w500, // ✅ Medium
                                      height: 1.1, // ✅ 110%
                                      letterSpacing: 0,
                                      color: const Color(0xFF3B3B3B), // ✅ Figma
                                    ),
                                  ),
                                ),

                                _GreySquareCheck(
                                  value: item.checked,
                                  onTap: () =>
                                      _toggleAndMaybeGo(i, !item.checked),
                                  borderColor: _boxBorder,
                                  fillColor: _boxFill,
                                  checkColor: _green,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // ✅ divider after every row (including last)
                      const Divider(height: 1, thickness: 1, color: _divider),
                    ],
                  );
                }),
              ),

              // ✅ big empty area
              const Expanded(child: SizedBox()),
            ],
          ),
        ),
      ),
    );
  }
}

class _RowItem {
  final String title;
  bool checked;
  _RowItem(this.title, {this.checked = false});
}

/// ✅ progress bar like screenshot (grey track + small green pill)
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

    return Container(
      height: 15,
      decoration: BoxDecoration(
        color: track,
        borderRadius: BorderRadius.circular(999),
      ),
      padding: const EdgeInsets.all(2), // ✅ inner gap like screenshot
      child: LayoutBuilder(
        builder: (context, c) {
          final w = c.maxWidth * v;
          return Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: w < 50 ? 50 : w, // ✅ small pill visible like screenshot
              height: double.infinity,
              decoration: BoxDecoration(
                color: fill,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// ✅ grey square checkbox like screenshot
class _GreySquareCheck extends StatelessWidget {
  const _GreySquareCheck({
    required this.value,
    required this.onTap,
    required this.borderColor,
    required this.fillColor,
    required this.checkColor,
  });

  final bool value;
  final VoidCallback onTap;
  final Color borderColor;
  final Color fillColor;
  final Color checkColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(3),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: borderColor, width: 1.2),
        ),
        child: value
            ? Icon(Icons.check_rounded, size: 18, color: checkColor)
            : null,
      ),
    );
  }
}
