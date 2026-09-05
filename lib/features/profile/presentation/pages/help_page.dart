import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/theme/app_colors.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/fade_slide_in.dart';
import 'package:nabvera/core/widgets/premium_scaffold.dart';
import 'package:nabvera/core/widgets/pressable_scale.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

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
      _ContactOption(l10n.helpContactCustomerService, 'assets/customer.png', 'support@fitbody.app'),
      _ContactOption(l10n.helpContactWebsite, 'assets/website.png', 'www.fitbody.app'),
      _ContactOption(l10n.helpContactWhatsapp, 'assets/whats.png', '+1 555 010 2024'),
      _ContactOption(l10n.helpContactFacebook, 'assets/face_help.png', '@fitbody'),
      _ContactOption(l10n.helpContactInstagram, 'assets/insta.png', '@fitbody'),
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
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            SliverToBoxAdapter(
              child: _ModeSwitch(
                faqLabel: l10n.helpFaqTab,
                contactLabel: l10n.helpContactUsTab,
                showContact: _showContact,
                onFaq: () => setState(() => _showContact = false),
                onContact: () => setState(() => _showContact = true),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
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
                      icon: _categoryIcon(entry.faq.category),
                      expanded: _expandedFaqIndex == entry.index,
                      onTap: () => setState(() {
                        _expandedFaqIndex =
                            _expandedFaqIndex == entry.index ? null : entry.index;
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
  const _HelpHero({required this.title, required this.subtitle, required this.showBack, required this.onBack});
  final String title;
  final String subtitle;
  final bool showBack;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [AppColors.seedViolet, AppColors.seedInk],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            color: AppColors.seedViolet.withValues(alpha: 0.28),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Stack(
        children: [
          PositionedDirectional(
            end: -18,
            bottom: -24,
            child: Icon(
              Icons.support_agent_rounded,
              color: Colors.white.withValues(alpha: 0.07),
              size: 148,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (showBack)
                    InkWell(
                      onTap: onBack,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                      ),
                    ),
                  if (showBack) const SizedBox(width: 12),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(shape: BoxShape.circle, gradient: ext.accentGradient),
                    child: Icon(Icons.forum_rounded, color: ext.onAccent),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.72),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ModeSwitch extends StatelessWidget {
  const _ModeSwitch({required this.faqLabel, required this.contactLabel, required this.showContact, required this.onFaq, required this.onContact});
  final String faqLabel;
  final String contactLabel;
  final bool showContact;
  final VoidCallback onFaq;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: ext.glassFill,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: ext.glassBorder),
      ),
      child: Row(
        children: [
          _ModeSegment(label: faqLabel, icon: Icons.quiz_outlined, selected: !showContact, onTap: onFaq),
          _ModeSegment(label: contactLabel, icon: Icons.chat_bubble_outline_rounded, selected: showContact, onTap: onContact),
        ],
      ),
    );
  }
}

class _ModeSegment extends StatelessWidget {
  const _ModeSegment({required this.label, required this.icon, required this.selected, required this.onTap});
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
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(gradient: selected ? ext.accentGradient : null, borderRadius: BorderRadius.circular(14)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 17, color: selected ? ext.onAccent : ext.textMuted),
              const SizedBox(width: 7),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: selected ? ext.onAccent : ext.textPrimary, fontWeight: FontWeight.w800),
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
  const _SearchField({required this.controller, required this.hint, required this.onChanged, required this.onClear});
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
        suffixIcon: onClear == null ? null : IconButton(onPressed: onClear, icon: Icon(Icons.close_rounded, color: ext.textMuted)),
        filled: true,
        fillColor: ext.glassFill,
        border: _border(ext.glassBorder),
        enabledBorder: _border(ext.glassBorder),
        focusedBorder: _border(ext.accentGlow, 1.4),
      ),
    );
  }

  OutlineInputBorder _border(Color color, [double width = 1]) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: BorderSide(color: color, width: width),
  );
}

class _CategoryTabs extends StatelessWidget {
  const _CategoryTabs({required this.labels, required this.selectedIndex, required this.onSelected});
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
            backgroundColor: ext.glassFill,
            side: BorderSide(color: selected ? ext.accentGlow : ext.glassBorder),
            labelStyle: TextStyle(color: selected ? ext.accentGlow : ext.textPrimary, fontWeight: FontWeight.w800),
          );
        },
      ),
    );
  }
}

class _FaqCard extends StatelessWidget {
  const _FaqCard({required this.question, required this.answer, required this.icon, required this.expanded, required this.onTap});
  final String question;
  final String answer;
  final IconData icon;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return PressableScale(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: expanded ? ext.cardColor : ext.glassFill,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: expanded ? ext.accentGlow.withValues(alpha: 0.6) : ext.glassBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(color: ext.accentGlow.withValues(alpha: 0.14), shape: BoxShape.circle),
                    child: Icon(icon, color: ext.accentGlow, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(question, style: TextStyle(color: ext.textPrimary, fontWeight: FontWeight.w800, fontSize: 14.5))),
                  AnimatedRotation(
                    turns: expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 220),
                    child: Icon(Icons.expand_more_rounded, color: ext.accentGlow),
                  ),
                ],
              ),
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 220),
                crossFadeState: expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                firstChild: const SizedBox.shrink(),
                secondChild: Padding(
                  padding: const EdgeInsetsDirectional.only(top: 14, start: 50, end: 4),
                  child: Text(answer, style: TextStyle(color: ext.textMuted, height: 1.55, fontSize: 13.5)),
                ),
              ),
            ],
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
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: ext.glassFill,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: ext.glassBorder),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(color: ext.accentGlow.withValues(alpha: 0.14), shape: BoxShape.circle),
                child: Center(child: Image.asset(option.icon, width: 22, height: 22)),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(option.title, style: TextStyle(color: ext.textPrimary, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 3),
                    Text(option.value, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: ext.textMuted, fontSize: 12.5)),
                  ],
                ),
              ),
              Icon(Icons.copy_rounded, color: ext.accentGlow, size: 19),
            ],
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
            Text(title, style: TextStyle(color: ext.textPrimary, fontWeight: FontWeight.w800)),
            const SizedBox(height: 5),
            Text(message, textAlign: TextAlign.center, style: TextStyle(color: ext.textMuted, height: 1.4)),
          ],
        ),
      ),
    );
  }
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
