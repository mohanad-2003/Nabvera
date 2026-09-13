import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/premium_scaffold.dart';
import 'package:nabvera/features/subscription/data/subscription_repository.dart';
import 'package:nabvera/features/subscription/presentation/providers/subscription_providers.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// The "upgrade to Pro" screen — pushed from a Profile menu tile, or (once
/// feature-gating is wired up) from any place in the app that hits a
/// free-tier limit. Built directly against RevenueCat's [Offerings]/
/// [Package] types rather than RevenueCat's own prebuilt paywall UI, so it
/// can match `PremiumScaffold`'s look exactly.
class SubscriptionPaywallPage extends ConsumerStatefulWidget {
  const SubscriptionPaywallPage({super.key});

  @override
  ConsumerState<SubscriptionPaywallPage> createState() =>
      _SubscriptionPaywallPageState();
}

class _SubscriptionPaywallPageState
    extends ConsumerState<SubscriptionPaywallPage> {
  Package? _selectedPackage;
  bool _purchasing = false;
  bool _restoring = false;

  Future<void> _purchase(Package package) async {
    setState(() => _purchasing = true);
    try {
      await ref.read(subscriptionRepositoryProvider).purchasePackage(package);
      // The RevenueCat webhook that updates the backend can lag a few
      // seconds behind this call returning — refresh anyway so the rest
      // of the app picks up the new state as soon as it's actually there,
      // rather than waiting for the next natural refresh point.
      await ref.read(subscriptionStatusProvider.notifier).refresh();
      if (mounted) context.pop();
    } on PlatformException catch (error) {
      // The user backing out of the store's own purchase sheet isn't a
      // failure worth surfacing.
      if (PurchasesErrorHelper.getErrorCode(error) ==
          PurchasesErrorCode.purchaseCancelledError) {
        return;
      }
      if (mounted) _showError(AppLocalizations.of(context).subscriptionPurchaseFailed);
    } finally {
      if (mounted) setState(() => _purchasing = false);
    }
  }

  Future<void> _restore() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _restoring = true);
    try {
      await ref.read(subscriptionRepositoryProvider).restorePurchases();
      await ref.read(subscriptionStatusProvider.notifier).refresh();
      final isActive =
          ref.read(subscriptionStatusProvider).value?.isActive ?? false;
      if (!mounted) return;
      _showMessage(
        isActive
            ? l10n.subscriptionRestoreSuccess
            : l10n.subscriptionRestoreNothingFound,
      );
      if (isActive) context.pop();
    } catch (_) {
      if (mounted) _showError(l10n.subscriptionRestoreFailed);
    } finally {
      if (mounted) setState(() => _restoring = false);
    }
  }

  void _showError(String message) => _showMessage(message);

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);
    final offerings = ref.watch(offeringsProvider);
    final busy = _purchasing || _restoring;

    return PremiumScaffold(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PremiumHeader(
              title: l10n.subscriptionPaywallTitle,
              subtitle: l10n.subscriptionPaywallSubtitle,
              showBack: true,
            ),
            const SizedBox(height: 26),
            const _FeatureList(),
            const SizedBox(height: 26),
            offerings.when(
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (_, _) => _OfferingsUnavailable(
                message: l10n.subscriptionOfferingsUnavailable,
              ),
              data: (offeringsResult) {
                final packages = offeringsResult.current?.availablePackages ?? const [];
                if (packages.isEmpty) {
                  return _OfferingsUnavailable(
                    message: l10n.subscriptionOfferingsUnavailable,
                  );
                }
                _selectedPackage ??= packages.first;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final package in packages)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _PlanCard(
                          package: package,
                          selected: _selectedPackage?.identifier == package.identifier,
                          onTap: busy
                              ? null
                              : () => setState(() => _selectedPackage = package),
                        ),
                      ),
                    const SizedBox(height: 10),
                    _ContinueButton(
                      loading: _purchasing,
                      enabled: !busy && _selectedPackage != null,
                      label: l10n.subscriptionContinueButton,
                      onTap: () =>
                          _selectedPackage == null ? null : _purchase(_selectedPackage!),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: busy ? null : _restore,
                child: _restoring
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: ext.textMuted,
                        ),
                      )
                    : Text(
                        l10n.subscriptionRestorePurchases,
                        style: TextStyle(color: ext.textMuted),
                      ),
              ),
            ),
            const SizedBox(height: 8),
            _LegalFooter(l10n: l10n, ext: ext),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _FeatureList extends StatelessWidget {
  const _FeatureList();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final features = [
      (Icons.restaurant_menu_rounded, l10n.subscriptionFeatureAiMealPlanTitle, l10n.subscriptionFeatureAiMealPlanBody),
      (Icons.fitness_center_rounded, l10n.subscriptionFeatureWorkoutsTitle, l10n.subscriptionFeatureWorkoutsBody),
      (Icons.monitor_heart_rounded, l10n.subscriptionFeatureRecoveryTitle, l10n.subscriptionFeatureRecoveryBody),
      (Icons.support_agent_rounded, l10n.subscriptionFeatureSupportTitle, l10n.subscriptionFeatureSupportBody),
    ];

    return PremiumGlassCard(
      child: Column(
        children: [
          for (var i = 0; i < features.length; i++) ...[
            if (i > 0) const SizedBox(height: 14),
            _FeatureRow(
              icon: features[i].$1,
              title: features[i].$2,
              body: features[i].$3,
            ),
          ],
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ext.accentGlow.withValues(alpha: 0.16),
          ),
          child: Icon(icon, color: ext.accentGlow, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: ext.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(body, style: TextStyle(fontSize: 12.5, color: ext.textMuted)),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.package, required this.selected, required this.onTap});

  final Package package;
  final bool selected;
  final VoidCallback? onTap;

  /// RevenueCat's [PackageType.annual] is the only plan worth flagging as
  /// the better deal — a single monthly plan (or a lifetime one, not
  /// offered here) has nothing to compare itself against.
  bool get _isBestValue => package.packageType == PackageType.annual;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);
    final product = package.storeProduct;

    return PremiumGlassCard(
      onTap: onTap,
      color: selected ? ext.accentGlow.withValues(alpha: 0.12) : null,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(
            selected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
            color: selected ? ext.accentGlow : ext.textMuted,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        product.title.isNotEmpty ? product.title : product.identifier,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: ext.textPrimary,
                        ),
                      ),
                    ),
                    if (_isBestValue) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          gradient: ext.accentGradient,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          l10n.subscriptionPlanBestValue,
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            color: ext.onAccent,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(product.priceString, style: TextStyle(color: ext.textMuted, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContinueButton extends StatelessWidget {
  const _ContinueButton({
    required this.loading,
    required this.enabled,
    required this.label,
    required this.onTap,
  });

  final bool loading;
  final bool enabled;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: enabled ? ext.accentGradient : null,
          color: enabled ? null : ext.glassFill,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: enabled ? onTap : null,
            borderRadius: BorderRadius.circular(18),
            child: Center(
              child: loading
                  ? SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: ext.onAccent,
                      ),
                    )
                  : Text(
                      label,
                      style: TextStyle(
                        color: enabled ? ext.onAccent : ext.textMuted,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OfferingsUnavailable extends StatelessWidget {
  const _OfferingsUnavailable({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return PremiumGlassCard(
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(color: ext.textMuted),
      ),
    );
  }
}

class _LegalFooter extends StatelessWidget {
  const _LegalFooter({required this.l10n, required this.ext});

  final AppLocalizations l10n;
  final AppThemeExtension ext;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: TextStyle(fontSize: 11.5, color: ext.textMuted, height: 1.4),
        children: [
          TextSpan(text: l10n.subscriptionLegalFooterPrefix),
          TextSpan(
            text: l10n.privacyTerms,
            style: const TextStyle(fontWeight: FontWeight.w700),
            recognizer: TapGestureRecognizer()
              ..onTap = () => context.push(AppRoutes.termsAndConditions),
          ),
          TextSpan(text: l10n.authAgreeTermsAnd),
          TextSpan(
            text: l10n.privacyPolicy,
            style: const TextStyle(fontWeight: FontWeight.w700),
            recognizer: TapGestureRecognizer()
              ..onTap = () => context.push(AppRoutes.privacyPolicy),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
