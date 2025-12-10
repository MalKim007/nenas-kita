import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nenas_kita/core/models/image_data.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';

/// Multi-image picker grid (max 3 images, compress to 500KB)
class ImagePickerGrid extends StatelessWidget {
  const ImagePickerGrid({
    super.key,
    required this.existingUrls,
    required this.newImages,
    required this.onImagesChanged,
    this.maxImages = 3,
    this.maxSizeKB = 500,
  });

  /// URLs of already uploaded images
  final List<String> existingUrls;

  /// Newly selected local images
  final List<ImageData> newImages;

  /// Callback when images change
  final void Function(List<String> urls, List<ImageData> images) onImagesChanged;

  /// Maximum number of images allowed
  final int maxImages;

  /// Max image size in KB (for compression)
  final int maxSizeKB;

  int get _totalCount => existingUrls.length + newImages.length;
  bool get _canAddMore => _totalCount < maxImages;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Grid - responsive based on screen width
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 120,
            crossAxisSpacing: AppSpacing.s,
            mainAxisSpacing: AppSpacing.s,
          ),
          itemCount: _totalCount + (_canAddMore ? 1 : 0),
          itemBuilder: (context, index) {
            // Add button
            if (_canAddMore && index == _totalCount) {
              return _AddImageButton(onTap: () => _pickImage(context));
            }
            // Existing URL
            if (index < existingUrls.length) {
              return _ImageTile(
                imageUrl: existingUrls[index],
                isPrimary: index == 0,
                onRemove: () => _removeExisting(index),
                onSetPrimary: index > 0 ? () => _setPrimary(index) : null,
              );
            }
            // New local image
            final imageIndex = index - existingUrls.length;
            return _ImageTile(
              imageBytes: newImages[imageIndex].bytes,
              isPrimary: existingUrls.isEmpty && imageIndex == 0,
              onRemove: () => _removeNew(imageIndex),
              onSetPrimary: imageIndex > 0 && existingUrls.isEmpty
                  ? () => _setNewPrimary(imageIndex)
                  : null,
            );
          },
        ),
        AppSpacing.vGapS,
        // Helper text
        Text(
          '$_totalCount/$maxImages images - first image is primary',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
      ],
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    final source = await _showSourceDialog(context);
    if (source == null) return;

    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      maxWidth: 1280,
      maxHeight: 1280,
      imageQuality: 80, // Compress to ~500KB
    );

    if (picked != null) {
      final bytes = await picked.readAsBytes();
      final imageData = ImageData(bytes: bytes, name: picked.name);
      onImagesChanged(existingUrls, [...newImages, imageData]);
    }
  }

  Future<ImageSource?> _showSourceDialog(BuildContext context) {
    return showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }

  void _removeExisting(int index) {
    final urls = List<String>.from(existingUrls);
    urls.removeAt(index);
    onImagesChanged(urls, newImages);
  }

  void _removeNew(int index) {
    final images = List<ImageData>.from(newImages);
    images.removeAt(index);
    onImagesChanged(existingUrls, images);
  }

  void _setPrimary(int index) {
    final urls = List<String>.from(existingUrls);
    final url = urls.removeAt(index);
    urls.insert(0, url);
    onImagesChanged(urls, newImages);
  }

  void _setNewPrimary(int index) {
    final images = List<ImageData>.from(newImages);
    final image = images.removeAt(index);
    images.insert(0, image);
    onImagesChanged(existingUrls, images);
  }
}

