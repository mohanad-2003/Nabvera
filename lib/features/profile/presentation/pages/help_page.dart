import 'package:fitness_app/core/localization/generated/app_localizations.dart';
import 'package:fitness_app/core/theme/app_theme_extension.dart';
import 'package:fitness_app/core/widgets/fade_slide_in.dart';
import 'package:fitness_app/core/widgets/premium_scaffold.dart';
import 'package:fitness_app/core/widgets/pressable_scale.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

/// Navigation args for [HelpPage], passed via GoRouter `extra` so callers
/// (e.g. Privacy → Contact Support) can land directly on the Contact tab.
class HelpPageArgs {
  const HelpPageArgs({this.startOnContact = false});
  final bool startOnContact;
}

class HelpPage extends StatefulWidget {
  const HelpPage({super.key, this.args = const HelpPageArgs()});

  final HelpPageArgs args;

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  late bool _isContactUsExpanded = widget.args.startOnContact;
  int _selectedTabIndex = 0;
  int? _expandedFaqIndex;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final tabs = [
      l10n.helpTabGeneral,
      l10n.helpTabAccount,
      l10n.helpTabServices,
    ];
    final contactOptions = [
      (
        l10n.helpContactCustomerService,
        'assets/customer.png',
        'support@fitbody.app',
      ),
      (l10n.helpContactWebsite, 'assets/website.png', 'www.fitbody.app'),
      (l10n.helpContactWhatsapp, 'assets/whats.png', '+1 555 010 2024'),
      (l10n.helpContactFacebook, 'assets/face_help.png', '@fitbody'),
      (l10n.helpContactInstagram, 'assets/insta.png', '@fitbody'),
    ];
    final faqs = [
      (l10n.helpFaqQ1, l10n.helpFaqA1),
      (l10n.helpFaqQ2, l10n.helpFaqA2),
      (l10n.helpFaqQ3, l10n.helpFaqA3),
      (l10n.helpFaqQ4, l10n.helpFaqA4),
      (l10n.helpFaqQ5, l10n.helpFaqA5),
    ];

    return PremiumScaffold(
      child: SingleChildScrollView(
        child: FadeSlideIn(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (context.canPop())
                    PremiumIconButton(
                      icon: Icons.arrow_back_ios_new_rounded,
                      onTap: () => context.pop(),
                    ),
                  const SizedBox(width: 12),
                  Text(
                    l10n.helpTitle,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: ext.textPrimary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Center(
                child: Text(
                  l10n.helpHowCanWeHelp,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: ext.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  _ToggleButton(
                    text: l10n.helpFaqTab,
                    isSelected: !_isContactUsExpanded,
                    onTap: () => setState(() => _isContactUsExpanded = false),
                  ),
                  const SizedBox(width: 12),
                  _ToggleButton(
                    text: l10n.helpContactUsTab,
                    isSelected: _isContactUsExpanded,
                    onTap: () => setState(() => _isContactUsExpanded = true),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              if (_isContactUsExpanded)
                Column(
                  children: [
                    for (final option in contactOptions) ...[
                      _ContactRow(
                        icon: option.$2,
                        title: option.$1,
                        value: option.$3,
                        onTap: () => _copyContact(context, option.$1, option.$3),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ],
                )
              else ...[
                Row(
                  children: List.generate(
                    tabs.length,
                    (index) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedTabIndex = index),
                          child: Container(
                            height: 36,
                            decoration: BoxDecoration(
                              color:
                                  _selectedTabIndex == index
                                      ? theme.colorScheme.primary
                                      : ext.glassFill,
                              borderRadius: BorderRadius.circular(20),
                              border:
                                  _selectedTabIndex == index
                                      ? null
                                      : Border.all(color: ext.glassBorder),
                            ),
                            child: Center(
                              child: Text(
                                tabs[index],
                                style: TextStyle(
                                  color:
                                      _selectedTabIndex == index
                                          ? theme.colorScheme.onPrimary
                                          : ext.textPrimary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                TextField(
                  decoration: InputDecoration(
                    filled: false,
                    fillColor: Colors.transparent,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: ext.glassBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: theme.colorScheme.primary,
                        width: 1.2,
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: theme.colorScheme.secondary,
                    ),
                    hintText: l10n.helpSearchHint,
                  ),
                ),
                const SizedBox(height: 22),
                for (var i = 0; i < faqs.length; i++) ...[
                  _FaqItem(
                    question: faqs[i].$1,
                    answer: faqs[i].$2,
                    expanded: _expandedFaqIndex == i,
                    onTap:
                        () => setState(
                          () =>
                              _expandedFaqIndex =
                                  _expandedFaqIndex == i ? null : i,
                        ),
                  ),
                  const SizedBox(height: 10),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _copyContact(BuildContext context, String label, String value) {
    Clipboard.setData(ClipboardData(text: value));
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).helpContactCopied(value)),
        backgroundColor: ext.cardColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  const _ToggleButton({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 36,
          decoration: BoxDecoration(
            gradient: isSelected ? ext.accentGradient : null,
            color: isSelected ? null : ext.glassFill,
            borderRadius: BorderRadius.circular(20),
            border: isSelected ? null : Border.all(color: ext.glassBorder),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: isSelected ? ext.onAccent : ext.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
  });

  final String icon;
  final String title;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return PressableScale(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ext.accentGlow.withValues(alpha: 0.14),
                ),
                child: Center(
                  child: Image.asset(icon, width: 20, height: 20),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: ext.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 14.5,
                      ),
                    ),
                    Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: ext.textMuted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Icon(Icons.copy_rounded, color: ext.accentGlow, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

class _FaqItem extends StatelessWidget {
  const _FaqItem({
    required this.question,
    required this.answer,
    required this.expanded,
    required this.onTap,
  });

  final String question;
  final String answer;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onTap,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    question,
                    style: TextStyle(
                      color: ext.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.5,
                    ),
                  ),
                ),
                Icon(
                  expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: ext.accentGlow,
                ),
              ],
            ),
          ),
          if (expanded) ...[
            const SizedBox(height: 8),
            Text(
              answer,
              style: TextStyle(color: ext.textMuted, fontSize: 13, height: 1.5),
            ),
          ],
        ],
      ),
    );
  }
}
