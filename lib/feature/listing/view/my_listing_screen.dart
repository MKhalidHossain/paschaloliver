import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'create_listing_screen.dart';
import 'listing_summary_screen.dart';
import 'point_tiers_screen.dart';

class MyListingScreen extends StatefulWidget {
  const MyListingScreen({super.key});

  @override
  State<MyListingScreen> createState() => _MyListingScreenState();
}

class _MyListingScreenState extends State<MyListingScreen> {
  // Colors like screenshots
  static const Color _green = Color(0xFF2FA86A);
  static const Color _text = Color(0xFF1F1F1F);
  static const Color _muted = Color(0xFF8B8B8B);

  // ---- Demo data (replace with API/state) ----
  // If this list is empty => empty state screen
  final List<ListingItem> listings = [
    ListingItem.published(
      title: "Ironing",
      subtitle: "Listing visible",
      tier: "Bronze",
    ),
    ListingItem.published(
      title: "Cleaning",
      subtitle: "Listing visible",
      tier: "Bronze",
    ),
  ];
  final ListingSummary summary = const ListingSummary(
    tierLabel: "Bronze",
    subtitle: "Listing is visible",
    completedServices: 120,
    totalServices: 200,
    nextTierLabel: "Silver",
    progressOverride: 0.70,
  );
  // ------------------------------------------

  bool get isEmpty => listings.isEmpty;

  int _tabIndex = 3; // Listings selected

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // Top header (title + icons)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
                child: Row(
                  children: [
                    Text(
                      "My Listing",
                      style: GoogleFonts.urbanist(
                        color: _text,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      splashRadius: 22,
                      onPressed: () {},
                      icon: const Icon(Icons.search, color: _text, size: 26),
                    ),
                    Stack(
                      children: [
                        IconButton(
                          splashRadius: 22,
                          onPressed: () {},
                          icon: const Icon(
                            Icons.notifications_none_rounded,
                            color: _text,
                            size: 26,
                          ),
                        ),
                        Positioned(
                          right: 16,
                          top: 12,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Expanded(
                child: isEmpty
                    ? _EmptyState(onCreate: _onCreateListing)
                    : _ListingState(
                        items: listings,
                        summary: summary,
                        onOpenSummary: _openTierSummary,
                        onAddNewListing: _onCreateListing,
                        onOpenPublished: (it) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ListingSummaryScreen(
                                title: it.title,
                                subtitle: it.subtitle,
                                tierLabel: it.tier ?? "Bronze",
                                completedServices: summary.completedServices,
                                rating: _ratingForListing(it.title),
                              ),
                            ),
                          );
                        },
                        onOpenIncomplete: (it) {},
                      ),
              ),

              // Bottom Navigation (like screenshot)
              _BottomNav(
                index: _tabIndex,
                onTap: (i) => setState(() => _tabIndex = i),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onCreateListing() {
    // TODO: navigate to create listing flow
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateListingScreen()),
    );
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Create listing tapped")));
  }

  void _openTierSummary() {
    final title = listings.isNotEmpty ? listings.first.title : "My Listing";
    final tier = _parseTier(summary.tierLabel);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PointTiersScreen(
          serviceTitle: title,
          currentTier: tier,
          completedServices: summary.completedServices,
          currentRating: 4.6,
          hasViolations: false,
        ),
      ),
    );
  }

  TierLevel _parseTier(String? tier) {
    switch ((tier ?? "").toLowerCase()) {
      case "silver":
        return TierLevel.silver;
      case "gold":
        return TierLevel.gold;
      case "bronze":
      default:
        return TierLevel.bronze;
    }
  }

  double _ratingForListing(String title) {
    final lower = title.toLowerCase();
    if (lower.contains("iron")) return 4.2;
    if (lower.contains("clean")) return 4.5;
    return 4.4;
  }
}

