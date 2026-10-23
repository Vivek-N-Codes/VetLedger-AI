import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/locale_service.dart';

class DisclaimerBanner extends StatelessWidget {
  final String? text;
  final bool isEpidemiological;

  const DisclaimerBanner({
    super.key,
    this.text,
    this.isEpidemiological = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isEpidemiological ? const Color(0xFFFFFBEB) : const Color(0xFFF0FDF4);
    final borderColor = isEpidemiological ? const Color(0xFFFDE68A) : const Color(0xFFBBF7D0);
    final iconColor = isEpidemiological ? AppTheme.warningAmber : AppTheme.secondaryEmerald;
    final textColor = isEpidemiological ? const Color(0xFF92400E) : const Color(0xFF166534);

    String defaultDisclaimer;
    if (isEpidemiological) {
      defaultDisclaimer = LocaleService.code == 'mr'
          ? 'एआय महामारी सतर्कता निर्देशक. अंतिम फील्ड तपासणी व पुष्टीकरण पशुसंवर्धन अधिकाऱ्यांच्या अखत्यारीत आहे.'
          : (LocaleService.code == 'hi'
              ? 'एआई महामारी निगरानी संकेतक। अंतिम सत्यापन योग्य पशु चिकित्सा अधिकारी के अधीन है।'
              : 'AI epidemiological surveillance indicator. Final validation remains under qualified veterinary jurisdiction.');
    } else {
      defaultDisclaimer = LocaleService.code == 'mr'
          ? 'एआय-निर्मित क्लिनिकल निर्णय साहाय्य. अंतिम वैद्यकीय निर्णय अधिकृत पशुवैद्यकांचा राहील.'
          : (LocaleService.code == 'hi'
              ? 'एआई-जनरेटेड नैदानिक निर्णय समर्थन। अंतिम मूल्यांकन योग्य पशु चिकित्सक के पास है।'
              : 'AI-generated clinical decision support. Final assessment remains with a qualified veterinarian.');
    }

    final displayText = (text != null && text!.isNotEmpty)
        ? LocaleService.translateAdvisory(text!)
        : defaultDisclaimer;

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
              displayText,
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
