import 'package:flutter/material.dart';
import 'add_screen.dart';

class InstallationScreen extends StatefulWidget {
  const InstallationScreen({super.key});

  @override
  State<InstallationScreen> createState() => _InstallationScreenState();
}

class _InstallationScreenState extends State<InstallationScreen> {
  static const Color _green = Color(0xFF2FA86A);
  static const Color _muted = Color(0xFF8B8B8B);
  static const Color _divider = Color(0xFFD9D9D9);
  static const Color _track = Color(0xFFEAEAEA);

  static const Color _boxBorder = Color(0xFFBDBDBD);
  static const Color _boxFill = Color(0xFFE6E6E6);

  final List<String> _items = const [
    "Cooling/Heating",
    "For Windows",
    "Bathroom",
    "Kitchen",
  ];

  late final List<bool> _selected = List<bool>.filled(_items.length, false);

  final double _progress = 0.16;
  bool _navigating = false;

  void _goNext() {
    if (_navigating) return;
    _navigating = true;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddHanScreen()),
    ).then((_) => _navigating = false);
  }

  void _toggleAndGo(int index) {
    final nextValue = !_selected[index];
    setState(() => _selected[index] = nextValue);

    // ✅ only go next when turning ON
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
              // ✅ progress bar like your screenshot
              const _TopProgressBar(value: 0.16),
              const SizedBox(height: 12),

              // back + save
              Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(10),
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: Icon(Icons.arrow_back, size: 22, color: _green),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: _muted,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      textStyle: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w500),
                    ),
                    child: const Text("Save and exit"),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              // title
              const Text(
                "Installation",
                style: TextStyle(
                  color: _green,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  height: 1.15,
                ),
              ),

              const SizedBox(height: 10),

              // ✅ top divider line before list (like screenshot)
              const Divider(height: 1, thickness: 1, color: _divider),

              // ✅ list rows (no outer box, only full width lines)
              Column(
                children: List.generate(_items.length, (i) {
                  return Column(
                    children: [
                      InkWell(
                        onTap: () => _toggleAndGo(i),
                        child: SizedBox(
                          height: 46,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _items[i],
                                    style: const TextStyle(
                                      color: Color(0xFF2B2B2B),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                _GreySquareCheck(
                                  value: _selected[i],
                                  onTap: () => _toggleAndGo(i),
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

              const Expanded(child: SizedBox()),
            ],
          ),
        ),
      ),
    );
  }
}

/// ✅ progress bar like screenshot (grey track + inner padding + green pill)
class _TopProgressBar extends StatelessWidget {
  const _TopProgressBar({required this.value});
  final double value;

  static const Color _green = Color(0xFF2FA86A);
  static const Color _track = Color(0xFFEAEAEA);

  @override
  Widget build(BuildContext context) {
    final v = value.clamp(0.0, 1.0);

    return Container(
      height: 15,
      decoration: BoxDecoration(
        color: _track,
        borderRadius: BorderRadius.circular(999),
      ),
      padding: const EdgeInsets.all(2),
      child: LayoutBuilder(
        builder: (context, c) {
          final w = c.maxWidth * v;
          return Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: w < 50 ? 50 : w, // ✅ small pill always visible
              height: double.infinity,
              decoration: BoxDecoration(
                color: _green,
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
        child: value ? Icon(Icons.check_rounded, size: 18, color: checkColor) : null,
      ),
    );
  }
}
