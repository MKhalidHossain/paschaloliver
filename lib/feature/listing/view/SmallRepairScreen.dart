import 'package:flutter/material.dart';

import 'FurnitureAssemblyScreen.dart';

class SmallRepairScreen extends StatefulWidget {
  const SmallRepairScreen({super.key});

  @override
  State<SmallRepairScreen> createState() => _SmallRepairScreenState();
}

class _SmallRepairScreenState extends State<SmallRepairScreen> {
  static const _C = _Colors();

  final List<_OptionItem> _items = [
    _OptionItem("cistern repair"),
    _OptionItem("Top replacement"),
    _OptionItem("Socket replacement"),
    _OptionItem("Unclogging"),
  ];

  double progress = 0.16; // 16%

  bool _navigated = false; // prevent double navigation

  void _goNext() {
    if (_navigated) return;
    _navigated = true;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FurnitureAssemblyScreen()),
    ).then((_) {
      // reset after coming back
      _navigated = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),

              // Progress bar
              _ProgressBar(
                value: progress,
                height: 12,
                bg: _C.progressBg,
                fg: _Colors.green,
              ),

              const SizedBox(height: 14),

              // Top row: back + Save and exit
              Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () => Navigator.pop(context),
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: Icon(Icons.arrow_back, size: 22),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: _C.muted,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                    ),
                    child: const Text(
                      "Save and exit",
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Title
              const Text(
                "Small Repair",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: _Colors.green,
                  height: 1.1,
                ),
              ),

              const SizedBox(height: 14),

              // Options list
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: _items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, i) {
                    final item = _items[i];

                    return _OptionRow(
                      title: item.title,
                      value: item.selected,
                      onChanged: (v) {
                        final selected = v ?? false;

                        setState(() => item.selected = selected);

                        // ✅ Navigate only when turning ON
                        if (selected) _goNext();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* --------------------------- Widgets --------------------------- */

class _OptionRow extends StatelessWidget {
  const _OptionRow({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final bool value;
  final ValueChanged<bool?> onChanged;

  static const _C = _Colors();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w500,
              color: _Colors.green,
              height: 1.2,
            ),
          ),
        ),
        Theme(
          data: Theme.of(context).copyWith(
            checkboxTheme: CheckboxThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3),
              ),
              side: const BorderSide(color: _Colors.checkBorder, width: 1.4),
              fillColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) return _Colors.green;
                return Colors.transparent;
              }),
              checkColor: WidgetStateProperty.all(Colors.white),
            ),
          ),
          child: Transform.scale(
            scale: 1.1,
            child: Checkbox(
              value: value,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({
    required this.value,
    required this.height,
    required this.bg,
    required this.fg,
  });

  final double value; // 0..1
  final double height;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    final v = value.clamp(0.0, 1.0);
    return LayoutBuilder(
      builder: (context, c) {
        return Container(
          height: height,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: c.maxWidth * v,
              decoration: BoxDecoration(
                color: fg,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        );
      },
    );
  }
}

/* --------------------------- Models/Colors --------------------------- */

class _OptionItem {
  _OptionItem(this.title, {this.selected = false});
  final String title;
  bool selected;
}

class _Colors {
  const _Colors();
  static const Color green = Color(0xFF2FA86A);
  Color get bg => Colors.white;
  Color get muted => const Color(0xFF8B8B8B);
  Color get progressBg => const Color(0xFFEAEAEA);
  static const Color checkBorder = Color(0xFFBDBDBD);
}