/* ====================== EMPTY STATE (2nd screenshot) ====================== */

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onCreate});
  final VoidCallback onCreate;

  static const Color _green = Color(0xFF2FA86A);
  static const Color _text = Color(0xFF1F1F1F);
  static const Color _muted = Color(0xFF8B8B8B);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),

        // center illustration (simple megaphone style)
        const _MegaphoneIllustration(),

        const SizedBox(height: 18),
        Text(
          "No listing",
          style: GoogleFonts.urbanist(
            color: _text,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Create your first listing so clients\ncan find you",
          textAlign: TextAlign.center,
          style: GoogleFonts.urbanist(
            color: _muted,
            fontSize: 12.5,
            height: 1.35,
            fontWeight: FontWeight.w500,
          ),
        ),

        const Spacer(),

        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
          child: SizedBox(
            height: 52,
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onCreate,
              style: ElevatedButton.styleFrom(
                backgroundColor: _green,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.add, color: Colors.white),
              label: Text(
                "Create listing",
                style: GoogleFonts.urbanist(
                  color: Colors.white,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MegaphoneIllustration extends StatelessWidget {
  const _MegaphoneIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: CustomPaint(painter: _MegaphonePainter()),
    );
  }
}

class _MegaphonePainter extends CustomPainter {
  static const Color green = Color(0xFF2FA86A);

  @override
  void paint(Canvas canvas, Size size) {
    final grey = Paint()..color = const Color(0xFFDADADA);
    final darkGrey = Paint()..color = const Color(0xFFBDBDBD);
    final g = Paint()..color = green;

    // handle
    canvas.save();
    canvas.translate(size.width * .28, size.height * .68);
    canvas.rotate(-0.45);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width * .36, size.height * .12),
        const Radius.circular(8),
      ),
      grey,
    );
    canvas.restore();

    // horn (green)
    final horn = Path()
      ..moveTo(size.width * .50, size.height * .35)
      ..lineTo(size.width * .88, size.height * .50)
      ..lineTo(size.width * .52, size.height * .68)
      ..close();
    canvas.drawPath(horn, g);

    // horn inner edge
    final hornEdge = Path()
      ..moveTo(size.width * .54, size.height * .42)
      ..lineTo(size.width * .80, size.height * .50)
      ..lineTo(size.width * .56, size.height * .60)
      ..close();
    canvas.drawPath(hornEdge, Paint()..color = green.withOpacity(.18));

    // mouth ring
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * .43,
          size.height * .44,
          size.width * .10,
          size.height * .18,
        ),
        const Radius.circular(10),
      ),
      darkGrey,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/* ====================== TIER SUMMARY CARD ====================== */

class _TierSummaryCard extends StatelessWidget {
  const _TierSummaryCard({required this.summary, required this.onTap});

  final ListingSummary summary;
  final VoidCallback onTap;

  static const Color _bronze = Color(0xFFB35C00);
  static const Color _bronzeLight = Color(0xFFC68948);
  static const Color _bronzeBorder = Color(0xFFE1B684);
  static const Color _progressGreen = Color(0xFF3FA96B);
  static const Color _progressYellow = Color(0xFFFFC21A);
  static const Color _note = Color(0xFFFFD08A);

