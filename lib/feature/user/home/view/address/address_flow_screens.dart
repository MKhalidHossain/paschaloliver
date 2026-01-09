import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// ---------------------------------------------------------------------------
/// ADDRESS FLOW (UI LIKE YOUR SCREENSHOTS) - GetX
/// Screens:
/// 1) MyAddressesScreen
/// 2) ServiceAddressMapScreen
/// 3) AddressSearchScreen
/// 4) AddressDetailsScreen
/// Bottom sheets:
/// - StreetNumberSheet
/// - FloorDoorSheet
/// ---------------------------------------------------------------------------

class AddressFlowController extends GetxController {
  final searchCtrl = TextEditingController();
  final detailsCtrl = TextEditingController();
  final streetNumberCtrl = TextEditingController(text: "20");

  final selectedAddress = "Ungwan Kifi, Nigeria".obs;
  final selectedSub = "080006, Ungwan".obs;

  final suggestions = <String>[
    "Ungwan Kifi, Nigeria",
    "Ungwan Kifi, Nigeria",
  ].obs;

  @override
  void onClose() {
    searchCtrl.dispose();
    detailsCtrl.dispose();
    streetNumberCtrl.dispose();
    super.onClose();
  }
}

class AddressUI {
  static const Color green = Color(0xFF3AAE6E);
  static const Color text = Color(0xFF1B1B1B);
  static const Color muted = Color(0xFF6E6E6E);
  static const Color line = Color(0xFFE6E6E6);
  static const Color fill = Color(0xFFF1F1F1);
}

