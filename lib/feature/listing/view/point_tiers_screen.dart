import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paschaloliver/core/network/api_service/token_meneger.dart';

class PointTiersScreen extends StatefulWidget {
  const PointTiersScreen({
    super.key,
    required this.serviceTitle,
    required this.currentTier,
    required this.completedServices,
    required this.currentRating,
    required this.hasViolations,
  });

  final String serviceTitle;
  final TierLevel currentTier;
  final int completedServices;
  final double currentRating;
  final bool hasViolations;

  @override
  State<PointTiersScreen> createState() => _PointTiersScreenState();
}

class _PointTiersScreenState extends State<PointTiersScreen> {
  late TierLevel _selected = widget.currentTier;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _maybeShowCongrats();
    });
  }

  @override
  Widget build(BuildContext context) {
    final tiers = _buildTierData();
    final selected = tiers[_selected]!;
    final isCurrent = _selected == widget.currentTier;
    final currentBenefits = _currentBenefitsFor(widget.currentTier);
    final showBronzeTip = _selected == TierLevel.bronze;
    final showAchieved = isCurrent && _selected == TierLevel.silver;
    final showGoldExtras = isCurrent && _selected == TierLevel.gold;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF2F2F2),
        foregroundColor: const Color(0xFF1F1F1F),
        title: const Text(
          "Point Tiers",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
        children: [
          _TierTabs(
            tiers: tiers,
            selected: _selected,
            current: widget.currentTier,
            onSelect: (t) => setState(() => _selected = t),
          ),
          const SizedBox(height: 12),
          _TierCard(
            tier: selected,
            nextTier: selected.next != null ? tiers[selected.next!] : null,
            isCurrent: isCurrent,
          ),
          const SizedBox(height: 10),
          if (showBronzeTip) const _BronzeTipCard(),
          if (showAchieved) _TierAchievedCard(tier: selected),
          if (showGoldExtras) ...[
            const SizedBox(height: 10),
            const _EliteStatusCard(),
          ],
          const SizedBox(height: 12),
          _TierBenefitsGrid(
            tiers: tiers.values.toList(),
            current: widget.currentTier,
          ),
          const SizedBox(height: 12),
          if (currentBenefits.isNotEmpty)
            _CurrentBenefitsList(
              title: widget.currentTier == TierLevel.gold
                  ? "Your Gold Benefits"
                  : "Your Current Benefits",
              benefits: currentBenefits,
            ),
          if (showGoldExtras) ...[
            const SizedBox(height: 12),
            const _MaintainGoldStatusCard(),
          ],
          const SizedBox(height: 12),
          if (selected.next != null)
            _PrimaryButton(
              label: "See how to reach ${tiers[selected.next!]!.label} level",
              leading: const Icon(
                Icons.emoji_events_rounded,
                size: 16,
                color: Color(0xFF2E1B00),
              ),
              goldStyle: _selected == TierLevel.silver,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => TierRequirementsScreen(
                      currentTier: selected,
                      nextTier: tiers[selected.next!]!,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Map<TierLevel, TierData> _buildTierData() {
    return {
      TierLevel.bronze: TierData(
        level: TierLevel.bronze,
        label: "Bronze",
        subtitle: "Listing is visible",
        color: const Color(0xFFB5610E),
        commissionPercent: 20,
        totalServicesRequired: 200,
        requiredRating: 4.5,
        completedServices: widget.completedServices,
        currentRating: widget.currentRating,
        hasViolations: widget.hasViolations,
        benefits: const [
          "Lower commission (20%)",
          "Higher visibility",
          "Trust badge on profile",
        ],
        next: TierLevel.silver,
      ),
      TierLevel.silver: TierData(
        level: TierLevel.silver,
        label: "Silver",
        subtitle: "Higher visibility - Trust badge",
        color: const Color(0xFF8D8D8D),
        commissionPercent: 15,
        totalServicesRequired: 500,
        requiredRating: 4.8,
        completedServices: widget.completedServices,
        currentRating: widget.currentRating,
        hasViolations: widget.hasViolations,
        benefits: const [
          "Lower commission (15%)",
          "Higher visibility",
          "Trust badge on profile",
        ],
        next: TierLevel.gold,
      ),
      TierLevel.gold: TierData(
        level: TierLevel.gold,
        label: "Gold",
        subtitle: "Top-tier professional - Maximum visibility",
        color: const Color(0xFFD9A12B),
        commissionPercent: 10,
        totalServicesRequired: 1000,
        requiredRating: 4.9,
        completedServices: widget.completedServices,
        currentRating: widget.currentRating,
        hasViolations: widget.hasViolations,
        benefits: const [
          "Only 10% commission (save 5% more)",
          "Premium visibility",
          "VIP support access",
          "Exclusive promotional opportunities",
        ],
      ),
    };
  }

  List<BenefitDetail> _currentBenefitsFor(TierLevel level) {
    switch (level) {
      case TierLevel.bronze:
        return const [];
      case TierLevel.silver:
        return const [
          BenefitDetail(
            title: "15% commission",
            subtitle: "Save 5% compared to Bronze",
          ),
          BenefitDetail(
            title: "Priority Listing Placement",
            subtitle: "Appear higher in search result",
          ),
          BenefitDetail(
            title: "Trusted Professional Badge",
            subtitle: "Build customer confidence",
          ),
          BenefitDetail(
            title: "Priority Support",
            subtitle: "Faster response time",
          ),
        ];
      case TierLevel.gold:
        return const [
          BenefitDetail(
            title: "Only 10% Commission",
            subtitle: "Save 5% more compared to Silver",
          ),
          BenefitDetail(
            title: "Premium Visibility",
            subtitle: "Top placement in all search results",
          ),
          BenefitDetail(
            title: "VIP Support Access",
            subtitle: "Dedicated support and fast response",
          ),
          BenefitDetail(
            title: "Exclusive Opportunities",
            subtitle: "Early access to premium clients",
          ),
          BenefitDetail(
            title: "Elite Pro Badge",
            subtitle: "Premium trust indicator on profile",
          ),
        ];
    }
  }

  Future<void> _maybeShowCongrats() async {
    final tiers = _buildTierData();
    final current = tiers[widget.currentTier];
    if (current == null || current.next == null) return;

    final next = tiers[current.next!];
    if (next == null) return;

    final meetsService =
        current.completedServices >= next.totalServicesRequired;
    final meetsRating = current.currentRating >= next.requiredRating;
    final meetsViolations = current.hasViolations == false;

    if (!(meetsService && meetsRating && meetsViolations)) return;

    final alreadyShown = await TokenManager.isTierCongratsShown(next.label);
    if (alreadyShown || !mounted) return;

    await TokenManager.setTierCongratsShown(next.label);
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => _TierSuccessDialog(reachedTier: next),
    );
  }
}

enum TierLevel { bronze, silver, gold }

class TierData {
  TierData({
    required this.level,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.commissionPercent,
    required this.totalServicesRequired,
    required this.requiredRating,
    required this.completedServices,
    required this.currentRating,
    required this.hasViolations,
    required this.benefits,
    this.next,
  });

  final TierLevel level;
  final String label;
  final String subtitle;
  final Color color;
  final int commissionPercent;
  final int totalServicesRequired;
  final double requiredRating;
  final int completedServices;
  final double currentRating;
  final bool hasViolations;
  final List<String> benefits;
  final TierLevel? next;

  double get serviceProgress =>
      (completedServices / totalServicesRequired).clamp(0.0, 1.0);
}

class _TierTabs extends StatelessWidget {
  const _TierTabs({
    required this.tiers,
    required this.selected,
    required this.current,
    required this.onSelect,
  });
  final Map<TierLevel, TierData> tiers;
  final TierLevel selected;
  final TierLevel current;
  final ValueChanged<TierLevel> onSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TierTab(
          data: tiers[TierLevel.bronze]!,
          selected: selected == TierLevel.bronze,
          locked: _isLocked(TierLevel.bronze),
          onTap: () => onSelect(TierLevel.bronze),
        ),
        const SizedBox(width: 10),
        _TierTab(
          data: tiers[TierLevel.silver]!,
          selected: selected == TierLevel.silver,
          locked: _isLocked(TierLevel.silver),
          onTap: () => onSelect(TierLevel.silver),
        ),
        const SizedBox(width: 10),
        _TierTab(
          data: tiers[TierLevel.gold]!,
          selected: selected == TierLevel.gold,
          locked: _isLocked(TierLevel.gold),
          onTap: () => onSelect(TierLevel.gold),
        ),
      ],
    );
  }

  bool _isLocked(TierLevel level) => level.index > current.index;
}

