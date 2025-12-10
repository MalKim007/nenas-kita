import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:nenas_kita/core/routing/route_names.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/features/farm/models/farm_model.dart';
import 'package:nenas_kita/features/market/providers/farm_discovery_providers.dart';
import 'package:nenas_kita/features/market/widgets/farm_map_marker.dart';
import 'package:nenas_kita/features/market/widgets/farm_preview_card.dart';
import 'package:nenas_kita/services/providers/service_providers.dart';

/// Farm discovery map view using OpenStreetMap
/// Shows farm locations with interactive markers and preview card
class FarmMapView extends ConsumerStatefulWidget {
  const FarmMapView({super.key, required this.farms});

  final List<FarmWithDistance> farms;

  @override
  ConsumerState<FarmMapView> createState() => _FarmMapViewState();
}

class _FarmMapViewState extends ConsumerState<FarmMapView>
    with SingleTickerProviderStateMixin {
  late MapController _mapController;
  String? _selectedFarmId;
  LatLng? _userLocation;
  bool _isGettingLocation = false;
  double _mapRotation = 0.0;

  // Animation for preview card
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  // Constants
  static const _melakaCenter = LatLng(2.1896, 102.2501);
  static const _defaultZoom = 12.0;
  static const _focusZoom = 15.0;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _initializeMap();
  }

  @override
  void dispose() {
    _mapController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _initializeMap() async {
    // Try to get user location
    try {
      final locationService = ref.read(locationServiceProvider);
      final position = await locationService.getCurrentPosition();
      if (position != null && mounted) {
        setState(() {
          _userLocation = LatLng(position.latitude, position.longitude);
        });
        _mapController.move(_userLocation!, _defaultZoom);
      }
    } catch (e) {
      debugPrint('Could not get initial location: $e');
    }
  }

  void _onMarkerTap(FarmModel farm) {
    HapticFeedback.lightImpact();

    setState(() {
      _selectedFarmId = farm.id;
    });

    // Animate preview card in
    _slideController.forward();

    // Move map to marker location
    if (farm.location != null) {
      _mapController.move(
        LatLng(farm.location!.latitude, farm.location!.longitude),
        _focusZoom,
      );
    }
  }

  void _onMapTap(TapPosition tapPosition, LatLng point) {
    if (_selectedFarmId != null) {
      _slideController.reverse().then((_) {
        if (mounted) {
          setState(() {
            _selectedFarmId = null;
          });
        }
      });
    }
  }

  void _onClosePreview() {
    _slideController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _selectedFarmId = null;
        });
      }
    });
  }

  Future<void> _launchWhatsApp(FarmModel farm) async {
    final whatsappNumber = farm.effectiveWhatsAppNumber;
    if (whatsappNumber == null || whatsappNumber.isEmpty) return;

    // Clean phone number (remove spaces, dashes, etc.)
    final cleanNumber = whatsappNumber.replaceAll(RegExp(r'[^\d+]'), '');

    // Ensure it has country code
    final phoneWithCode = cleanNumber.startsWith('+')
        ? cleanNumber
        : '+60$cleanNumber';

    // Pre-filled message
    final message =
        'Hi, I am interested in products from ${farm.farmName}.\n\nSent via NenasKita App';

    final url = Uri.parse(
      'https://wa.me/${phoneWithCode.replaceFirst('+', '')}?text=${Uri.encodeComponent(message)}',
    );

    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch WhatsApp';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open WhatsApp')),
        );
      }
    }
  }

  Future<void> _launchDirections(FarmModel farm) async {
    if (farm.location == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Location not available')));
      return;
    }

    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=${farm.location!.latitude},${farm.location!.longitude}',
    );

    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch directions';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open directions')),
        );
      }
    }
  }

  Future<void> _goToCurrentLocation() async {
    setState(() => _isGettingLocation = true);

    try {
      final locationService = ref.read(locationServiceProvider);
      final position = await locationService.getCurrentPosition();

      if (position != null && mounted) {
        final newLocation = LatLng(position.latitude, position.longitude);
        setState(() {
          _userLocation = newLocation;
        });
        _mapController.move(newLocation, _focusZoom);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not get location: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isGettingLocation = false);
      }
    }
  }

  void _onViewDetails() {
    if (_selectedFarmId != null) {
      context.push(RouteNames.buyerFarmDetailPath(_selectedFarmId!));
    }
  }

  List<Marker> _buildFarmMarkers() {
    return widget.farms
        .where((farmWithDistance) => farmWithDistance.farm.location != null)
        .map((farmWithDistance) {
          final farm = farmWithDistance.farm;
          final location = farm.location!;

          return Marker(
            point: LatLng(location.latitude, location.longitude),
            width: 48,
            height: 48,
            child: FarmMapMarker(
              isVerified: farm.verifiedByLPNM,
              isSelected: _selectedFarmId == farm.id,
              onTap: () => _onMarkerTap(farm),
            ),
          );
        })
        .toList();
  }

  int get _farmsWithoutLocationCount {
    return widget.farms
        .where((farmWithDistance) => farmWithDistance.farm.location == null)
        .length;
  }

  FarmModel? get _selectedFarm {
    if (_selectedFarmId == null) return null;
    try {
      return widget.farms.firstWhere((f) => f.farm.id == _selectedFarmId).farm;
    } catch (e) {
      return null;
    }
  }

  double? get _selectedFarmDistance {
    if (_selectedFarmId == null) return null;
    try {
      return widget.farms
          .firstWhere((f) => f.farm.id == _selectedFarmId)
          .distanceKm;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Map
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _userLocation ?? _melakaCenter,
            initialZoom: _defaultZoom,
            onPositionChanged: (position, hasGesture) {
              if (!mounted) return;
              setState(() => _mapRotation = position.rotation);
            },
            onTap: _onMapTap,
          ),
          children: [
            // OSM Tile Layer
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.nenaskita.app',
            ),
            // User location marker (blue dot)
            if (_userLocation != null)
              MarkerLayer(
                markers: [
                  Marker(
                    point: _userLocation!,
                    width: 24,
                    height: 24,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.info,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.surface, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            // Farm markers
            MarkerLayer(markers: _buildFarmMarkers()),
          ],
        ),

        // Compass / north reset
        Positioned(
          top: AppSpacing.m,
          right: AppSpacing.m,
          child: Material(
            elevation: 2,
            color: AppColors.surface,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () {
                _mapController.rotate(0);
                setState(() => _mapRotation = 0.0);
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Transform.rotate(
                  angle: -_mapRotation * (3.1415926535 / 180),
                  child: const Icon(
                    Icons.navigation,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ),

        // "X farms not shown" banner at top if farms without location
        if (_farmsWithoutLocationCount > 0)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.all(AppSpacing.m),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.m,
                vertical: AppSpacing.s,
              ),
              decoration: BoxDecoration(
                color: AppColors.warningLight,
                borderRadius: BorderRadius.circular(AppSpacing.radiusM),
                border: Border.all(
                  color: AppColors.warning.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: AppColors.warning,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '$_farmsWithoutLocationCount business${_farmsWithoutLocationCount == 1 ? '' : 'es'} not shown (location unavailable)',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.onPrimaryContainer,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Current location FAB - responsive offset when preview card is shown
        Positioned(
          right: AppSpacing.m,
          bottom: _selectedFarmId != null
              ? MediaQuery.of(context).size.height *
                    0.22 // Above preview card
              : AppSpacing.m,
          child: FloatingActionButton.small(
            onPressed: _isGettingLocation ? null : _goToCurrentLocation,
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

        // Preview card with SlideTransition animation
        if (_selectedFarmId != null && _selectedFarm != null)
          Positioned(
            left: AppSpacing.m,
            right: AppSpacing.m,
            bottom: AppSpacing.m,
            child: SlideTransition(
              position: _slideAnimation,
              child: FarmPreviewCard(
                farm: _selectedFarm!,
                distanceKm: _selectedFarmDistance,
                onWhatsAppTap: () => _launchWhatsApp(_selectedFarm!),
                onDirectionsTap: () => _launchDirections(_selectedFarm!),
                onViewDetailsTap: _onViewDetails,
                onClose: _onClosePreview,
              ),
            ),
          ),
      ],
    );
  }
}
