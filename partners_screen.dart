import 'package:flutter/material.dart';
import 'package:hushh/models.dart';
import 'package:hushh/app_theme.dart';
import 'package:hushh/shared_widgets.dart';

//Partners list screen
class PartnersScreen extends StatefulWidget {
  const PartnersScreen({super.key});

  @override
  State<PartnersScreen> createState() => _PartnersScreenState();
}
class _PartnersScreenState extends State<PartnersScreen> {
  // Local copy so we can toggle active state without a state-management package
  late final List<DataPartner> _partners;

  @override
  void initState() {
    super.initState();
    _partners = List.from(SampleData.partners);
  }

  void _togglePartner(int index) {
    setState(() {
      final p = _partners[index];
      _partners[index] = p.copyWith(
        isActive: !p.isActive,
        lastUpdated: DateTime.now(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final active = _partners.where((p) => p.isActive).toList();
    final inactive = _partners.where((p) => !p.isActive).toList();

    return Scaffold(
      backgroundColor: AppTheme.bgBase,
      appBar: AppBar(
        title: const Text('Data Partners'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () => _showInfoSheet(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (active.isNotEmpty) ...[
            const SectionHeader(title: 'Active access'),
            const SizedBox(height: 14),
            ...active.map((p) {
              final idx = _partners.indexOf(p);
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _PartnerListCard(
                  partner: p,
                  onToggle: () => _togglePartner(idx),
                  onTap: () => _openDetail(context, p, idx),
                ),
              );
            }),
            const SizedBox(height: 24),
          ],
          if (inactive.isNotEmpty) ...[
            const SectionHeader(title: 'No access'),
            const SizedBox(height: 14),
            ...inactive.map((p) {
              final idx = _partners.indexOf(p);
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _PartnerListCard(
                  partner: p,
                  onToggle: () {
                    // Before granting, show the permission summary
                    _showPermissionSheet(context, p, () => _togglePartner(idx));
                  },
                  onTap: () => _openDetail(context, p, idx),
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  void _openDetail(BuildContext ctx, DataPartner p, int idx) {
    Navigator.of(ctx).push(
      MaterialPageRoute(
        builder: (_) => PartnerDetailScreen(
          partner: p,
          onToggle: () => _togglePartner(idx),
        ),
      ),
    );
  }

  void _showInfoSheet(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      backgroundColor: AppTheme.bgSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const _InfoSheet(),
    );
  }

  void _showPermissionSheet(
      BuildContext ctx,
      DataPartner partner,
      VoidCallback onConfirm,
      ) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: AppTheme.bgSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => PermissionSummarySheet(
        partner: partner,
        onConfirm: () {
          Navigator.pop(ctx);
          onConfirm();
        },
        onDeny: () => Navigator.pop(ctx),
      ),
    );
  }
}

// ─── Partner card in the list ─────────────────────────────────────────────────

class _PartnerListCard extends StatelessWidget {
  const _PartnerListCard({
    required this.partner,
    required this.onToggle,
    required this.onTap,
  });

  final DataPartner partner;
  final VoidCallback onToggle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return HushhCard(
      onTap: onTap,
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
                Text(partner.category, style: AppTheme.caption),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Switch.adaptive(
                value: partner.isActive,
                onChanged: (_) => onToggle(),
                activeColor: AppTheme.teal,
                inactiveThumbColor: AppTheme.textMuted,
                inactiveTrackColor: AppTheme.bgCardElevated,
              ),
              RiskBadge(level: partner.riskLevel),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Partner detail screen ────────────────────────────────────────────────────

/// Full detail for a single data partner.
/// Shows what they want, why, and lets the user revoke or approve.
class PartnerDetailScreen extends StatelessWidget {
  const PartnerDetailScreen({
    super.key,
    required this.partner,
    this.onToggle,
  });

  final DataPartner partner;
  final VoidCallback? onToggle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgBase,
      appBar: AppBar(title: Text(partner.name)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Header
          Row(
            children: [
              PartnerAvatar(logo: partner.logoAsset, size: 64),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(partner.name, style: AppTheme.headline2),
                    const SizedBox(height: 4),
                    Text(partner.category, style: AppTheme.caption),
                    const SizedBox(height: 8),
                    RiskBadge(level: partner.riskLevel),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Description
          HushhCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Why they want access',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  partner.description,
                  style: AppTheme.body.copyWith(fontSize: 14),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Requested fields
          HushhCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Requested data',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${partner.requestedFields.length} fields',
                      style: AppTheme.caption,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...partner.requestedFields.asMap().entries.map((entry) {
                  final i = entry.key;
                  final field = entry.value;
                  return Column(
                    children: [
                      if (i > 0) const HushhDivider(indent: 0),
                      _DataFieldTile(field: field),
                    ],
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Access info
          HushhCard(
            child: Column(
              children: [
                _InfoRow(
                  icon: Icons.timer_outlined,
                  label: 'Access duration',
                  value: partner.accessDuration,
                ),
                const HushhDivider(),
                _InfoRow(
                  icon: partner.isActive
                      ? Icons.check_circle_outline_rounded
                      : Icons.cancel_outlined,
                  label: 'Status',
                  value: partner.isActive ? 'Active' : 'Inactive',
                  valueColor:
                  partner.isActive ? AppTheme.success : AppTheme.textMuted,
                ),
                if (partner.lastUpdated != null) ...[
                  const HushhDivider(),
                  _InfoRow(
                    icon: Icons.update_rounded,
                    label: 'Last updated',
                    value: _formatDate(partner.lastUpdated!),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 28),

          // Action button
          if (onToggle != null)
            partner.isActive
                ? OutlinedButton.icon(
              onPressed: () {
                onToggle!();
                Navigator.pop(context);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.danger,
                side: const BorderSide(color: AppTheme.danger),
              ),
              icon: const Icon(Icons.block_rounded, size: 18),
              label: const Text('Revoke access'),
            )
                : ElevatedButton.icon(
              onPressed: () {
                onToggle!();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.check_rounded, size: 18),
              label: const Text('Grant access'),
            ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

class _DataFieldTile extends StatelessWidget {
  const _DataFieldTile({required this.field});
  final DataField field;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      field.label,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    if (field.isRequired) ...[
                      const SizedBox(width: 6),
                      const Text(
                        'required',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppTheme.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(field.description, style: AppTheme.caption),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SensitivityChip(sensitivity: field.sensitivity),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor = AppTheme.textPrimary,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppTheme.textMuted),
          const SizedBox(width: 10),
          Text(label, style: AppTheme.body.copyWith(fontSize: 13)),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Permission summary bottom sheet ─────────────────────────────────────────

/// The "share safely" confirmation sheet.
/// Shows before granting any partner access — this is the key trust moment.
class PermissionSummarySheet extends StatelessWidget {
  const PermissionSummarySheet({
    super.key,
    required this.partner,
    required this.onConfirm,
    required this.onDeny,
  });

  final DataPartner partner;
  final VoidCallback onConfirm;
  final VoidCallback onDeny;

  bool get _hasHighRisk =>
      partner.requestedFields.any((f) => f.sensitivity == Sensitivity.high);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.92,
      expand: false,
      builder: (_, controller) => Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.textMuted.withOpacity(0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Expanded(
            child: ListView(
              controller: controller,
              padding: const EdgeInsets.all(24),
              children: [
                // Header
                Row(
                  children: [
                    PartnerAvatar(logo: partner.logoAsset, size: 52),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${partner.name} wants access',
                            style: AppTheme.headline2,
                          ),
                          const SizedBox(height: 4),
                          RiskBadge(level: partner.riskLevel),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Risk warning if applicable
                if (_hasHighRisk) _RiskWarningBanner(),

                // What they're requesting
                const Text(
                  'They want access to:',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                ...partner.requestedFields.map(
                      (f) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _FieldSummaryRow(field: f),
                  ),
                ),

                const SizedBox(height: 16),
                HushhDivider(),
                const SizedBox(height: 16),

                // Duration
                Row(
                  children: [
                    const Icon(Icons.timer_outlined,
                        color: AppTheme.textMuted, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Access granted for ${partner.accessDuration}',
                      style: AppTheme.body.copyWith(fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.undo_rounded,
                        color: AppTheme.textMuted, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'You can revoke this at any time',
                      style: AppTheme.body.copyWith(fontSize: 13),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // Action buttons
                ElevatedButton(
                  onPressed: onConfirm,
                  child: const Text('Allow access'),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: onDeny,
                  child: const Text('Deny'),
                ),

                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RiskWarningBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.danger.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.danger.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded,
              color: AppTheme.danger, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'This request includes highly sensitive data. '
                  'Review carefully before approving.',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.danger.withOpacity(0.9),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldSummaryRow extends StatelessWidget {
  const _FieldSummaryRow({required this.field});
  final DataField field;

  @override
  Widget build(BuildContext context) {
    final sentColor = switch (field.sensitivity) {
      Sensitivity.low => AppTheme.success,
      Sensitivity.medium => AppTheme.warning,
      Sensitivity.high => AppTheme.danger,
    };

    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: sentColor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            field.label,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SensitivityChip(sensitivity: field.sensitivity),
      ],
    );
  }
}
class _InfoSheet extends StatelessWidget {
  const _InfoSheet();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('How data partners work', style: AppTheme.headline2),
          const SizedBox(height: 12),
          Text(
            'Data partners are companies or services that have requested access '
                'to portions of your personal data. Unlike traditional apps that '
                'take your data silently, Hushh shows you exactly what each partner '
                'is asking for — and you decide whether to allow it.',
            style: AppTheme.body,
          ),
          const SizedBox(height: 16),
          Text(
            'You can revoke access at any time. Once revoked, the partner is '
                'notified and must delete any data they have stored.',
            style: AppTheme.body,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