class _TierTab extends StatelessWidget {
  const _TierTab({
    required this.data,
    required this.selected,
    required this.locked,
    required this.onTap,
  });

  final TierData data;
  final bool selected;
  final bool locked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? const Color(0xFF5EC691)
                  : const Color(0xFFD2D2D2),
            ),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: data.color.withOpacity(.55)),
                      ),
                      child: Icon(
                        Icons.emoji_events_rounded,
                        size: 18,
                        color: data.color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data.label,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: selected
                            ? const Color(0xFF2FA86A)
                            : const Color(0xFF5A5A5A),
                      ),
                    ),
                  ],
                ),
              ),
              if (locked)
                Positioned(
                  bottom: 6,
                  right: 8,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE53935),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lock_rounded,
                      size: 10,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TierCard extends StatelessWidget {
  const _TierCard({
    required this.tier,
    required this.nextTier,
    required this.isCurrent,
  });
  final TierData tier;
  final TierData? nextTier;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    if (tier.level == TierLevel.gold && isCurrent) {
      return _GoldTierCard(tier: tier);
    }

    final targetTotal =
        nextTier?.totalServicesRequired ?? tier.totalServicesRequired;
    final progress =
        (tier.completedServices / targetTotal).clamp(0.0, 1.0);
    final percent = (progress * 100).round();
    final remaining = (targetTotal - tier.completedServices).clamp(0, targetTotal);
    final theme = _tierCardTheme(tier.level);

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        color: theme.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: theme.iconBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.iconBorder),
                ),
                child: Icon(
                  Icons.emoji_events_rounded,
                  color: tier.color,
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${tier.label} Level",
                      style: GoogleFonts.urbanist(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: theme.titleColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      tier.subtitle,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: theme.subtitleColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            decoration: BoxDecoration(
              color: theme.innerBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: theme.innerBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Complete $targetTotal services for ${nextTier?.label ?? tier.label}",
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: theme.innerTitleColor,
                  ),
                ),
                const SizedBox(height: 10),
                ClipRRect(
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
                            widthFactor: progress,
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
                ),
                const SizedBox(height: 6),
                Text(
                  "${tier.completedServices}/$targetTotal services completed",
                  style: TextStyle(
                    fontSize: 11,
                    color: theme.innerSubColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (nextTier != null) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  Icons.track_changes,
                  size: 14,
                  color: theme.remainingIconColor,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    "$remaining more services to reach ${nextTier!.label}",
                    style: TextStyle(
                      color: theme.remainingTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

}

class _TierCardTheme {
  const _TierCardTheme({
    required this.cardBg,
    required this.cardBorder,
    required this.titleColor,
    required this.subtitleColor,
    required this.iconBg,
    required this.iconBorder,
    required this.innerBg,
    required this.innerBorder,
    required this.innerTitleColor,
    required this.innerSubColor,
    required this.remainingTextColor,
    required this.remainingIconColor,
  });

  final Color cardBg;
  final Color cardBorder;
  final Color titleColor;
  final Color subtitleColor;
  final Color iconBg;
  final Color iconBorder;
  final Color innerBg;
  final Color innerBorder;
  final Color innerTitleColor;
  final Color innerSubColor;
  final Color remainingTextColor;
  final Color remainingIconColor;
}

_TierCardTheme _tierCardTheme(TierLevel level) {
  switch (level) {
    case TierLevel.bronze:
      return const _TierCardTheme(
        cardBg: Color(0xFFB96A17),
        cardBorder: Color(0xFF9D5710),
        titleColor: Colors.white,
        subtitleColor: Color(0xFFFFE2BA),
        iconBg: Color(0xFFF9F1E6),
        iconBorder: Color(0xFFE2B97A),
        innerBg: Color(0xFFC77B22),
        innerBorder: Color(0xFFE0B06A),
        innerTitleColor: Colors.white,
        innerSubColor: Color(0xFFFFE7C6),
        remainingTextColor: Color(0xFFFFE4BC),
        remainingIconColor: Color(0xFFE74C3C),
      );
    case TierLevel.silver:
      return const _TierCardTheme(
        cardBg: Color(0xFFE2E2E2),
        cardBorder: Color(0xFFC5C5C5),
        titleColor: Color(0xFF1F1F1F),
        subtitleColor: Color(0xFF6E6E6E),
        iconBg: Color(0xFFF3F3F3),
        iconBorder: Color(0xFFC9C9C9),
        innerBg: Color(0xFFCFCFCF),
        innerBorder: Color(0xFFB8B8B8),
        innerTitleColor: Color(0xFF1F1F1F),
        innerSubColor: Color(0xFF5F5F5F),
        remainingTextColor: Color(0xFF2E7D5B),
        remainingIconColor: Color(0xFFE74C3C),
      );
    case TierLevel.gold:
      return const _TierCardTheme(
        cardBg: Color(0xFFF0A024),
        cardBorder: Color(0xFFD4861B),
        titleColor: Colors.white,
        subtitleColor: Color(0xFFFFE3B8),
        iconBg: Color(0xFFFFF3DF),
        iconBorder: Color(0xFFE2B97A),
        innerBg: Color(0xFFF1B24A),
        innerBorder: Color(0xFFE1B063),
        innerTitleColor: Colors.white,
        innerSubColor: Color(0xFFFFE9C6),
        remainingTextColor: Color(0xFFFFE4BC),
        remainingIconColor: Color(0xFFE74C3C),
      );
  }
}

class _GoldTierCard extends StatelessWidget {
  const _GoldTierCard({required this.tier});
  final TierData tier;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0A024),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD4861B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3DF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2B97A)),
                ),
                child: Icon(
                  Icons.emoji_events_rounded,
                  color: tier.color,
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${tier.label} Level",
                      style: GoogleFonts.urbanist(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      "Top-tier Professional - Maximum visibility",
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFFFFE3B8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF6C25A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE6B35C)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "You've reached the Top!",
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Total Services",
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFFFFF1D6),
                        ),
                      ),
                    ),
                    Text(
                      "540",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Average rating",
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFFFFF1D6),
                        ),
                      ),
                    ),
                    Text(
                      "4.9",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            decoration: BoxDecoration(
              color: const Color(0xFFEFA53B),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFD48A2B)),
            ),
            child: const Text(
              "Congratulations! You're among the top 5% of professionals",
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TierAchievedCard extends StatelessWidget {
  const _TierAchievedCard({required this.tier});
  final TierData tier;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: const Color(0xFFE1F2E7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF88C9A6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${tier.label} Achieved!",
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2E7D5B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "You're now enjoying ${tier.commissionPercent}% commission and priority placement. Keep up the excellent work!",
            style: const TextStyle(
              fontSize: 11.5,
              color: Color(0xFF3E6B55),
            ),
          ),
        ],
      ),
    );
  }
}

