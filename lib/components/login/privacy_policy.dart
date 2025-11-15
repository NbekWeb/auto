import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../colors.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 12,
          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        ),
        children: [
          const TextSpan(text: 'Нажимая на кнопку, соглашаюсь\nс '),
          TextSpan(
            text: 'политикой конфиденциальности',
            style: TextStyle(
              color: AppColors.orangeSelected,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                final Uri url = Uri.parse('https://myvela.ai/politics');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
          ),
        ],
      ),
    );
  }
}
