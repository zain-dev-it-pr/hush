import 'package:flutter/material.dart';

import 'package:hushh/models.dart';
import 'package:hushh/app_theme.dart';

class RiskBadge extends StatelessWidget {
  const RiskBadge({super.key, required this.level});
final RiskLevel level;
 @override
  Widget build(BuildContext context) {
    final (label, color) = switch (level) {
      RiskLevel.low => ('Low risk', AppTheme.success),
      RiskLevel.medium => ('Medium risk', AppTheme.warning),
      RiskLevel.high => ('High risk', AppTheme.danger),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

// ─── Sensitivity Chip
class SensitivityChip extends StatelessWidget {
  const SensitivityChip({super.key, required this.sensitivity});
 final Sensitivity sensitivity;
@override
  Widget build(BuildContext context) {
    final (icon, label, color) = switch (sensitivity) {
      Sensitivity.low => (Icons.circle_outlined, 'Low', AppTheme.textMuted),
      Sensitivity.medium => (Icons.circle, 'Sensitive', AppTheme.warning),
      Sensitivity.high => (Icons.warning_amber_rounded, 'Very sensitive', AppTheme.danger),
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// Section Header


class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.action,
  });

  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title.toUpperCase(),
          style: AppTheme.label,
        ),
        const Spacer(),
        if (action != null) action!,
      ],
    );
  }
}
class HushhCard extends StatelessWidget {
  const HushhCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
  });

  final Widget child;
  final EdgeInsets padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.bgCard,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: AppTheme.teal.withOpacity(0.08),
        highlightColor: AppTheme.teal.withOpacity(0.04),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.border),
          ),
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
class PartnerAvatar extends StatelessWidget {
  const PartnerAvatar({
    super.key,
    required this.logo,
    this.size = 48,
  });

  final String logo;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppTheme.bgCardElevated,
        shape: BoxShape.circle,
        border: Border.all(color: AppTheme.border),
      ),
      child: Center(
        child: Text(
          logo,
          style: TextStyle(fontSize: size * 0.4),
        ),
      ),
    );
  }
}

class HushhDivider extends StatelessWidget {
  const HushhDivider({super.key, this.indent = 0});

  final double indent;

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: AppTheme.border,
      thickness: 1,
      height: 1,
      indent: indent,
    );
  }
}
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: AppTheme.textMuted),
            const SizedBox(height: 16),
            Text(title, style: AppTheme.headline2, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: AppTheme.body,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
