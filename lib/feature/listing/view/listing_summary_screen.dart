import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'point_tiers_screen.dart';

class ListingSummaryScreen extends StatelessWidget {
  const ListingSummaryScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.tierLabel,
    required this.completedServices,
    required this.rating,
  });

  final String title;
  final String subtitle;
  final String tierLabel;
  final int completedServices;
  final double rating;

  bool get _isIroning => title.toLowerCase().contains("iron");

  String get _asset =>
      _isIroning ? "assets/calender/ironing.png" : "assets/calender/cleaning.png";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1F1F1F),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          "$title Listing summary",
          style: GoogleFonts.urbanist(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1F1F1F),
          ),
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          _ListingHeaderCard(
            title: title,
            subtitle: subtitle,
            tierLabel: tierLabel,
            asset: _asset,
            onTierTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PointTiersScreen(
                    serviceTitle: title,
                    currentTier: _parseTier(tierLabel),
                    completedServices: completedServices,
                    currentRating: rating,
                    hasViolations: false,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 18),
          _InfoPill(
            background: const Color(0xFFE7FFF1),
            border: const Color(0xFF4FB47B),
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.urbanist(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1F1F1F),
                ),
                children: [
                  const TextSpan(text: "Completed "),
                  TextSpan(
                    text: "$completedServices ",
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(text: "$title services"),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          _InfoPill(
            background: const Color(0xFFFFF7D9),
            border: const Color(0xFFD7B861),
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.urbanist(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1F1F1F),
                ),
                children: [
                  TextSpan(
                    text: rating.toStringAsFixed(1),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const TextSpan(text: "⭐ Ratings in "),
                  TextSpan(text: "$title Service"),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _DeleteButton(
            onTap: () {},
          ),
        ],
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
}

class _ListingHeaderCard extends StatelessWidget {
  const _ListingHeaderCard({
    required this.title,
    required this.subtitle,
    required this.tierLabel,
    required this.asset,
    required this.onTierTap,
  });

  final String title;
  final String subtitle;
  final String tierLabel;
  final String asset;
  final VoidCallback onTierTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEFEFEF)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Image.asset(
                  asset,
                  width: 56,
                  height: 56,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.cleaning_services_rounded,
                    size: 40,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.urbanist(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1F1F1F),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
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
          InkWell(
            onTap: onTierTap,
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(16),
            ),
            child: Container(
              height: 56,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
                gradient: LinearGradient(
                  colors: [Color(0xFF3FA96B), Color(0xFF7DEFA7)],
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Image.asset(
                    "assets/images/star.png",
                    width: 38,
                    height: 38,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.emoji_events_rounded,
                      color: Color(0xFFB35C00),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    tierLabel,
                    style: GoogleFonts.urbanist(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1B1B1B),
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white,
                    size: 26,
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

class _InfoPill extends StatelessWidget {
  const _InfoPill({
    required this.background,
    required this.border,
    required this.child,
  });

  final Color background;
  final Color border;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border, width: 1.4),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF3FA96B)),
          const SizedBox(width: 10),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ElevatedButton.icon(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFC8324A),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        icon: const Icon(Icons.delete_outline_rounded, color: Colors.white),
        label: Text(
          "Delete the listing",
          style: GoogleFonts.urbanist(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
