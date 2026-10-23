import 'package:flutter/material.dart';
import '../services/locale_service.dart';
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
    final localized = LocaleService.translateSeverity(severity);
    switch (severity.toUpperCase()) {
      case 'SEVERE':
        return StatusBadge(
          label: localized,
          backgroundColor: AppTheme.alertBg,
          textColor: AppTheme.alertRed,
          icon: Icons.error_outline_rounded,
        );
      case 'MODERATE':
        return StatusBadge(
          label: localized,
          backgroundColor: AppTheme.warningBg,
          textColor: AppTheme.warningAmber,
          icon: Icons.warning_amber_rounded,
        );
      case 'MILD':
      default:
        return StatusBadge(
          label: localized,
          backgroundColor: AppTheme.successBg,
          textColor: AppTheme.successGreen,
          icon: Icons.check_circle_outline_rounded,
        );
    }
  }

  factory StatusBadge.risk(String riskLevel) {
    String label;
    if (LocaleService.code == 'mr') {
      label = riskLevel.toUpperCase() == 'HIGH' ? 'उच्च धोका' : (riskLevel.toUpperCase() == 'ELEVATED' ? 'वाढलेला संसर्ग' : 'निरीक्षण');
    } else if (LocaleService.code == 'hi') {
      label = riskLevel.toUpperCase() == 'HIGH' ? 'उच्च जोखिम' : (riskLevel.toUpperCase() == 'ELEVATED' ? 'बढ़ा हुआ खतरा' : 'निगरानी');
    } else {
      label = riskLevel.toUpperCase() == 'HIGH' ? 'HIGH PRIORITY' : (riskLevel.toUpperCase() == 'ELEVATED' ? 'ELEVATED CLUSTER' : 'SURVEILLANCE WATCH');
    }

    switch (riskLevel.toUpperCase()) {
      case 'HIGH':
        return StatusBadge(
          label: label,
          backgroundColor: AppTheme.alertBg,
          textColor: AppTheme.alertRed,
          icon: Icons.campaign_rounded,
        );
      case 'ELEVATED':
        return StatusBadge(
          label: label,
          backgroundColor: AppTheme.warningBg,
          textColor: AppTheme.warningAmber,
          icon: Icons.insights_rounded,
        );
      default:
        return StatusBadge(
          label: label,
          backgroundColor: AppTheme.primaryLight,
          textColor: AppTheme.primaryTeal,
          icon: Icons.visibility_rounded,
        );
    }
  }

  factory StatusBadge.aiSource(String source) {
    final isLive = source.toUpperCase().contains('LIVE');
    String label;
    if (isLive) {
      label = LocaleService.code == 'mr' ? 'थेट एआय विश्लेषण' : (LocaleService.code == 'hi' ? 'लाइव एआई विश्लेषण' : 'LIVE LLM INTELLIGENCE');
      return StatusBadge(
        label: label,
        backgroundColor: const Color(0xFFE0E7FF),
        textColor: const Color(0xFF4338CA),
        icon: Icons.auto_awesome_rounded,
      );
    } else {
      label = LocaleService.code == 'mr' ? 'क्लिनिकल नॉलेज इंजिन' : (LocaleService.code == 'hi' ? 'क्लिनिकल नॉलेज इंजन' : 'CLINICAL KNOWLEDGE ENGINE');
      return StatusBadge(
        label: label,
        backgroundColor: const Color(0xFFE6FFFA),
        textColor: const Color(0xFF0D9488),
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
