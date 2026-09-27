import 'dart:typed_data';

import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/app_text_field.dart';
import 'package:nabvera/core/widgets/primary_button.dart';
import 'package:nabvera/features/community/data/community_repository.dart';
import 'package:nabvera/features/community/presentation/providers/community_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

/// Opens the composer for a new Community post — the feature the feed's
/// "Forums" tab never actually had (view/like/comment all worked, nothing
/// ever called `POST /posts`; see `CommunityRepository.createPost`).
Future<void> showNewPostSheet(BuildContext context, WidgetRef ref) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const _NewPostSheet(),
  );
}

class _NewPostSheet extends ConsumerStatefulWidget {
  const _NewPostSheet();

  @override
  ConsumerState<_NewPostSheet> createState() => _NewPostSheetState();
}

class _NewPostSheetState extends ConsumerState<_NewPostSheet> {
  final _controller = TextEditingController();
  bool _posting = false;
  String? _error;

  XFile? _pendingImage;
  Uint8List? _imagePreviewBytes;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Only picks and previews — not uploaded yet. The actual upload happens
  /// in [_submit], so backing out of the composer after picking a photo
  /// never leaves an orphaned upload with no post attached to it.
  Future<void> _pickImage() async {
    try {
      final selected = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 85,
      );
      if (selected == null) return;
      final bytes = await selected.readAsBytes();
      if (!mounted) return;
      setState(() {
        _pendingImage = selected;
        _imagePreviewBytes = bytes;
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).communityPhotoPickFailed),
        ),
      );
    }
  }

  Future<void> _submit() async {
    final content = _controller.text.trim();
    if (content.isEmpty) return;
    setState(() {
      _posting = true;
      _error = null;
    });
    try {
      String? imageUrl;
      final pendingImage = _pendingImage;
      final imageBytes = _imagePreviewBytes;
      if (pendingImage != null && imageBytes != null) {
        imageUrl = await ref
            .read(communityRepositoryProvider)
            .uploadPostImage(
              bytes: imageBytes,
              filename: pendingImage.name,
              contentType: pendingImage.mimeType,
            );
      }
      await ref
          .read(communityForumsProvider.notifier)
          .create(content, imageUrl: imageUrl);
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = AppLocalizations.of(context).communityPostFailed;
        _posting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 20,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: ext.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: Border.all(color: ext.glassBorder),
        ),
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.communityNewPostTitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: ext.textPrimary,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 14),
              AppTextField(
                controller: _controller,
                hint: l10n.communityNewPostHint,
                maxLines: 5,
              ),
              const SizedBox(height: 12),
              if (_imagePreviewBytes != null)
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.memory(
                        _imagePreviewBytes!,
                        width: double.infinity,
                        height: 160,
                        fit: BoxFit.cover,
                        // A picked file that fails to decode (corrupt, or a
                        // format Flutter's built-in codecs don't support)
                        // should never leave a mysterious blank box with no
                        // explanation — this at least tells the user their
                        // photo didn't load rather than silently no-op'ing.
                        errorBuilder:
                            (context, error, stackTrace) => Container(
                              width: double.infinity,
                              height: 160,
                              color: ext.glassFill,
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.broken_image_outlined,
                                color: ext.textMuted,
                                size: 32,
                              ),
                            ),
                      ),
                    ),
                    PositionedDirectional(
                      top: 8,
                      end: 8,
                      child: GestureDetector(
                        onTap:
                            () => setState(() {
                              _pendingImage = null;
                              _imagePreviewBytes = null;
                            }),
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              else
                OutlinedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image_outlined, size: 18),
                  label: Text(l10n.communityAddPhoto),
                ),
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(
                  _error!,
                  style: TextStyle(color: ext.danger, fontSize: 12.5),
                ),
              ],
              const SizedBox(height: 16),
              PrimaryButton(
                label: l10n.communityPostAction,
                isLoading: _posting,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
