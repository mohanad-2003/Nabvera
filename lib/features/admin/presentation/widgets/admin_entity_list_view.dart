import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/theme/app_spacing.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/app_text_field.dart';
import 'package:nabvera/features/admin/presentation/widgets/admin_content_card.dart';
import 'package:nabvera/features/admin/presentation/widgets/admin_empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// One chip in the filter row shown above an [AdminEntityListView]'s list.
/// A predicate rather than a plain value/equality check so one filter row
/// can mix fields (e.g. both difficulty *and* category chips for
/// Workouts) — the first option in the list should normally be "All" with
/// `matches: null` (always passes).
class AdminFilterOption {
  const AdminFilterOption({required this.label, this.matches});
  final String label;
  final bool Function(Map<String, dynamic> item)? matches;
}

/// The list body shared by every Admin content page: a search field, an
/// optional filter chip row, and the resulting list of [AdminContentCard]s
/// — with loading/error/empty states all handled the same way everywhere.
/// Each entity page owns its data (the `items` AsyncValue) and field
/// extraction; this widget only owns search/filter UI and rendering.
class AdminEntityListView extends StatefulWidget {
  const AdminEntityListView({
    super.key,
    required this.items,
    required this.titleOf,
    required this.imageOf,
    this.subtitleOf,
    this.chipsOf,
    this.searchableTextOf,
    this.filters = const [],
    required this.onRefresh,
    this.onTap,
    this.onEdit,
    required this.onDelete,
    required this.emptyIcon,
    required this.emptyTitle,
    required this.emptyMessage,
    required this.errorMessage,
    this.searchHint,
  });

  final AsyncValue<List<Map<String, dynamic>>> items;
  final String Function(Map<String, dynamic>) titleOf;
  final String? Function(Map<String, dynamic>) imageOf;
  final String? Function(Map<String, dynamic>)? subtitleOf;
  final List<String> Function(Map<String, dynamic>)? chipsOf;

  /// Defaults to [titleOf] when omitted — the text actually matched
  /// against the search field.
  final String Function(Map<String, dynamic>)? searchableTextOf;

  final List<AdminFilterOption> filters;

  final Future<void> Function() onRefresh;
  final void Function(Map<String, dynamic> item)? onTap;

  /// Null hides the edit action for every row (see [AdminContentCard]).
  final void Function(Map<String, dynamic> item)? onEdit;
  final void Function(Map<String, dynamic> item) onDelete;

  final IconData emptyIcon;
  final String emptyTitle;
  final String emptyMessage;
  final String errorMessage;
  final String? searchHint;

  @override
  State<AdminEntityListView> createState() => _AdminEntityListViewState();
}

class _AdminEntityListViewState extends State<AdminEntityListView> {
  final _searchController = TextEditingController();
  String _query = '';
  int _selectedFilterIndex = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: AppTextField(
            controller: _searchController,
            hint: widget.searchHint ?? l10n.adminSearchHint,
            prefixIcon: Icons.search_rounded,
            flat: true,
            onChanged:
                (value) => setState(() => _query = value.trim().toLowerCase()),
          ),
        ),
        if (widget.filters.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              itemCount: widget.filters.length,
              separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
              itemBuilder: (context, index) {
                final filter = widget.filters[index];
                final selected = _selectedFilterIndex == index;
                return ChoiceChip(
                  label: Text(filter.label),
                  selected: selected,
                  onSelected:
                      (_) => setState(() => _selectedFilterIndex = index),
                  selectedColor: ext.accentGlow.withValues(alpha: 0.22),
                  backgroundColor: ext.glassFill,
                  side: BorderSide(color: ext.glassBorder),
                  labelStyle: TextStyle(
                    color: selected ? ext.accentGlow : ext.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 12.5,
                  ),
                );
              },
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.md),
        Expanded(
          child: widget.items.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error:
                (error, _) => Center(
                  child: AdminEmptyState(
                    icon: Icons.cloud_off_rounded,
                    title: widget.errorMessage,
                    message: '$error',
                    actionLabel: l10n.adminActionRetry,
                    onAction: widget.onRefresh,
                  ),
                ),
            data: (items) {
              final filtered =
                  items.where((item) {
                    final matchesQuery =
                        _query.isEmpty ||
                        (widget.searchableTextOf ?? widget.titleOf)(item)
                            .toLowerCase()
                            .contains(_query);
                    final matchesFilter =
                        widget.filters.isEmpty ||
                        (widget.filters[_selectedFilterIndex].matches?.call(
                              item,
                            ) ??
                            true);
                    return matchesQuery && matchesFilter;
                  }).toList();

              if (items.isEmpty) {
                return Center(
                  child: AdminEmptyState(
                    icon: widget.emptyIcon,
                    title: widget.emptyTitle,
                    message: widget.emptyMessage,
                  ),
                );
              }
              if (filtered.isEmpty) {
                return Center(
                  child: AdminEmptyState(
                    icon: Icons.search_off_rounded,
                    title: l10n.adminNoResultsTitle,
                    message: l10n.adminNoResultsMessage,
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: widget.onRefresh,
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.xl,
                    0,
                    AppSpacing.xl,
                    AppSpacing.xxl,
                  ),
                  itemCount: filtered.length,
                  separatorBuilder:
                      (_, _) => const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    return AdminContentCard(
                      title: widget.titleOf(item),
                      imageUrl: widget.imageOf(item),
                      subtitle: widget.subtitleOf?.call(item),
                      metaChips: widget.chipsOf?.call(item) ?? const [],
                      onTap:
                          widget.onTap == null
                              ? null
                              : () => widget.onTap!(item),
                      onEdit:
                          widget.onEdit == null
                              ? null
                              : () => widget.onEdit!(item),
                      onDelete: () => widget.onDelete(item),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
