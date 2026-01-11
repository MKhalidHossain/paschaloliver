import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/constants/assets.dart';

/// ✅ USER SERVICE VIEW DETAILS (PRO UI + Payment Details Bottom Sheet)
class UserServiceViewDetailsScreen extends StatelessWidget {
  const UserServiceViewDetailsScreen({super.key});

  static const _green = Color(0xFF2FA86A);
  static const _text = Color(0xFF1F1F1F);
  static const _muted = Color(0xFF8B8B8B);
  static const _line = Color(0xFFEDEDED);
  static const _pill = Color(0xFFEFEFEF);
  static const _danger = Color(0xFFFF1E3A);

  // Toggle: show illustration header like your 3rd screenshot
  final bool showHeroHeader = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
          children: [
            // ✅ Back Arrow
            SizedBox(
              height: 48,
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Get.back(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 18,
                    color: _green,
                  ),
                ),
              ),
            ),

            // ✅ TOP MAP (no gestures so ListView scroll stays smooth)
            _TopMediaCard(
              height: 140,
              child: const _TopMapPreview(),
            ),

            const SizedBox(height: 12),

            // Provider row
            _ProviderStrip(
              avatar: Images.men,
              name: "Mr. Hamid",
              subtitle: "Professional",
              rating: 4.8,
            ),

            const SizedBox(height: 14),

            // Main details card
            Container(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _line),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.06),
                    blurRadius: 16,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + status pill
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          "Cleaning Service",
                          style: TextStyle(
                            fontFamily: "Urbanist",
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: _text,
                            height: 1.1,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: _pill,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          "Accepted",
                          style: TextStyle(
                            fontFamily: "Urbanist",
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF777777),
                            height: 1.1,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // View payment details (tap -> bottom sheet)
                  _PaymentChevronRow(
                    title: "View payment details",
                    onTap: () => _openPaymentDetails(context),
                  ),

                  const SizedBox(height: 12),
                  const Divider(height: 1, thickness: 1, color: _line),
                  const SizedBox(height: 12),

                  // Addresses
                  const _DotRow(text: "Road No. 6 Avenue - 05"),
                  const SizedBox(height: 10),
                  const _DotRow(text: "Moroccan university road"),

                  const SizedBox(height: 14),

                  // Meta rows
                  const _MetaRow(icon: Icons.calendar_month_outlined, label: "Date:", value: "12 July 2025"),
                  const SizedBox(height: 12),
                  const _MetaRow(icon: Icons.access_time_rounded, label: "Time:", value: "10:00 AM–11 AM"),
                  const SizedBox(height: 12),
                  const _MetaRow(icon: Icons.cleaning_services_outlined, label: "Services:", value: "Cleaner"),
                  const SizedBox(height: 12),
                  const _MetaRow(icon: Icons.mail_outline_rounded, label: "Email:", value: "example@gmail.com"),
                  const SizedBox(height: 12),
                  const _MetaRow(icon: Icons.call_outlined, label: "Phone:", value: "012562589663"),

                  const SizedBox(height: 14),

                  // Duration / Distance
                  Row(
                    children: [
                      const Expanded(
                        child: _SmallStatCard(
                          icon: Icons.access_time_rounded,
                          title: "Duration",
                          value: "2h",
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SmallStatCard(
                          icon: Images.locationMessageIcon,
                          title: "Distance",
                          value: "1.1 Km",
                        ),
                      ),
                    ],
                  ),


                  const SizedBox(height: 16),

                  // Send message
                  SizedBox(
                    height: 46,
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFBDBDBD)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      icon:  Image.asset(
                        Images.sendMessageIcon,
                        width: 15,
                        height: 15,
                        color: const Color(0xFF727272),
                        colorBlendMode: BlendMode.srcIn,
                      ),

                      label: const Text(
                        "Send massage",
                        style: TextStyle(
                          fontFamily: "Urbanist",
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                          color: _text,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Cancel booking
                  SizedBox(
                    height: 46,
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _confirmCancel(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _danger,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      icon: const Icon(Icons.close_rounded, color: Colors.white, size: 18),
                      label: const Text(
                        "Cancel Booking",
                        style: TextStyle(
                          fontFamily: "Urbanist",
                          fontSize: 13.5,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
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
    );
  }

  /// ✅ FIXED: No left/right/bottom gaps (sheet attaches to screen edges)
  static void _openPaymentDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(.35),
      builder: (_) => const _ServicePriceSheet(
        serviceName: "Cleaning",
        hourlyRate: 12.50,
        bookedHours: 2,
        minCharge: 12.50,
        managementFee: 0.83,
        vatFee: 0.17,
      ),
    );
  }

  static void _confirmCancel(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Cancel booking?"),
        content: const Text("Are you sure you want to cancel this booking?"),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("No")),
          TextButton(onPressed: () => Get.back(), child: const Text("Yes")),
        ],
      ),
    );
  }
}




