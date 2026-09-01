import 'package:fitness_app/core/localization/generated/app_localizations.dart';
import 'package:fitness_app/core/theme/app_theme_extension.dart';
import 'package:fitness_app/core/widgets/app_text_field.dart';
import 'package:fitness_app/core/widgets/fade_slide_in.dart';
import 'package:fitness_app/core/widgets/premium_scaffold.dart';
import 'package:fitness_app/core/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum _PasswordStrength { weak, medium, strong }

class PasswordSettingsPage extends StatefulWidget {
  const PasswordSettingsPage({super.key});

  @override
  State<PasswordSettingsPage> createState() => _PasswordSettingsPageState();
}

class _PasswordSettingsPageState extends State<PasswordSettingsPage> {
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _showCurrent = false;
  bool _showNew = false;
  bool _showConfirm = false;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  _PasswordStrength _strengthOf(String value) {
    if (value.length < 8) return _PasswordStrength.weak;
    final hasUpper = value.contains(RegExp('[A-Z]'));
    final hasDigit = value.contains(RegExp(r'\d'));
    if (hasUpper && hasDigit) return _PasswordStrength.strong;
    return _PasswordStrength.medium;
  }

  Future<void> _handleUpdate(AppLocalizations l10n) async {
    if (_currentController.text.isEmpty) {
      setState(() => _error = l10n.passwordCurrentValidation);
      return;
    }
    if (_newController.text.isEmpty) {
      setState(() => _error = l10n.passwordNewValidation);
      return;
    }
    if (_newController.text.length < 8) {
      setState(() => _error = l10n.passwordMinLengthValidation);
      return;
    }
    if (_newController.text != _confirmController.text) {
      setState(() => _error = l10n.passwordMismatchValidation);
      return;
    }
    setState(() {
      _error = null;
      _saving = true;
    });
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.passwordUpdateSuccess)));
  }

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);
    final strength = _strengthOf(_newController.text);

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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.passwordSettingsTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(
                            context,
                          ).textTheme.headlineSmall?.copyWith(
                            color: ext.textPrimary,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          l10n.passwordSettingsSubtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: ext.textMuted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Padding(
                padding: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.passwordCurrentPassword,
                      style: TextStyle(
                        color: ext.textPrimary,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    AppTextField(
                      controller: _currentController,
                      obscureText: !_showCurrent,
                      prefixIcon: Icons.lock_outline,
                      flat: true,
                      onChanged: (_) {
                        if (_error != null) setState(() => _error = null);
                      },
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showCurrent
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: ext.textMuted,
                        ),
                        onPressed:
                            () =>
                                setState(() => _showCurrent = !_showCurrent),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(l10n.passwordForgot),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.passwordNew,
                      style: TextStyle(
                        color: ext.textPrimary,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    AppTextField(
                      controller: _newController,
                      obscureText: !_showNew,
                      prefixIcon: Icons.lock_reset_rounded,
                      flat: true,
                      onChanged: (_) {
                        setState(() => _error = null);
                      },
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showNew
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: ext.textMuted,
                        ),
                        onPressed: () => setState(() => _showNew = !_showNew),
                      ),
                    ),
                    if (_newController.text.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      _StrengthIndicator(strength: strength, ext: ext),
                      const SizedBox(height: 2),
                      Text(
                        switch (strength) {
                          _PasswordStrength.weak => l10n.passwordStrengthWeak,
                          _PasswordStrength.medium =>
                            l10n.passwordStrengthMedium,
                          _PasswordStrength.strong =>
                            l10n.passwordStrengthStrong,
                        },
                        style: TextStyle(
                          color: switch (strength) {
                            _PasswordStrength.weak => ext.danger,
                            _PasswordStrength.medium => ext.warning,
                            _PasswordStrength.strong => ext.success,
                          },
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                    const SizedBox(height: 18),
                    Text(
                      l10n.passwordConfirmNew,
                      style: TextStyle(
                        color: ext.textPrimary,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    AppTextField(
                      controller: _confirmController,
                      obscureText: !_showConfirm,
                      prefixIcon: Icons.lock_outline,
                      flat: true,
                      onChanged: (_) {
                        if (_error != null) setState(() => _error = null);
                      },
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showConfirm
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: ext.textMuted,
                        ),
                        onPressed:
                            () =>
                                setState(() => _showConfirm = !_showConfirm),
                      ),
                    ),
                  ],
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 14),
                Text(
                  _error!,
                  style: TextStyle(color: ext.danger, fontSize: 12.5),
                ),
              ],
              const SizedBox(height: 24),
              PrimaryButton(
                label: l10n.passwordUpdateAction,
                isLoading: _saving,
                onPressed: () => _handleUpdate(l10n),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class _StrengthIndicator extends StatelessWidget {
  const _StrengthIndicator({required this.strength, required this.ext});

  final _PasswordStrength strength;
  final AppThemeExtension ext;

  @override
  Widget build(BuildContext context) {
    final activeSegments = switch (strength) {
      _PasswordStrength.weak => 1,
      _PasswordStrength.medium => 2,
      _PasswordStrength.strong => 3,
    };
    final color = switch (strength) {
      _PasswordStrength.weak => ext.danger,
      _PasswordStrength.medium => ext.warning,
      _PasswordStrength.strong => ext.success,
    };
    return Row(
      children: [
        for (var i = 0; i < 3; i++) ...[
          if (i != 0) const SizedBox(width: 6),
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              height: 5,
              decoration: BoxDecoration(
                color: i < activeSegments ? color : ext.glassBorder,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
