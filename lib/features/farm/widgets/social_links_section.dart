import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/core/widgets/app_button.dart';

/// Social links section with WhatsApp and Facebook buttons
class SocialLinksSection extends StatelessWidget {
  const SocialLinksSection({
    super.key,
    this.whatsappNumber,
    this.facebookUrl,
    this.farmName,
  });

  final String? whatsappNumber;
  final String? facebookUrl;
  final String? farmName;

  @override
  Widget build(BuildContext context) {
    if ((whatsappNumber == null || whatsappNumber!.isEmpty) &&
        (facebookUrl == null || facebookUrl!.isEmpty)) {
      return Text(
        'No contact links added',
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
      );
    }

    return Row(
      children: [
        if (whatsappNumber != null && whatsappNumber!.isNotEmpty)
          Expanded(
            child: WhatsAppButton(
              onPressed: () => _launchWhatsApp(context),
              isFullWidth: true,
            ),
          ),
        if (whatsappNumber != null &&
            whatsappNumber!.isNotEmpty &&
            facebookUrl != null &&
            facebookUrl!.isNotEmpty)
          AppSpacing.hGapS,
        if (facebookUrl != null && facebookUrl!.isNotEmpty)
          Expanded(
            child: _FacebookButton(onPressed: () => _launchFacebook(context)),
          ),
      ],
    );
  }

  void _launchWhatsApp(BuildContext context) async {
    if (whatsappNumber == null) return;

    // Clean phone number (remove spaces, dashes, etc.)
    final cleanNumber = whatsappNumber!.replaceAll(RegExp(r'[^\d+]'), '');

    // Ensure it has country code
    final phoneWithCode = cleanNumber.startsWith('+')
        ? cleanNumber
        : '+60$cleanNumber';

    // Pre-filled message
    final message = farmName != null
        ? 'Hi, I am interested in products from $farmName.\n\nSent via NenasKita App'
        : 'Hi, I am interested in your pineapple products.\n\nSent via NenasKita App';

    final url = Uri.parse(
      'https://wa.me/${phoneWithCode.replaceFirst('+', '')}?text=${Uri.encodeComponent(message)}',
    );

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open WhatsApp')),
        );
      }
    }
  }

  void _launchFacebook(BuildContext context) async {
    if (facebookUrl == null) return;

    final url = Uri.parse(facebookUrl!);

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open Facebook')),
        );
      }
    }
  }
}

class _FacebookButton extends StatelessWidget {
  const _FacebookButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.buttonHeight,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.facebook, size: 20),
        label: const Text('Facebook'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1877F2),
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}

/// Compact social links for forms (icon buttons)
class SocialLinksCompact extends StatelessWidget {
  const SocialLinksCompact({
    super.key,
    this.whatsappNumber,
    this.facebookUrl,
    this.farmName,
  });

  final String? whatsappNumber;
  final String? facebookUrl;
  final String? farmName;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (whatsappNumber != null && whatsappNumber!.isNotEmpty)
          IconButton(
            onPressed: () => _launchWhatsApp(context),
            icon: const Icon(Icons.chat),
            color: AppColors.whatsapp,
            tooltip: 'WhatsApp',
          ),
        if (facebookUrl != null && facebookUrl!.isNotEmpty)
          IconButton(
            onPressed: () => _launchFacebook(context),
            icon: const Icon(Icons.facebook),
            color: const Color(0xFF1877F2),
            tooltip: 'Facebook',
          ),
      ],
    );
  }

  void _launchWhatsApp(BuildContext context) async {
    if (whatsappNumber == null) return;

    final cleanNumber = whatsappNumber!.replaceAll(RegExp(r'[^\d+]'), '');
    final phoneWithCode = cleanNumber.startsWith('+')
        ? cleanNumber
        : '+60$cleanNumber';

    final message = farmName != null
        ? 'Hi, I am interested in products from $farmName.'
        : 'Hi, I am interested in your products.';

    final url = Uri.parse(
      'https://wa.me/${phoneWithCode.replaceFirst('+', '')}?text=${Uri.encodeComponent(message)}',
    );

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Could not launch WhatsApp: $e');
    }
  }

  void _launchFacebook(BuildContext context) async {
    if (facebookUrl == null) return;

    final url = Uri.parse(facebookUrl!);

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Could not launch Facebook: $e');
    }
  }
}

/// WhatsApp input field with +60 prefix
class WhatsAppInputField extends StatelessWidget {
  const WhatsAppInputField({
    super.key,
    required this.controller,
    this.label = 'WhatsApp Number',
    this.enabled = true,
  });

  final TextEditingController controller;
  final String label;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: label,
        prefixText: '+60 ',
        prefixIcon: const Icon(Icons.chat, color: AppColors.whatsapp),
        border: const OutlineInputBorder(),
        hintText: '12-345 6789',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return null; // Optional field
        final digits = value.replaceAll(RegExp(r'[^\d]'), '');
        if (digits.length < 9 || digits.length > 10) {
          return 'Enter valid Malaysian phone number';
        }
        return null;
      },
    );
  }
}

/// Facebook URL input field
class FacebookInputField extends StatelessWidget {
  const FacebookInputField({
    super.key,
    required this.controller,
    this.label = 'Facebook Page URL',
    this.enabled = true,
  });

  final TextEditingController controller;
  final String label;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: TextInputType.url,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.facebook, color: Color(0xFF1877F2)),
        border: const OutlineInputBorder(),
        hintText: 'https://facebook.com/yourpage',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return null; // Optional field
        if (!value.startsWith('http://') && !value.startsWith('https://')) {
          return 'Enter valid URL (https://...)';
        }
        return null;
      },
    );
  }
}

/// Instagram URL input field
class InstagramInputField extends StatelessWidget {
  const InstagramInputField({
    super.key,
    required this.controller,
    this.label = 'Instagram Profile URL',
    this.enabled = true,
  });

  final TextEditingController controller;
  final String label;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: TextInputType.url,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Padding(
          padding: EdgeInsets.all(12),
          child: FaIcon(
            FontAwesomeIcons.squareInstagram,
            color: Color(0xFFE4405F),
            size: 24,
          ),
        ),
        border: const OutlineInputBorder(),
        hintText: 'https://instagram.com/yourpage',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return null; // Optional field
        if (!value.startsWith('http://') && !value.startsWith('https://')) {
          return 'Enter valid URL (https://...)';
        }
        return null;
      },
    );
  }
}