class MyAddressesScreen extends StatelessWidget {
  const MyAddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(AddressFlowController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AddressUI.text,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Get.back(),
        ),
        centerTitle: false,
        title: const Text(
          "Addresses",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enter the address where the service will be performed\n"
                  "to show your available professionals.",
              style: TextStyle(
                fontSize: 12.5,
                height: 1.3,
                color: AddressUI.muted,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 14),

            // Search field (opens search page)
            _SearchField(
              hint: "Street name and number…",
              onTap: () => Get.to(() => const AddressSearchScreen()),
            ),
            const SizedBox(height: 14),

            // Use current location button
            _PrimaryOutlineButton(
              icon: Icons.my_location_rounded,
              label: "Use Current Location",
              onTap: () {
                // show street number bottom sheet like screenshot
                Get.bottomSheet(
                  const StreetNumberSheet(
                    placeTitle: "Maddalena plaza",
                    placeSub: "(Durango,480200)",
                  ),
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Bottom sheet: Street number
class StreetNumberSheet extends StatelessWidget {
  const StreetNumberSheet({
    super.key,
    required this.placeTitle,
    required this.placeSub,
  });

  final String placeTitle;
  final String placeSub;

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AddressFlowController>();

    return _BottomSheetCard(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // top row: title + close
            Row(
              children: [
                const Expanded(
                  child: Text(
                    "Street number:",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                  ),
                ),
                _SheetCloseButton(onTap: () => Get.back()),
              ],
            ),
            const SizedBox(height: 10),

            Text(
              placeTitle,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(
              placeSub,
              style: const TextStyle(fontSize: 12, color: AddressUI.muted, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 14),
            TextField(
              controller: c.streetNumberCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                fillColor: AddressUI.fill,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 14),

            _GreenButton(
              label: "Next",
              onTap: () {
                Get.back(); // close sheet
                Get.to(() => const ServiceAddressMapScreen());
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Screen: Service address map (UI like screenshot)
class ServiceAddressMapScreen extends StatelessWidget {
  const ServiceAddressMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AddressFlowController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top bar with title + close
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Service  address",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                    ),
                  ),
                  _TinyCircle(
                    icon: Icons.close_rounded,
                    onTap: () => Get.back(),
                  ),
                ],
              ),
            ),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: _SearchBarInline(
                hint: "Type your address",
                onTap: () => Get.to(() => const AddressSearchScreen()),
              ),
            ),
            const SizedBox(height: 10),

            // Map placeholder (replace with GoogleMap later)
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      color: const Color(0xFFF4F0E6),
                      child: const Center(
                        child: Text(
                          "MAP (placeholder)\nReplace with google_maps_flutter",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AddressUI.muted, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),

                  // Use location chip
                  Positioned(
                    right: 14,
                    bottom: 78,
                    child: _MapPillButton(
                      icon: Icons.near_me_outlined,
                      label: "Use location",
                      onTap: () {},
                    ),
                  ),

                  // Bottom confirm button
                  Positioned(
                    left: 18,
                    right: 18,
                    bottom: 18,
                    child: _GreyButton(
                      label: "Confirm address",
                      onTap: () => Get.to(() => const AddressDetailsScreen()),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Screen: Address search results
class AddressSearchScreen extends StatelessWidget {
  const AddressSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AddressFlowController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
          child: Column(
            children: [
              _SearchBarInline(
                hint: "Ungwan Kifi, Nigeria",
                controller: c.searchCtrl,
                autofocus: true,
                onChanged: (v) {
                  // UI-only: keep same list for now
                },
              ),
              const SizedBox(height: 14),

              Expanded(
                child: Obx(() {
                  return ListView.separated(
                    itemCount: c.suggestions.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (_, i) {
                      final s = c.suggestions[i];
                      return InkWell(
                        onTap: () {
                          c.selectedAddress.value = s;
                          Get.back(); // return to previous screen
                        },
                        child: Text(
                          s,
                          style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600, color: AddressUI.text),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Screen: Address details with map on top + confirm
class AddressDetailsScreen extends StatelessWidget {
  const AddressDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AddressFlowController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // App bar style: Back + centered title + close
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: Row(
                children: [
                  TextButton.icon(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: AddressUI.green),
                    label: const Text(
                      "Back",
                      style: TextStyle(color: AddressUI.green, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    "Service  address",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  const Spacer(),
                  _TinyCircle(icon: Icons.close_rounded, onTap: () => Get.back()),
                ],
              ),
            ),

            // Map header (placeholder)
            SizedBox(
              height: 220,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      color: const Color(0xFFF4F0E6),
                      child: const Center(
                        child: Text(
                          "MAP (placeholder)",
                          style: TextStyle(color: AddressUI.muted, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),

                  // floating controls
                  Positioned(
                    right: 12,
                    top: 54,
                    child: Column(
                      children: [
                        _MapFloatingBtn(icon: Icons.near_me_outlined, onTap: () {}),
                        const SizedBox(height: 10),
                        _MapFloatingBtn(icon: Icons.add, onTap: () {}),
                        const SizedBox(height: 10),
                        _MapFloatingBtn(icon: Icons.remove, onTap: () {}),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Selected address card
                    Obx(() {
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AddressUI.fill,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AddressUI.line),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on_outlined, color: AddressUI.green),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    c.selectedAddress.value,
                                    style: const TextStyle(fontWeight: FontWeight.w800, color: AddressUI.text),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    c.selectedSub.value,
                                    style: const TextStyle(fontSize: 12, color: AddressUI.muted, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right_rounded, color: AddressUI.muted),
                          ],
                        ),
                      );
                    }),

                    const SizedBox(height: 14),

                    // Address details label
                    Row(
                      children: const [
                        Icon(Icons.receipt_long_outlined, color: AddressUI.muted),
                        SizedBox(width: 8),
                        Text(
                          "Address details:",
                          style: TextStyle(fontWeight: FontWeight.w800, color: AddressUI.text),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Details field
                    TextField(
                      controller: c.detailsCtrl,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: "Floor, door, apartment, etc.",
                        hintStyle: const TextStyle(color: AddressUI.muted, fontWeight: FontWeight.w600),
                        filled: true,
                        fillColor: AddressUI.fill,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Confirm address button
                    _GreenButton(
                      label: "Confirm address",
                      onTap: () {
                        Get.bottomSheet(
                          const FloorDoorSheet(),
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bottom sheet: Floor and door
class FloorDoorSheet extends StatelessWidget {
  const FloorDoorSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return _BottomSheetCard(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // grab handle
            Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: AddressUI.line,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(height: 10),

            Align(
              alignment: Alignment.centerRight,
              child: _SheetCloseButton(onTap: () => Get.back()),
            ),
            const SizedBox(height: 6),

            // Illustration placeholder
            Container(
              height: 90,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(Icons.home_work_outlined, size: 44, color: AddressUI.muted),
              ),
            ),

            const SizedBox(height: 10),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Floor and door?",
                style: TextStyle(
                  color: AddressUI.green,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: 8),

            const Text(
              "Include additional details of your address ( floor, door,\n"
                  "apartment, etc ) to make it easier for the professional to\n"
                  "find your home.",
              style: TextStyle(
                color: AddressUI.muted,
                height: 1.3,
                fontWeight: FontWeight.w600,
                fontSize: 12.5,
              ),
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: _WhiteOutlineBtn(
                    label: "Skip this step",
                    onTap: () => Get.back(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _GreenButton(
                    label: "Add details",
                    onTap: () {
                      // Here you can focus details field or open details editor
                      Get.back();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// UI Components (match your style)
/// ---------------------------------------------------------------------------

class _SearchField extends StatelessWidget {
  const _SearchField({required this.hint, required this.onTap});
  final String hint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AddressUI.fill,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AddressUI.line),
        ),
        child: Row(
          children: [
            const Icon(Icons.search_rounded, color: AddressUI.muted),
            const SizedBox(width: 10),
            Text(
              hint,
              style: const TextStyle(color: AddressUI.muted, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBarInline extends StatelessWidget {
  const _SearchBarInline({
    required this.hint,
    this.controller,
    this.autofocus = false,
    this.onTap,
    this.onChanged,
  });

  final String hint;
  final TextEditingController? controller;
  final bool autofocus;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AddressUI.fill,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AddressUI.line),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on_outlined, color: AddressUI.green, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              autofocus: autofocus,
              onTap: onTap,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: AddressUI.muted, fontWeight: FontWeight.w600),
                border: InputBorder.none,
                isCollapsed: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryOutlineButton extends StatelessWidget {
  const _PrimaryOutlineButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18, color: AddressUI.text),
        label: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w700, color: AddressUI.text),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AddressUI.text.withOpacity(.25)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}

class _GreenButton extends StatelessWidget {
  const _GreenButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AddressUI.green,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 0,
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

class _GreyButton extends StatelessWidget {
  const _GreyButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE6E6E6),
          foregroundColor: AddressUI.text,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
      ),
    );
  }
}

class _WhiteOutlineBtn extends StatelessWidget {
  const _WhiteOutlineBtn({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AddressUI.green.withOpacity(.7), width: 1.2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: Colors.white,
        ),
        child: Text(
          label,
          style: const TextStyle(color: AddressUI.green, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

class _BottomSheetCard extends StatelessWidget {
  const _BottomSheetCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _SheetCloseButton extends StatelessWidget {
  const _SheetCloseButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AddressUI.fill,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AddressUI.line),
        ),
        child: const Icon(Icons.close_rounded, size: 18, color: AddressUI.text),
      ),
    );
  }
}

class _TinyCircle extends StatelessWidget {
  const _TinyCircle({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: AddressUI.fill,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AddressUI.line),
        ),
        child: Icon(icon, size: 18, color: AddressUI.muted),
      ),
    );
  }
}

class _MapPillButton extends StatelessWidget {
  const _MapPillButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(999),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(.12),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: AddressUI.text),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }
}

class _MapFloatingBtn extends StatelessWidget {
  const _MapFloatingBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(.12),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 38,
          height: 38,
          child: Center(child: Icon(icon, color: AddressUI.text)),
        ),
      ),
    );
  }
}
