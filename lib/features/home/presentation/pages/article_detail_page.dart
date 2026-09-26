import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/premium_scaffold.dart';
import 'package:nabvera/core/widgets/smart_image.dart';
import 'package:nabvera/features/home/domain/home_models.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Localized label for an `Article.category` value — a fixed backend enum
/// (`nutrition`/`workout`/`recovery`/`mindset`), never rendered as its raw
/// English key.
String _categoryLabel(AppLocalizations l10n, String category) => switch (category) {
  'nutrition' => l10n.articleCategoryNutrition,
  'workout' => l10n.articleCategoryWorkout,
  'recovery' => l10n.articleCategoryRecovery,
  'mindset' => l10n.articleCategoryMindset,
  _ => category,
};

/// Full-content view for a Home "Articles & Tips" card — a `/api/articles`
/// document, shown in full: hero photo, category/read-time, every
/// paragraph of the real article body, and its tags.
class ArticleDetailPage extends StatelessWidget {
  const ArticleDetailPage({super.key, required this.article});

  final ArticleTip article;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(gradient: ext.backgroundGradient),
            ),
          ),
          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        if (context.canPop())
                          PremiumBackButton(onTap: () => context.pop()),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: AspectRatio(
                        aspectRatio: 16 / 10,
                        child: SmartImage(article.image),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (article.category.isNotEmpty) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary.withValues(
                                    alpha: 0.14,
                                  ),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  _categoryLabel(l10n, article.category).toUpperCase(),
                                  style: TextStyle(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 11,
                                    letterSpacing: 0.6,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                            ],
                            Icon(
                              Icons.schedule_rounded,
                              size: 15,
                              color: ext.textMuted,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              l10n.articleReadTimeMinutes(article.readTimeMinutes),
                              style: TextStyle(
                                color: ext.textMuted,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          article.localizedTitle(context),
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: ext.textPrimary,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          article.localizedBody(context),
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 20),
                        for (final paragraph in article.localizedParagraphs(context)) ...[
                          Text(
                            paragraph,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: ext.textMuted,
                              height: 1.7,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        if (article.tags.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              for (final tag in article.tags)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 7,
                                  ),
                                  decoration: BoxDecoration(
                                    color: ext.glassFill,
                                    borderRadius: BorderRadius.circular(999),
                                    border: Border.all(color: ext.glassBorder),
                                  ),
                                  child: Text(
                                    '#$tag',
                                    style: TextStyle(
                                      color: ext.textPrimary,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
