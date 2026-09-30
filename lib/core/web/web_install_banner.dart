import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web/web.dart' as web;

import '../theme/app_theme_extension.dart';

/// SharedPreferences key: set once the user explicitly closes the banner,
/// so it doesn't nag again every reload — the browser's own
/// `beforeinstallprompt` re-fires on every page load, this app's own
/// dismissal preference is what actually silences it.
const _dismissedPrefsKey = 'web_install_banner_dismissed';

/// Chrome/Edge fire `beforeinstallprompt` on any page load where the site
/// meets install criteria (HTTPS, a valid manifest, an active service
/// worker) *unless* the page calls `event.preventDefault()`, in which case
/// the browser suppresses its own native mini-infobar and leaves it up to
/// the page to show its own UI and call `.prompt()` later — that's what
/// this listener captures.
JSObject? _deferredInstallPrompt;

/// A bottom, dismissible "install this as an app" sheet — the same idea as
/// most mobile-first web apps' own custom install prompt (asked for
/// explicitly, matching another PWA's own banner) rather than relying on
/// the browser's own small, easy-to-miss install icon in the address bar.
/// Renders nothing on native builds or once the user has already dismissed
/// it/installed the app.
class WebInstallBanner extends StatefulWidget {
  const WebInstallBanner({super.key});

  @override
  State<WebInstallBanner> createState() => _WebInstallBannerState();
}

class _WebInstallBannerState extends State<WebInstallBanner> {
  bool _canInstall = false;
  bool _dismissed = true;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) return;
    _loadDismissed();
    _listenForInstallPrompt();
  }

  Future<void> _loadDismissed() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() => _dismissed = prefs.getBool(_dismissedPrefsKey) ?? false);
  }

  void _listenForInstallPrompt() {
    // Already captured by an earlier instance (a hot-restart/navigation
    // rebuilds this widget, but the browser only fires the event once per
    // page load) — just reflect that state instead of waiting forever.
    if (_deferredInstallPrompt != null) {
      setState(() => _canInstall = true);
      return;
    }
    web.window.addEventListener(
      'beforeinstallprompt',
      ((web.Event event) {
        event.preventDefault();
        _deferredInstallPrompt = event as JSObject;
        if (mounted) setState(() => _canInstall = true);
      }).toJS,
    );
    // The browser fires this once the user accepts *any* install path
    // (this banner or its own address-bar icon) — either way, the prompt
    // this banner exists for is no longer relevant.
    web.window.addEventListener(
      'appinstalled',
      ((web.Event _) {
        _deferredInstallPrompt = null;
        if (mounted) setState(() => _canInstall = false);
      }).toJS,
    );
  }

  Future<void> _install() async {
    final prompt = _deferredInstallPrompt;
    if (prompt == null) return;
    // Fire-and-forget: the actual accept/dismiss choice happens in the
    // browser's own native dialog from here on, this app has no further
    // say (and `userChoice` isn't worth plumbing through js_interop_unsafe
    // just to log which button the user clicked).
    prompt.callMethodVarArgs('prompt'.toJS);
    _deferredInstallPrompt = null;
    if (mounted) setState(() => _canInstall = false);
  }

  Future<void> _dismiss() async {
    setState(() => _dismissed = true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_dismissedPrefsKey, true);
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return const SizedBox.shrink();

    final visible = _canInstall && !_dismissed;
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    // Kept mounted (not swapped for SizedBox.shrink) whenever the app
    // *could* show it, purely so the slide/fade below has something to
    // animate from — an IgnorePointer while hidden keeps it from eating
    // taps over the content underneath.
    return IgnorePointer(
      ignoring: !visible,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: AnimatedSlide(
          duration: const Duration(milliseconds: 380),
          curve: Curves.easeOutCubic,
          offset: visible ? Offset.zero : const Offset(0, 1),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 260),
            opacity: visible ? 1 : 0,
            child: SafeArea(
              minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Material(
                  elevation: 16,
                  shadowColor: Colors.black.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(26),
                  color: ext.cardColor,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 18, 16, 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(color: ext.cardBorderColor),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                width: 52,
                                height: 52,
                                color: ext.glassFill,
                                padding: const EdgeInsets.all(8),
                                child: Image.network(
                                  'icons/Icon-192.png',
                                  errorBuilder:
                                      (_, _, _) => Icon(
                                        Icons.install_mobile_rounded,
                                        color: ext.accentGlow,
                                      ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isArabic
                                        ? 'ثبّت Nabvera كتطبيق'
                                        : 'Install Nabvera as an app',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleSmall?.copyWith(
                                      color: ext.textPrimary,
                                      fontWeight: FontWeight.w800,
                                      height: 1.1,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    isArabic
                                        ? 'يفتح بضغطة وحدة من شاشتك الرئيسية، بدون شريط عنوان.'
                                        : 'Opens in one tap from your home screen, no address bar.',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall?.copyWith(
                                      color: ext.textMuted,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: _dismiss,
                              borderRadius: BorderRadius.circular(999),
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Icon(
                                  Icons.close_rounded,
                                  size: 20,
                                  color: ext.textMuted,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: ext.accentGradient,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: ext.accentGlow.withValues(alpha: 0.35),
                                  blurRadius: 18,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Material(
                              type: MaterialType.transparency,
                              child: InkWell(
                                onTap: _install,
                                borderRadius: BorderRadius.circular(15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.download_rounded,
                                      size: 18,
                                      color: ext.onAccent,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      isArabic
                                          ? 'تثبيت التطبيق'
                                          : 'Install app',
                                      style: TextStyle(
                                        color: ext.onAccent,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
