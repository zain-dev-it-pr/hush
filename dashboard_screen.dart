import 'package:flutter/material.dart';

import 'package:hushh/models.dart';
import 'package:hushh/app_theme.dart';
import 'package:hushh/shared_widgets.dart';
import 'partners_screen.dart';

/// The home tab — gives a quick health check of the user's data sharing.
/// shortcut. The idea: you can see your entire data posture in one glance.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final activePartners = SampleData.partners.where((p) => p.isActive).toList();
    final totalFields = activePartners.fold<int>(0, (sum, p) => sum + p.requestedFields.length);
    return Scaffold(
      backgroundColor: AppTheme.bgBase,
      body: CustomScrollView(slivers: [_buildAppBar(),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(delegate: SliverChildListDelegate([
                _StatsRow(
                  activeCount: activePartners.length, fieldCount: totalFields, lastActivity: '2 hours ago',
                ),
                const SizedBox(height: 28),
                const SectionHeader(title: 'Active partners'),
                const SizedBox(height: 14),
                ...activePartners.map(
                      (p) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _ActivePartnerCard(partner: p),
                  ),
                ),
                const SizedBox(height: 20),
                _DataHealthCard(partners: SampleData.partners),
                const SizedBox(height: 12),
                _QuickTipCard(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar() {
    return SliverAppBar(pinned: true,
      backgroundColor: AppTheme.bgBase, expandedHeight: 100,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Good morning 👋',
              style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
            ),
            SizedBox(height: 2),
            Text(
              'Your data dashboard', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Stats row ────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  const _StatsRow({
    required this.activeCount,
    required this.fieldCount,
    required this.lastActivity,
  });
  final int activeCount;
  final int fieldCount;
  final String lastActivity;
  @override
  Widget build(BuildContext context) {
    return Row(children: [
        Expanded(
          child: _StatCard(value: '$activeCount', label: 'Active\npartners', color: AppTheme.teal,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(value: '$fieldCount', label: 'Fields\nshared', color: AppTheme.warning,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: _StatCard(
            value: lastActivity, label: 'Last\nactivity', color: AppTheme.info, smallValue: true,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
    required this.color,
    this.smallValue = false,
  });

  final String value;
  final String label;
  final Color color;
  final bool smallValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: smallValue ? 14 : 26,
              fontWeight: FontWeight.w700,
              color: color,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 6),
          Text(label, style: AppTheme.caption),
        ],
      ),
    );
  }
}

// ─── Active partner card ──────────────────────────────────────────────────────

class _ActivePartnerCard extends StatelessWidget {
  const _ActivePartnerCard({required this.partner});
  final DataPartner partner;

  @override
  Widget build(BuildContext context) {
    return HushhCard(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PartnerDetailScreen(partner: partner),
          ),
        );
      },
      child: Row(
        children: [
          PartnerAvatar(logo: partner.logoAsset),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  partner.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${partner.requestedFields.length} fields · ${partner.accessDuration}',
                  style: AppTheme.caption,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              RiskBadge(level: partner.riskLevel),
              const SizedBox(height: 6),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppTheme.textMuted,
                size: 18,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//  Data health card

class _DataHealthCard extends StatelessWidget {
  const _DataHealthCard({required this.partners});
  final List<DataPartner> partners;

  @override
  Widget build(BuildContext context) {
    final highRisk = partners.where((p) => p.isActive && p.riskLevel == RiskLevel.high).length;
    final score = highRisk == 0 ? 92 : highRisk == 1 ? 71 : 45;
    final scoreColor = score > 80
        ? AppTheme.success
        : score > 60
        ? AppTheme.warning
        : AppTheme.danger;

    return HushhCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.health_and_safety_outlined,
                  color: AppTheme.teal, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Privacy health score',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const Spacer(),
              Text(
                '$score / 100',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: scoreColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: score / 100,
              backgroundColor: AppTheme.bgCardElevated,
              valueColor: AlwaysStoppedAnimation(scoreColor),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            highRisk > 0
                ? 'You have $highRisk high-risk partner(s) active. Consider reviewing.'
                : 'Looking good — no high-risk partners are currently active.',
            style: AppTheme.caption.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// Quick tip

class _QuickTipCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.teal.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.teal.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lightbulb_outline_rounded,
              color: AppTheme.teal, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Quick tip',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.teal,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Regularly check the Audit tab to see when data was last accessed. '
                      'If a partner hasn\'t accessed your data in 3+ months, consider revoking.',
                  style: AppTheme.caption.copyWith(fontSize: 12, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