class _BronzeTipCard extends StatelessWidget {
  const _BronzeTipCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: const Color(0xFFE7F6EE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFBDE6CE)),
      ),
      child: Row(
        children: [
          const Icon(Icons.track_changes, size: 16, color: Color(0xFFE74C3C)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "Complete more services and get better reviews to reduce commission.",
              style: const TextStyle(
                fontSize: 12.5,
                color: Color(0xFF2E7D5B),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EliteStatusCard extends StatelessWidget {
  const _EliteStatusCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE6F4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF3A3D6)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.emoji_events_rounded, size: 16, color: Color(0xFFD81B60)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Elite Professional Status",
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFB0004D),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "You've achieved the highest tier! Enjoy exclusive benefits, VIP support, and maximum earnings.",
                  style: TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF8A3D64),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MaintainGoldStatusCard extends StatelessWidget {
  const _MaintainGoldStatusCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4DD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE7C688)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.verified, size: 16, color: Color(0xFFB5771E)),
              SizedBox(width: 6),
              Text(
                "Maintain Your Gold Status",
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF7A4B0A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            "Keep providing exceptional service to maintain your Gold tier status. Continue with 4.8+ ratings and quality service.",
            style: TextStyle(
              fontSize: 11.5,
              color: Color(0xFF7A6A4B),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: const [
              Text(
                "Current Rating",
                style: TextStyle(fontSize: 11.5, color: Color(0xFF7A6A4B)),
              ),
              Spacer(),
              Text(
                "4.9",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF7A4B0A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: Container(
              height: 8,
              color: const Color(0xFFF1E1C2),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: 0.9,
                  child: Container(color: const Color(0xFF2FA86A)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "Exceeding Gold tier requirements",
            style: TextStyle(fontSize: 11, color: Color(0xFF2E7D5B)),
          ),
        ],
      ),
    );
  }
}

class _TierBenefitsGrid extends StatelessWidget {
  const _TierBenefitsGrid({required this.tiers, required this.current});
  final List<TierData> tiers;
  final TierLevel current;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Tier Benefits",
          style: GoogleFonts.urbanist(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1F1F1F),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: tiers.map((t) {
            final isCurrent = t.level == current;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _TierBenefitTile(
                  tier: t,
                  selected: isCurrent,
                  locked: t.level.index > current.index,
                ),
              ),
            );
          }).toList()..removeLast(),
        ),
      ],
    );
  }
}

