import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/theme/app_colors.dart';
import 'package:nabvera/core/theme/app_spacing.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/fade_slide_in.dart';
import 'package:nabvera/core/widgets/premium_scaffold.dart';
import 'package:nabvera/core/widgets/pressable_scale.dart';

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
  late bool _showContact = widget.args.startOnContact;
  final _searchController = TextEditingController();
  int _selectedCategory = 0;
  int? _expandedFaqIndex;
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final categories = [
      l10n.helpTabGeneral,
      l10n.helpTabAccount,
      l10n.helpTabServices,
    ];
    final faqs = [
      _HelpFaq(l10n.helpFaqQ1, l10n.helpFaqA1, 2),
      _HelpFaq(l10n.helpFaqQ2, l10n.helpFaqA2, 2),
      _HelpFaq(l10n.helpFaqQ3, l10n.helpFaqA3, 0),
      _HelpFaq(l10n.helpFaqQ4, l10n.helpFaqA4, 1),
      _HelpFaq(l10n.helpFaqQ5, l10n.helpFaqA5, 1),
    ];
    final visibleFaqs = [
      for (var i = 0; i < faqs.length; i++)
        if ((_query.isNotEmpty || faqs[i].category == _selectedCategory) &&
            (_query.isEmpty ||
                '${faqs[i].question} ${faqs[i].answer}'.toLowerCase().contains(
                  _query.toLowerCase(),
                )))
          (index: i, faq: faqs[i]),
    ];
    final contacts = [
      _ContactOption(
        l10n.helpContactCustomerService,
        'assets/customer.png',
        'mohnadzakoot34@gmail.com',
      ),
      // Website/WhatsApp/Facebook/Instagram tiles removed — they held
      // leftover "FitBody"-branding placeholder values (a fake +1 555
      // number, @fitbody handles, www.fitbody.app) that were never real
      // for Nabvera. Add them back with real values once those channels
      // exist; showing fake contact info is misleading (and a possible
      // App Store/Play Store review flag).
    ];

    return PremiumScaffold(
      child: FadeSlideIn(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _HelpHero(
                title: l10n.helpTitle,
                subtitle: l10n.helpHowCanWeHelp,
                showBack: context.canPop(),
                onBack: () => context.pop(),
                faqCount: faqs.length,
                contactCount: contacts.length,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 22)),
            SliverToBoxAdapter(
              child: _ModeSwitch(
                faqLabel: l10n.helpFaqTab,
                contactLabel: l10n.helpContactUsTab,
                showContact: _showContact,
                onFaq: () => setState(() => _showContact = false),
                onContact: () => setState(() => _showContact = true),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 22)),
            if (_showContact)
              SliverList.separated(
                itemCount: contacts.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) => _ContactCard(
                  option: contacts[index],
                  onTap: () => _copyContact(contacts[index].value),
                ),
              )
            else ...[
              SliverToBoxAdapter(
                child: _SearchField(
                  controller: _searchController,
                  hint: l10n.helpSearchHint,
                  onChanged: (value) => setState(() => _query = value.trim()),
                  onClear: _query.isEmpty
                      ? null
                      : () {
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              SliverToBoxAdapter(
                child: _CategoryTabs(
                  labels: categories,
                  selectedIndex: _selectedCategory,
                  onSelected: (index) => setState(() {
                    _selectedCategory = index;
                    _expandedFaqIndex = null;
                  }),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 18)),
              if (visibleFaqs.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _NoResults(
                    title: l10n.searchNoResultsTitle,
                    message: l10n.searchNoResultsBody,
                  ),
                )
              else
                SliverList.separated(
                  itemCount: visibleFaqs.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, position) {
                    final entry = visibleFaqs[position];
                    return _FaqCard(
                      question: entry.faq.question,
                      answer: entry.faq.answer,
                      categoryLabel: categories[entry.faq.category],
                      icon: _categoryIcon(entry.faq.category),
                      expanded: _expandedFaqIndex == entry.index,
                      onTap: () => setState(() {
                        _expandedFaqIndex = _expandedFaqIndex == entry.index
                            ? null
                            : entry.index;
                      }),
                    );
                  },
                ),
            ],
            const SliverToBoxAdapter(child: SizedBox(height: 28)),
          ],
        ),
      ),
    );
  }

  IconData _categoryIcon(int category) => switch (category) {
    0 => Icons.tune_rounded,
    1 => Icons.person_outline_rounded,
    _ => Icons.bolt_rounded,
  };

  void _copyContact(String value) {
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

class _HelpHero extends StatelessWidget {
  const _HelpHero({
    required this.title,
    required this.subtitle,
    required this.showBack,
    required this.onBack,
    required this.faqCount,
    required this.contactCount,
  });

  final String title;
  final String subtitle;
  final bool showBack;
  final VoidCallback onBack;
  final int faqCount;
  final int contactCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;

    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (showBack) ...[
                PremiumBackButton(onTap: onBack),
                const SizedBox(width: 12),
              ],
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: ext.accentGradient,
                  boxShadow: [
                    BoxShadow(
                      color: ext.accentGlow.withValues(alpha: 0.22),
                      blurRadius: 22,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(Icons.support_agent_rounded, color: ext.onAccent),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: ext.textPrimary,
              fontWeight: FontWeight.w900,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Text(
              subtitle,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: ext.textMuted,
                height: 1.35,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _HelpMetric(
                icon: Icons.quiz_outlined,
                value: '$faqCount',
                color: ext.accentGlow,
              ),
              const SizedBox(width: 10),
              _HelpMetric(
                icon: Icons.forum_outlined,
                value: '$contactCount',
                color: theme.colorScheme.secondary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HelpMetric extends StatelessWidget {
  const _HelpMetric({
    required this.icon,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 7),
          Text(
            value,
            style: TextStyle(
              color: ext.textPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeSwitch extends StatelessWidget {
  const _ModeSwitch({
    required this.faqLabel,
    required this.contactLabel,
    required this.showContact,
    required this.onFaq,
    required this.onContact,
  });

  final String faqLabel;
  final String contactLabel;
  final bool showContact;
  final VoidCallback onFaq;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: _surfaceTint(context, alpha: 0.86),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: _borderTint(context)),
      ),
      child: Row(
        children: [
          _ModeSegment(
            label: faqLabel,
            icon: Icons.quiz_outlined,
            selected: !showContact,
            onTap: onFaq,
          ),
          _ModeSegment(
            label: contactLabel,
            icon: Icons.chat_bubble_outline_rounded,
            selected: showContact,
            onTap: onContact,
          ),
        ],
      ),
    );
  }
}

class _ModeSegment extends StatelessWidget {
  const _ModeSegment({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            gradient: selected ? ext.accentGradient : null,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 17,
                color: selected ? ext.onAccent : ext.textMuted,
              ),
              const SizedBox(width: 7),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: selected ? ext.onAccent : ext.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.hint,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: TextStyle(color: ext.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: ext.textMuted),
        prefixIcon: Icon(Icons.search_rounded, color: ext.accentGlow),
        suffixIcon: onClear == null
            ? null
            : IconButton(
                onPressed: onClear,
                icon: Icon(Icons.close_rounded, color: ext.textMuted),
              ),
        filled: true,
        fillColor: _surfaceTint(context, alpha: 0.82),
        border: _border(_borderTint(context)),
        enabledBorder: _border(_borderTint(context)),
        focusedBorder: _border(ext.accentGlow, 1.4),
      ),
    );
  }

  OutlineInputBorder _border(Color color, [double width = 1]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}

class _CategoryTabs extends StatelessWidget {
  const _CategoryTabs({
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: labels.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final selected = index == selectedIndex;
          return ChoiceChip(
            label: Text(labels[index]),
            selected: selected,
            onSelected: (_) => onSelected(index),
            selectedColor: ext.accentGlow.withValues(alpha: 0.18),
            backgroundColor: _surfaceTint(context, alpha: 0.7),
            side: BorderSide(
              color: selected ? ext.accentGlow : _borderTint(context),
            ),
            labelStyle: TextStyle(
              color: selected ? ext.accentGlow : ext.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          );
        },
      ),
    );
  }
}

class _FaqCard extends StatelessWidget {
  const _FaqCard({
    required this.question,
    required this.answer,
    required this.categoryLabel,
    required this.icon,
    required this.expanded,
    required this.onTap,
  });

  final String question;
  final String answer;
  final String categoryLabel;
  final IconData icon;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return PressableScale(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.card),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: _faqFill(context, expanded),
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(
                color: expanded
                    ? ext.accentGlow.withValues(alpha: 0.56)
                    : _borderTint(context),
              ),
              boxShadow: expanded
                  ? [
                      BoxShadow(
                        color: ext.accentGlow.withValues(alpha: 0.14),
                        blurRadius: 26,
                        offset: const Offset(0, 12),
                      ),
                    ]
                  : const [],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: ext.accentGlow.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(
                          color: ext.accentGlow.withValues(alpha: 0.16),
                        ),
                      ),
                      child: Icon(icon, color: ext.accentGlow, size: 21),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            categoryLabel,
                            style: TextStyle(
                              color: ext.accentGlow,
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            question,
                            style: TextStyle(
                              color: ext.textPrimary,
                              fontWeight: FontWeight.w900,
                              fontSize: 14.5,
                              height: 1.25,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    AnimatedRotation(
                      turns: expanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 220),
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ext.accentGlow.withValues(alpha: 0.12),
                        ),
                        child: Icon(
                          Icons.expand_more_rounded,
                          color: ext.accentGlow,
                        ),
                      ),
                    ),
                  ],
                ),
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 220),
                  crossFadeState: expanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  firstChild: const SizedBox.shrink(),
                  secondChild: Padding(
                    padding: const EdgeInsetsDirectional.only(
                      top: 16,
                      start: 54,
                      end: 4,
                    ),
                    child: Text(
                      answer,
                      style: TextStyle(
                        color: ext.textMuted,
                        height: 1.58,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({required this.option, required this.onTap});

  final _ContactOption option;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return PressableScale(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.card),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: _surfaceTint(context, alpha: 0.82),
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: _borderTint(context)),
            ),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: ext.accentGlow.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Center(
                    child: Image.asset(option.icon, width: 22, height: 22),
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        option.title,
                        style: TextStyle(
                          color: ext.textPrimary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        option.value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: ext.textMuted,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.copy_rounded, color: ext.accentGlow, size: 19),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NoResults extends StatelessWidget {
  const _NoResults({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded, color: ext.textMuted, size: 42),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: ext.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: ext.textMuted, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}

Color _surfaceTint(BuildContext context, {required double alpha}) {
  final theme = Theme.of(context);
  return theme.brightness == Brightness.dark
      ? AppColors.graphite.withValues(alpha: alpha)
      : const Color(0xFFEAF4E2).withValues(alpha: alpha);
}

Color _faqFill(BuildContext context, bool expanded) {
  final theme = Theme.of(context);
  if (theme.brightness == Brightness.dark) {
    return expanded
        ? const Color(0xFF14211C).withValues(alpha: 0.94)
        : AppColors.graphite.withValues(alpha: 0.78);
  }
  return expanded
      ? const Color(0xFFE5F3D5).withValues(alpha: 0.96)
      : const Color(0xFFEEF6E8).withValues(alpha: 0.9);
}

Color _borderTint(BuildContext context) {
  final theme = Theme.of(context);
  return theme.brightness == Brightness.dark
      ? Colors.white.withValues(alpha: 0.10)
      : AppColors.accentOnLight.withValues(alpha: 0.14);
}

class _HelpFaq {
  const _HelpFaq(this.question, this.answer, this.category);
  final String question;
  final String answer;
  final int category;
}

class _ContactOption {
  const _ContactOption(this.title, this.icon, this.value);
  final String title;
  final String icon;
  final String value;
}
