import 'package:flutter/material.dart';
import 'package:hushh/app_theme.dart';
import 'package:hushh/shared_widgets.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // These would be persisted in SharedPreferences or a state manager
  bool _consentNotifications = true;
  bool _biometricLock = false;
  bool _analyticsOptOut = true;
  bool _autoRevoke = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgBase,
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _ProfileHeader(),
          const SizedBox(height: 28),
          const SectionHeader(title: 'Privacy preferences'),
          const SizedBox(height: 14),
          HushhCard(
            child: Column(
              children: [
                _ToggleSetting(
                  icon: Icons.notifications_outlined,
                  title: 'Consent notifications',
                  subtitle: 'Alert me before any data is shared',
                  value: _consentNotifications,
                  onChanged: (v) => setState(() => _consentNotifications = v),
                ),
                const HushhDivider(),
                _ToggleSetting(
                  icon: Icons.fingerprint_rounded,
                  title: 'Biometric lock',
                  subtitle: 'Require Face ID / fingerprint to approve shares',
                  value: _biometricLock,
                  onChanged: (v) => setState(() => _biometricLock = v),
                ),
                const HushhDivider(),
                _ToggleSetting(
                  icon: Icons.bar_chart_outlined,
                  title: 'Opt out of analytics',
                  subtitle: 'Don\'t share anonymous usage data with Hushh',
                  value: _analyticsOptOut,
                  onChanged: (v) => setState(() => _analyticsOptOut = v),
                ),
                const HushhDivider(),
                _ToggleSetting(
                  icon: Icons.timer_off_outlined,
                  title: 'Auto-revoke expired access',
                  subtitle: 'Revoke access automatically when duration ends',
                  value: _autoRevoke,
                  onChanged: (v) => setState(() => _autoRevoke = v),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          const SectionHeader(title: 'Account'),
          const SizedBox(height: 14),
          HushhCard(
            child: Column(
              children: [
                _TappableSetting(
                  icon: Icons.download_outlined,
                  title: 'Export my data',
                  subtitle: 'Download a copy of all your sharing history',
                  onTap: () => _showComingSoon(context, 'Export'),
                ),
                const HushhDivider(),
                _TappableSetting(
                  icon: Icons.history_rounded,
                  title: 'Clear audit log',
                  subtitle: 'Remove all past sharing records locally',
                  onTap: () => _confirmClear(context),
                ),
                const HushhDivider(),
                _TappableSetting(
                  icon: Icons.lock_reset_rounded,
                  title: 'Change PIN',
                  onTap: () => _showComingSoon(context, 'Change PIN'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          const SectionHeader(title: 'About'),
          const SizedBox(height: 14),
          HushhCard(
            child: Column(
              children: [
                _TappableSetting(
                  icon: Icons.policy_outlined,
                  title: 'Privacy policy',
                  onTap: () {},
                ),
                const HushhDivider(),
                _TappableSetting(
                  icon: Icons.article_outlined,
                  title: 'Terms of service',
                  onTap: () {},
                ),
                const HushhDivider(),
                _TappableSetting(
                  icon: Icons.info_outline_rounded,
                  title: 'App version',
                  trailing: const Text(
                    '1.0.0',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.textMuted,
                    ),
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Sign out — separate so it feels intentional
          OutlinedButton.icon(
            onPressed: () => _confirmSignOut(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.danger,
              side: const BorderSide(color: AppTheme.danger),
            ),
            icon: const Icon(Icons.logout_rounded, size: 18),
            label: const Text('Sign out'),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext ctx, String feature) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Text('$feature — coming soon'),
        backgroundColor: AppTheme.bgCard,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _confirmClear(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.bgCard,
        title: const Text('Clear audit log?',
            style: TextStyle(color: AppTheme.textPrimary)),
        content: const Text(
          'This removes your local history. It doesn\'t affect what partners hold.',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(color: AppTheme.textMuted)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(ctx).showSnackBar(
                const SnackBar(
                  content: Text('Audit log cleared'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Clear',
                style: TextStyle(color: AppTheme.danger)),
          ),
        ],
      ),
    );
  }

  void _confirmSignOut(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.bgCard,
        title: const Text('Sign out?',
            style: TextStyle(color: AppTheme.textPrimary)),
        content: const Text(
          'You\'ll need to sign back in to manage your data permissions.',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(color: AppTheme.textMuted)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Sign out',
                style: TextStyle(color: AppTheme.danger)),
          ),
        ],
      ),
    );
  }
} // ─── Profile header
class _ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppTheme.teal.withOpacity(0.15),
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.teal.withOpacity(0.3)),
          ),
          child: const Center(
            child: Text('👤', style: TextStyle(fontSize: 28)),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Alex Johnson',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 3),
              const Text(
                'alex@example.com',
                style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.teal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.teal.withOpacity(0.3)),
                ),
                child: const Text(
                  '🛡️  Privacy Pro',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.teal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.edit_outlined,
              color: AppTheme.textMuted, size: 20),
        ),
      ],
    );
  }
}

class _ToggleSetting extends StatelessWidget {
  const _ToggleSetting({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.textMuted),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimary,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(subtitle!, style: AppTheme.caption),
                ],
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.teal,
          ),
        ],
      ),
    );
  }
}

class _TappableSetting extends StatelessWidget {
  const _TappableSetting({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppTheme.textMuted),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle!, style: AppTheme.caption),
                  ],
                ],
              ),
            ),
            trailing ??
                const Icon(Icons.chevron_right_rounded,
                    color: AppTheme.textMuted, size: 18),
          ],
        ),
      ),
    );
  }
}