class _TierBenefitTile extends StatelessWidget {
  const _TierBenefitTile({
    required this.tier,
    required this.selected,
    required this.locked,
  });

  final TierData tier;
  final bool selected;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFEAF7F0) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: selected ? const Color(0xFF5EC691) : const Color(0xFFD5D5D5),
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: tier.color.withOpacity(.55)),
                  ),
                  child: Icon(
                    Icons.emoji_events_rounded,
                    size: 15,
                    color: tier.color,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  tier.label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: selected
                        ? const Color(0xFF2E7D5B)
                        : const Color(0xFF3F3F3F),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "${tier.commissionPercent}%",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: locked
                        ? const Color(0xFF8B8B8B)
                        : const Color(0xFF2FA86A),
                  ),
                ),
              ],
            ),
          ),
          if (locked)
            Positioned(
              bottom: 4,
              right: 8,
              child: Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  color: Color(0xFFE53935),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_rounded,
                  size: 10,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class BenefitDetail {
  const BenefitDetail({required this.title, required this.subtitle});
  final String title;
  final String subtitle;
}

class _CurrentBenefitsList extends StatelessWidget {
  const _CurrentBenefitsList({
    required this.title,
    required this.benefits,
  });

  final String title;
  final List<BenefitDetail> benefits;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFBFE7D0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.urbanist(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1F1F1F),
            ),
          ),
          const SizedBox(height: 8),
          ...benefits.map(
            (b) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle,
                    size: 15,
                    color: Color(0xFF2FA86A),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          b.title,
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1F1F1F),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          b.subtitle,
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: Color(0xFF6F6F6F),
                          ),
                        ),
                      ],
                    ),
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

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.onTap,
    this.leading,
    this.goldStyle = false,
  });
  final String label;
  final VoidCallback onTap;
  final Widget? leading;
  final bool goldStyle;

  @override
  Widget build(BuildContext context) {
    if (goldStyle) {
      return SizedBox(
        height: 44,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              colors: [Color(0xFFB07A1E), Color(0xFF8C5A11)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.18),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onTap,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (leading != null) ...[leading!, const SizedBox(width: 8)],
                  Text(
                    label,
                    style: GoogleFonts.urbanist(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFF5E1B5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 44,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2FA86A),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: 8)],
            Text(
              label,
              style: GoogleFonts.urbanist(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TierRequirementsScreen extends StatelessWidget {
  const TierRequirementsScreen({
    super.key,
    required this.currentTier,
    required this.nextTier,
  });

  final TierData currentTier;
  final TierData nextTier;

  bool get _meetsService =>
      currentTier.completedServices >= nextTier.totalServicesRequired;
  bool get _meetsRating => currentTier.currentRating >= nextTier.requiredRating;
  bool get _meetsViolations => currentTier.hasViolations == false;

  bool get _allMet => _meetsService && _meetsRating && _meetsViolations;

  @override
  Widget build(BuildContext context) {
    final serviceProgress =
        (currentTier.completedServices / nextTier.totalServicesRequired).clamp(
          0.0,
          1.0,
        );
    final ratingProgress = (currentTier.currentRating / nextTier.requiredRating)
        .clamp(0.0, 1.0);
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF2F2F2),
        foregroundColor: const Color(0xFF1F1F1F),
        title: Text(
          "Reach ${nextTier.label} Level",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
        children: [
          Text(
            "You are currently on ${currentTier.label}",
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6F6F6F),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          if (currentTier.level == TierLevel.silver) ...[
            const _SectionTitle("Progress Details"),
            const SizedBox(height: 8),
            _ProgressDetailsCard(
              servicesText:
                  "${currentTier.completedServices}/${nextTier.totalServicesRequired} services completed",
              ratingText:
                  "${currentTier.currentRating.toStringAsFixed(1)}/${nextTier.requiredRating} ratings",
              serviceProgress: serviceProgress,
              ratingProgress: ratingProgress,
            ),
            const SizedBox(height: 12),
          ],
          _SectionTitle("Requirements for ${nextTier.label}"),
          const SizedBox(height: 8),
          _RequirementTile(
            label: "Complete ${nextTier.totalServicesRequired} services",
            sublabel:
                "${currentTier.completedServices}/${nextTier.totalServicesRequired} services completed",
            ok: _meetsService,
          ),
          const SizedBox(height: 10),
          _RequirementTile(
            label: "Maintain rating ${nextTier.requiredRating}+⭐",
            sublabel:
                "Current rating: ${currentTier.currentRating.toStringAsFixed(1)}",
            ok: _meetsRating,
          ),
          const SizedBox(height: 10),
          _RequirementTile(
            label: "No policy violations",
            sublabel: currentTier.hasViolations
                ? "Violations found"
                : "Clean record",
            ok: _meetsViolations,
          ),
          if (currentTier.level != TierLevel.silver) ...[
            const SizedBox(height: 12),
            const _SectionTitle("Progress Details"),
            const SizedBox(height: 8),
            _ProgressDetailsCard(
              servicesText:
                  "${currentTier.completedServices}/${nextTier.totalServicesRequired} services completed",
              ratingText:
                  "${currentTier.currentRating.toStringAsFixed(1)}/${nextTier.requiredRating} ratings",
              serviceProgress: serviceProgress,
              ratingProgress: ratingProgress,
            ),
          ],
          const SizedBox(height: 12),
          _BenefitsCard(
            title: currentTier.level == TierLevel.silver
                ? "${nextTier.label} Benefits Awaiting you"
                : "${nextTier.label} Benefits",
            benefits: nextTier.benefits,
          ),
          const SizedBox(height: 12),
          _OutlinedActionButton(
            label: _allMet
                ? "Reach ${nextTier.label} (complete)"
                : "Reach ${nextTier.label} (complete Requirements)",
            onTap: () {
              if (_allMet) {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (_) => _TierSuccessDialog(reachedTier: nextTier),
                );
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => TierSuccessScreen(
                      reachedTier: nextTier,
                      canProceed: _allMet,
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.urbanist(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF1F1F1F),
      ),
    );
  }
}

class _RequirementTile extends StatelessWidget {
  const _RequirementTile({
    required this.label,
    required this.sublabel,
    required this.ok,
  });

  final String label;
  final String sublabel;
  final bool ok;

  @override
  Widget build(BuildContext context) {
    final bg = ok ? const Color(0xFFF0FFF6) : Colors.white;
    final border = ok ? const Color(0xFF6BCB99) : const Color(0xFFDDDDDD);
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border, width: 1),
      ),
      child: Row(
        children: [
          Icon(
            ok ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 18,
            color: ok ? const Color(0xFF2FA86A) : const Color(0xFF6F6F6F),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F1F1F),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  sublabel,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF6F6F6F),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressDetailsCard extends StatelessWidget {
  const _ProgressDetailsCard({
    required this.servicesText,
    required this.ratingText,
    required this.serviceProgress,
    required this.ratingProgress,
  });

  final String servicesText;
  final String ratingText;
  final double serviceProgress;
  final double ratingProgress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF6BCB99)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(
                Icons.show_chart_rounded,
                size: 18,
                color: Color(0xFF1F1F1F),
              ),
              SizedBox(width: 8),
              Text(
                "Progress Details",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F1F1F),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _CapsuleProgress(
            progress: serviceProgress,
            label: "Service completed",
            percentText: "${(serviceProgress * 100).round()}%",
          ),
          const SizedBox(height: 4),
          Text(
            servicesText,
            style: const TextStyle(fontSize: 11.5, color: Color(0xFF6F6F6F)),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.check_circle,
                size: 14,
                color: Color(0xFF2FA86A),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    height: 8,
                    color: const Color(0xFFEFEFEF),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: ratingProgress,
                        child: Container(color: const Color(0xFF2FA86A)),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            ratingText,
            style: const TextStyle(fontSize: 11.5, color: Color(0xFF6F6F6F)),
          ),
        ],
      ),
    );
  }
}

class _CapsuleProgress extends StatelessWidget {
  const _CapsuleProgress({
    required this.progress,
    required this.label,
    required this.percentText,
  });

  final double progress;
  final String label;
  final String percentText;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 18,
        color: const Color(0xFFF0CFAF),
        child: Stack(
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: progress,
                  child: Container(color: const Color(0xFF2FA86A)),
                ),
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 12,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8CF4D),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            label,
                            style: const TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              height: 1.0,
                            ),
                          ),
                        ),
                        Text(
                          percentText,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
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

class _BenefitsCard extends StatelessWidget {
  const _BenefitsCard({required this.title, required this.benefits});

  final String title;
  final List<String> benefits;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF6BCB99)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.show_chart_rounded,
                size: 18,
                color: Color(0xFF1F1F1F),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F1F1F),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...benefits.map(
            (b) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    size: 14,
                    color: Color(0xFF2FA86A),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      b,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF4B4B4B),
                      ),
                    ),
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

