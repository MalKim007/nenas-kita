import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/core/widgets/app_button.dart';
import 'package:nenas_kita/services/providers/service_providers.dart';

/// Location picker bottom sheet using OpenStreetMap
class LocationPicker extends ConsumerStatefulWidget {
  const LocationPicker({
    super.key,
    this.initialLocation,
    required this.onLocationSelected,
  });

  final GeoPoint? initialLocation;
  final void Function(GeoPoint location, String? address) onLocationSelected;

  /// Show location picker as bottom sheet
  static Future<void> show({
    required BuildContext context,
    GeoPoint? initialLocation,
    required void Function(GeoPoint location, String? address) onLocationSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: LocationPicker(
          initialLocation: initialLocation,
          onLocationSelected: (location, address) {
            onLocationSelected(location, address);
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  @override
  ConsumerState<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends ConsumerState<LocationPicker> {
  late MapController _mapController;
  LatLng? _selectedLocation;
  String? _address;
  bool _isLoading = false;
  bool _isGettingLocation = false;

  // Default to Melaka center
  static const _defaultCenter = LatLng(2.1896, 102.2501);
  static const _defaultZoom = 12.0;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    if (widget.initialLocation != null) {
      _selectedLocation = LatLng(
        widget.initialLocation!.latitude,
        widget.initialLocation!.longitude,
      );
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isGettingLocation = true);

    try {
      final locationService = ref.read(locationServiceProvider);
      final position = await locationService.getCurrentPosition();

      if (position != null) {
        final newLocation = LatLng(position.latitude, position.longitude);
        setState(() {
          _selectedLocation = newLocation;
        });
        _mapController.move(newLocation, 15.0);
        await _reverseGeocode(newLocation);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not get location: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGettingLocation = false);
      }
    }
  }

  Future<void> _reverseGeocode(LatLng location) async {
    setState(() => _isLoading = true);

    try {
      final locationService = ref.read(locationServiceProvider);
      final address = await locationService.getAddressFromCoordinates(
        location.latitude,
        location.longitude,
      );
      if (mounted) {
        setState(() => _address = address);
      }
    } catch (e) {
      debugPrint('Reverse geocode failed: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _onMapTap(TapPosition tapPosition, LatLng point) {
    setState(() {
      _selectedLocation = point;
      _address = null;
    });
    _reverseGeocode(point);
  }

  void _confirmLocation() {
    if (_selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a location on the map')),
      );
      return;
    }

    widget.onLocationSelected(
      GeoPoint(_selectedLocation!.latitude, _selectedLocation!.longitude),
      _address,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(AppSpacing.m),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.outlineVariant),
            ),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
              const Expanded(
                child: Text(
                  'Select Business Location',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 48), // Balance the close button
            ],
          ),
        ),

        // Map
        Expanded(
          child: Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _selectedLocation ?? _defaultCenter,
                  initialZoom: _selectedLocation != null ? 15.0 : _defaultZoom,
                  onTap: _onMapTap,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.nenaskita.app',
                  ),
                  if (_selectedLocation != null)
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _selectedLocation!,
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.location_pin,
                            color: AppColors.primary,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                ],
              ),

              // Current location button
              Positioned(
                right: AppSpacing.m,
                bottom: AppSpacing.m,
                child: FloatingActionButton.small(
                  onPressed: _isGettingLocation ? null : _getCurrentLocation,
                  backgroundColor: AppColors.surface,
                  child: _isGettingLocation
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.my_location, color: AppColors.primary),
                ),
              ),

              // Instructions overlay
              if (_selectedLocation == null)
                Positioned(
                  top: AppSpacing.m,
                  left: AppSpacing.m,
                  right: AppSpacing.m,
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.s),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusM),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadow,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.touch_app, color: AppColors.textSecondary),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Tap on the map to select your business location',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Address display and confirm button
        Container(
          padding: const EdgeInsets.all(AppSpacing.m),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(
              top: BorderSide(color: AppColors.outlineVariant),
            ),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Address
                if (_selectedLocation != null) ...[
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.s),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusM),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        AppSpacing.hGapS,
                        Expanded(
                          child: _isLoading
                              ? const Text(
                                  'Getting address...',
                                  style: TextStyle(color: AppColors.textSecondary),
                                )
                              : Text(
                                  _address ?? 'Location selected',
                                  style: const TextStyle(fontSize: 14),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                        ),
                      ],
                    ),
                  ),
                  AppSpacing.vGapM,
                ],
                // Confirm button
                AppButton(
                  onPressed: _selectedLocation != null ? _confirmLocation : null,
                  label: 'Confirm Location',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Mini map preview (read-only)
class LocationPreview extends StatelessWidget {
  const LocationPreview({
    super.key,
    required this.location,
    this.height = 150,
    this.onTap,
  });

  final GeoPoint location;
  final double height;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusM),
          border: Border.all(color: AppColors.outline),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(location.latitude, location.longitude),
                initialZoom: 14.0,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.none,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.nenaskita.app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(location.latitude, location.longitude),
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.location_pin,
                        color: AppColors.primary,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Tap overlay
            if (onTap != null)
              Positioned(
                right: AppSpacing.s,
                bottom: AppSpacing.s,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusS),
                    boxShadow: [
                      BoxShadow(color: AppColors.shadow, blurRadius: 2),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit, size: 14, color: AppColors.primary),
                      SizedBox(width: 4),
                      Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.primary,
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
}
