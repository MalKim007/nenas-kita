import 'dart:typed_data';

import 'package:cloudinary_public/cloudinary_public.dart';

/// Service for image storage operations using Cloudinary
/// Uses unsigned uploads with consistent publicId for image replacement
class StorageService {
  final CloudinaryPublic _cloudinary;

  StorageService()
      : _cloudinary = CloudinaryPublic(
          'dbbtlsik6',
          'nenas_kita',
          cache: false,
        );

  // Constants
  static const int maxFileSizeBytes = 5 * 1024 * 1024; // 5MB
  static const List<String> validExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];

  /// Validate file type
  bool isValidImageType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    return validExtensions.contains(extension);
  }

  /// Validate file size
  bool isValidFileSize(int sizeInBytes) {
    return sizeInBytes <= maxFileSizeBytes;
  }

  /// Upload product image
  /// Uses consistent publicId for replacement: product_{productId}
  /// Folder: nenaskita/farms/{farmId}/products
  Future<String> uploadProductImage({
    required String farmId,
    required String productId,
    required Uint8List bytes,
    required String fileName,
  }) async {
    if (!isValidImageType(fileName)) {
      throw Exception('Invalid image type. Allowed: ${validExtensions.join(', ')}');
    }

    if (!isValidFileSize(bytes.length)) {
      throw Exception('File too large. Maximum size: ${maxFileSizeBytes ~/ 1024 ~/ 1024}MB');
    }

    final response = await _cloudinary.uploadFile(
      CloudinaryFile.fromBytesData(
        bytes,
        identifier: fileName,
        folder: 'nenaskita/farms/$farmId/products',
        publicId: 'product_$productId',
        resourceType: CloudinaryResourceType.Image,
      ),
    );

    return response.secureUrl;
  }

  /// Upload farm image
  /// Uses consistent publicId for replacement: farm_{farmId}
  /// Folder: nenaskita/farms/{farmId}
  Future<String> uploadFarmImage({
    required String farmId,
    required Uint8List bytes,
    required String fileName,
  }) async {
    if (!isValidImageType(fileName)) {
      throw Exception('Invalid image type. Allowed: ${validExtensions.join(', ')}');
    }

    if (!isValidFileSize(bytes.length)) {
      throw Exception('File too large. Maximum size: ${maxFileSizeBytes ~/ 1024 ~/ 1024}MB');
    }

    final response = await _cloudinary.uploadFile(
      CloudinaryFile.fromBytesData(
        bytes,
        identifier: fileName,
        folder: 'nenaskita/farms/$farmId',
        publicId: 'farm_$farmId',
        resourceType: CloudinaryResourceType.Image,
      ),
    );

    return response.secureUrl;
  }

  /// Upload user avatar
  /// Uses consistent publicId for replacement: avatar_{userId}
  /// Folder: nenaskita/users
  Future<String> uploadUserAvatar({
    required String userId,
    required Uint8List bytes,
    required String fileName,
  }) async {
    if (!isValidImageType(fileName)) {
      throw Exception('Invalid image type. Allowed: ${validExtensions.join(', ')}');
    }

    if (!isValidFileSize(bytes.length)) {
      throw Exception('File too large. Maximum size: ${maxFileSizeBytes ~/ 1024 ~/ 1024}MB');
    }

    final response = await _cloudinary.uploadFile(
      CloudinaryFile.fromBytesData(
        bytes,
        identifier: fileName,
        folder: 'nenaskita/users',
        publicId: 'avatar_$userId',
        resourceType: CloudinaryResourceType.Image,
      ),
    );

    return response.secureUrl;
  }

  /// Delete image by URL
  /// NOTE: Not supported with unsigned uploads
  /// Images are replaced automatically when uploading with same publicId
  Future<void> deleteImage(String url) async {
    // No-op: Unsigned uploads cannot delete
    // To update an image, simply upload a new one with the same publicId
    // The old image will be automatically replaced
  }

  /// Delete all images in a folder
  /// NOTE: Not supported with unsigned uploads
  Future<void> deleteFolder(String path) async {
    // No-op: Unsigned uploads cannot delete
    // Cloudinary dashboard can be used for manual cleanup if needed
  }
}