  @override
  Widget build(BuildContext context) {
    final percent = (summary.progress * 100).round();

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: _bronze,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.08),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    "assets/images/star.png",
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.emoji_events_rounded,
                      color: _bronze,
                      size: 26,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        summary.levelLabel,
                        style: GoogleFonts.urbanist(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        summary.subtitle,
                        style: GoogleFonts.urbanist(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              decoration: BoxDecoration(
                color: _bronzeLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _bronzeBorder.withOpacity(.7)),
              ),
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Complete ${summary.totalServices} services",
                    style: GoogleFonts.urbanist(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _ServiceCompletedPill(
                    progress: summary.progress,
                    percent: percent,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${summary.completedServices}/${summary.totalServices} services completed",
                    style: GoogleFonts.urbanist(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.track_changes, color: _note, size: 16),
                const SizedBox(width: 6),
                Text(
                  "${summary.remainingServices} more services to reach ${summary.nextTierLabel}",
                  style: GoogleFonts.urbanist(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _note,
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

class _ServiceCompletedPill extends StatelessWidget {
  const _ServiceCompletedPill({
    required this.progress,
    required this.percent,
  });

  final double progress;
  final int percent;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 22,
        color: const Color(0xFFEDEDED),
        child: Stack(
          children: [
            // Green progress fill (top strip)
            Align(
              alignment: Alignment.topLeft,
              child: FractionallySizedBox(
                widthFactor: progress.clamp(0.0, 1.0),
                child: Container(
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2FA86A),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(999),
                      topRight: Radius.circular(999),
                      bottomRight: Radius.circular(99),
                    ),
                  ),
                ),
              ),
            ),
            // Yellow bar with text (bottom section)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 14,
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8CF4D),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Service completed",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          height: 1.0,
                          color: Color(0xFF1F1F1F),
                        ),
                      ),
                    ),
                    Text(
                      "$percent%",
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        height: 1.0,
                        color: Color(0xFF1F1F1F),
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

/* ====================== LISTING STATE (3rd/4th/5th) ====================== */

class _ListingState extends StatelessWidget {
  const _ListingState({
    required this.items,
    required this.summary,
    required this.onOpenSummary,
    required this.onAddNewListing,
    required this.onOpenPublished,
    required this.onOpenIncomplete,
  });

  final List<ListingItem> items;
  final ListingSummary summary;
  final VoidCallback onOpenSummary;
  final VoidCallback onAddNewListing;
  final ValueChanged<ListingItem> onOpenPublished;
  final ValueChanged<ListingItem> onOpenIncomplete;

  static const Color _muted = Color(0xFF8B8B8B);

  @override
  Widget build(BuildContext context) {
    final published = items
        .where((e) => e.type == ListingType.published)
        .toList();
    final progress = items
        .where((e) => e.type == ListingType.inProgress)
        .toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
      children: [
        _TierSummaryCard(summary: summary, onTap: onOpenSummary),
        const SizedBox(height: 18),
        if (published.isNotEmpty) ...[
          Text(
            "Published",
            style: GoogleFonts.urbanist(
              color: _muted,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          ...published.map(
            (it) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _PublishedCard(
                item: it,
                onBronzeTap: () => onOpenPublished(it),
              ),
            ),
          ),
        ],

        if (progress.isNotEmpty) ...[
          Text(
            "In progress",
            style: GoogleFonts.urbanist(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF8B8B8B),
            ),
          ),

          const SizedBox(height: 12),
          ...progress.map(
            (it) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _InProgressCard(
                item: it,
                onTapIncomplete: () => onOpenIncomplete(it),
              ),
            ),
          ),
        ],

        // Add new listing button (outlined)
        const SizedBox(height: 2),
        _AddNewListingButton(onTap: onAddNewListing),
      ],
    );
  }
}

/* ---------------- Published Card ---------------- */

class _PublishedCard extends StatelessWidget {
  const _PublishedCard({required this.item, required this.onBronzeTap});
  final ListingItem item;
  final VoidCallback onBronzeTap;

  static const Color _cardBorder = Color(0xFFF1F1F1);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onBronzeTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _cardBorder, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.06),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            _ServiceIcon(kind: item.title),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: GoogleFonts.urbanist(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF181919),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.subtitle,
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF6F6F6F),
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

/* ---------------- In Progress Card ---------------- */

class _InProgressCard extends StatelessWidget {
  const _InProgressCard({required this.item, required this.onTapIncomplete});

  final ListingItem item;
  final VoidCallback onTapIncomplete;

  static const Color _cardBorder = Color(0xFFE9E9E9);
  static const Color _green = Color(0xFF2FA86A);
  static const Color _yellow = Color(0xFFF3B400);

