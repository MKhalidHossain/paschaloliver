import 'package:flutter/material.dart';

import 'interest_service_screen.dart';

class AddHanScreen extends StatefulWidget {
  const AddHanScreen({super.key});

  @override
  State<AddHanScreen> createState() => _AddHanScreenState();
}

class _AddHanScreenState extends State<AddHanScreen> {
  static const Color _green = Color(0xFF2FA86A);
  static const Color _muted = Color(0xFF8B8B8B);
  static const Color _track = Color(0xFFEAEAEA);
  static const Color _text = Color(0xFF2B2B2B);

  final _priceCtrl = TextEditingController();
  final _discountCtrl = TextEditingController();

  // 0 = no offer, 1 = offer discount
  int _discountChoice = 1;

  final double _progress = 0.38;

  @override
  void dispose() {
    _priceCtrl.dispose();
    _discountCtrl.dispose();
    super.dispose();
  }

  void _onSave() {
    // ✅ go to InformationOfInterestScreen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const InformationOfInterestScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wantsDiscount = _discountChoice == 1;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // CONTENT
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _TopProgressBar(
                      value: _progress,
                      track: _track,
                      fill: _green,
                    ),
                    const SizedBox(height: 12),

                    // Back + Save and exit
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

                    const SizedBox(height: 8),

                    const Text(
                      "Price of your service",
                      style: TextStyle(
                        color: _green,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        height: 1.1,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      "This is the price of your handyman sevice.",
                      style: TextStyle(
                        color: _text,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w400,
                        height: 1.35,
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      "Price:",
                      style: TextStyle(
                        color: _green,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),

                    _OutlinedField(
                      controller: _priceCtrl,
                      hint: "Enter Price",
                      suffixText: "₦/h",
                    ),

                    const SizedBox(height: 12),

                    Center(
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          foregroundColor: _green,
                          textStyle: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        child: const Text(
                          "How much you will i make for my services?",
                        ),
                      ),
                    ),

                    const SizedBox(height: 4),
                    Center(
                      child: Text(
                        "We recommend that you start with a lower price to get\nyour first reviews, You can edit this price anytime.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _text,
                          fontSize: 12.8,
                          fontWeight: FontWeight.w400,
                          height: 1.35,
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // const Text(
                    //   "Requiring Discount",
                    //   style: TextStyle(
                    //     color: Color(0xFF6E6E6E),
                    //     fontSize: 16,
                    //     fontWeight: FontWeight.w700,
                    //   ),
                    // ),
                    // const SizedBox(height: 8),

                    // const Text(
                    //   "If you add a discount for requiring bookings, you will\nreceive longer lasting bookings.",
                    //   style: TextStyle(
                    //     color: _text,
                    //     fontSize: 12.8,
                    //     fontWeight: FontWeight.w400,
                    //     height: 1.35,
                    //   ),
                    // ),
                    const SizedBox(height: 14),

                    // RADIO 1
                    // _RadioRow(
                    //   selected: _discountChoice == 0,
                    //   title: "I don’t want to add a special offer",
                    //   onTap: () => setState(() => _discountChoice = 0),
                    // ),
                    // const SizedBox(height: 10),

                    // // RADIO 2 + recommended chip
                    _RadioRow(
                      selected: _discountChoice == 1,
                      title: "I want to offer a discount",
                      onTap: () => setState(() => _discountChoice = 1),
                    ),

                    const SizedBox(height: 6),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDEDED),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          "Recommended option",
                          style: TextStyle(
                            color: Color(0xFF6F6F6F),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // const Text(
                    //   "Requiring Price:",
                    //   style: TextStyle(
                    //     color: _green,
                    //     fontSize: 13.5,
                    //     fontWeight: FontWeight.w500,
                    //   ),
                    // ),
                    const SizedBox(height: 6),

                    Opacity(
                      opacity: wantsDiscount ? 1 : 0.45,
                      child: IgnorePointer(
                        ignoring: !wantsDiscount,
                        child: _OutlinedField(
                          controller: _discountCtrl,
                          hint: "Enter Price",
                          suffixText: "%",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // BOTTOM SAVE BUTTON
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
              child: SizedBox(
                height: 52,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Save",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
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

/* ------------------ Small widgets ------------------ */

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

class _OutlinedField extends StatelessWidget {
  const _OutlinedField({
    required this.controller,
    required this.hint,
    required this.suffixText,
  });

  final TextEditingController controller;
  final String hint;
  final String suffixText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFB0B0B0), fontSize: 13),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFFBDBDBD), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFF2FA86A), width: 1.2),
        ),
        suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Text(
            suffixText,
            style: const TextStyle(
              color: Color(0xFF5A5A5A),
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
            ),
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
  });

  final bool selected;
  final String title;
  final VoidCallback onTap;

  static const Color _green = Color(0xFF2FA86A);
  static const Color _text = Color(0xFF3A3A3A);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          _RadioCircle(selected: selected),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: _text,
                fontSize: 13.8,
                fontWeight: FontWeight.w500,
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RadioCircle extends StatelessWidget {
  const _RadioCircle({required this.selected});
  final bool selected;

  static const Color _green = Color(0xFF2FA86A);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? _green : const Color(0xFFBDBDBD),
          width: 1.4,
        ),
      ),
      child: selected
          ? Center(
              child: Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  color: _green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 12, color: Colors.white),
              ),
            )
          : null,
    );
  }
}
