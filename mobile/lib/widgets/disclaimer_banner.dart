import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class DisclaimerBanner extends StatelessWidget {
  final String text;
  final bool isEpidemiological;

  const DisclaimerBanner({
    super.key,
    this.text = 'AI-generated clinical decision support. Final assessment remains with a qualified veterinarian.',
    this.isEpidemiological = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isEpidemiological ? const Color(0xFFFFFBEB) : const Color(0xFFF0FDF4);
    final borderColor = isEpidemiological ? const Color(0xFFFDE68A) : const Color(0xFFBBF7D0);
    final iconColor = isEpidemiological ? AppTheme.warningAmber : AppTheme.secondaryEmerald;
    final textColor = isEpidemiological ? const Color(0xFF92400E) : const Color(0xFF166534);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isEpidemiological ? Icons.crisis_alert_rounded : Icons.verified_user_outlined,
            color: iconColor,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
