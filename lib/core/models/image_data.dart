import 'dart:typed_data';

/// Cross-platform image data class that works on both web and mobile.
/// Uses Uint8List instead of dart:io File for web compatibility.
class ImageData {
  final Uint8List bytes;
  final String name;

  const ImageData({
    required this.bytes,
    required this.name,
  });
}