class _OutlinedActionButton extends StatelessWidget {
  const _OutlinedActionButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: OutlinedButton.icon(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(color: Color(0xFF2FA86A)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          foregroundColor: const Color(0xFF1F1F1F),
        ),
        icon: const Icon(Icons.lock_rounded, size: 16, color: Color(0xFF1F1F1F)),
        label: Text(
          label,
          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _TierSuccessDialog extends StatelessWidget {
  const _TierSuccessDialog({required this.reachedTier});

  final TierData reachedTier;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 320,
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.18),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.emoji_events_rounded,
                  color: reachedTier.color,
                  size: 34,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Congratulations!",
                style: GoogleFonts.urbanist(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2FA86A),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "You have reached ${reachedTier.label} Level",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: Color(0xFF1F1F1F)),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 42,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).popUntil((r) => r.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2FA86A),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Go to Home",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TierSuccessScreen extends StatelessWidget {
  const TierSuccessScreen({
    super.key,
    required this.reachedTier,
    required this.canProceed,
  });

  final TierData reachedTier;
  final bool canProceed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF2F2F2),
        foregroundColor: const Color(0xFF1F1F1F),
        title: const Text(
          "Point Tiers",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF5FFF9),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFBFE7D0)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: reachedTier.color,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.emoji_events_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                canProceed ? "Congratulations!" : "Almost there",
                style: GoogleFonts.urbanist(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1F1F1F),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                canProceed
                    ? "You have reached ${reachedTier.label} level"
                    : "Complete the requirements to reach ${reachedTier.label}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: Color(0xFF5A5A5A),
                ),
              ),
              const SizedBox(height: 14),
              _PrimaryButton(
                label: "Go to Home",
                onTap: () {
                  Navigator.of(context).popUntil((r) => r.isFirst);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
