import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;

  const StatusBadge({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    this.icon,
  });

  factory StatusBadge.severity(String severity) {
    switch (severity.toUpperCase()) {
      case 'SEVERE':
        return const StatusBadge(
          label: 'SEVERE',
          backgroundColor: AppTheme.alertBg,
          textColor: AppTheme.alertRed,
          icon: Icons.error_outline_rounded,
        );
      case 'MODERATE':
        return const StatusBadge(
          label: 'MODERATE',
          backgroundColor: AppTheme.warningBg,
          textColor: AppTheme.warningAmber,
          icon: Icons.warning_amber_rounded,
        );
      case 'MILD':
      default:
        return const StatusBadge(
          label: 'MILD',
          backgroundColor: AppTheme.successBg,
          textColor: AppTheme.successGreen,
          icon: Icons.check_circle_outline_rounded,
        );
    }
  }

  factory StatusBadge.risk(String riskLevel) {
    switch (riskLevel.toUpperCase()) {
      case 'HIGH':
        return const StatusBadge(
          label: 'HIGH PRIORITY',
          backgroundColor: AppTheme.alertBg,
          textColor: AppTheme.alertRed,
          icon: Icons.campaign_rounded,
        );
      case 'ELEVATED':
        return const StatusBadge(
          label: 'ELEVATED CLUSTER',
          backgroundColor: AppTheme.warningBg,
          textColor: AppTheme.warningAmber,
          icon: Icons.insights_rounded,
        );
      default:
        return const StatusBadge(
          label: 'SURVEILLANCE WATCH',
          backgroundColor: AppTheme.primaryLight,
          textColor: AppTheme.primaryTeal,
          icon: Icons.visibility_rounded,
        );
    }
  }

  factory StatusBadge.aiSource(String source) {
    final isLive = source.toUpperCase().contains('LIVE');
    if (isLive) {
      return const StatusBadge(
        label: 'LIVE LLM INTELLIGENCE',
        backgroundColor: Color(0xFFE0E7FF),
        textColor: Color(0xFF4338CA),
        icon: Icons.auto_awesome_rounded,
      );
    } else {
      return const StatusBadge(
        label: 'CLINICAL KNOWLEDGE ENGINE',
        backgroundColor: Color(0xFFE6FFFA),
        textColor: Color(0xFF0D9488),
        icon: Icons.psychology_rounded,
      );
    }
  }

  factory StatusBadge.synthetic() {
    return const StatusBadge(
      label: 'SYNTHETIC DEMO',
      backgroundColor: Color(0xFFF1F5F9),
      textColor: Color(0xFF475569),
      icon: Icons.science_outlined,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
