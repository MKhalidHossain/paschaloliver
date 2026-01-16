import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'SmallRepairScreen.dart';

/// Pro UI based on your screenshot (Hanging selection list)
class HangingScreen extends StatefulWidget {
  const HangingScreen({super.key});

  @override
  State<HangingScreen> createState() => _HangingScreenState();
}

class _HangingScreenState extends State<HangingScreen> {
  static const _brand = Color(0xFF2FA86A);
  static const _text = Color(0xFF1F1F1F);
  static const _muted = Color(0xFF7A7A7A);
  static const _line = Color(0xFFE6E6E6);
  static const _bg = Colors.white;

  final List<String> _items = const [
    "Lamp",
    "TV",
    "Picture",
    "Mirror",
    "Coat Rack",
    "Other objective",
  ];

  final Set<String> _selected = {};
  final TextEditingController _otherCtrl = TextEditingController();

  @override
  void dispose() {
    _otherCtrl.dispose();
    super.dispose();
  }

  bool get _otherSelected => _selected.contains("Other objective");

  void _toggle(String item) {
    final willSelect = !_selected.contains(item);

    setState(() {
      if (willSelect) {
        _selected.add(item);
      } else {
        _selected.remove(item);
        if (item == "Other objective") _otherCtrl.clear();
      }
    });

    // GO when checked
    if (willSelect) {
      Get.to(() => const SmallRepairScreen());
    }
  }

  void _saveAndExit() {
    // TODO: Save to backend / controller if needed
    // Example payload:
    final payload = {
      "selected": _selected.toList(),
      "otherText": _otherSelected ? _otherCtrl.text.trim() : "",
    };

    debugPrint("Hanging payload: $payload");
    Get.back(result: payload); // returns to previous screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            // Top progress + actions
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: 0.18,
                      minHeight: 12,
                      backgroundColor: const Color(0xFFE9E9E9),
                      valueColor: const AlwaysStoppedAnimation(_brand),
                    ),
                  ),
                  const SizedBox(height: 12),

                  SizedBox(
                    height: 40, // ✅ consistent header height
                    child: Row(
                      children: [
                        // ✅ Back aligned to left edge
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () => Get.back(),
                            child: const SizedBox(
                              width: 40,
                              height: 40,
                              child: Align(
                                alignment: Alignment
                                    .centerLeft, // ✅ perfect left align
                                child: Icon(
                                  Icons.arrow_back,
                                  size: 20,
                                  color: _brand,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const Spacer(),

                        // ✅ Save & exit aligned to right edge and vertically centered
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: _saveAndExit,
                            child: SizedBox(
                              height: 40, // ✅ match left side height
                              child: Center(
                                child: Text(
                                  "Save and exit",
                                  style: GoogleFonts.urbanist(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    height: 1.1,
                                    letterSpacing: 0,
                                    color: const Color(0xFF727272),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: 343, // ✅ Figma
                      child: Text(
                        "Hanging",
                        style: GoogleFonts.urbanist(
                          fontSize: 24, // ✅ Figma
                          fontWeight: FontWeight.w600, // ✅ SemiBold
                          height: 1.1, // ✅ 110%
                          letterSpacing: 0,
                          color: const Color(0xFF3FA96B), // ✅ Green Primary
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // List
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: _line, width: 1),
                    bottom: BorderSide(
                      color: _line,
                      width: 1,
                    ), // ✅ adds last line
                  ),
                ),
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: _items.length + (_otherSelected ? 1 : 0),
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, thickness: 1, color: _line),
                  itemBuilder: (context, index) {
                    // Insert "Other objective" text field under the row when selected
                    if (_otherSelected &&
                        index == _items.indexOf("Other objective") + 1) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7F7F7),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE7E7E7)),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          child: TextField(
                            controller: _otherCtrl,
                            textInputAction: TextInputAction.done,
                            style: const TextStyle(
                              color: _text,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: const InputDecoration(
                              hintText: "Write other objective...",
                              hintStyle: TextStyle(
                                color: _muted,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                      );
                    }

                    // Map index to item when extra field inserted
                    final adjustedIndex =
                        (_otherSelected &&
                            index > _items.indexOf("Other objective"))
                        ? index - 1
                        : index;

                    final item = _items[adjustedIndex];
                    final checked = _selected.contains(item);

                    return InkWell(
                      onTap: () => _toggle(item),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                item,
                                style: const TextStyle(
                                  color: _text,
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            _ProCheckbox(
                              value: checked,
                              onTap: () => _toggle(item),
                              brand: _brand,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          
          
          ],
        ),
      ),
    );
  }
}

/// A cleaner checkbox (square like your screenshot)
class _ProCheckbox extends StatelessWidget {
  const _ProCheckbox({
    required this.value,
    required this.onTap,
    required this.brand,
  });

  final bool value;
  final VoidCallback onTap;
  final Color brand;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: value ? brand : const Color(0xFFF2F2F2),
          border: Border.all(
            color: value ? brand : const Color(0xFFBDBDBD),
            width: 1.2,
          ),
          boxShadow: value
              ? [
                  BoxShadow(
                    color: brand.withOpacity(.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: value
            ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
            : null,
      ),
    );
  }
}
