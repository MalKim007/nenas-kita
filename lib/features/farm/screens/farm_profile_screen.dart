import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:nenas_kita/core/routing/route_names.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/core/widgets/app_error.dart';
import 'package:nenas_kita/core/widgets/skeletons/skeletons.dart';
import 'package:nenas_kita/features/farm/providers/farm_providers.dart';
import 'package:nenas_kita/features/farm/widgets/farm_info_card.dart';
import 'package:nenas_kita/features/farm/widgets/variety_chips.dart';
import 'package:nenas_kita/features/farm/widgets/social_links_section.dart';
import 'package:nenas_kita/features/farm/widgets/location_picker.dart';

/// Farm profile view screen (read-only)
class FarmProfileScreen extends ConsumerWidget {
  const FarmProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final farmAsync = ref.watch(myPrimaryFarmProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Business'),
        actions: [
          IconButton(
            onPressed: () => context.push(RouteNames.farmerFarmEdit),
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Business',
          ),
        ],
      ),
      body: farmAsync.when(
        data: (farm) {
          if (farm == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.agriculture,
                    size: 64,
                    color: AppColors.textDisabled,
                  ),
                  AppSpacing.vGapM,
                  const Text('No business profile yet'),
                  AppSpacing.vGapL,
                  ElevatedButton(
                    onPressed: () => context.push(RouteNames.farmerFarmSetup),
                    child: const Text('Create Business'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: AppSpacing.pagePadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero header
                FarmHeader(
                  farm: farm,
                  heroImageUrl: farm.socialLinks['heroImage'],
                ),
                AppSpacing.vGapL,

                // Description
                if (farm.description != null && farm.description!.isNotEmpty) ...[
                  FarmDetailSection(
                    title: 'About',
                    icon: Icons.info_outline,
                    child: Text(
                      farm.description!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  AppSpacing.vGapL,
                ],

                // Varieties
                FarmDetailSection(
                  title: 'Varieties',
                  icon: Icons.local_florist,
                  child: VarietyChips(varieties: farm.varieties),
                ),
                AppSpacing.vGapL,

                // Details (collapsible)
                CollapsibleFarmSection(
                  title: 'Business Details',
                  icon: Icons.assignment,
                  initiallyExpanded: true,
                  child: Column(
                    children: [
                      if (farm.licenseNumber != null)
                        FarmInfoRow(
                          label: 'License',
                          value: farm.licenseNumber!,
                          icon: Icons.badge,
                        ),
                      if (farm.farmSizeHectares != null)
                        FarmInfoRow(
                          label: 'Business Size',
                          value: '${farm.farmSizeHectares!.toStringAsFixed(1)} acres',
                          icon: Icons.square_foot,
                        ),
                      FarmInfoRow(
                        label: 'Delivery',
                        value: farm.deliveryAvailable ? 'Available' : 'Not available',
                        icon: Icons.local_shipping,
                      ),
                      if (farm.licenseExpiry != null)
                        FarmInfoRow(
                          label: 'License Expiry',
                          value: _formatDate(farm.licenseExpiry!),
                          icon: Icons.event,
                        ),
                    ],
                  ),
                ),
                AppSpacing.vGapM,

                // Contact / Social Links (collapsible)
                CollapsibleFarmSection(
                  title: 'Contact Information',
                  icon: Icons.contact_phone,
                  initiallyExpanded: false,
                  child: SocialLinksSection(
                    whatsappNumber: farm.socialLinks['whatsapp'],
                    facebookUrl: farm.socialLinks['facebook'],
                    farmName: farm.farmName,
                  ),
                ),
                AppSpacing.vGapL,

                // Location
                if (farm.location != null) ...[
                  FarmDetailSection(
                    title: 'Location',
                    icon: Icons.location_on,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (farm.address != null && farm.address!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.s),
                            child: Text(
                              farm.address!,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        LocationPreview(
                          location: farm.location!,
                          onTap: () => _openInGoogleMaps(
                            farm.location!.latitude,
                            farm.location!.longitude,
                          ),
                        ),
                        AppSpacing.vGapS,
                        TextButton.icon(
                          onPressed: () => _openInGoogleMaps(
                            farm.location!.latitude,
                            farm.location!.longitude,
                          ),
                          icon: const Icon(Icons.directions, size: 18),
                          label: const Text('Get Directions'),
                        ),
                      ],
                    ),
                  ),
                  AppSpacing.vGapL,
                ],

                // Bottom spacing
                AppSpacing.vGapXL,
              ],
            ),
          );
        },
        loading: () => const FarmProfileSkeleton(),
        error: (e, _) => AppError(
          message: 'Failed to load business profile',
          onRetry: () => ref.invalidate(myPrimaryFarmProvider),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _openInGoogleMaps(double lat, double lng) async {
    final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Could not open Google Maps: $e');
    }
  }
}
