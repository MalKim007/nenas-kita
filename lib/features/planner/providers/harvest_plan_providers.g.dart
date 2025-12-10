// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'harvest_plan_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$harvestPlanRepositoryHash() =>
    r'fd999ee5bc7fa409061f45f691b43f2c1441c41c';

/// Harvest plan repository provider
///
/// Copied from [harvestPlanRepository].
@ProviderFor(harvestPlanRepository)
final harvestPlanRepositoryProvider = Provider<HarvestPlanRepository>.internal(
  harvestPlanRepository,
  name: r'harvestPlanRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$harvestPlanRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HarvestPlanRepositoryRef = ProviderRef<HarvestPlanRepository>;
String _$harvestPlanByIdHash() => r'f4c76643fe786ee9dffd8f2a0106f6d1426e9a8c';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Get harvest plan by ID
///
/// Copied from [harvestPlanById].
@ProviderFor(harvestPlanById)
const harvestPlanByIdProvider = HarvestPlanByIdFamily();

/// Get harvest plan by ID
///
/// Copied from [harvestPlanById].
class HarvestPlanByIdFamily extends Family<AsyncValue<HarvestPlanModel?>> {
  /// Get harvest plan by ID
  ///
  /// Copied from [harvestPlanById].
  const HarvestPlanByIdFamily();

  /// Get harvest plan by ID
  ///
  /// Copied from [harvestPlanById].
  HarvestPlanByIdProvider call(
    String planId,
  ) {
    return HarvestPlanByIdProvider(
      planId,
    );
  }

  @override
  HarvestPlanByIdProvider getProviderOverride(
    covariant HarvestPlanByIdProvider provider,
  ) {
    return call(
      provider.planId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'harvestPlanByIdProvider';
}

/// Get harvest plan by ID
///
/// Copied from [harvestPlanById].
class HarvestPlanByIdProvider
    extends AutoDisposeStreamProvider<HarvestPlanModel?> {
  /// Get harvest plan by ID
  ///
  /// Copied from [harvestPlanById].
  HarvestPlanByIdProvider(
    String planId,
  ) : this._internal(
          (ref) => harvestPlanById(
            ref as HarvestPlanByIdRef,
            planId,
          ),
          from: harvestPlanByIdProvider,
          name: r'harvestPlanByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$harvestPlanByIdHash,
          dependencies: HarvestPlanByIdFamily._dependencies,
          allTransitiveDependencies:
              HarvestPlanByIdFamily._allTransitiveDependencies,
          planId: planId,
        );

  HarvestPlanByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.planId,
  }) : super.internal();

  final String planId;

  @override
  Override overrideWith(
    Stream<HarvestPlanModel?> Function(HarvestPlanByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HarvestPlanByIdProvider._internal(
        (ref) => create(ref as HarvestPlanByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        planId: planId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<HarvestPlanModel?> createElement() {
    return _HarvestPlanByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HarvestPlanByIdProvider && other.planId == planId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, planId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin HarvestPlanByIdRef on AutoDisposeStreamProviderRef<HarvestPlanModel?> {
  /// The parameter `planId` of this provider.
  String get planId;
}

class _HarvestPlanByIdProviderElement
    extends AutoDisposeStreamProviderElement<HarvestPlanModel?>
    with HarvestPlanByIdRef {
  _HarvestPlanByIdProviderElement(super.provider);

  @override
  String get planId => (origin as HarvestPlanByIdProvider).planId;
}

String _$myHarvestPlansHash() => r'344680ce009628522956113979b2ef439cda3d71';

/// Current user's harvest plans
///
/// Copied from [myHarvestPlans].
@ProviderFor(myHarvestPlans)
final myHarvestPlansProvider =
    AutoDisposeStreamProvider<List<HarvestPlanModel>>.internal(
  myHarvestPlans,
  name: r'myHarvestPlansProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$myHarvestPlansHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MyHarvestPlansRef
    = AutoDisposeStreamProviderRef<List<HarvestPlanModel>>;
String _$myUpcomingHarvestsHash() =>
    r'98e9ad9abe0a66d5f4a7246786079fb261b68b89';

/// Current user's upcoming harvests
///
/// Copied from [myUpcomingHarvests].
@ProviderFor(myUpcomingHarvests)
final myUpcomingHarvestsProvider =
    AutoDisposeStreamProvider<List<HarvestPlanModel>>.internal(
  myUpcomingHarvests,
  name: r'myUpcomingHarvestsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$myUpcomingHarvestsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MyUpcomingHarvestsRef
    = AutoDisposeStreamProviderRef<List<HarvestPlanModel>>;
String _$myOverduePlansHash() => r'80f602eb23d7a145b4af29decaa6ad04ce9ac482';

/// Current user's overdue plans
///
/// Copied from [myOverduePlans].
@ProviderFor(myOverduePlans)
final myOverduePlansProvider =
    AutoDisposeFutureProvider<List<HarvestPlanModel>>.internal(
  myOverduePlans,
  name: r'myOverduePlansProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$myOverduePlansHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MyOverduePlansRef
    = AutoDisposeFutureProviderRef<List<HarvestPlanModel>>;
String _$harvestPlansByFarmHash() =>
    r'1744c51f06e38710e98d262e07aa0bae16331ddf';

/// Harvest plans for a specific farm
///
/// Copied from [harvestPlansByFarm].
@ProviderFor(harvestPlansByFarm)
const harvestPlansByFarmProvider = HarvestPlansByFarmFamily();

/// Harvest plans for a specific farm
///
/// Copied from [harvestPlansByFarm].
class HarvestPlansByFarmFamily
    extends Family<AsyncValue<List<HarvestPlanModel>>> {
  /// Harvest plans for a specific farm
  ///
  /// Copied from [harvestPlansByFarm].
  const HarvestPlansByFarmFamily();

  /// Harvest plans for a specific farm
  ///
  /// Copied from [harvestPlansByFarm].
  HarvestPlansByFarmProvider call(
    String farmId,
  ) {
    return HarvestPlansByFarmProvider(
      farmId,
    );
  }

  @override
  HarvestPlansByFarmProvider getProviderOverride(
    covariant HarvestPlansByFarmProvider provider,
  ) {
    return call(
      provider.farmId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'harvestPlansByFarmProvider';
}

/// Harvest plans for a specific farm
///
/// Copied from [harvestPlansByFarm].
class HarvestPlansByFarmProvider
    extends AutoDisposeStreamProvider<List<HarvestPlanModel>> {
  /// Harvest plans for a specific farm
  ///
  /// Copied from [harvestPlansByFarm].
  HarvestPlansByFarmProvider(
    String farmId,
  ) : this._internal(
          (ref) => harvestPlansByFarm(
            ref as HarvestPlansByFarmRef,
            farmId,
          ),
          from: harvestPlansByFarmProvider,
          name: r'harvestPlansByFarmProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$harvestPlansByFarmHash,
          dependencies: HarvestPlansByFarmFamily._dependencies,
          allTransitiveDependencies:
              HarvestPlansByFarmFamily._allTransitiveDependencies,
          farmId: farmId,
        );

  HarvestPlansByFarmProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.farmId,
  }) : super.internal();

  final String farmId;

  @override
  Override overrideWith(
    Stream<List<HarvestPlanModel>> Function(HarvestPlansByFarmRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HarvestPlansByFarmProvider._internal(
        (ref) => create(ref as HarvestPlansByFarmRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        farmId: farmId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<HarvestPlanModel>> createElement() {
    return _HarvestPlansByFarmProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HarvestPlansByFarmProvider && other.farmId == farmId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, farmId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin HarvestPlansByFarmRef
    on AutoDisposeStreamProviderRef<List<HarvestPlanModel>> {
  /// The parameter `farmId` of this provider.
  String get farmId;
}

class _HarvestPlansByFarmProviderElement
    extends AutoDisposeStreamProviderElement<List<HarvestPlanModel>>
    with HarvestPlansByFarmRef {
  _HarvestPlansByFarmProviderElement(super.provider);

  @override
  String get farmId => (origin as HarvestPlansByFarmProvider).farmId;
}

String _$allHarvestPlansHash() => r'e5567044f0655a678f40a98412ed1bb1a5e95cb6';

/// All harvest plans (for admin/calendar view)
///
/// Copied from [allHarvestPlans].
@ProviderFor(allHarvestPlans)
final allHarvestPlansProvider =
    AutoDisposeStreamProvider<List<HarvestPlanModel>>.internal(
  allHarvestPlans,
  name: r'allHarvestPlansProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$allHarvestPlansHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllHarvestPlansRef
    = AutoDisposeStreamProviderRef<List<HarvestPlanModel>>;
String _$plansNeedingReminderHash() =>
    r'ae3d275b4aa6c2ab8ed8e58dc0f2b51f02cd7ee3';

/// Plans needing reminder (7 days or less)
///
/// Copied from [plansNeedingReminder].
@ProviderFor(plansNeedingReminder)
final plansNeedingReminderProvider =
    AutoDisposeFutureProvider<List<HarvestPlanModel>>.internal(
  plansNeedingReminder,
  name: r'plansNeedingReminderProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$plansNeedingReminderHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PlansNeedingReminderRef
    = AutoDisposeFutureProviderRef<List<HarvestPlanModel>>;
String _$myActiveHarvestCountHash() =>
    r'cde4be4855e2a0b1fe01043578fd349a6bcd2479';

/// Active harvest plans count for current user
///
/// Copied from [myActiveHarvestCount].
@ProviderFor(myActiveHarvestCount)
final myActiveHarvestCountProvider = AutoDisposeFutureProvider<int>.internal(
  myActiveHarvestCount,
  name: r'myActiveHarvestCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$myActiveHarvestCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MyActiveHarvestCountRef = AutoDisposeFutureProviderRef<int>;
String _$upcomingHarvestQuantityHash() =>
    r'fe8b62fad6b8faa26b7738df8bdbc2a382df8a3a';

/// Upcoming quantity by variety (aggregate)
///
/// Copied from [upcomingHarvestQuantity].
@ProviderFor(upcomingHarvestQuantity)
final upcomingHarvestQuantityProvider =
    AutoDisposeFutureProvider<Map<String, double>>.internal(
  upcomingHarvestQuantity,
  name: r'upcomingHarvestQuantityProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$upcomingHarvestQuantityHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UpcomingHarvestQuantityRef
    = AutoDisposeFutureProviderRef<Map<String, double>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