/// Add image button
class _AddImageButton extends StatelessWidget {
  const _AddImageButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceVariant,
      borderRadius: BorderRadius.circular(AppSpacing.radiusM),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.outline,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(AppSpacing.radiusM),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_photo_alternate,
                size: 32,
                color: AppColors.primary,
              ),
              SizedBox(height: 4),
              Text(
                'Add',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Image tile with remove/primary actions
class _ImageTile extends StatelessWidget {
  const _ImageTile({
    this.imageUrl,
    this.imageBytes,
    required this.isPrimary,
    required this.onRemove,
    this.onSetPrimary,
  });

  final String? imageUrl;
  final Uint8List? imageBytes;
  final bool isPrimary;
  final VoidCallback onRemove;
  final VoidCallback? onSetPrimary;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusM),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Image
          if (imageBytes != null)
            Image.memory(imageBytes!, fit: BoxFit.cover)
          else if (imageUrl != null)
            CachedNetworkImage(
              imageUrl: imageUrl!,
              fit: BoxFit.cover,
              placeholder: (_, __) => _placeholder(),
              errorWidget: (_, __, ___) => _placeholder(),
            )
          else
            _placeholder(),

          // Primary badge
          if (isPrimary)
            Positioned(
              top: AppSpacing.xs,
              left: AppSpacing.xs,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xs,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusS),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, size: 12, color: AppColors.onPrimary),
                    SizedBox(width: 2),
                    Text(
                      'Primary',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Action buttons
          Positioned(
            right: AppSpacing.xs,
            top: AppSpacing.xs,
            child: Row(
              children: [
                // Set as primary
                if (onSetPrimary != null)
                  _ActionButton(
                    icon: Icons.star_outline,
                    onTap: onSetPrimary!,
                    tooltip: 'Set as primary',
                  ),
                const SizedBox(width: 4),
                // Remove
                _ActionButton(
                  icon: Icons.close,
                  onTap: onRemove,
                  tooltip: 'Remove',
                  isDestructive: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: AppColors.surfaceVariant,
      child: const Center(
        child: Icon(
          Icons.image,
          color: AppColors.textDisabled,
        ),
      ),
    );
  }
}

/// Small action button overlay
class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.onTap,
    required this.tooltip,
    this.isDestructive = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: AppColors.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(AppSpacing.radiusS),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusS),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Icon(
              icon,
              size: 16,
              color: isDestructive ? AppColors.error : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

/// Single image picker (hero image for farm)
class SingleImagePicker extends StatelessWidget {
  const SingleImagePicker({
    super.key,
    this.imageUrl,
    this.imageData,
    required this.onImageChanged,
    this.height = 180,
    this.placeholder,
  });

  final String? imageUrl;
  final ImageData? imageData;
  final void Function(ImageData? imageData) onImageChanged;
  final double height;
  final Widget? placeholder;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _pickImage(context),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppSpacing.radiusL),
          border: Border.all(color: AppColors.outline),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image
            if (imageData != null)
              Image.memory(imageData!.bytes, fit: BoxFit.cover)
            else if (imageUrl != null && imageUrl!.isNotEmpty)
              CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                placeholder: (_, __) => _defaultPlaceholder(),
                errorWidget: (_, __, ___) => _defaultPlaceholder(),
              )
            else
              placeholder ?? _defaultPlaceholder(),

            // Edit button overlay
            Positioned(
              right: AppSpacing.s,
              bottom: AppSpacing.s,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusS),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      imageData != null || (imageUrl != null && imageUrl!.isNotEmpty)
                          ? Icons.edit
                          : Icons.add_photo_alternate,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      imageData != null || (imageUrl != null && imageUrl!.isNotEmpty)
                          ? 'Change'
                          : 'Add Photo',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _defaultPlaceholder() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.add_photo_alternate,
            size: 48,
            color: AppColors.primary,
          ),
          SizedBox(height: 8),
          Text(
            'Add Photo',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            if (imageData != null || (imageUrl != null && imageUrl!.isNotEmpty))
              ListTile(
                leading: const Icon(Icons.delete, color: AppColors.error),
                title: const Text(
                  'Remove Photo',
                  style: TextStyle(color: AppColors.error),
                ),
                onTap: () {
                  Navigator.pop(context);
                  onImageChanged(null);
                },
              ),
          ],
        ),
      ),
    );

    if (source == null) return;

    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      maxWidth: 1280,
      maxHeight: 720,
      imageQuality: 80,
    );

    if (picked != null) {
      final bytes = await picked.readAsBytes();
      onImageChanged(ImageData(bytes: bytes, name: picked.name));
    }
  }
}