  @override
  Widget build(BuildContext context) {
    final p = (item.progress ?? 0).clamp(0.0, 1.0);
    final percent = (p * 100).round();

    return InkWell(
      onTap: onTapIncomplete,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _cardBorder, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.06),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _ServiceIcon(kind: item.title),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: GoogleFonts.urbanist(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF181919),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.subtitle,
                        style: GoogleFonts.urbanist(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF6F6F6F),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: Container(
                height: 10,
                color: const Color(0xFFEAEAEA),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: p,
                    child: Container(color: _green),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "$percent% Complete",
              style: GoogleFonts.urbanist(
                color: const Color(0xFF7A7A7A),
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _yellow,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                "Incomplete",
                style: GoogleFonts.urbanist(
                  color: Colors.black,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ---------------- Add New Listing (outlined) ---------------- */

class _AddNewListingButton extends StatelessWidget {
  const _AddNewListingButton({required this.onTap});
  final VoidCallback onTap;

  static const Color _green = Color(0xFF2FA86A);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: OutlinedButton.icon(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: _green,
          side: const BorderSide(color: _green, width: 1.6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        icon: const Icon(Icons.add, size: 20),
        label: Text(
          "Add new listing",
          style: GoogleFonts.urbanist(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            height: 1.1,
            color: const Color(0xFF3FA96B), // ✅ #3FA96B
          ),
        ),
      ),
    );
  }
}

/* ---------------- Service Icon (simple) ---------------- */

class _ServiceIcon extends StatelessWidget {
  const _ServiceIcon({required this.kind});
  final String kind;

  @override
  Widget build(BuildContext context) {
    final asset = kind.toLowerCase().contains("iron")
        ? "assets/calender/ironing.png"
        : "assets/calender/cleaning.png";

    return SizedBox(
      width: 54,
      height: 54,
      child: Center(
        child: Image.asset(
          asset,
          width: 46,
          height: 46,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => const Icon(
            Icons.cleaning_services_rounded,
            size: 28,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}

/* ====================== Bottom Nav ====================== */

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.index, required this.onTap});
  final int index;
  final ValueChanged<int> onTap;

  static const Color _green = Color(0xFF2FA86A);
  static const Color _muted = Color(0xFF8B8B8B);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEDEDED), width: 1)),
      ),
      child: Row(
        children: [
          _NavItem(
            icon: Icons.calendar_today_rounded,
            label: "Calendar",
            selected: index == 0,
            onTap: () => onTap(0),
          ),
          _NavItem(
            icon: Icons.receipt_long_rounded,
            label: "Requests",
            selected: index == 1,
            onTap: () => onTap(1),
          ),
          _NavItem(
            icon: Icons.chat_bubble_outline_rounded,
            label: "Inbox",
            selected: index == 2,
            onTap: () => onTap(2),
          ),
          _NavItem(
            icon: Icons.list_alt_rounded,
            label: "Listings",
            selected: index == 3,
            onTap: () => onTap(3),
            selectedColor: _green,
          ),
          _NavItem(
            icon: Icons.person_outline_rounded,
            label: "Profile",
            selected: index == 4,
            onTap: () => onTap(4),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.selectedColor,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? selectedColor;

  static const Color _green = Color(0xFF2FA86A);
  static const Color _muted = Color(0xFF8B8B8B);

  @override
  Widget build(BuildContext context) {
    final c = selected ? (selectedColor ?? _green) : _muted;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(icon, color: c, size: 22),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  color: c,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ====================== Summary Model ====================== */

class ListingSummary {
  final String tierLabel;
  final String subtitle;
  final int completedServices;
  final int totalServices;
  final String nextTierLabel;
  final double? progressOverride;

  const ListingSummary({
    required this.tierLabel,
    required this.subtitle,
    required this.completedServices,
    required this.totalServices,
    required this.nextTierLabel,
    this.progressOverride,
  });

  String get levelLabel => "$tierLabel Level";

  int get remainingServices {
    final remaining = totalServices - completedServices;
    return remaining < 0 ? 0 : remaining;
  }

  double get progress {
    if (progressOverride != null) {
      final value = progressOverride!;
      if (value < 0) return 0;
      if (value > 1) return 1;
      return value;
    }
    if (totalServices <= 0) return 0;
    final raw = completedServices / totalServices;
    if (raw < 0) return 0;
    if (raw > 1) return 1;
    return raw;
  }
}

/* ====================== Model ====================== */

enum ListingType { published, inProgress }

class ListingItem {
  final ListingType type;
  final String title;
  final String subtitle;

  // published
  final String? tier;

  // progress
  final double? progress;

  ListingItem._(
    this.type, {
    required this.title,
    required this.subtitle,
    this.tier,
    this.progress,
  });

  factory ListingItem.published({
    required String title,
    required String subtitle,
    required String tier,
  }) => ListingItem._(
    ListingType.published,
    title: title,
    subtitle: subtitle,
    tier: tier,
  );

  factory ListingItem.inProgress({
    required String title,
    required String subtitle,
    required double progress,
  }) => ListingItem._(
    ListingType.inProgress,
    title: title,
    subtitle: subtitle,
    progress: progress,
  );
}
