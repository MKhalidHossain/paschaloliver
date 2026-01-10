import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ✅ TODO: change this import path to your real file

import '../../../service/view/service_flow_user_screen.dart';

/// ---------------------------------------------------------------------------
/// ✅ Confirm & Pay Screen — FULL REPLACEABLE FILE (GetX)
/// - Tap "View payment details" -> Service price BottomSheet (like screenshot)
/// - Tap "Book with Pay" -> Navigate to UserServicesScreen ✅
/// - Back -> "You're almost there!" sheet (like screenshot)
/// ---------------------------------------------------------------------------

class _C {
  static const green = Color(0xFF2FA86A);
  static const text = Color(0xFF1F1F1F);
  static const muted = Color(0xFF8B8B8B);
  static const line = Color(0xFFEDEDED);
  static const soft = Color(0xFFF6F6F6);
  static const chipBg = Color(0xFFF2F2F2);
  static const star = Color(0xFFF4B400);
}

class ConfirmAndPayController extends GetxController {
  final proName = "Equioi_katthy".obs;
  final category = "Cleaning".obs;
  final rating = 4.9.obs;
  final reviewsCount = 350.obs;

  final dateText = "Thursday, December 25".obs;
  final startText = "18:00".obs;
  final endText = "20:00".obs;
  final durationText = "(Duration: 2h)".obs;

  final addressLine1 = "Calle de leganitos,20".obs;
  final addressLine2 = "Ungwan Kifi, Nigeria".obs;

  final servicePrice = "₦31,00".obs;

  final hasPaymentMethods = true.obs;
  final selectedMethod = "apple".obs; // "apple" | "card"

  // Payment details breakdown (dummy)
  final hourly = "₦12.50/h".obs;
  final bookedHours = "2h".obs;
  final subtotal = "₦25.0".obs;
  final minCharge = "+ ₦12.50".obs;
  final fees = "+ ₦0.83".obs;
  final vat = "+ ₦0.17".obs;
  final totalPrice = "₦37.00".obs;
}