/* ========================= GOOGLE MAP PREVIEW (TOP) ========================= */

class _TopMapPreview extends StatelessWidget {
  const _TopMapPreview();

  // ✅ Change to your real booking/service location
  static const LatLng _center = LatLng(33.5731, -7.5898); // Casablanca

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: const CameraPosition(target: _center, zoom: 15),
      // markers: const {Marker(markerId: MarkerId("service_location"), position: _center)},
      scrollGesturesEnabled: false,
      zoomGesturesEnabled: false,
      rotateGesturesEnabled: false,
      tiltGesturesEnabled: false,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      compassEnabled: false,
      mapToolbarEnabled: false,
    );
  }
}

/* ----------------------------- TOP MEDIA CARD ----------------------------- */

class _TopMediaCard extends StatelessWidget {
  const _TopMediaCard({required this.child, required this.height});
  final Widget child;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: height,
        width: double.infinity,
        color: const Color(0xFFF2F2F2),
        child: child,
      ),
    );
  }
}

/* ----------------------------- PROVIDER STRIP ----------------------------- */

class _ProviderStrip extends StatelessWidget {
  const _ProviderStrip({
    required this.avatar,
    required this.name,
    required this.subtitle,
    required this.rating,
  });

  final String avatar;
  final String name;
  final String subtitle;
  final double rating;

  static const _text = Color(0xFF1F1F1F);
  static const _muted = Color(0xFF8B8B8B);
  static const _line = Color(0xFFEDEDED);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _line),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: Image.asset(avatar, width: 40, height: 40, fit: BoxFit.cover),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontFamily: "Urbanist",
                    fontSize: 14.5,
                    fontWeight: FontWeight.w900,
                    color: _text,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: "Urbanist",
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _muted,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(
              fontFamily: "Urbanist",
              fontSize: 12.5,
              fontWeight: FontWeight.w900,
              color: _text,
            ),
          ),
          const SizedBox(width: 6),
          const Icon(Icons.star_rounded, color: Color(0xFFF4B400), size: 18),
        ],
      ),
    );
  }
}

/* ----------------------------- PAYMENT ROW ----------------------------- */

class _PaymentChevronRow extends StatelessWidget {
  const _PaymentChevronRow({required this.title, required this.onTap});
  final String title;
  final VoidCallback onTap;

  static const _green = Color(0xFF2FA86A);
  static const _text = Color(0xFF1F1F1F);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: _green.withOpacity(.10),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.payment, size: 16, color: _green),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: "Urbanist",
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: _text,
                    height: 1.1,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right_rounded, size: 22, color: _text),
            ],
          ),
        ),
      ),
    );
  }
}

/* ----------------------------- DOT + META ----------------------------- */

class _DotRow extends StatelessWidget {
  const _DotRow({required this.text});
  final String text;

  static const _text = Color(0xFF1F1F1F);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 7, height: 7, decoration: const BoxDecoration(color: Color(0xFF2FA86A), shape: BoxShape.circle)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: "Urbanist",
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: _text,
              height: 1.2,
            ),
          ),
        ),
      ],
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  static const _text = Color(0xFF1F1F1F);
  static const _muted = Color(0xFF8B8B8B);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: _text),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(
            fontFamily: "Urbanist",
            fontSize: 12.5,
            fontWeight: FontWeight.w800,
            color: _text,
            height: 1.1,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontFamily: "Urbanist",
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: _muted,
              height: 1.2,
            ),
          ),
        ),
      ],
    );
  }
}

class _SmallStatCard extends StatelessWidget {
  const _SmallStatCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  final dynamic icon; // IconData or String
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEAEAEA)),
      ),
      child: Row(
        children: [
          appIcon(icon, size: 16, color: const Color(0xFF727272)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF727272))),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget appIcon(dynamic icon, {double size = 18, Color? color}) {
  // Material icon
  if (icon is IconData) {
    return Icon(icon, size: size, color: color);
  }

  // Asset path
  if (icon is String) {

    return Image.asset(
      icon,
      width: size,
      height: size,
      fit: BoxFit.contain,
      color: color,
      colorBlendMode: color == null ? null : BlendMode.srcIn,
    );
  }

  return SizedBox(width: size, height: size);
}





