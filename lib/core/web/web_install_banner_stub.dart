import 'package:flutter/widgets.dart';

/// Native builds have no install banner; the real implementation lives in
/// `web_install_banner.dart` and is only compiled for web.
class WebInstallBanner extends StatelessWidget {
  const WebInstallBanner({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
