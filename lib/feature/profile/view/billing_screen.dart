import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// ------------------------------------------------------------
/// ✅ Billing Details Screen (UI like your screenshot)
/// - Simple top bar: back + "Billing details"
/// - Grey rounded input fields
/// - 2 dropdown-looking fields with chevron
/// - Big green "Save" button fixed at bottom
///
/// Use:
/// Get.to(() => const BillingDetailsScreen());
/// ------------------------------------------------------------

class BillingDetailsScreen extends StatefulWidget {
  const BillingDetailsScreen({super.key});

  @override
  State<BillingDetailsScreen> createState() => _BillingDetailsScreenState();
}

class _BillingDetailsScreenState extends State<BillingDetailsScreen> {
  final _nameCtrl = TextEditingController();
  final _tinCtrl = TextEditingController();
  final _streetCtrl = TextEditingController();
  final _numberCtrl = TextEditingController();
  final _extraCtrl = TextEditingController();
  final _zipCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _stateCtrl = TextEditingController();

  String _docCountry = "Country of the documents";
  String _country = "Country";

  final _countries = const [
    "Nigeria",
    "Ghana",
    "Kenya",
    "South Africa",
    "United Kingdom",
    "United States",
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _tinCtrl.dispose();
    _streetCtrl.dispose();
    _numberCtrl.dispose();
    _extraCtrl.dispose();
    _zipCtrl.dispose();
    _cityCtrl.dispose();
    _stateCtrl.dispose();
    super.dispose();
  }

  void _openCountryPicker({
    required String title,
    required String current,
    required ValueChanged<String> onPick,
  }) {
    Get.bottomSheet(
      SafeArea(
        top: false,
        child: Container(
          margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(.18), blurRadius: 22, offset: const Offset(0, 10))],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 46, height: 4, decoration: BoxDecoration(color: const Color(0xFFDADADA), borderRadius: BorderRadius.circular(999))),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: _C.text),
                    ),
                  ),
                  InkWell(
                    onTap: Get.back,
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(color: _C.fieldBg, borderRadius: BorderRadius.circular(999), border: Border.all(color: _C.line)),
                      child: const Icon(Icons.close_rounded, size: 16, color: _C.muted),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ..._countries.map((c) {
                final sel = c == current;
                return InkWell(
                  onTap: () {
                    onPick(c);
                    Get.back();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            c,
                            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: _C.text),
                          ),
                        ),
                        if (sel) const Icon(Icons.check_rounded, color: _C.green, size: 20),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 6),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(.35),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: _C.bg,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 6),
            _TopBar(
              title: "Billing details",
              onBack: () => Get.back(),
            ),
            const SizedBox(height: 6),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 6, 18, 16),
                children: [
                  _Field(
                    controller: _nameCtrl,
                    hint: "First name and surname/company name",
                  ),
                  const SizedBox(height: 10),

                  _DropdownField(
                    value: _docCountry,
                    onTap: () => _openCountryPicker(
                      title: "Country of the documents",
                      current: (_docCountry == "Country of the documents") ? "" : _docCountry,
                      onPick: (v) => setState(() => _docCountry = v),
                    ),
                  ),
                  const SizedBox(height: 10),

                  _Field(
                    controller: _tinCtrl,
                    hint: "Tax identification Number ( TIN )",
                  ),
                  const SizedBox(height: 10),

                  _Field(
                    controller: _streetCtrl,
                    hint: "Street",
                  ),
                  const SizedBox(height: 10),

                  _Field(
                    controller: _numberCtrl,
                    hint: "Number",
                  ),
                  const SizedBox(height: 10),

                  _Field(
                    controller: _extraCtrl,
                    hint: "Additional details ( optional )",
                  ),
                  const SizedBox(height: 10),

                  _Field(
                    controller: _zipCtrl,
                    hint: "Zip/Postal Code",
                  ),
                  const SizedBox(height: 10),

                  _Field(
                    controller: _cityCtrl,
                    hint: "City",
                  ),
                  const SizedBox(height: 10),

                  _Field(
                    controller: _stateCtrl,
                    hint: "State/Country/Region",
                  ),
                  const SizedBox(height: 10),

                  _DropdownField(
                    value: _country,
                    onTap: () => _openCountryPicker(
                      title: "Country",
                      current: (_country == "Country") ? "" : _country,
                      onPick: (v) => setState(() => _country = v),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(18, 10, 18, 14 + bottomInset),
              child: SizedBox(
                height: 46,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: save API call
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _C.green,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                  child: const Text(
                    "Save",
                    style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900, color: Colors.white),
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

/// -------------------- UI Pieces --------------------

class _TopBar extends StatelessWidget {
  const _TopBar({required this.title, required this.onBack});
  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 6, 10, 8),
      child: Row(
        children: [
          InkWell(
            onTap: onBack,
            borderRadius: BorderRadius.circular(10),
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: _C.green),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: _C.text),
            ),
          ),
          const SizedBox(width: 18),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.controller, required this.hint});
  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: _C.fieldBg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: _C.line),
      ),
      alignment: Alignment.centerLeft,
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _C.text),
        decoration: InputDecoration(
          border: InputBorder.none,
          isDense: true,
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: _C.muted),
        ),
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({required this.value, required this.onTap});
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isPlaceholder = value == "Country of the documents" || value == "Country";
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: _C.fieldBg,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: _C.line),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: isPlaceholder ? _C.muted : _C.text,
                ),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down_rounded, color: _C.muted),
          ],
        ),
      ),
    );
  }
}

/// -------------------- Theme --------------------

class _C {
  static const green = Color(0xFF27AE60);

  static const bg = Colors.white;
  static const text = Color(0xFF111111);
  static const muted = Color(0xFF8A8A8A);

  static const line = Color(0xFFEDEDED);
  static const fieldBg = Color(0xFFEDEDED);
}