class ConfirmAndPayScreen extends StatelessWidget {
  const ConfirmAndPayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ConfirmAndPayController());

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) _openGoBackSheet();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 4),

              // Top bar
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 6, 12, 10),
                child: Row(
                  children: [
                    InkWell(
                      onTap: _openGoBackSheet,
                      borderRadius: BorderRadius.circular(10),
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: _C.text),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Expanded(
                      child: Text(
                        "Confirm and pay",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: _C.text),
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1, thickness: 1, color: _C.line),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Pro row
                      Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: const BoxDecoration(shape: BoxShape.circle, color: _C.soft),
                            child: const Icon(Icons.person, color: _C.muted),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(() {
                                  return Row(
                                    children: [
                                      Text(
                                        c.proName.value,
                                        style: const TextStyle(fontSize: 12.3, fontWeight: FontWeight.w900, color: _C.text),
                                      ),
                                      const SizedBox(width: 6),
                                      const Icon(Icons.verified, size: 14, color: _C.green),
                                    ],
                                  );
                                }),
                                const SizedBox(height: 3),
                                Obx(() {
                                  return Text(
                                    c.category.value,
                                    style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w900, color: _C.green),
                                  );
                                }),
                              ],
                            ),
                          ),
                          Obx(() {
                            return Row(
                              children: [
                                const Icon(Icons.star_rounded, size: 16, color: _C.star),
                                const SizedBox(width: 4),
                                Text(
                                  c.rating.value.toStringAsFixed(1),
                                  style: const TextStyle(fontSize: 11.8, fontWeight: FontWeight.w900, color: _C.text),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "(${c.reviewsCount.value})",
                                  style: const TextStyle(fontSize: 11.2, fontWeight: FontWeight.w800, color: _C.muted),
                                ),
                              ],
                            );
                          }),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // Protected row
                      _ChevronTile(
                        leading: const _ShieldIcon(),
                        title: "Protected by Handynaija\nGuarantee",
                        onTap: () {},
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        "How does it work?",
                        style: TextStyle(fontSize: 11.8, fontWeight: FontWeight.w900, color: _C.green),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "The professional has 24 hours to confirm your booking\nrequest.\n\nIf they reject or do not respond, you will be refunded the\nfull amount of the service.",
                        style: TextStyle(fontSize: 11.2, fontWeight: FontWeight.w700, color: _C.muted, height: 1.35),
                      ),

                      const SizedBox(height: 14),
                      const Divider(height: 1, thickness: 1, color: _C.line),
                      const SizedBox(height: 12),

                      _SectionHeader(title: "Date and time", actionText: "Edit", onTap: () {}),
                      const SizedBox(height: 10),
                      Obx(() {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _IconLine(icon: Icons.calendar_today_outlined, text: c.dateText.value),
                            const SizedBox(height: 8),
                            _DotLine(label: "Start:", value: c.startText.value),
                            const SizedBox(height: 6),
                            _DotLine(label: "End:", value: c.endText.value),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.access_time_rounded, size: 16, color: _C.muted),
                                const SizedBox(width: 8),
                                Text(
                                  c.durationText.value,
                                  style: const TextStyle(fontSize: 11.2, fontWeight: FontWeight.w800, color: _C.muted),
                                ),
                              ],
                            ),
                          ],
                        );
                      }),

                      const SizedBox(height: 14),
                      const Divider(height: 1, thickness: 1, color: _C.line),
                      const SizedBox(height: 12),

                      _SectionHeader(title: "Address", actionText: "Change", onTap: () {}),
                      const SizedBox(height: 10),
                      Obx(() => _AddressBlock(line1: c.addressLine1.value, line2: c.addressLine2.value)),

                      const SizedBox(height: 14),
                      const Divider(height: 1, thickness: 1, color: _C.line),
                      const SizedBox(height: 12),

                      InkWell(
                        onTap: () {},
                        child: const Text(
                          "Edit details",
                          style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w900, color: _C.green),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          const Text(
                            "Service price",
                            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w900, color: _C.green),
                          ),
                          const Spacer(),
                          Obx(() => Text(
                            c.servicePrice.value,
                            style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w900, color: _C.green),
                          )),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // ✅ View payment details -> screenshot sheet
                      _ChevronTile(
                        leading: const Icon(Icons.receipt_long_outlined, size: 18, color: _C.green),
                        title: "View payment details",
                        onTap: () => _openPaymentDetailsSheet(c),
                        dense: true,
                      ),

                      const SizedBox(height: 14),
                      const Divider(height: 1, thickness: 1, color: _C.line),
                      const SizedBox(height: 12),

                      _SectionHeader(title: "Payment method", actionText: "Edit", onTap: () {}),
                      const SizedBox(height: 10),

                      Obx(() {
                        if (!c.hasPaymentMethods.value) {
                          return SizedBox(
                            height: 46,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _C.green,
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              child: const Text(
                                "Add Payment method to pay",
                                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900, color: Colors.white),
                              ),
                            ),
                          );
                        }

                        return _PaymentMethodCard(
                          selected: c.selectedMethod.value,
                          onSelect: (v) => c.selectedMethod.value = v,
                        );
                      }),

                      const SizedBox(height: 18),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // ✅ Bottom button (Book with Pay -> UserServicesScreen)
        bottomNavigationBar: SafeArea(
          top: false,
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: _C.line)),
            ),
            child: Obx(() {
              final canPay = c.hasPaymentMethods.value;
              final isApple = c.selectedMethod.value == "apple";

              return SizedBox(
                height: 46,
                child: ElevatedButton(
                  onPressed: !canPay
                      ? null
                      : () {
                    // ✅ YOUR REQUEST:
                    // If Apple Pay -> go UserServicesScreen
                    if (isApple) {
                      Get.to(() => const UserServicesScreen());
                    } else {
                      // If card selected -> also go (or change to your next screen)
                      Get.to(() => const UserServicesScreen());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _C.green,
                    disabledBackgroundColor: _C.green.withOpacity(.35),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: canPay
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isApple ? "Book with " : "Book now",
                        style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900, color: Colors.white),
                      ),
                      if (isApple) ...[
                        const SizedBox(width: 6),
                        const Text(
                          "Pay",
                          style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900, color: Colors.white),
                        ),
                      ],
                    ],
                  )
                      : const Text(
                    "Add Payment method to pay",
                    style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900, color: Colors.white),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  // ✅ Payment details sheet (like screenshot)
  void _openPaymentDetailsSheet(ConfirmAndPayController c) {
    Get.bottomSheet(
      _BaseSheet(
        title: "Service price",
        child: Obx(() {
          return Column(
            children: [
              _TwoColRow(left: "Cleaning", right: c.hourly.value),
              const SizedBox(height: 8),
              _TwoColRow(left: "Booked hours", right: c.bookedHours.value),
              const SizedBox(height: 10),
              const Divider(height: 1, thickness: 1, color: _C.line),
              const SizedBox(height: 10),
              _TwoColRow(left: "Subtotal", right: c.subtotal.value),
              const SizedBox(height: 8),
              _TwoColRow(left: "Professional's minimum charge", right: c.minCharge.value),
              const SizedBox(height: 8),
              _TwoColRow(left: "Management fees", right: c.fees.value),
              const SizedBox(height: 8),
              _TwoColRow(left: "VAT ( heading fee )", right: c.vat.value),
              const SizedBox(height: 10),
              const Divider(height: 1, thickness: 1, color: _C.line),
              const SizedBox(height: 10),
              _TwoColRow(left: "Price:", right: c.totalPrice.value, strong: true),
              const SizedBox(height: 14),
              _ExitRemainRow(
                onExit: () => Get.back(),
                onRemain: () => Get.back(),
              ),
            ],
          );
        }),
      ),
      isScrollControlled: true,
      barrierColor: Colors.black.withOpacity(.35),
      backgroundColor: Colors.transparent,
    );
  }

  // Back sheet (like screenshot)
  void _openGoBackSheet() {
    Get.bottomSheet(
      _BaseSheet(
        title: "if want to go back",
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 74,
              height: 74,
              decoration: BoxDecoration(
                color: _C.green.withOpacity(.10),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: _C.green.withOpacity(.20)),
              ),
              child: const Icon(Icons.construction_rounded, size: 40, color: _C.green),
            ),
            const SizedBox(height: 14),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "You're almost there!",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: _C.green),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Nicolas availability may soon be fully booked for the\nhours you require. Book without obligation and with free\ncancellation up to 24 hours before the service.",
              style: TextStyle(fontSize: 11.2, fontWeight: FontWeight.w700, color: _C.muted, height: 1.35),
            ),
            const SizedBox(height: 14),
            _ExitRemainRow(
              onExit: () {
                Get.back();
                Get.back();
              },
              onRemain: () => Get.back(),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      barrierColor: Colors.black.withOpacity(.35),
      backgroundColor: Colors.transparent,
    );
  }
}

