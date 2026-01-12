import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:paschaloliver/feature/inbox/view/inbox_screen.dart';

import '../../../core/constants/assets.dart';
import '../../user/home/view/address/address_flow_screens.dart';
import '../models/requests_model.dart';

// ✅ CHANGE THIS IMPORT PATH to your actual file location
// Example: import '../../address_flow/address_flow.dart';

/// ---------------------------------------------------------------------------
/// VIEW DETAILS (REAL GOOGLE MAP INTEGRATION)
/// - Map uses AddressFlowController (selectedLatLng, markers, permissions)
/// - Tap on map to pick location
/// - Buttons: use location, zoom in/out
/// - Address lines come from controller (selectedAddress, selectedSub)
/// ---------------------------------------------------------------------------
class ViewDetails extends StatefulWidget {
  const ViewDetails({super.key, required this.item});
  final RequestItem item;

  @override
  State<ViewDetails> createState() => _ViewDetailsState();
}

class _ViewDetailsState extends State<ViewDetails> {
  final _msgCtrl = TextEditingController();

  late final AddressFlowController addrC;

  @override
  void initState() {
    super.initState();

    // ✅ Use existing controller if already created, otherwise create it.
    addrC = Get.isRegistered<AddressFlowController>()
        ? Get.find<AddressFlowController>()
        : Get.put(AddressFlowController());
  }

  @override
  void dispose() {
    _msgCtrl.dispose();
    super.dispose();
  }

