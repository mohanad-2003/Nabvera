import 'package:flutter/material.dart';
import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/network/api_client.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';

String workoutCopy(BuildContext context, String ar, String en) =>
    Localizations.localeOf(context).languageCode == 'ar' ? ar : en;

String workoutError(BuildContext context, Object error) =>
    error is ApiException
        ? error.message
        : workoutCopy(
          context,
          'تعذّر إكمال الطلب. تحقق من الاتصال وحاول مجددًا.',
          'The request could not be completed. Check your connection and retry.',
        );

/// Feature-only backdrop: a full screen gradient, without enclosing cards.
class WorkoutScaffold extends StatelessWidget {
  const WorkoutScaffold({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(20, 18, 20, 20),
    this.bottomBar,
  });
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Widget? bottomBar;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return DecoratedBox(
      decoration: BoxDecoration(gradient: ext.backgroundGradient),
      child: Scaffold(
        backgroundColor: ext.cardColor.withValues(alpha: 0),
        bottomNavigationBar:
            MediaQuery.viewInsetsOf(context).bottom > 0 ? null : bottomBar,
        body: SafeArea(
          child: SizedBox.expand(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 840),
                child: Padding(padding: padding, child: child),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class WorkoutPill extends StatelessWidget {
  const WorkoutPill({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return ChoiceChip(
      label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
      selected: selected,
      onSelected: onTap == null ? null : (_) => onTap!(),
      showCheckmark: false,
      selectedColor: ext.accentGlow.withValues(alpha: .12),
      backgroundColor: ext.glassFill,
      labelStyle: TextStyle(
        color: selected ? ext.accentGlow : ext.textMuted,
        fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
      ),
      side: BorderSide(color: selected ? ext.accentGlow : ext.glassBorder),
      shape: const StadiumBorder(),
    );
  }
}

class WorkoutStatus extends StatelessWidget {
  const WorkoutStatus({
    super.key,
    this.loading = false,
    this.error,
    this.message,
    this.onRetry,
    this.action,
  });
  final bool loading;
  final Object? error;
  final String? message;
  final VoidCallback? onRetry;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (loading)
            CircularProgressIndicator(color: ext.accentGlow)
          else
            Icon(
              error == null
                  ? Icons.fitness_center_rounded
                  : Icons.cloud_off_rounded,
              size: 36,
              color: error == null ? ext.accentGlow : ext.danger,
            ),
          const SizedBox(height: 12),
          Semantics(
            liveRegion: true,
            child: Text(
              loading
                  ? workoutCopy(context, 'جارٍ التحميل…', 'Loading…')
                  : error != null
                  ? workoutError(context, error!)
                  : message ?? AppLocalizations.of(context).emptyGenericTitle,
              textAlign: TextAlign.center,
              style: TextStyle(color: ext.textMuted),
            ),
          ),
          if (error != null && onRetry != null)
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(AppLocalizations.of(context).actionRetry),
            ),
          if (action != null) ...[const SizedBox(height: 16), action!],
        ],
      ),
    );
  }
}
