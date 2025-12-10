import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Utility class for launching social media and communication apps
/// Handles WhatsApp, Facebook, Instagram with proper error handling
class SocialUtils {
  SocialUtils._();

  /// Launch WhatsApp with pre-filled message
  ///
  /// [context] - BuildContext for showing error messages
  /// [phoneNumber] - Raw phone number (will be cleaned and +60 prefixed)
  /// [farmName] - Name of the farm for the message
  /// [productName] - Optional product name to include in message
  static Future<void> launchWhatsApp(
    BuildContext context, {
    required String phoneNumber,
    required String farmName,
    String? productName,
  }) async {
    try {
      // Clean phone number (remove spaces, dashes, etc.)
      final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');

      // Ensure it has country code (+60 for Malaysia)
      final phoneWithCode = cleanNumber.startsWith('+')
          ? cleanNumber
          : '+60$cleanNumber';

      // Build pre-filled message
      final message = productName != null
          ? 'Hi, I am interested in $productName from $farmName.\n\nSent via NenasKita App'
          : 'Hi, I am interested in products from $farmName.\n\nSent via NenasKita App';

      // Build WhatsApp URL (wa.me format)
      final url = Uri.parse(
        'https://wa.me/${phoneWithCode.replaceFirst('+', '')}?text=${Uri.encodeComponent(message)}',
      );

      // Check if can launch
      if (!await canLaunchUrl(url)) {
        if (context.mounted) {
          _showErrorSnackBar(
            context,
            'WhatsApp is not installed on this device',
          );
        }
        return;
      }

      // Launch WhatsApp
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (context.mounted) {
        _showErrorSnackBar(
          context,
          'Could not open WhatsApp. Please try again.',
        );
      }
    }
  }

  /// Launch Facebook page
  ///
  /// [context] - BuildContext for showing error messages
  /// [facebookUrl] - Full Facebook URL (https://facebook.com/...)
  static Future<void> launchFacebook(
    BuildContext context, {
    required String facebookUrl,
  }) async {
    try {
      // Validate URL format
      if (!facebookUrl.startsWith('http://') &&
          !facebookUrl.startsWith('https://')) {
        if (context.mounted) {
          _showErrorSnackBar(context, 'Invalid Facebook URL format');
        }
        return;
      }

      final webUrl = Uri.parse(facebookUrl);
      final fbAppUrl = Uri.parse(
        'fb://facewebmodal/f?href=${Uri.encodeComponent(facebookUrl)}',
      );

      // Try Facebook app first, fall back to browser
      final launchedApp = await launchUrl(
        fbAppUrl,
        mode: LaunchMode.externalApplication,
      );

      if (!launchedApp) {
        final launchedWeb = await launchUrl(
          webUrl,
          mode: LaunchMode.externalApplication,
        );
        if (!launchedWeb) {
          if (context.mounted) {
            _showErrorSnackBar(context, 'Could not open Facebook link');
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorSnackBar(
          context,
          'Could not open Facebook. Please try again.',
        );
      }
    }
  }

  /// Launch Instagram profile
  ///
  /// [context] - BuildContext for showing error messages
  /// [instagramUrl] - Full Instagram URL (https://instagram.com/...)
  static Future<void> launchInstagram(
    BuildContext context, {
    required String instagramUrl,
  }) async {
    try {
      // Validate URL format
      if (!instagramUrl.startsWith('http://') &&
          !instagramUrl.startsWith('https://')) {
        if (context.mounted) {
          _showErrorSnackBar(context, 'Invalid Instagram URL format');
        }
        return;
      }

      final url = Uri.parse(instagramUrl);

      // Check if can launch
      if (!await canLaunchUrl(url)) {
        if (context.mounted) {
          _showErrorSnackBar(context, 'Could not open Instagram link');
        }
        return;
      }

      // Launch Instagram
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (context.mounted) {
        _showErrorSnackBar(
          context,
          'Could not open Instagram. Please try again.',
        );
      }
    }
  }

  /// Show error snackbar
  static void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