/* ============================ SERVICE PRICE SHEET ============================ */
/* ✅ FIXED: no outer margin/gap. Sheet attaches to left/right/bottom edges. */

class _ServicePriceSheet extends StatelessWidget {
  const _ServicePriceSheet({
    required this.serviceName,
    required this.hourlyRate,
    required this.bookedHours,
    required this.minCharge,
    required this.managementFee,
    required this.vatFee,
  });

  final String serviceName;
  final double hourlyRate;
  final int bookedHours;
  final double minCharge;
  final double managementFee;
  final double vatFee;

  static const _green = Color(0xFF2FA86A);
  static const _text = Color(0xFF1F1F1F);
  static const _muted = Color(0xFF8B8B8B);
  static const _line = Color(0xFFEDEDED);

  String _money(double v) => "₦${v.toStringAsFixed(2)}";

  @override
  Widget build(BuildContext context) {
    final subtotal = hourlyRate * bookedHours;
    final total = subtotal + minCharge + managementFee + vatFee;

    final bottomSafe = MediaQuery.of(context).padding.bottom;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: double.infinity,

          // ✅ NO MARGIN => removes the red gaps (left/right/bottom)
          margin: EdgeInsets.zero,

          // ✅ keep safe-area space INSIDE the sheet (not outside)
          padding: EdgeInsets.fromLTRB(16, 10, 16, 16 + bottomSafe),

          decoration: BoxDecoration(
            color: Colors.white,

            // ✅ only top corners rounded (looks like your screenshot + no side gaps)
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.18),
                blurRadius: 22,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top handle
              Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFD6D6D6),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 12),

              // Header
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Service price",
                      style: TextStyle(
                        fontFamily: "Urbanist",
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: _green,
                        height: 1.1,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => Get.back(),
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: _line),
                      ),
                      child: const Icon(Icons.close_rounded, size: 18, color: _muted),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
              const Divider(height: 1, thickness: 1, color: _line),
              const SizedBox(height: 10),

              _PriceRow(left: serviceName, right: "${_money(hourlyRate)}/h"),
              const SizedBox(height: 10),
              _PriceRow(left: "Booked hours", right: "${bookedHours}h"),
              const SizedBox(height: 10),
              _PriceRow(left: "Subtotal", right: _money(subtotal)),

              const SizedBox(height: 12),
              const Divider(height: 1, thickness: 1, color: _line),
              const SizedBox(height: 12),

              _PriceRow(left: "Professional's minimum charge", right: "+ ${_money(minCharge)}", showInfo: true),
              const SizedBox(height: 10),
              _PriceRow(left: "Management fees", right: "+ ${_money(managementFee)}", showInfo: true),
              const SizedBox(height: 10),
              _PriceRow(left: "VAT ( heading fee )", right: "+ ${_money(vatFee)}", showInfo: true),

              const SizedBox(height: 12),
              const Divider(height: 1, thickness: 1, color: _line),
              const SizedBox(height: 12),

              Row(
                children: [
                  const Text(
                    "Price:",
                    style: TextStyle(
                      fontFamily: "Urbanist",
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: _text,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _money(total),
                    style: const TextStyle(
                      fontFamily: "Urbanist",
                      fontSize: 13.5,
                      fontWeight: FontWeight.w900,
                      color: _text,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: _green, width: 1.2),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text(
                          "Exit",
                          style: TextStyle(
                            fontFamily: "Urbanist",
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: _green,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () => Get.back(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _green,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text(
                          "Remain",
                          style: TextStyle(
                            fontFamily: "Urbanist",
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),
              // Bottom small indicator (inside)
              Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({
    required this.left,
    required this.right,
    this.showInfo = false,
  });

  final String left;
  final String right;
  final bool showInfo;

  static const _text = Color(0xFF1F1F1F);
  static const _muted = Color(0xFF8B8B8B);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            children: [
              Flexible(
                child: Text(
                  left,
                  style: const TextStyle(
                    fontFamily: "Urbanist",
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: _text,
                    height: 1.1,
                  ),
                ),
              ),
              if (showInfo) ...[
                const SizedBox(width: 6),
                const Icon(Icons.info_outline_rounded, size: 16, color: _muted),
              ],
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          right,
          style: const TextStyle(
            fontFamily: "Urbanist",
            fontSize: 12.5,
            fontWeight: FontWeight.w800,
            color: _text,
            height: 1.1,
          ),
        ),
      ],
    );
  }
}
