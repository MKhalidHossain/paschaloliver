import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'create_listing_screen.dart';
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
  static const Color _line = Color(0xFFEDEDED);
  static const Color _cardBorder = Color(0xFFE9E9E9);
  static const Color _yellow = Color(0xFFF3B400);

  // ---- Demo data (replace with API/state) ----
  // If this list is empty => empty state screen
  final List<ListingItem> listings = [
    ListingItem.published(
      title: "Ironing",
      subtitle: "Listing visible",
      tier: "Bronze",
    ),
    ListingItem.inProgress(
      title: "Cleaning",
      subtitle: "Listing not visible yet",
      progress: 0.70,
    ),
  ];
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
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                child: Row(
                  children: [
                    const Text(
                      "My Listing",
                      style: TextStyle(
                        color: _text,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      splashRadius: 22,
                      onPressed: () {},
                      icon: const Icon(Icons.search, color: _text),
                    ),
                    Stack(
                      children: [
                        IconButton(
                          splashRadius: 22,
                          onPressed: () {},
                          icon: const Icon(
                            Icons.notifications_none_rounded,
                            color: _text,
                          ),
                        ),
                        Positioned(
                          right: 14,
                          top: 10,
                          child: Container(
                            width: 7,
                            height: 7,
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
                        onAddNewListing: _onCreateListing,
                        onOpenPublished: (it) {
                          final tier = _parseTier(it.tier);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PointTiersScreen(
                                serviceTitle: it.title,
                                currentTier: tier,
                                completedServices: 140,
                                currentRating: 4.6,
                                hasViolations: false,
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
        const Text(
          "No listing",
          style: TextStyle(
            color: _text,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "Create your first listing so clients\ncan find you",
          textAlign: TextAlign.center,
          style: TextStyle(
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
              label: const Text(
                "Create listing",
                style: TextStyle(
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

/* ====================== LISTING STATE (3rd/4th/5th) ====================== */

class _ListingState extends StatelessWidget {
  const _ListingState({
    required this.items,
    required this.onAddNewListing,
    required this.onOpenPublished,
    required this.onOpenIncomplete,
  });

  final List<ListingItem> items;
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
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 18),
      children: [
        if (published.isNotEmpty) ...[
          const Text(
            "Published",
            style: TextStyle(
              color: _muted,
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          ...published.map(
            (it) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
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
              fontSize: 16, // ✅ 16px
              fontWeight: FontWeight.w500, // ✅ Medium
              height: 1.2, // ✅ 120%
              letterSpacing: 0, // ✅ 0%
              color: const Color(0xFF727272), // ✅ #727272
            ),
          ),

          const SizedBox(height: 10),
          ...progress.map(
            (it) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
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

  static const Color _cardBorder = Color(0xFFE9E9E9);
  static const Color _text = Color(0xFF1F1F1F);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _cardBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
            child: Row(
              children: [
                _ServiceIcon(kind: item.title),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: GoogleFonts.urbanist(
                          fontSize: 18, // ✅ 18px
                          fontWeight: FontWeight.w500, // ✅ Medium (500)
                          height: 1.2, // ✅ 120%
                          letterSpacing: 0, // ✅ 0%
                          color: const Color(0xFF181919), // ✅ #181919
                        ),
                      ),

                      const SizedBox(height: 2),
                      Text(
                        item.subtitle,
                        style: GoogleFonts.urbanist(
                          fontSize: 14, // ✅ 14px
                          fontWeight: FontWeight.w400, // ✅ Regular
                          height: 1.2, // ✅ 120%
                          letterSpacing: 0, // ✅ 0%
                          color: const Color(0xFF181919), // ✅ #181919
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // green bar "Bronze" with chevron (like screenshot)
          InkWell(
            onTap: onBronzeTap,
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(12),
                ),
                gradient: LinearGradient(
                  colors: [const Color(0xFF2FA86A), const Color(0xFF67DCA0)],
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  const Icon(
                    Icons.emoji_events_rounded,
                    color: Colors.brown,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item.tier ?? "Bronze",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
        ],
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
  static const Color _text = Color(0xFF1F1F1F);
  static const Color _green = Color(0xFF2FA86A);
  static const Color _yellow = Color(0xFFF3B400);

  @override
  Widget build(BuildContext context) {
    final p = (item.progress ?? 0).clamp(0.0, 1.0);
    final percent = (p * 100).round();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _cardBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: Row(
              children: [
                _ServiceIcon(kind: item.title),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: GoogleFonts.urbanist(
                          fontSize: 18, // ✅ 18px
                          fontWeight: FontWeight.w500, // ✅ Medium (500)
                          height: 1.2, // ✅ 120%
                          letterSpacing: 0, // ✅ 0%
                          color: const Color(0xFF181919), // ✅ #181919
                        ),
                      ),

                      const SizedBox(height: 2),
                      Text(
                        item.subtitle,
                        style: GoogleFonts.urbanist(
                          fontSize: 14, // ✅ 14px
                          fontWeight: FontWeight.w400, // ✅ Regular (400)
                          height: 1.2, // ✅ 120%
                          letterSpacing: 0, // ✅ 0%
                          color: const Color(0xFF181919), // ✅ #181919
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    height: 12,
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
                  style: const TextStyle(
                    color: Color(0xFF7A7A7A),
                    fontSize: 11.6,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Yellow "Incomplete" bar with chevron
          InkWell(
            onTap: onTapIncomplete,
            child: Container(
              height: 44,
              decoration: const BoxDecoration(
                color: _yellow,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(12),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: const Row(
                children: [
                  Expanded(
                    child: Text(
                      "Incomplete",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
        ],
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
      height: 44,
      child: OutlinedButton.icon(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: _green,
          side: const BorderSide(color: _green, width: 1.2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        icon: const Icon(Icons.add, size: 18),
        label: Text(
          "Add new listing",
          style: GoogleFonts.urbanist(
            fontSize: 16, // ✅ 16px
            fontWeight: FontWeight.w500, // ✅ Medium (500)
            height: 1.1, // ✅ 110%
            letterSpacing: 0, // ✅ 0%
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
    final icon = kind.toLowerCase().contains("iron")
        ? Icons.local_laundry_service_rounded
        : Icons.cleaning_services_rounded;

    final bg = kind.toLowerCase().contains("iron")
        ? const Color(0xFFFFE6F1)
        : const Color(0xFFE9F5FF);

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: Colors.black87, size: 22),
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