/// --------------------------- SHEET BASE ---------------------------

class _BaseSheet extends StatelessWidget {
  const _BaseSheet({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Spacer(),
                Container(
                  width: 46,
                  height: 5,
                  decoration: BoxDecoration(
                    color: _C.line,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () => Get.back(),
                  borderRadius: BorderRadius.circular(999),
                  child: const Padding(
                    padding: EdgeInsets.all(6),
                    child: Icon(Icons.close_rounded, size: 18, color: _C.muted),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900, color: _C.green),
              ),
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}

class _ExitRemainRow extends StatelessWidget {
  const _ExitRemainRow({required this.onExit, required this.onRemain});
  final VoidCallback onExit;
  final VoidCallback onRemain;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 44,
            child: OutlinedButton(
              onPressed: onExit,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: _C.line),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                "Exit",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: _C.green),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SizedBox(
            height: 44,
            child: ElevatedButton(
              onPressed: onRemain,
              style: ElevatedButton.styleFrom(
                backgroundColor: _C.green,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                "Remain",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TwoColRow extends StatelessWidget {
  const _TwoColRow({required this.left, required this.right, this.strong = false});
  final String left;
  final String right;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            left,
            style: TextStyle(
              fontSize: 11.2,
              fontWeight: strong ? FontWeight.w900 : FontWeight.w800,
              color: strong ? _C.text : _C.muted,
            ),
          ),
        ),
        Text(
          right,
          style: TextStyle(
            fontSize: 11.2,
            fontWeight: strong ? FontWeight.w900 : FontWeight.w800,
            color: strong ? _C.text : _C.muted,
          ),
        ),
      ],
    );
  }
}

/// --------------------------- SMALL UI ---------------------------

class _ShieldIcon extends StatelessWidget {
  const _ShieldIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: _C.green.withOpacity(.10),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _C.green.withOpacity(.25)),
      ),
      child: const Icon(Icons.verified_user_rounded, size: 18, color: _C.green),
    );
  }
}

