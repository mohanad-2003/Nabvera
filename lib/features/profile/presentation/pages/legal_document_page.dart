import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/fade_slide_in.dart';
import 'package:nabvera/core/widgets/premium_scaffold.dart';
import 'package:flutter/material.dart';

enum LegalDocumentType { privacyPolicy, terms }

/// Generic reader for the two static legal documents reachable from
/// Profile → Privacy — replaces the "coming soon" snackbar stubs that used
/// to sit behind the Privacy Policy / Terms & Conditions tiles.
class LegalDocumentPage extends StatelessWidget {
  const LegalDocumentPage({super.key, required this.type});

  final LegalDocumentType type;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);
    final title = switch (type) {
      LegalDocumentType.privacyPolicy => l10n.privacyPolicy,
      LegalDocumentType.terms => l10n.privacyTerms,
    };
    final body = switch (type) {
      LegalDocumentType.privacyPolicy => l10n.legalPrivacyPolicyBody,
      LegalDocumentType.terms => l10n.legalTermsBody,
    };
    // The mock legal copy is written as paragraphs separated by a blank
    // line — split them into their own cards for clearer section breaks
    // and a more readable line length, instead of one dense text block.
    final paragraphs =
        body.split('\n\n').where((p) => p.trim().isNotEmpty).toList();

    return PremiumScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeSlideIn(
            offset: const Offset(0, -0.1),
            child: Row(
              children: [
                if (Navigator.of(context).canPop())
                  PremiumBackButton(onTap: () => Navigator.of(context).pop()),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: ext.textPrimary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: paragraphs.length,
              separatorBuilder: (_, _) => Divider(color: ext.glassBorder),
              itemBuilder: (context, index) {
                return FadeSlideIn(
                  delay: Duration(milliseconds: 60 * index),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 26,
                          height: 26,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ext.accentGlow.withValues(alpha: 0.14),
                          ),
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: ext.accentGlow,
                              fontWeight: FontWeight.w800,
                              fontSize: 12.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            paragraphs[index].trim(),
                            style: TextStyle(
                              color: ext.textMuted,
                              fontSize: 13.5,
                              height: 1.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
