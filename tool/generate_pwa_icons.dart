// ignore_for_file: avoid_print
/// Script to generate PWA icons from AppIcon.jpeg
///
/// Run with: dart run tool/generate_pwa_icons.dart
///
/// This generates all required icon sizes for the PWA manifest.
library;

import 'dart:io';
import 'package:image/image.dart' as img;

const String sourceImagePath = 'assets/images/AppIcon.jpeg';
const String webIconsPath = 'web/icons';
const String webPath = 'web';

// Icon sizes to generate
const List<int> iconSizes = [72, 96, 128, 144, 192, 384, 512];
const List<int> faviconSizes = [16, 32, 64];

void main() async {
  print('PWA Icon Generator for NenasKita');
  print('=' * 40);

  // Load source image
  final sourceFile = File(sourceImagePath);
  if (!sourceFile.existsSync()) {
    print('Error: Source image not found at $sourceImagePath');
    exit(1);
  }

  print('Loading source image: $sourceImagePath');
  final sourceBytes = sourceFile.readAsBytesSync();
  final sourceImage = img.decodeImage(sourceBytes);

  if (sourceImage == null) {
    print('Error: Could not decode source image');
    exit(1);
  }

  print('Source image size: ${sourceImage.width}x${sourceImage.height}');
  print('');

  // Ensure icons directory exists
  final iconsDir = Directory(webIconsPath);
  if (!iconsDir.existsSync()) {
    iconsDir.createSync(recursive: true);
  }

  // Generate standard icons
  print('Generating standard icons...');
  for (final size in iconSizes) {
    final resized = img.copyResize(
      sourceImage,
      width: size,
      height: size,
      interpolation: img.Interpolation.linear,
    );
    final outputPath = '$webIconsPath/Icon-$size.png';
    File(outputPath).writeAsBytesSync(img.encodePng(resized));
    print('  Created: $outputPath');
  }

  // Generate maskable icons (with 10% padding for safe zone)
  print('');
  print('Generating maskable icons...');
  for (final size in [192, 512]) {
    final maskable = _createMaskableIcon(sourceImage, size);
    final outputPath = '$webIconsPath/Icon-maskable-$size.png';
    File(outputPath).writeAsBytesSync(img.encodePng(maskable));
    print('  Created: $outputPath');
  }

  // Generate favicons
  print('');
  print('Generating favicons...');
  for (final size in faviconSizes) {
    final resized = img.copyResize(
      sourceImage,
      width: size,
      height: size,
      interpolation: img.Interpolation.linear,
    );
    final outputPath = size == 64
        ? '$webPath/favicon.png'
        : '$webPath/favicon-${size}x$size.png';
    File(outputPath).writeAsBytesSync(img.encodePng(resized));
    print('  Created: $outputPath');
  }

  print('');
  print('Done! All PWA icons generated successfully.');
  print('');
  print('Next steps:');
  print('1. Run: flutter build web');
  print('2. Run: firebase deploy --only hosting');
}

/// Creates a maskable icon with proper safe zone padding
/// The safe zone is 80% of the icon (10% padding on each side)
img.Image _createMaskableIcon(img.Image source, int size) {
  // Background color (light amber from AppColors.primaryContainer)
  final backgroundColor = img.ColorRgba8(254, 243, 199, 255); // #FEF3C7

  // Create canvas with background color
  final canvas = img.Image(width: size, height: size);
  img.fill(canvas, color: backgroundColor);

  // Calculate the safe zone (80% of the icon)
  final safeZoneSize = (size * 0.80).round();
  final padding = ((size - safeZoneSize) / 2).round();

  // Resize source to fit in safe zone
  final resized = img.copyResize(
    source,
    width: safeZoneSize,
    height: safeZoneSize,
    interpolation: img.Interpolation.linear,
  );

  // Composite the resized image onto the canvas
  img.compositeImage(canvas, resized, dstX: padding, dstY: padding);

  return canvas;
}