class _ChevronTile extends StatelessWidget {
  const _ChevronTile({
    required this.leading,
    required this.title,
    required this.onTap,
    this.dense = false,
  });

  final Widget leading;
  final String title;
  final VoidCallback onTap;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, dense ? 8 : 10, 0, dense ? 8 : 10),
        child: Row(
          children: [
            leading,
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 11.7, fontWeight: FontWeight.w900, color: _C.text, height: 1.2),
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: _C.muted),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.actionText, required this.onTap});
  final String title;
  final String actionText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: const TextStyle(fontSize: 11.8, fontWeight: FontWeight.w900, color: _C.green)),
        const Spacer(),
        InkWell(
          onTap: onTap,
          child: Text(actionText, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w900, color: _C.green)),
        ),
      ],
    );
  }
}

class _IconLine extends StatelessWidget {
  const _IconLine({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: _C.muted),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: _C.text))),
      ],
    );
  }
}

class _DotLine extends StatelessWidget {
  const _DotLine({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: const BoxDecoration(color: _C.text, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 11.2, fontWeight: FontWeight.w900, color: _C.text)),
        const SizedBox(width: 8),
        Text(value, style: const TextStyle(fontSize: 11.2, fontWeight: FontWeight.w800, color: _C.muted)),
      ],
    );
  }
}

class _AddressBlock extends StatelessWidget {
  const _AddressBlock({required this.line1, required this.line2});
  final String line1;
  final String line2;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 2),
          child: Icon(Icons.location_on_outlined, size: 18, color: _C.text),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(line1, style: const TextStyle(fontSize: 11.6, fontWeight: FontWeight.w900, color: _C.text)),
              const SizedBox(height: 3),
              Text(line2, style: const TextStyle(fontSize: 11.2, fontWeight: FontWeight.w800, color: _C.muted)),
            ],
          ),
        ),
      ],
    );
  }
}

/// --------------------------- PAYMENT METHOD CARD ---------------------------

class _PaymentMethodCard extends StatelessWidget {
  const _PaymentMethodCard({required this.selected, required this.onSelect});
  final String selected; // "apple" | "card"
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: _C.line),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        children: [
          _PaymentRow(
            title: "Apple Pay",
            leading: const _LogoBox(text: "Pay"),
            selected: selected == "apple",
            onTap: () => onSelect("apple"),
          ),
          const Divider(height: 1, thickness: 1, color: _C.line),
          _PaymentRow(
            title: "Visa/Mastercard’s",
            leading: const _LogoBox(text: "VISA"),
            selected: selected == "card",
            onTap: () => onSelect("card"),
          ),
        ],
      ),
    );
  }
}

class _PaymentRow extends StatelessWidget {
  const _PaymentRow({required this.title, required this.leading, required this.selected, required this.onTap});
  final String title;
  final Widget leading;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: Row(
          children: [
            leading,
            const SizedBox(width: 10),
            Expanded(
              child: Text(title, style: const TextStyle(fontSize: 11.8, fontWeight: FontWeight.w900, color: _C.text)),
            ),
            if (selected) const Icon(Icons.check_circle_rounded, size: 18, color: _C.green) else const SizedBox(width: 18),
          ],
        ),
      ),
    );
  }
}

class _LogoBox extends StatelessWidget {
  const _LogoBox({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 26,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _C.chipBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _C.line),
      ),
      child: Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: _C.text)),
    );
  }
}
