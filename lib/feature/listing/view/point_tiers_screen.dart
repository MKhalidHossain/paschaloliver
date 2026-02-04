import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  Widget build(BuildContext context) {
    final tiers = _buildTierData();
    final selected = tiers[_selected]!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
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
            isCurrent: _selected == widget.currentTier,
          ),
          const SizedBox(height: 10),
          const _TipCard(
            text:
                "Complete more services and get better reviews to reduce commission.",
          ),
          const SizedBox(height: 12),
          _TierBenefitsGrid(
            tiers: tiers.values.toList(),
            current: widget.currentTier,
          ),
          const SizedBox(height: 12),
          if (selected.next != null)
            _PrimaryButton(
              label: "See how to reach ${tiers[selected.next!]!.label} level",
              leading: Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.show_chart_rounded,
                  size: 12,
                  color: Color(0xFF2FA86A),
                ),
              ),
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
        color: const Color(0xFF8D8D8D),
        commissionPercent: 15,
        totalServicesRequired: 500,
        requiredRating: 4.8,
        completedServices: widget.completedServices,
        currentRating: widget.currentRating,
        hasViolations: widget.hasViolations,
        benefits: const [
          "Only 15% commission",
          "Top placement in search",
          "Priority support",
        ],
        next: TierLevel.gold,
      ),
      TierLevel.gold: TierData(
        level: TierLevel.gold,
        label: "Gold",
        color: const Color(0xFFD9A12B),
        commissionPercent: 10,
        totalServicesRequired: 1000,
        requiredRating: 4.9,
        completedServices: widget.completedServices,
        currentRating: widget.currentRating,
        hasViolations: widget.hasViolations,
        benefits: const [
          "Only 10% commission",
          "Premium visibility",
          "Exclusive opportunities",
        ],
      ),
    };
  }
}

enum TierLevel { bronze, silver, gold }

class TierData {
  TierData({
    required this.level,
    required this.label,
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
            color: selected ? const Color(0xFFE7F6EE) : const Color(0xFFB3B3B3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? const Color(0xFF6BC68D)
                  : const Color(0xFF8C8C8C),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.05),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
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
                            : const Color(0xFF3F3F3F),
                      ),
                    ),
                  ],
                ),
              ),
              if (locked)
                Positioned(
                  bottom: 6,
                  left: 0,
                  right: 0,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: 18,
                      height: 18,
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
    final percent = (tier.serviceProgress * 100).round();
    final remaining = (tier.totalServicesRequired - tier.completedServices)
        .clamp(0, tier.totalServicesRequired);
    final accent = _accentColor(tier.level);
    final track = _trackColor(tier.level);

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: tier.color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: tier.color),
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
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
                    Text(
                      isCurrent ? "Listing is visible" : "Tier overview",
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Colors.white70,
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
              color: accent,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withOpacity(.25)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.08),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Complete ${tier.totalServicesRequired} services",
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    height: 18,
                    color: track,
                    child: Stack(
                      children: [
                        // Green progress fill (dynamic width)
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: FractionallySizedBox(
                              widthFactor: tier.serviceProgress,
                              child: Container(color: const Color(0xFF2FA86A)),
                            ),
                          ),
                        ),
                        // Yellow capsule overlay (static width inside bar)
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Container(
                              height: 12,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFD068),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Row(
                                children: [
                                  const Expanded(
                                    child: Text(
                                      "Service completed",
                                      style: TextStyle(
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.w700,
                                        height: 1.0,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "$percent%",
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
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "${tier.completedServices}/${tier.totalServicesRequired} services completed",
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.white,
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
                const Text("🎯", style: TextStyle(fontSize: 12)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    "$remaining more services to reach ${nextTier!.label}",
                    style: const TextStyle(
                      color: Colors.white,
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

  Color _accentColor(TierLevel level) {
    switch (level) {
      case TierLevel.bronze:
        return const Color(0xFFCE8B4A);
      case TierLevel.silver:
        return const Color(0xFFB3B3B3);
      case TierLevel.gold:
        return const Color(0xFFE3B04A);
    }
  }

  Color _trackColor(TierLevel level) {
    switch (level) {
      case TierLevel.bronze:
        return const Color(0xFFF0CFAF);
      case TierLevel.silver:
        return const Color(0xFFE3E3E3);
      case TierLevel.gold:
        return const Color(0xFFF2E0B6);
    }
  }
}

class _TipCard extends StatelessWidget {
  const _TipCard({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      decoration: BoxDecoration(
        color: const Color(0xFFE7F6EE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFBDE6CE)),
      ),
      child: Row(
        children: [
          const Icon(Icons.track_changes, size: 16, color: Color(0xFF2FA86A)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
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
        color: selected ? const Color(0xFFE7F6EE) : const Color(0xFFBEBEBE),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: selected ? const Color(0xFF6BC68D) : const Color(0xFF8C8C8C),
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
                        ? const Color(0xFF2FA86A)
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
                        ? const Color(0xFF4F4F4F)
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

class _TierBenefitsList extends StatelessWidget {
  const _TierBenefitsList({required this.benefits});
  final List<String> benefits;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE7E7E7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 8,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
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

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.onTap,
    this.leading,
  });
  final String label;
  final VoidCallback onTap;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2FA86A),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: 8)],
            Text(
              label,
              style: GoogleFonts.urbanist(
                fontSize: 13.5,
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1F1F1F),
        title: Text(
          "Reach ${nextTier.label} Level",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
        children: [
          _RequirementCard(
            label: "Complete ${nextTier.totalServicesRequired} services",
            value:
                "${currentTier.completedServices}/${nextTier.totalServicesRequired} completed",
            progress:
                (currentTier.completedServices / nextTier.totalServicesRequired)
                    .clamp(0.0, 1.0),
            ok: _meetsService,
          ),
          const SizedBox(height: 10),
          _RequirementCard(
            label: "Maintain rating ${nextTier.requiredRating}+",
            value:
                "Current rating: ${currentTier.currentRating.toStringAsFixed(1)}",
            progress: (currentTier.currentRating / nextTier.requiredRating)
                .clamp(0.0, 1.0),
            ok: _meetsRating,
          ),
          const SizedBox(height: 10),
          _RequirementCard(
            label: "No policy violations",
            value: currentTier.hasViolations
                ? "Violations found"
                : "Clean record",
            progress: currentTier.hasViolations ? 0.3 : 1.0,
            ok: _meetsViolations,
          ),
          const SizedBox(height: 14),
          _TierBenefitsList(benefits: nextTier.benefits),
          const SizedBox(height: 14),
          _PrimaryButton(
            label: _allMet
                ? "Reach ${nextTier.label} (complete)"
                : "Reach ${nextTier.label} (complete requirements)",
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => TierSuccessScreen(
                    reachedTier: nextTier,
                    canProceed: _allMet,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _RequirementCard extends StatelessWidget {
  const _RequirementCard({
    required this.label,
    required this.value,
    required this.progress,
    required this.ok,
  });

  final String label;
  final String value;
  final double progress;
  final bool ok;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE7E7E7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                ok ? Icons.check_circle : Icons.radio_button_unchecked,
                size: 16,
                color: ok ? const Color(0xFF2FA86A) : const Color(0xFFBDBDBD),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F1F1F),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: Container(
              height: 8,
              color: const Color(0xFFEAEAEA),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: progress,
                  child: Container(color: const Color(0xFF2FA86A)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontSize: 11.5, color: Color(0xFF7B7B7B)),
          ),
        ],
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
