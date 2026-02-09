import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paschaloliver/feature/listing/controller/listing_create_controller.dart';
import 'package:paschaloliver/feature/listing/view/interest_service_screen.dart';

/// ✅ Price of your service (matches screenshot)
/// - Top progress bar
/// - Back arrow (green)
/// - "Save and exit" on right
/// - Title + subtitle
/// - Price input + currency suffix
/// - Green link text (underline)
/// - Discount toggle + badge + discount input
/// - Save button
class PriceOfServiceScreen extends StatefulWidget {
  const PriceOfServiceScreen({super.key});

  static const Color _green = Color(0xFF2FA86A);
  static const Color _muted = Color(0xFF6F6F6F);
  static const Color _text = Color(0xFF1E1E1E);
  static const Color _divider = Color(0xFFE6E6E6);

  @override
  State<PriceOfServiceScreen> createState() => _PriceOfServiceScreenState();
}

class _PriceOfServiceScreenState extends State<PriceOfServiceScreen> {
  final _priceCtrl = TextEditingController();
  late final ListingCreateController _listingController;

  @override
  void dispose() {
    _priceCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _listingController = Get.find<ListingCreateController>();
    if (_listingController.price.value > 0) {
      _priceCtrl.text = _listingController.price.value.toStringAsFixed(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),

              // ✅ Progress bar (left green fill + grey)
              const _TopProgress(value: 0.16),

              const SizedBox(height: 16),

              // Back + Save and exit
              Row(
                children: [
                  // ✅ Back arrow perfectly left-aligned
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => Get.back(),
                        child: SizedBox(
                          width: 32,
                          height: 32,
                          child: Center(
                            child: Transform.translate(
                              offset: const Offset(-2, 0),
                              child: const Icon(
                                Icons.arrow_back,
                                size: 20,
                                color: PriceOfServiceScreen._green,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Get.back(),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: Size.zero,
                    ),
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
                ],
              ),

              const SizedBox(height: 10),

              // Title
              Text(
                "Price of your service",
                style: GoogleFonts.urbanist(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  height: 1.1,
                  letterSpacing: 0,
                  color: const Color(0xFF3FA96B),
                ),
              ),

              const SizedBox(height: 6),

              // Subtitle
              Text(
                "This is the price of your handyman service.",
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.1,
                  letterSpacing: 0,
                  color: const Color(0xFF000000),
                ),
              ),

              const SizedBox(height: 12),

              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    const Text(
                      "Price:",
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6F6F6F),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _PriceField(
                      controller: _priceCtrl,
                      hintText: "Enter Price",
                      suffixText: "\$/h",
                    ),

                    const SizedBox(height: 16),

                    InkWell(
                      onTap: () {},
                      child: Text(
                        "How much you will i make for my services?",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.urbanist(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 1.1,
                          letterSpacing: 0,
                          color: const Color(0xFF3FA96B),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                    Text(
                      "We recommend that you start with a lower price to get\n"
                      "your first reviews. You can edit this price anytime.",
                      style: GoogleFonts.urbanist(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w400,
                        height: 1.3,
                        color: const Color(0xFF6F6F6F),
                      ),
                    ),

                    const SizedBox(height: 12),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                height: 52,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final priceValue = double.tryParse(_priceCtrl.text.trim());
                    if (priceValue == null || priceValue <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Enter a valid price')),
                      );
                      return;
                    }

                    _listingController.setPrice(priceValue);
                    _listingController.setDiscountPercent(null);

                    Get.to(() => const InformationOfInterestScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2FA86A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Save",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

// ===================== PROGRESS =====================
class _TopProgress extends StatelessWidget {
  const _TopProgress({required this.value});

  final double value; // 0..1

  @override
  Widget build(BuildContext context) {
    final v = value.clamp(0.0, 1.0);

    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;
        const h = 12.0;
        final fillW = (w * v).clamp(h, w);

        return ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: Container(
            height: h,
            color: const Color(0xFFE7E7E7),
            alignment: Alignment.centerLeft,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: fillW,
              height: h,
              decoration: BoxDecoration(
                color: PriceOfServiceScreen._green,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PriceField extends StatelessWidget {
  const _PriceField({
    required this.controller,
    required this.hintText,
    required this.suffixText,
    this.enabled = true,
  });

  final TextEditingController controller;
  final String hintText;
  final String suffixText;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: TextField(
        controller: controller,
        enabled: enabled,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w400,
            color: Color(0xFFB6B6B6),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
          suffixText: suffixText,
          suffixStyle: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6F6F6F),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFBDBDBD)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFBDBDBD)),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
        ),
      ),
    );
  }
}
