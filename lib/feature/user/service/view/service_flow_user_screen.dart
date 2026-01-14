import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paschaloliver/feature/user/service/view/service_details_user.dart';

import '../../../../core/constants/assets.dart';

/// ✅ USER SERVICES (Upcoming / Past / Canceled) — LOGICALLY HANDLED
///
/// Requirements (ASSET):
/// - Add this in assets.dart:
///   static const String servicesEmpty = "assets/images/services_empty.png";
/// - And pubspec.yaml include: assets/images/
///
/// Behavior:
/// - Upcoming:
///   - If no upcoming items => show empty state (image from Images.servicesEmpty)
///   - Still shows "Do you want to repeat?" section (suggestions)
///   - If upcoming items exist => shows upcoming cards with "View details"
/// - Past:
///   - List cards with "Repeat" button
/// - Canceled:
///   - List cards with "Request declined" (red) button

class UserServicesScreen extends StatefulWidget {
  const UserServicesScreen({super.key});

  @override
  State<UserServicesScreen> createState() => _UserServicesScreenState();
}

class _UserServicesScreenState extends State<UserServicesScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  static const _green = Color(0xFF2FA86A);
  static const _text = Color(0xFF1F1F1F);
  static const _line = Color(0xFFEDEDED);

  // ------------------ DEMO DATA (replace with API) ------------------
  final List<_ServiceItem> _all = [
    // Upcoming (uncomment to test upcoming list)
    // _ServiceItem(
    //   status: _ServiceStatus.upcoming,
    //   providerName: "Nicolas bond",
    //   serviceName: "House Cleaning",
    //   pricePerHour: 20.50,
    //   servicesCount: 656,
    //   rating: 4.8,
    //   reviewsText: "4,323 Reviews",
    // ),

    // Past (for Past tab)
    _ServiceItem(
      status: _ServiceStatus.past,
      providerName: "Nicolas bond",
      serviceName: "Cleaning",
      dateText: "Thursday, 9 Oct. 2025",
      timeText: "Thursday, 9 Oct. 2025",
    ),
    _ServiceItem(
      status: _ServiceStatus.past,
      providerName: "Nicolas bond",
      serviceName: "Cleaning",
      dateText: "Thursday, 9 Oct. 2025",
      timeText: "Thursday, 9 Oct. 2025",
    ),
    _ServiceItem(
      status: _ServiceStatus.past,
      providerName: "Nicolas bond",
      serviceName: "Handyman",
      dateText: "Thursday, 9 Oct. 2025",
      timeText: "Thursday, 9 Oct. 2025",
    ),

    // Canceled (for Canceled tab)
    _ServiceItem(
      status: _ServiceStatus.canceled,
      providerName: "Nicolas bond",
      serviceName: "Cleaning",
      dateText: "Thursday, 9 Oct. 2025",
      timeText: "Thursday, 9 Oct. 2025",
    ),
    _ServiceItem(
      status: _ServiceStatus.canceled,
      providerName: "Nicolas bond",
      serviceName: "Cleaning",
      dateText: "Thursday, 9 Oct. 2025",
      timeText: "Thursday, 9 Oct. 2025",
    ),
    _ServiceItem(
      status: _ServiceStatus.canceled,
      providerName: "Nicolas bond",
      serviceName: "Handyman",
      dateText: "Thursday, 9 Oct. 2025",
      timeText: "Thursday, 9 Oct. 2025",
    ),
  ];

  // Suggestions shown in Upcoming under “Do you want to repeat?”
  // (This matches your screenshot even when Upcoming is empty)
  final List<_ServiceItem> _repeatSuggestions = const [
    _ServiceItem(
      status: _ServiceStatus.suggestion,
      providerName: "Nicolas bond",
      serviceName: "House Cleaning",
      pricePerHour: 20.50,
      servicesCount: 656,
      rating: 4.8,
      reviewsText: "4,323 Reviews",
    ),
  ];

  // -----------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  List<_ServiceItem> _byStatus(_ServiceStatus s) =>
      _all.where((e) => e.status == s).toList();

  @override
  Widget build(BuildContext context) {
    final upcoming = _byStatus(_ServiceStatus.upcoming);
    final past = _byStatus(_ServiceStatus.past);
    final canceled = _byStatus(_ServiceStatus.canceled);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 14),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Services",
                style: GoogleFonts.urbanist(
                  fontSize: 24,
                  fontWeight: FontWeight.w600, // SemiBold
                  height: 1.1,
                  color: const Color(0xFF3FA96B),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TabBar(
                controller: _tab,
                indicatorColor: _green,
                indicatorWeight: 2,
                labelColor: const Color(0xFF181919),
                unselectedLabelColor: const Color(0xFF181919), // change if Figma differs
                labelStyle: GoogleFonts.urbanist(
                  fontSize: 16,
                  fontWeight: FontWeight.w500, // Medium
                  height: 1.2,
                ),
                unselectedLabelStyle: GoogleFonts.urbanist(
                  fontSize: 16,
                  fontWeight: FontWeight.w500, // Medium (same as Figma text)
                  height: 1.2,
                ),
                tabs: const [
                  Tab(text: "Upcoming"),
                  Tab(text: "Past"),
                  Tab(text: "Cancelled"),
                ],
              ),
            ),

            const Divider(height: 1, thickness: 1, color: _line),

            Expanded(
              child: TabBarView(
                controller: _tab,
                children: [
                  _UpcomingTab(
                    upcoming: upcoming,
                    repeatSuggestions: _repeatSuggestions,
                  ),
                  _PastTab(items: past),
                  _CanceledTab(items: canceled),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ============================ UPCOMING TAB ============================ */

class _UpcomingTab extends StatelessWidget {
  const _UpcomingTab({
    required this.upcoming,
    required this.repeatSuggestions,
  });

  final List<_ServiceItem> upcoming;
  final List<_ServiceItem> repeatSuggestions;

  static const _green = Color(0xFF2FA86A);

  @override
  Widget build(BuildContext context) {
    final hasUpcoming = upcoming.isNotEmpty;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      children: [
        // EMPTY STATE only when no upcoming
        if (!hasUpcoming) ...[
          _UpcomingEmptyState(
            imageAsset: Images.NoFavoIcon, // ✅ red portion image from Images.
            text: "You have no pending services",
          ),
          const SizedBox(height: 18),
        ],

        // If there are upcoming services, show list (like 3rd screenshot)
        if (hasUpcoming) ...[
          ...upcoming.map(
                (e) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _UpcomingServiceCard(
                item: e,
                onViewDetails: () {
                  // TODO: navigate to details
                  // Get.to(() => const UserServiceViewDetailsScreen());
                },
                onFavoriteTap: () {
                  // TODO
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],

        // “Do you want to repeat?” section (shows in your screenshot)
        if (repeatSuggestions.isNotEmpty) ...[
          Text(
            "Do you want to repeat?",
            style: GoogleFonts.urbanist(
              fontSize: 24,
              fontWeight: FontWeight.w600, // SemiBold
              height: 1.1,
              color: const Color(0xFF3FA96B),
            ),
          ),
          const SizedBox(height: 12),
          ...repeatSuggestions.map(
                (e) => _UpcomingServiceCard(
              item: e,
              onViewDetails: () {
                // TODO: navigate
                Get.to(() => const UserServiceViewDetailsScreen());
              },
              onFavoriteTap: () {
                // TODO
              },
            ),
          ),
        ],
      ],
    );
  }
}

class _UpcomingEmptyState extends StatelessWidget {
  const _UpcomingEmptyState({
    required this.imageAsset,
    required this.text,
  });

  final String imageAsset;
  final String text;

  static const _muted = Color(0xFF8B8B8B);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEDEDED)),
      ),
      child: Column(
        children: [
          Image.asset(
            imageAsset,
            height: 120,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: const TextStyle(
              fontFamily: "Urbanist",
              fontSize: 12.8,
              fontWeight: FontWeight.w600,
              color: _muted,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

/* ============================ PAST TAB ============================ */

class _PastTab extends StatelessWidget {
  const _PastTab({required this.items});
  final List<_ServiceItem> items;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      children: [
        Text(
          "Do you want to repeat?",
          style: GoogleFonts.urbanist(
            fontSize: 24,
            fontWeight: FontWeight.w600, // SemiBold
            height: 1.1,
            color: const Color(0xFF3FA96B),
          ),
        ),
        const SizedBox(height: 12),
        ...items.map(
              (e) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _PastServiceCard(
              item: e,
              onRepeat: () {
                // TODO: repeat action
              },
            ),
          ),
        ),
      ],
    );
  }
}

/* ============================ CANCELED TAB ============================ */

class _CanceledTab extends StatelessWidget {
  const _CanceledTab({required this.items});
  final List<_ServiceItem> items;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      children: [
        ...items.map(
              (e) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _CanceledServiceCard(item: e),
          ),
        ),
      ],
    );
  }
}

/* ============================ CARDS ============================ */

class _UpcomingServiceCard extends StatelessWidget {
  const _UpcomingServiceCard({
    required this.item,
    required this.onViewDetails,
    required this.onFavoriteTap,
  });

  final _ServiceItem item;
  final VoidCallback onViewDetails;
  final VoidCallback onFavoriteTap;

  static const _green = Color(0xFF2FA86A);
  static const _text = Color(0xFF1F1F1F);
  static const _muted = Color(0xFF8B8B8B);
  static const _chipBg = Color(0xFFF3F3F3);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE9E9E9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // avatar
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  Images.men,
                  width: 54,
                  height: 54,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            item.providerName ?? "Nicolas bond",
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.urbanist(
                              fontSize: 12,
                              fontWeight: FontWeight.w400, // Regular
                              height: 1.1,
                              color: const Color(0xFF3B3B3B),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const _VerifiedDot(),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.serviceName ?? "House Cleaning",
                      style: GoogleFonts.urbanist(
                        fontSize: 14,
                        fontWeight: FontWeight.w500, // Medium
                        height: 1.1,
                        color: const Color(0xFF181919),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          "₦${(item.pricePerHour ?? 20.50).toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontFamily: "Urbanist",
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            color: _green,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          "Per hour",
                          style: TextStyle(
                            fontFamily: "Urbanist",
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: _muted,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _Stars(rating: item.rating ?? 4.8),
                        const SizedBox(width: 6),
                        Text(
                          (item.rating ?? 4.8).toStringAsFixed(1),
                          style: GoogleFonts.urbanist(
                            fontSize: 12,
                            fontWeight: FontWeight.w400, // Regular
                            height: 1.1,
                            color: const Color(0xFF3B3B3B),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          item.reviewsText ?? "4,323 Reviews",
                          style: GoogleFonts.urbanist(
                            fontSize: 12,
                            fontWeight: FontWeight.w400, // Regular
                            height: 1.1,
                            color: const Color(0xFF3B3B3B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: onFavoriteTap,
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.favorite_border_rounded,
                        size: 18,
                        color: _green,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    "${item.servicesCount ?? 656} Services",
                    style: GoogleFonts.urbanist(
                      fontSize: 12,
                      fontWeight: FontWeight.w500, // Medium
                      height: 1.1,
                      color: const Color(0xFF3B3B3B),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // chips 2x2
          const Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _InfoChip(
                      icon: Icons.badge_outlined,
                      text: "Business Profile",
                      bg: _chipBg,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _InfoChip(
                      icon: Icons.repeat_rounded,
                      text: "7 have repeated",
                      bg: _chipBg,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _InfoChip(
                      icon: Icons.calendar_month_outlined,
                      text: "Updated schedule",
                      bg: _chipBg,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _InfoChip(
                      icon: Icons.attach_money_rounded,
                      text: "Minimum charge ₦30",
                      bg: _chipBg,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // action button (View details)
          SizedBox(
            width: double.infinity,
            height: 42,
            child: ElevatedButton(
              onPressed: onViewDetails,
              style: ElevatedButton.styleFrom(
                backgroundColor: _green,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "View details",
                style: GoogleFonts.urbanist(
                  fontSize: 16,
                  fontWeight: FontWeight.w500, // Medium
                  height: 1.1,
                  color: Colors.white,         // change if your button text isn't white
                  decoration: TextDecoration.underline,
                  decorationStyle: TextDecorationStyle.solid,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PastServiceCard extends StatelessWidget {
  const _PastServiceCard({
    required this.item,
    required this.onRepeat,
  });

  final _ServiceItem item;
  final VoidCallback onRepeat;

  static const _green = Color(0xFF2FA86A);
  static const _text = Color(0xFF1F1F1F);
  static const _muted = Color(0xFF8B8B8B);

  @override
  Widget build(BuildContext context) {
    final date = item.dateText ?? "Thursday, 9 Oct. 2025";
    final time = item.timeText ?? "Thursday, 9 Oct. 2025";

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE9E9E9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  Images.men,
                  width: 54,
                  height: 54,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.serviceName ?? "Cleaning",
                      style: GoogleFonts.urbanist(
                        fontSize: 14,
                        fontWeight: FontWeight.w500, // Medium
                        height: 1.1,
                        color: const Color(0xFF181919),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            item.providerName ?? "Nicolas bond",
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.urbanist(
                              fontSize: 12,
                              fontWeight: FontWeight.w400, // Regular
                              height: 1.1,
                              color: const Color(0xFF3B3B3B), // use #727272 if your design uses that
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const _VerifiedDot(),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_month_outlined,
                          size: 16,
                          color: Color(0xFF18191A),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          date,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w400, // Regular
                            height: 1.2,                 // 120%
                            color: const Color(0xFF18191A),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          size: 16,
                          color: Color(0xFF18191A),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          time,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            height: 1.2,
                            color: const Color(0xFF18191A),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 42,
            child: ElevatedButton.icon(
              onPressed: onRepeat,
              style: ElevatedButton.styleFrom(
                backgroundColor: _green,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: Image.asset(
                Images.refreshIcon, // or refreshIcon if that's your const
                width: 10,
                height: 10,
                color: Colors.white,
                colorBlendMode: BlendMode.srcIn,
              ),

              label: Text(
                "Repeat",
                style: GoogleFonts.urbanist(
                  fontSize: 16,
                  fontWeight: FontWeight.w500, // Medium
                  height: 1.1,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CanceledServiceCard extends StatelessWidget {
  const _CanceledServiceCard({required this.item});
  final _ServiceItem item;

  static const _text = Color(0xFF1F1F1F);
  static const _muted = Color(0xFF8B8B8B);
  static const _danger = Color(0xFFC9304A);

  @override
  Widget build(BuildContext context) {
    final date = item.dateText ?? "Thursday, 9 Oct. 2025";
    final time = item.timeText ?? "Thursday, 9 Oct. 2025";

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE9E9E9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  Images.men,
                  width: 54,
                  height: 54,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.serviceName ?? "Cleaning",
                      style: GoogleFonts.urbanist(
                        fontSize: 14,
                        fontWeight: FontWeight.w500, // Medium
                        height: 1.1,
                        color: const Color(0xFF181919),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            item.providerName ?? "Nicolas bond",
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w400, // Regular
                              height: 1.2,                 // 120%
                              color: const Color(0xFF3B3B3B),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const _VerifiedDot(),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_month_outlined,
                          size: 16,
                          color: Color(0xFF18191A),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          date,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            height: 1.2,
                            color: const Color(0xFF18191A),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          size: 16,
                          color: Color(0xFF18191A),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          time,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            height: 1.2,
                            color: const Color(0xFF18191A),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 42,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Request declined",
                style: GoogleFonts.urbanist(
                  fontSize: 16,
                  fontWeight: FontWeight.w500, // Medium
                  height: 1.1,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ============================ SMALL WIDGETS ============================ */

class _VerifiedDot extends StatelessWidget {
  const _VerifiedDot({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      Images.checkBadgeIcon,
      width: 16,
      height: 16,
      fit: BoxFit.contain,
    );
  }
}


class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.text,
    required this.bg,
  });

  final IconData icon;
  final String text;
  final Color bg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5EEFF)), // if you use this border
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF3B3B3B)),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.urbanist(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 1.1,
                color: const Color(0xFF3B3B3B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _Stars extends StatelessWidget {
  const _Stars({required this.rating});
  final double rating;

  @override
  Widget build(BuildContext context) {
    final full = rating.floor().clamp(0, 5);
    final half = (rating - full) >= 0.5 && full < 5;

    final stars = <Widget>[];
    for (int i = 0; i < 5; i++) {
      if (i < full) {
        stars.add(const Icon(Icons.star_rounded,
            size: 14, color: Color(0xFFF4B400)));
      } else if (i == full && half) {
        stars.add(const Icon(Icons.star_half_rounded,
            size: 14, color: Color(0xFFF4B400)));
      } else {
        stars.add(const Icon(Icons.star_border_rounded,
            size: 14, color: Color(0xFFF4B400)));
      }
    }
    return Row(children: stars);
  }
}

/* ============================ MODEL ============================ */

enum _ServiceStatus { upcoming, past, canceled, suggestion }

class _ServiceItem {
  final _ServiceStatus status;

  // Upcoming / Suggestion card fields
  final String? providerName;
  final String? serviceName;
  final double? pricePerHour;
  final int? servicesCount;
  final double? rating;
  final String? reviewsText;

  // Past / Canceled card fields
  final String? dateText;
  final String? timeText;

  const _ServiceItem({
    required this.status,
    this.providerName,
    this.serviceName,
    this.pricePerHour,
    this.servicesCount,
    this.rating,
    this.reviewsText,
    this.dateText,
    this.timeText,
  });
}
