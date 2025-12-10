import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/core/utils/social_utils.dart';
import 'package:nenas_kita/core/widgets/section_header.dart';
import 'package:nenas_kita/features/farm/models/farm_model.dart';
import 'package:url_launcher/url_launcher.dart';

/// Contact section with social media icons and action buttons
/// Displays Facebook, Instagram, WhatsApp, and Directions buttons
class ContactSection extends StatelessWidget {
  const ContactSection({super.key, required this.farm});

  final FarmModel farm;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        const SectionHeader(
          title: 'Contact',
          icon: Icons.contact_phone,
        ),
        AppSpacing.vGapS,
        // Social icons and directions button row
        Row(
          children: [
            // Facebook icon button
            _SocialIconButton(
              icon: FontAwesomeIcons.facebookF,
              color: AppColors.facebook,
              enabled: farm.hasFacebookContact,
              tooltip: 'Facebook',
              onPressed: () => farm.hasFacebookContact
                  ? SocialUtils.launchFacebook(
                      context,
                      facebookUrl: farm.facebookLink!,
                    )
                  : _showDisabledSnackbar(context, 'Facebook'),
            ),
            AppSpacing.hGapS,
            // Instagram icon button
            _SocialIconButton(
              icon: FontAwesomeIcons.instagram,
              color: AppColors.instagram,
              enabled: farm.hasInstagramContact,
              tooltip: 'Instagram',
              onPressed: () => farm.hasInstagramContact
                  ? SocialUtils.launchInstagram(
                      context,
                      instagramUrl: farm.instagramLink!,
                    )
                  : _showDisabledSnackbar(context, 'Instagram'),
            ),
            AppSpacing.hGapS,
            // WhatsApp icon button (same as FB/IG)
            _SocialIconButton(
              icon: FontAwesomeIcons.whatsapp,
              color: AppColors.whatsapp,
              enabled: farm.hasWhatsAppContact,
              tooltip: 'WhatsApp',
              onPressed: () => farm.hasWhatsAppContact
                  ? _handleWhatsAppTap(context)
                  : _showDisabledSnackbar(context, 'WhatsApp'),
            ),
            AppSpacing.hGapM,
            // Directions button (full width)
            Expanded(
              child: SizedBox(
                height: AppSpacing.buttonHeight,
                child: ElevatedButton.icon(
                  onPressed: farm.location != null
                      ? () => _handleDirectionsTap(context)
                      : () => _showDisabledSnackbar(context, 'Directions'),
                  icon: const Icon(Icons.directions, size: 18),
                  label: const Text('Directions'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: farm.location != null
                        ? AppColors.tertiary
                        : AppColors.neutral300,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppSpacing.buttonRadius),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Open WhatsApp with pre-filled message
  Future<void> _handleWhatsAppTap(BuildContext context) async {
    final whatsappNumber = farm.effectiveWhatsAppNumber;
    if (whatsappNumber == null || whatsappNumber.isEmpty) return;

    try {
      // Clean phone number and ensure +60 prefix
      final cleanNumber = whatsappNumber.replaceAll(RegExp(r'[^\d+]'), '');
      final phoneWithCode = cleanNumber.startsWith('+')
          ? cleanNumber
          : '+60$cleanNumber';

      // Pre-filled message
      final message =
          'Hi, I am interested in products from ${farm.farmName}.\n\nSent via NenasKita App';

      // Build WhatsApp URL
      final url = Uri.parse(
        'https://wa.me/${phoneWithCode.replaceFirst('+', '')}?text=${Uri.encodeComponent(message)}',
      );

      // Launch WhatsApp
      final canLaunch = await canLaunchUrl(url);
      if (!canLaunch) {
        if (context.mounted) {
          _showErrorSnackBar(
            context,
            'WhatsApp is not installed on this device',
          );
        }
        return;
      }

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

  /// Open Google Maps with farm location
  Future<void> _handleDirectionsTap(BuildContext context) async {
    final location = farm.location;
    if (location == null) return;

    try {
      final lat = location.latitude;
      final lng = location.longitude;

      // Build Google Maps URL
      final url = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
      );

      // Launch Google Maps
      final canLaunch = await canLaunchUrl(url);
      if (!canLaunch) {
        if (context.mounted) {
          _showErrorSnackBar(context, 'Could not open Maps app');
        }
        return;
      }

      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (context.mounted) {
        _showErrorSnackBar(context, 'Could not open Maps. Please try again.');
      }
    }
  }

  /// Show error snackbar
  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Show snackbar when disabled social media button is tapped
  void _showDisabledSnackbar(BuildContext context, String platform) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Seller has not added $platform'),
        backgroundColor: AppColors.textSecondary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

/// Social media icon button widget
/// Shows enabled state with brand color or disabled state with neutral color
class _SocialIconButton extends StatelessWidget {
  const _SocialIconButton({
    required this.icon,
    required this.color,
    required this.enabled,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final Color color;
  final bool enabled;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: FaIcon(icon, size: 18),
      style: IconButton.styleFrom(
        backgroundColor: enabled ? color : AppColors.neutral300,
        foregroundColor: Colors.white,
        minimumSize: const Size(40, 40),
        maximumSize: const Size(40, 40),
      ),
      tooltip: tooltip,
    );
  }
}
