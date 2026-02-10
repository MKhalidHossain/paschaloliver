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
    final showBronzeTip = _selected == TierLevel.bronze;
    final showAchieved = isCurrent && _selected == TierLevel.silver;
    final showGoldExtras = isCurrent && _selected == TierLevel.gold;
    final currentBenefits = isCurrent ? _currentBenefitsFor(_selected) : const <BenefitDetail>[];
    final nextTier = selected.next != null ? tiers[selected.next!] : null;

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
          "Point Tiers",
          style: GoogleFonts.urbanist(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1F1F1F),
          ),
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
        children: [
          _TierTabs(
            tiers: tiers,
            selected: _selected,
            current: widget.currentTier,
            onSelect: (t) => setState(() => _selected = t),
          ),
          const SizedBox(height: 18),
          _TierCard(
            tier: selected,
            nextTier: selected.next != null ? tiers[selected.next!] : null,
            isCurrent: isCurrent,
          ),
          const SizedBox(height: 12),
          if (showBronzeTip) const _BronzeTipCard(),
          if (showAchieved) _TierAchievedCard(tier: selected),
          if (showGoldExtras) const _EliteStatusCard(),
          const SizedBox(height: 18),
          _TierBenefitsGrid(
            tiers: tiers.values.toList(),
            current: widget.currentTier,
          ),
          if (currentBenefits.isNotEmpty) ...[
            const SizedBox(height: 14),
            _CurrentBenefitsList(
              title: _selected == TierLevel.gold
                  ? "Your Gold Benefits"
                  : "Your Current Benefits",
              benefits: currentBenefits,
            ),
          ],
          if (showGoldExtras) ...[
            const SizedBox(height: 12),
            const _MaintainGoldStatusCard(),
          ],
          const SizedBox(height: 18),
          if (nextTier != null)
            _PrimaryButton(
              label: "See how to reach ${nextTier.label} Level",
              leading: _selected == TierLevel.silver
                  ? const _CrownIcon()
                  : const _ChartIcon(),
              goldStyle: _selected == TierLevel.silver,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => TierRequirementsScreen(
                      currentTier: selected,
                      nextTier: nextTier,
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
        progressOverride: 0.70,
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
        subtitle: "Top-tier Professional - Maximum benefits",
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
    this.progressOverride,
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
  final double? progressOverride;
  final TierLevel? next;

  double get serviceProgress =>
      (progressOverride ?? (completedServices / totalServicesRequired))
          .clamp(0.0, 1.0);
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
    final Color bgColor = selected
        ? const Color(0xFFE9FFF0)
        : Colors.white;
    final Color borderColor = selected
        ? const Color(0xFF3FA96B)
        : const Color(0xFF7A7A7A);

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 96,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: borderColor,
              width: 1.4,
            ),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _TierBadge(
                      level: data.level,
                      locked: locked,
                      size: 52,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      data.label,
                      style: GoogleFonts.urbanist(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2B2B2B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TierBadge extends StatelessWidget {
  const _TierBadge({
    required this.level,
    required this.locked,
    required this.size,
  });

  final TierLevel level;
  final bool locked;
  final double size;

  Color get _borderColor {
    switch (level) {
      case TierLevel.bronze:
        return const Color(0xFFB35C00);
      case TierLevel.silver:
        return const Color(0xFF6F6F6F);
      case TierLevel.gold:
        return const Color(0xFFB8811C);
    }
  }

  @override
  Widget build(BuildContext context) {
    final icon = Image.asset(
      "assets/images/star.png",
      fit: BoxFit.contain,
      color: locked ? Colors.black45 : null,
      colorBlendMode: locked ? BlendMode.srcIn : null,
      errorBuilder: (_, __, ___) => Icon(
        Icons.emoji_events_rounded,
        size: size * 0.5,
        color: locked ? Colors.black45 : _borderColor,
      ),
    );

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size,
            height: size,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _borderColor, width: 1.2),
            ),
            child: icon,
          ),
          if (locked)
            Positioned(
              bottom: -2,
              child: Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  color: Color(0xFFE53935),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_rounded,
                  size: 12,
                  color: Colors.white,
                ),
              ),
            ),
        ],
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

    final targetTotal = tier.totalServicesRequired;
    final progress =
        (tier.progressOverride ?? (tier.completedServices / targetTotal))
            .clamp(0.0, 1.0);
    final percent = (progress * 100).round();
    final remaining =
        (targetTotal - tier.completedServices).clamp(0, targetTotal);
    final theme = _tierCardTheme(tier.level);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: theme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: theme.iconBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.iconBorder),
                ),
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  "assets/images/star.png",
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.emoji_events_rounded,
                    color: tier.color,
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
                      "${tier.label} Level",
                      style: GoogleFonts.urbanist(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: theme.titleColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tier.subtitle,
                      style: GoogleFonts.urbanist(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: theme.subtitleColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            decoration: BoxDecoration(
              color: theme.innerBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.innerBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tier.level == TierLevel.bronze
                      ? "Complete $targetTotal services"
                      : "Complete $targetTotal services for ${nextTier?.label ?? tier.label}",
                  style: GoogleFonts.urbanist(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
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
                const SizedBox(height: 10),
                Text(
                  "${tier.completedServices}/$targetTotal services completed",
                  style: GoogleFonts.urbanist(
                    fontSize: 12.5,
                    color: theme.innerSubColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (nextTier != null) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.track_changes,
                  size: 16,
                  color: theme.remainingIconColor,
                ),
                const SizedBox(width: 6),
                Text(
                  "$remaining more services to reach ${nextTier!.label}",
                  style: GoogleFonts.urbanist(
                    color: theme.remainingTextColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
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
        cardBg: Color(0xFFB35C00),
        cardBorder: Color(0xFF9D4E00),
        titleColor: Colors.white,
        subtitleColor: Color(0xFFFFD49C),
        iconBg: Colors.white,
        iconBorder: Color(0xFFCC8E4D),
        innerBg: Color(0xFFC68948),
        innerBorder: Color(0xFFE1B684),
        innerTitleColor: Colors.white,
        innerSubColor: Color(0xFFFFE7C6),
        remainingTextColor: Color(0xFFFFD08A),
        remainingIconColor: Color(0xFFE74C3C),
      );
    case TierLevel.silver:
      return const _TierCardTheme(
        cardBg: Color(0xFFE4E4E4),
        cardBorder: Color(0xFFC9C9C9),
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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF28C12), Color(0xFFF4B021)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE08E1A)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3DF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2B97A)),
                ),
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  "assets/images/star.png",
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.emoji_events_rounded,
                    color: tier.color,
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
                      "${tier.label} Level",
                      style: GoogleFonts.urbanist(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      tier.subtitle,
                      style: GoogleFonts.urbanist(
                        fontSize: 14,
                        color: const Color(0xFFFFE3B8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF7C362),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2A94E)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "You've reached the Top!",
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
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
                        style: GoogleFonts.urbanist(
                          fontSize: 12,
                          color: const Color(0xFFFFF1D6),
                        ),
                      ),
                    ),
                    Text(
                      "540",
                      style: GoogleFonts.urbanist(
                        fontSize: 13,
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
                        style: GoogleFonts.urbanist(
                          fontSize: 12,
                          color: const Color(0xFFFFF1D6),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "4.9",
                          style: GoogleFonts.urbanist(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.star,
                          size: 14,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF6C25A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2A94E)),
            ),
            child: Text(
              "🎉 Congratulations! You're among the\n top 5% of professionals",
              style: GoogleFonts.urbanist(
                fontSize: 12.5,
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
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE8FFF2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF6BCB99), width: 1.2),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 20, color: Color(0xFF2FA86A)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${tier.label} Achieved!",
                  style: GoogleFonts.urbanist(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2E7D5B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "You're now enjoying ${tier.commissionPercent}% commission and priority placement. Keep up the excellent work!",
                  style: GoogleFonts.urbanist(
                    fontSize: 13,
                    color: const Color(0xFF3E6B55),
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

class _BronzeTipCard extends StatelessWidget {
  const _BronzeTipCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F5EA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF5FBF86), width: 1.2),
      ),
      child: Row(
        children: [
          const Icon(Icons.track_changes, size: 18, color: Color(0xFFE74C3C)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "Complete more services and get better reviews to reduce commission.",
              style: GoogleFonts.urbanist(
                fontSize: 15,
                color: Color(0xFF3D9C67),
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
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7DDF0),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE27AC3), width: 1.2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "👑",
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Elite Professional Status",
                  style: GoogleFonts.urbanist(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF8F1F5C),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "You've achieved the highest tier! Enjoy exclusive benefits, VIP support, and maximum earnings.",
                  style: GoogleFonts.urbanist(
                    fontSize: 13,
                    color: const Color(0xFF7E3A60),
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
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4DE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF2B14E), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text("👑", style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(
                "Maintain Your Gold Status",
                style: GoogleFonts.urbanist(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF7A4B0A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            "Keep providing exceptional service to maintain your Gold tier benefits. Continue with 4.8+ ratings and quality service.",
            style: GoogleFonts.urbanist(
              fontSize: 13,
              color: const Color(0xFF7A6A4B),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Current Ratting",
                      style: GoogleFonts.urbanist(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F1F1F),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "4.9",
                      style: GoogleFonts.urbanist(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1F1F1F),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.star, size: 14, color: Color(0xFFF2B14E)),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    height: 12,
                    color: const Color(0xFFEDF1FB),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: 0.9,
                        child: Container(color: const Color(0xFF3FA96B)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 14,
                      color: Color(0xFF2FA86A),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Exceeding Gold tier requirements",
                      style: GoogleFonts.urbanist(
                        fontSize: 12,
                        color: const Color(0xFF2E7D5B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1F1F1F),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            for (final t in tiers) ...[
              Expanded(
                child: _TierBenefitTile(
                  tier: t,
                  selected: t.level == current,
                  locked: t.level.index > current.index,
                ),
              ),
              if (t != tiers.last) const SizedBox(width: 12),
            ],
          ],
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
    final Color bgColor = selected
        ? const Color(0xFFE9FFF0)
        : Colors.white;
    final Color borderColor = selected
        ? const Color(0xFF3FA96B)
        : const Color(0xFF7A7A7A);

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: 1.4,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _TierBadge(
            level: tier.level,
            locked: locked,
            size: 44,
          ),
          const SizedBox(height: 6),
          Text(
            tier.label,
            style: GoogleFonts.urbanist(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2B2B2B),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            "${tier.commissionPercent}%",
            style: GoogleFonts.urbanist(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2FA86A),
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
    final isGold = title.toLowerCase().contains("gold");
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF6BCB99), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isGold ? Icons.auto_awesome : Icons.check_circle,
                size: 18,
                color: const Color(0xFF3FA96B),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1F1F1F),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...benefits.map(
            (b) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle,
                    size: 16,
                    color: Color(0xFF3FA96B),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          b.title,
                          style: GoogleFonts.urbanist(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1F1F1F),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          b.subtitle,
                          style: GoogleFonts.urbanist(
                            fontSize: 12,
                            color: const Color(0xFF6F6F6F),
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
        height: 56,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
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
              borderRadius: BorderRadius.circular(14),
              onTap: onTap,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (leading != null) ...[leading!, const SizedBox(width: 10)],
                  Text(
                    label,
                    style: GoogleFonts.urbanist(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFF8E7C2),
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
      height: 56,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3FA96B),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: 10)],
            Text(
              label,
              style: GoogleFonts.urbanist(
                fontSize: 16,
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

class _ChartIcon extends StatelessWidget {
  const _ChartIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white, width: 1.4),
      ),
      child: const Icon(
        Icons.show_chart_rounded,
        size: 18,
        color: Colors.white,
      ),
    );
  }
}

class _CrownIcon extends StatelessWidget {
  const _CrownIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white, width: 1.4),
      ),
      child: const Icon(
        Icons.workspace_premium_rounded,
        size: 18,
        color: Colors.white,
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

  bool get _meetsConsistency =>
      currentTier.completedServices >= (nextTier.totalServicesRequired * 0.3);

  bool get _allMet =>
      _meetsService &&
      _meetsRating &&
      _meetsViolations &&
      (currentTier.level == TierLevel.silver ? _meetsConsistency : true);

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
          "Reach ${nextTier.label} Level",
          style: GoogleFonts.urbanist(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1F1F1F),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Text(
            "You are currently on ${currentTier.label}",
            style: GoogleFonts.urbanist(
              fontSize: 13,
              color: const Color(0xFF6F6F6F),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
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
            const SizedBox(height: 14),
          ],
          _SectionTitle(
            currentTier.level == TierLevel.silver
                ? "Requirements for ${nextTier.label}"
                : "Requirements",
          ),
          const SizedBox(height: 10),
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
            label: currentTier.level == TierLevel.silver
                ? "Exceptional service record"
                : "No policy violations",
            sublabel: currentTier.hasViolations
                ? "Violations found"
                : currentTier.level == TierLevel.silver
                    ? "No violations - excellent history"
                    : "Clean record",
            ok: _meetsViolations,
          ),
          if (currentTier.level == TierLevel.silver) ...[
            const SizedBox(height: 10),
            _RequirementTile(
              label: "Consistent performance",
              sublabel: "6 months of active services",
              ok: _meetsConsistency,
            ),
          ],
          if (currentTier.level != TierLevel.silver) ...[
            const SizedBox(height: 14),
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
          const SizedBox(height: 14),
          _BenefitsCard(
            title: currentTier.level == TierLevel.silver
                ? "${nextTier.label} Benefits Awaiting you"
                : "${nextTier.label} Benefits",
            benefits: nextTier.benefits,
          ),
          const SizedBox(height: 14),
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
        fontSize: 16,
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
    final bg = ok ? const Color(0xFFE8FFF2) : Colors.white;
    final border = ok ? const Color(0xFF6BCB99) : const Color(0xFFDDDDDD);
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border, width: 1.2),
      ),
      child: Row(
        children: [
          Icon(
            ok ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 20,
            color: ok ? const Color(0xFF2FA86A) : const Color(0xFF6F6F6F),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F1F1F),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  sublabel,
                  style: GoogleFonts.urbanist(
                    fontSize: 12,
                    color: const Color(0xFF6F6F6F),
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
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF6BCB99), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8FFF2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.show_chart_rounded,
                  size: 16,
                  color: Color(0xFF2FA86A),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "Progress Details",
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1F1F1F),
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
            style: GoogleFonts.urbanist(
              fontSize: 12,
              color: const Color(0xFF6F6F6F),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.check_circle,
                size: 16,
                color: Color(0xFF2FA86A),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    height: 10,
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
            style: GoogleFonts.urbanist(
              fontSize: 12,
              color: const Color(0xFF6F6F6F),
            ),
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
        height: 22,
        color: const Color(0xFFEDEDED),
        child: Stack(
          children: [
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
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 14,
                padding: const EdgeInsets.symmetric(horizontal: 10),
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
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          height: 1.0,
                          color: Color(0xFF1F1F1F),
                        ),
                      ),
                    ),
                    Text(
                      percentText,
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

class _BenefitsCard extends StatelessWidget {
  const _BenefitsCard({required this.title, required this.benefits});

  final String title;
  final List<String> benefits;

  @override
  Widget build(BuildContext context) {
    final isGold = title.toLowerCase().contains("gold");
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF6BCB99), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isGold ? Icons.workspace_premium_rounded : Icons.emoji_events_rounded,
                size: 18,
                color: const Color(0xFF1F1F1F),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1F1F1F),
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
                    size: 15,
                    color: Color(0xFF3FA96B),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      b,
                      style: GoogleFonts.urbanist(
                        fontSize: 12.5,
                        color: const Color(0xFF4B4B4B),
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
      height: 52,
      child: OutlinedButton.icon(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0xFFF6F6F6),
          side: const BorderSide(color: Color(0xFFBDBDBD), width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          foregroundColor: const Color(0xFF1F1F1F),
        ),
        icon:
            const Icon(Icons.lock_rounded, size: 18, color: Color(0xFF1F1F1F)),
        label: Text(
          label,
          style: GoogleFonts.urbanist(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
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
          width: 300,
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
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
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F7F7),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(14),
                child: Image.asset(
                  "assets/images/star.png",
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.emoji_events_rounded,
                    color: reachedTier.color,
                    size: 34,
                  ),
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
                style: GoogleFonts.urbanist(
                  fontSize: 13,
                  color: const Color(0xFF1F1F1F),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).popUntil((r) => r.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3FA96B),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Go to Home",
                    style: GoogleFonts.urbanist(
                      color: Colors.white,
                      fontSize: 14.5,
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
          "Point Tiers",
          style: GoogleFonts.urbanist(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1F1F1F),
          ),
        ),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF5FFF9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFBFE7D0), width: 1.2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: reachedTier.color,
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  "assets/images/star.png",
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.emoji_events_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                canProceed ? "Congratulations!" : "Almost there",
                style: GoogleFonts.urbanist(
                  fontSize: 17,
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
                style: GoogleFonts.urbanist(
                  fontSize: 13,
                  color: const Color(0xFF5A5A5A),
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