  void _openPaymentDetails() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(.35),
      builder: (_) => const PaymentDetailsSheet(
        title: "Service price",
        serviceName: "Cleaning",
        hourlyRate: 12.50,
        bookedHours: 2,
        minCharge: 12.50,
        managementFee: 0.83,
        vat: 0.17,
        currencySymbol: "₦",
      ),
    );
  }

  Future<void> _confirmAccept() async {
    final ok = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(.45),
      builder: (_) => const AreYouReadyDialog(),
    );

    if (!mounted) return;
    if (ok == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Accepted ✅")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return Scaffold(
      backgroundColor: _C.bg,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar (back only)
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 6),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(10),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: 18,
                        color: _C.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
                children: [
                  // ✅ REAL GOOGLE MAP (replaces _MapPreview)
                  _LiveMapHeader(height: 178, c: addrC),
                  const SizedBox(height: 12),

                  // Main card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: _C.border, width: 1),
                    ),
                    child: Column(
                      children: [
                        // Person row
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
                          child: Row(
                            children: [
                              _Avatar(url: item.avatarUrl),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: const TextStyle(
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w800,
                                        color: _C.text,
                                        height: 1.15,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    const Text(
                                      "Client",
                                      style: TextStyle(
                                        fontSize: 11.5,
                                        color: _C.subtext,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Text(
                                "4.8",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: _C.text,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(Icons.star, size: 16, color: Color(0xFFF5B400)),
                            ],
                          ),
                        ),

                        const Divider(height: 1, thickness: 1, color: _C.divider),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${item.service} Service",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: _C.text,
                                ),
                              ),
                              const SizedBox(height: 10),

                              // View payment details
                              InkWell(
                                onTap: _openPaymentDetails,
                                borderRadius: BorderRadius.circular(10),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  child: Row(
                                    children: const [
                                      Icon(Icons.verified_user_outlined, color: _C.green, size: 18),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          "View payment details",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: _C.text,
                                          ),
                                        ),
                                      ),
                                      Icon(Icons.chevron_right_rounded, color: _C.subtext),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 6),

                              // ✅ LIVE ADDRESS (from AddressFlowController)
                              InkWell(
                                onTap: () => Get.to(() => const ServiceAddressMapScreen()),
                                borderRadius: BorderRadius.circular(10),
                                child: Obx(() {
                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          const _Dot(color: Color(0xFF2E86DE)),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              addrC.selectedAddress.value,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: _C.text,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          const Icon(Icons.edit_location_alt_outlined, size: 18, color: _C.subtext),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      if (addrC.selectedSub.value.trim().isNotEmpty)
                                        Row(
                                          children: [
                                            const _Dot(color: _C.green),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                addrC.selectedSub.value,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: _C.text,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  );
                                }),
                              ),

                              const SizedBox(height: 12),

                              _InfoRow(icon: Icons.calendar_today_outlined, label: "Date:", value: item.date),
                              _InfoRow(icon: Icons.access_time_rounded, label: "Time:", value: item.time),
                              _InfoRow(icon: Icons.settings_outlined, label: "Services:", value: item.service),
                              _InfoRow(icon: Icons.email_outlined, label: "Email:", value: item.email),
                              _InfoRow(icon: Icons.phone_outlined, label: "Phone:", value: item.phone),

                              const SizedBox(height: 10),

                              Row(
                                children: const [
                                  Expanded(
                                    child: _MetricCard(
                                      icon: Icons.schedule,
                                      title: "Duration",
                                      value: "15 min",
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: _MetricCard(
                                      icon: Icons.place_outlined,
                                      title: "Distance",
                                      value: "1.1 Km",
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              // Send message
                              // Send message (center icon + text as one group)
                              InkWell(
                                onTap: () {
                                  // TODO: open chat / message screen
                                  Get.to(() => InboxScreen());
                                },
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  height: 44,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: _C.border),
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min, // ✅ icon + text stick together
                                      children: [
                                        // ✅ If Images.sendMessageIcon is a PNG/JPG asset path:
                                        Image.asset(
                                          Images.sendMessageIcon,
                                          width: 18,
                                          height: 18,
                                          color: _C.subtext,       // remove if you don't want tint
                                          fit: BoxFit.contain,
                                        ),

                                        // ✅ If Images.sendMessageIcon is IconData instead, use this:
                                        // Icon(Images.sendMessageIcon, size: 18, color: _C.subtext),

                                        const SizedBox(width: 10),
                                        const Text(
                                          "Send message",
                                          style: TextStyle(
                                            color: _C.subtext,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            ),

            // Bottom actions
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 6, 14, 14),
                child: Row(
                  children: [
                    Expanded(
                      child: _ActionButton(
                        color: _C.red,
                        icon: Icons.close,
                        label: "Cancel",
                        onTap: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ActionButton(
                        color: _C.greenSoft,
                        icon: Icons.check,
                        label: "Accept",
                        onTap: _confirmAccept,
                      ),
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

/// ---------------------------------------------------------------------------
/// ✅ REAL GOOGLE MAP HEADER (uses AddressFlowController)
/// ---------------------------------------------------------------------------
class _LiveMapHeader extends StatelessWidget {
  const _LiveMapHeader({required this.height, required this.c});
  final double height;
  final AddressFlowController c;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(
              child: Obx(() {
                final target = c.selectedLatLng.value;
                return GoogleMap(
                  initialCameraPosition: CameraPosition(target: target, zoom: 15),
                  onMapCreated: c.onMapCreated,
                  markers: c.markers,
                  myLocationEnabled: c.hasLocationPermission.value,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  onTap: c.pickOnMap,
                );
              }),
            ),

            // right floating buttons
            Positioned(
              right: 10,
              top: 10,
              child: Column(
                children: [
                  _MapFloatBtn(
                    icon: Icons.near_me_outlined,
                    onTap: () async => c.useCurrentLocation(),
                  ),
                  const SizedBox(height: 8),
                  _MapFloatBtn(
                    icon: Icons.add,
                    onTap: () async => c.zoomBy(1),
                  ),
                  const SizedBox(height: 8),
                  _MapFloatBtn(
                    icon: Icons.remove,
                    onTap: () async => c.zoomBy(-1),
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

class _MapFloatBtn extends StatelessWidget {
  const _MapFloatBtn({required this.icon, required this.onTap});
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
          width: 36,
          height: 36,
          child: Center(child: Icon(icon, color: _C.text, size: 20)),
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// DIALOG: Are you ready?
/// ---------------------------------------------------------------------------
class AreYouReadyDialog extends StatelessWidget {
  const AreYouReadyDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 22),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Are you ready?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: _C.text),
            ),
            const SizedBox(height: 8),
            const Text(
              "Are you ready to begin providing the service?",
              textAlign: TextAlign.center,
              style: TextStyle(color: _C.subtext, fontWeight: FontWeight.w600, fontSize: 12.5),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _DialogButton(
                    color: _C.red,
                    label: "No",
                    onTap: () => Navigator.pop(context, false),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DialogButton(
                    color: _C.greenSoft,
                    label: "Yes",
                    onTap: () => Navigator.pop(context, true),
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

class _DialogButton extends StatelessWidget {
  const _DialogButton({
    required this.color,
    required this.label,
    required this.onTap,
  });

  final Color color;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Center(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
            ),
          ),
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// BOTTOM SHEET: Payment Details
/// ---------------------------------------------------------------------------
class PaymentDetailsSheet extends StatelessWidget {
  const PaymentDetailsSheet({
    super.key,
    required this.title,
    required this.serviceName,
    required this.hourlyRate,
    required this.bookedHours,
    required this.minCharge,
    required this.managementFee,
    required this.vat,
    required this.currencySymbol,
  });

  final String title;
  final String serviceName;
  final double hourlyRate;
  final int bookedHours;
  final double minCharge;
  final double managementFee;
  final double vat;
  final String currencySymbol;

  double get subtotal => hourlyRate * bookedHours;
  double get total => subtotal + minCharge + managementFee + vat;

  @override
  Widget build(BuildContext context) {

    final bottomSafe = MediaQuery.of(context).viewPadding.bottom;

    return SafeArea(
      top: false,
      bottom: false,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 10, 16, 16 + bottomSafe),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 46,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDADADA),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: _C.green,
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(18),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F2F2),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.close, size: 16, color: _C.subtext),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _SheetLine(label: serviceName, value: "$currencySymbol${hourlyRate.toStringAsFixed(2)}/h"),
                _SheetLine(label: "Booked hours", value: "${bookedHours}h"),
                const Divider(height: 18, color: _C.divider),
                _SheetLine(label: "Subtotal", value: "$currencySymbol${subtotal.toStringAsFixed(2)}"),
                _SheetLine(
                  label: "Professional’s minimum charge",
                  value: "+ $currencySymbol${minCharge.toStringAsFixed(2)}",
                  withInfo: true,
                ),
                _SheetLine(
                  label: "Management fees",
                  value: "+ $currencySymbol${managementFee.toStringAsFixed(2)}",
                  withInfo: true,
                ),
                _SheetLine(
                  label: "VAT ( heading fee )",
                  value: "+ $currencySymbol${vat.toStringAsFixed(2)}",
                  withInfo: true,
                ),
                const Divider(height: 18, color: _C.divider),
                _SheetLine(
                  label: "Price:",
                  value: "$currencySymbol${total.toStringAsFixed(2)}",
                  bold: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SheetLine extends StatelessWidget {
  const _SheetLine({
    required this.label,
    required this.value,
    this.bold = false,
    this.withInfo = false,
  });

  final String label;
  final String value;
  final bool bold;
  final bool withInfo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: bold ? FontWeight.w900 : FontWeight.w600,
                      color: _C.text,
                    ),
                  ),
                ),
                if (withInfo) ...[
                  const SizedBox(width: 6),
                  const Icon(Icons.info_outline, size: 15, color: _C.subtext),
                ],
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: bold ? FontWeight.w900 : FontWeight.w800,
              color: _C.text,
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// SMALL UI PIECES
/// ---------------------------------------------------------------------------
class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.color,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final Color color;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({this.url});
  final String? url;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 18,
      backgroundColor: const Color(0xFFD9D9D9),
      backgroundImage: (url == null || url!.isEmpty) ? null : NetworkImage(url!),
      child: (url == null || url!.isEmpty)
          ? const Icon(Icons.person, color: Color(0xFF666666), size: 20)
          : null,
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: _C.icon),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              color: _C.text,
              fontWeight: FontWeight.w800,
              fontSize: 12.6,
              height: 1.2,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: _C.value,
                fontWeight: FontWeight.w600,
                fontSize: 12.6,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: _C.metricBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _C.border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: _C.subtext),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: _C.subtext,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 12,
              color: _C.text,
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// COLORS
/// ---------------------------------------------------------------------------
class _C {
  static const green = Color(0xFF27AE60);
  static const greenSoft = Color(0xFF3DA86A);
  static const red = Color(0xFFE53935);

  static const bg = Colors.white;
  static const border = Color(0xFFE5E5E5);
  static const divider = Color(0xFFF0F0F0);
  static const metricBg = Color(0xFFF2F2F2);

  static const text = Color(0xFF111111);
  static const icon = Color(0xFF111111);
  static const value = Color(0xFF6E6E6E);
  static const subtext = Color(0xFF8A8A8A);
}
