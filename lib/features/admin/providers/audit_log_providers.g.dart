// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_log_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$auditLogRepositoryHash() =>
    r'34fa089154dee7ba6c178cd05c816e085f62f287';

/// Audit log repository provider
///
/// Copied from [auditLogRepository].
@ProviderFor(auditLogRepository)
final auditLogRepositoryProvider = Provider<AuditLogRepository>.internal(
  auditLogRepository,
  name: r'auditLogRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$auditLogRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuditLogRepositoryRef = ProviderRef<AuditLogRepository>;
String _$recentAuditLogsHash() => r'73c627f3dfbd287f0918f94cb12afdcdcce37588';

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

/// Recent audit logs
///
/// Copied from [recentAuditLogs].
@ProviderFor(recentAuditLogs)
const recentAuditLogsProvider = RecentAuditLogsFamily();

/// Recent audit logs
///
/// Copied from [recentAuditLogs].
class RecentAuditLogsFamily extends Family<AsyncValue<List<AuditLogModel>>> {
  /// Recent audit logs
  ///
  /// Copied from [recentAuditLogs].
  const RecentAuditLogsFamily();

  /// Recent audit logs
  ///
  /// Copied from [recentAuditLogs].
  RecentAuditLogsProvider call({
    int limit = 100,
  }) {
    return RecentAuditLogsProvider(
      limit: limit,
    );
  }

  @override
  RecentAuditLogsProvider getProviderOverride(
    covariant RecentAuditLogsProvider provider,
  ) {
    return call(
      limit: provider.limit,
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
  String? get name => r'recentAuditLogsProvider';
}

/// Recent audit logs
///
/// Copied from [recentAuditLogs].
class RecentAuditLogsProvider
    extends AutoDisposeStreamProvider<List<AuditLogModel>> {
  /// Recent audit logs
  ///
  /// Copied from [recentAuditLogs].
  RecentAuditLogsProvider({
    int limit = 100,
  }) : this._internal(
          (ref) => recentAuditLogs(
            ref as RecentAuditLogsRef,
            limit: limit,
          ),
          from: recentAuditLogsProvider,
          name: r'recentAuditLogsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$recentAuditLogsHash,
          dependencies: RecentAuditLogsFamily._dependencies,
          allTransitiveDependencies:
              RecentAuditLogsFamily._allTransitiveDependencies,
          limit: limit,
        );

  RecentAuditLogsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.limit,
  }) : super.internal();

  final int limit;

  @override
  Override overrideWith(
    Stream<List<AuditLogModel>> Function(RecentAuditLogsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RecentAuditLogsProvider._internal(
        (ref) => create(ref as RecentAuditLogsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<AuditLogModel>> createElement() {
    return _RecentAuditLogsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RecentAuditLogsProvider && other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RecentAuditLogsRef on AutoDisposeStreamProviderRef<List<AuditLogModel>> {
  /// The parameter `limit` of this provider.
  int get limit;
}

class _RecentAuditLogsProviderElement
    extends AutoDisposeStreamProviderElement<List<AuditLogModel>>
    with RecentAuditLogsRef {
  _RecentAuditLogsProviderElement(super.provider);

  @override
  int get limit => (origin as RecentAuditLogsProvider).limit;
}

String _$auditLogsByFarmHash() => r'2c1fc10b0ed6d765a6ea5a4266cc58e5d50a7710';

/// Audit logs for a specific farm
///
/// Copied from [auditLogsByFarm].
@ProviderFor(auditLogsByFarm)
const auditLogsByFarmProvider = AuditLogsByFarmFamily();

/// Audit logs for a specific farm
///
/// Copied from [auditLogsByFarm].
class AuditLogsByFarmFamily extends Family<AsyncValue<List<AuditLogModel>>> {
  /// Audit logs for a specific farm
  ///
  /// Copied from [auditLogsByFarm].
  const AuditLogsByFarmFamily();

  /// Audit logs for a specific farm
  ///
  /// Copied from [auditLogsByFarm].
  AuditLogsByFarmProvider call(
    String farmId,
  ) {
    return AuditLogsByFarmProvider(
      farmId,
    );
  }

  @override
  AuditLogsByFarmProvider getProviderOverride(
    covariant AuditLogsByFarmProvider provider,
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
  String? get name => r'auditLogsByFarmProvider';
}

/// Audit logs for a specific farm
///
/// Copied from [auditLogsByFarm].
class AuditLogsByFarmProvider
    extends AutoDisposeStreamProvider<List<AuditLogModel>> {
  /// Audit logs for a specific farm
  ///
  /// Copied from [auditLogsByFarm].
  AuditLogsByFarmProvider(
    String farmId,
  ) : this._internal(
          (ref) => auditLogsByFarm(
            ref as AuditLogsByFarmRef,
            farmId,
          ),
          from: auditLogsByFarmProvider,
          name: r'auditLogsByFarmProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$auditLogsByFarmHash,
          dependencies: AuditLogsByFarmFamily._dependencies,
          allTransitiveDependencies:
              AuditLogsByFarmFamily._allTransitiveDependencies,
          farmId: farmId,
        );

  AuditLogsByFarmProvider._internal(
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
    Stream<List<AuditLogModel>> Function(AuditLogsByFarmRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AuditLogsByFarmProvider._internal(
        (ref) => create(ref as AuditLogsByFarmRef),
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
  AutoDisposeStreamProviderElement<List<AuditLogModel>> createElement() {
    return _AuditLogsByFarmProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AuditLogsByFarmProvider && other.farmId == farmId;
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
mixin AuditLogsByFarmRef on AutoDisposeStreamProviderRef<List<AuditLogModel>> {
  /// The parameter `farmId` of this provider.
  String get farmId;
}

class _AuditLogsByFarmProviderElement
    extends AutoDisposeStreamProviderElement<List<AuditLogModel>>
    with AuditLogsByFarmRef {
  _AuditLogsByFarmProviderElement(super.provider);

  @override
  String get farmId => (origin as AuditLogsByFarmProvider).farmId;
}

String _$latestAuditLogForFarmHash() =>
    r'21ba8dd9fa8258a3589f0a256f39d47cc1961e4c';

/// Latest audit log for a farm
///
/// Copied from [latestAuditLogForFarm].
@ProviderFor(latestAuditLogForFarm)
const latestAuditLogForFarmProvider = LatestAuditLogForFarmFamily();

/// Latest audit log for a farm
///
/// Copied from [latestAuditLogForFarm].
class LatestAuditLogForFarmFamily extends Family<AsyncValue<AuditLogModel?>> {
  /// Latest audit log for a farm
  ///
  /// Copied from [latestAuditLogForFarm].
  const LatestAuditLogForFarmFamily();

  /// Latest audit log for a farm
  ///
  /// Copied from [latestAuditLogForFarm].
  LatestAuditLogForFarmProvider call(
    String farmId,
  ) {
    return LatestAuditLogForFarmProvider(
      farmId,
    );
  }

  @override
  LatestAuditLogForFarmProvider getProviderOverride(
    covariant LatestAuditLogForFarmProvider provider,
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
  String? get name => r'latestAuditLogForFarmProvider';
}

/// Latest audit log for a farm
///
/// Copied from [latestAuditLogForFarm].
class LatestAuditLogForFarmProvider
    extends AutoDisposeFutureProvider<AuditLogModel?> {
  /// Latest audit log for a farm
  ///
  /// Copied from [latestAuditLogForFarm].
  LatestAuditLogForFarmProvider(
    String farmId,
  ) : this._internal(
          (ref) => latestAuditLogForFarm(
            ref as LatestAuditLogForFarmRef,
            farmId,
          ),
          from: latestAuditLogForFarmProvider,
          name: r'latestAuditLogForFarmProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$latestAuditLogForFarmHash,
          dependencies: LatestAuditLogForFarmFamily._dependencies,
          allTransitiveDependencies:
              LatestAuditLogForFarmFamily._allTransitiveDependencies,
          farmId: farmId,
        );

  LatestAuditLogForFarmProvider._internal(
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
    FutureOr<AuditLogModel?> Function(LatestAuditLogForFarmRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LatestAuditLogForFarmProvider._internal(
        (ref) => create(ref as LatestAuditLogForFarmRef),
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
  AutoDisposeFutureProviderElement<AuditLogModel?> createElement() {
    return _LatestAuditLogForFarmProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LatestAuditLogForFarmProvider && other.farmId == farmId;
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
mixin LatestAuditLogForFarmRef on AutoDisposeFutureProviderRef<AuditLogModel?> {
  /// The parameter `farmId` of this provider.
  String get farmId;
}

class _LatestAuditLogForFarmProviderElement
    extends AutoDisposeFutureProviderElement<AuditLogModel?>
    with LatestAuditLogForFarmRef {
  _LatestAuditLogForFarmProviderElement(super.provider);

  @override
  String get farmId => (origin as LatestAuditLogForFarmProvider).farmId;
}

String _$auditLogsByAdminHash() => r'5bdb3f97cbbe3b5bc47cb56d5e66135014d2f8a7';

/// Audit logs by admin
///
/// Copied from [auditLogsByAdmin].
@ProviderFor(auditLogsByAdmin)
const auditLogsByAdminProvider = AuditLogsByAdminFamily();

/// Audit logs by admin
///
/// Copied from [auditLogsByAdmin].
class AuditLogsByAdminFamily extends Family<AsyncValue<List<AuditLogModel>>> {
  /// Audit logs by admin
  ///
  /// Copied from [auditLogsByAdmin].
  const AuditLogsByAdminFamily();

  /// Audit logs by admin
  ///
  /// Copied from [auditLogsByAdmin].
  AuditLogsByAdminProvider call(
    String adminId,
  ) {
    return AuditLogsByAdminProvider(
      adminId,
    );
  }

  @override
  AuditLogsByAdminProvider getProviderOverride(
    covariant AuditLogsByAdminProvider provider,
  ) {
    return call(
      provider.adminId,
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
  String? get name => r'auditLogsByAdminProvider';
}

/// Audit logs by admin
///
/// Copied from [auditLogsByAdmin].
class AuditLogsByAdminProvider
    extends AutoDisposeStreamProvider<List<AuditLogModel>> {
  /// Audit logs by admin
  ///
  /// Copied from [auditLogsByAdmin].
  AuditLogsByAdminProvider(
    String adminId,
  ) : this._internal(
          (ref) => auditLogsByAdmin(
            ref as AuditLogsByAdminRef,
            adminId,
          ),
          from: auditLogsByAdminProvider,
          name: r'auditLogsByAdminProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$auditLogsByAdminHash,
          dependencies: AuditLogsByAdminFamily._dependencies,
          allTransitiveDependencies:
              AuditLogsByAdminFamily._allTransitiveDependencies,
          adminId: adminId,
        );

  AuditLogsByAdminProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.adminId,
  }) : super.internal();

  final String adminId;

  @override
  Override overrideWith(
    Stream<List<AuditLogModel>> Function(AuditLogsByAdminRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AuditLogsByAdminProvider._internal(
        (ref) => create(ref as AuditLogsByAdminRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        adminId: adminId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<AuditLogModel>> createElement() {
    return _AuditLogsByAdminProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AuditLogsByAdminProvider && other.adminId == adminId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, adminId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AuditLogsByAdminRef on AutoDisposeStreamProviderRef<List<AuditLogModel>> {
  /// The parameter `adminId` of this provider.
  String get adminId;
}

class _AuditLogsByAdminProviderElement
    extends AutoDisposeStreamProviderElement<List<AuditLogModel>>
    with AuditLogsByAdminRef {
  _AuditLogsByAdminProviderElement(super.provider);

  @override
  String get adminId => (origin as AuditLogsByAdminProvider).adminId;
}

String _$auditLogsByActionHash() => r'2e7f221e3ce3b02e52e5803af154b69b2b91222a';

/// Audit logs by action type
///
/// Copied from [auditLogsByAction].
@ProviderFor(auditLogsByAction)
const auditLogsByActionProvider = AuditLogsByActionFamily();

/// Audit logs by action type
///
/// Copied from [auditLogsByAction].
class AuditLogsByActionFamily extends Family<AsyncValue<List<AuditLogModel>>> {
  /// Audit logs by action type
  ///
  /// Copied from [auditLogsByAction].
  const AuditLogsByActionFamily();

  /// Audit logs by action type
  ///
  /// Copied from [auditLogsByAction].
  AuditLogsByActionProvider call(
    AuditAction action,
  ) {
    return AuditLogsByActionProvider(
      action,
    );
  }

  @override
  AuditLogsByActionProvider getProviderOverride(
    covariant AuditLogsByActionProvider provider,
  ) {
    return call(
      provider.action,
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
  String? get name => r'auditLogsByActionProvider';
}

/// Audit logs by action type
///
/// Copied from [auditLogsByAction].
class AuditLogsByActionProvider
    extends AutoDisposeStreamProvider<List<AuditLogModel>> {
  /// Audit logs by action type
  ///
  /// Copied from [auditLogsByAction].
  AuditLogsByActionProvider(
    AuditAction action,
  ) : this._internal(
          (ref) => auditLogsByAction(
            ref as AuditLogsByActionRef,
            action,
          ),
          from: auditLogsByActionProvider,
          name: r'auditLogsByActionProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$auditLogsByActionHash,
          dependencies: AuditLogsByActionFamily._dependencies,
          allTransitiveDependencies:
              AuditLogsByActionFamily._allTransitiveDependencies,
          action: action,
        );

  AuditLogsByActionProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.action,
  }) : super.internal();

  final AuditAction action;

  @override
  Override overrideWith(
    Stream<List<AuditLogModel>> Function(AuditLogsByActionRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AuditLogsByActionProvider._internal(
        (ref) => create(ref as AuditLogsByActionRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        action: action,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<AuditLogModel>> createElement() {
    return _AuditLogsByActionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AuditLogsByActionProvider && other.action == action;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, action.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AuditLogsByActionRef
    on AutoDisposeStreamProviderRef<List<AuditLogModel>> {
  /// The parameter `action` of this provider.
  AuditAction get action;
}

class _AuditLogsByActionProviderElement
    extends AutoDisposeStreamProviderElement<List<AuditLogModel>>
    with AuditLogsByActionRef {
  _AuditLogsByActionProviderElement(super.provider);

  @override
  AuditAction get action => (origin as AuditLogsByActionProvider).action;
}

String _$approvalLogsHash() => r'e2bfe771acba1c5b8ab0dc9d23b3926fdc5ddbb1';

/// Approval logs
///
/// Copied from [approvalLogs].
@ProviderFor(approvalLogs)
final approvalLogsProvider =
    AutoDisposeStreamProvider<List<AuditLogModel>>.internal(
  approvalLogs,
  name: r'approvalLogsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$approvalLogsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ApprovalLogsRef = AutoDisposeStreamProviderRef<List<AuditLogModel>>;
String _$rejectionLogsHash() => r'df54619df2f7e95ac25e6a7e5de50b7d9796df58';

/// Rejection logs
///
/// Copied from [rejectionLogs].
@ProviderFor(rejectionLogs)
final rejectionLogsProvider =
    AutoDisposeStreamProvider<List<AuditLogModel>>.internal(
  rejectionLogs,
  name: r'rejectionLogsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$rejectionLogsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RejectionLogsRef = AutoDisposeStreamProviderRef<List<AuditLogModel>>;
String _$inspectionLogsHash() => r'bf9c68f495945fee45bcf16d9dd693017b735a44';

/// Inspection logs
///
/// Copied from [inspectionLogs].
@ProviderFor(inspectionLogs)
final inspectionLogsProvider =
    AutoDisposeStreamProvider<List<AuditLogModel>>.internal(
  inspectionLogs,
  name: r'inspectionLogsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$inspectionLogsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef InspectionLogsRef = AutoDisposeStreamProviderRef<List<AuditLogModel>>;
String _$totalAuditLogsCountHash() =>
    r'a20d61d3e89477a894063a90305c3e50d54c0b52';

/// Total audit logs count
///
/// Copied from [totalAuditLogsCount].
@ProviderFor(totalAuditLogsCount)
final totalAuditLogsCountProvider = AutoDisposeFutureProvider<int>.internal(
  totalAuditLogsCount,
  name: r'totalAuditLogsCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$totalAuditLogsCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TotalAuditLogsCountRef = AutoDisposeFutureProviderRef<int>;
String _$auditLogsCountByActionHash() =>
    r'559e5764010dca1bef75b937fdefb0064edf5964';

/// Audit logs count by action
///
/// Copied from [auditLogsCountByAction].
@ProviderFor(auditLogsCountByAction)
const auditLogsCountByActionProvider = AuditLogsCountByActionFamily();

/// Audit logs count by action
///
/// Copied from [auditLogsCountByAction].
class AuditLogsCountByActionFamily extends Family<AsyncValue<int>> {
  /// Audit logs count by action
  ///
  /// Copied from [auditLogsCountByAction].
  const AuditLogsCountByActionFamily();

  /// Audit logs count by action
  ///
  /// Copied from [auditLogsCountByAction].
  AuditLogsCountByActionProvider call(
    AuditAction action,
  ) {
    return AuditLogsCountByActionProvider(
      action,
    );
  }

  @override
  AuditLogsCountByActionProvider getProviderOverride(
    covariant AuditLogsCountByActionProvider provider,
  ) {
    return call(
      provider.action,
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
  String? get name => r'auditLogsCountByActionProvider';
}

/// Audit logs count by action
///
/// Copied from [auditLogsCountByAction].
class AuditLogsCountByActionProvider extends AutoDisposeFutureProvider<int> {
  /// Audit logs count by action
  ///
  /// Copied from [auditLogsCountByAction].
  AuditLogsCountByActionProvider(
    AuditAction action,
  ) : this._internal(
          (ref) => auditLogsCountByAction(
            ref as AuditLogsCountByActionRef,
            action,
          ),
          from: auditLogsCountByActionProvider,
          name: r'auditLogsCountByActionProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$auditLogsCountByActionHash,
          dependencies: AuditLogsCountByActionFamily._dependencies,
          allTransitiveDependencies:
              AuditLogsCountByActionFamily._allTransitiveDependencies,
          action: action,
        );

  AuditLogsCountByActionProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.action,
  }) : super.internal();

  final AuditAction action;

  @override
  Override overrideWith(
    FutureOr<int> Function(AuditLogsCountByActionRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AuditLogsCountByActionProvider._internal(
        (ref) => create(ref as AuditLogsCountByActionRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        action: action,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<int> createElement() {
    return _AuditLogsCountByActionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AuditLogsCountByActionProvider && other.action == action;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, action.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AuditLogsCountByActionRef on AutoDisposeFutureProviderRef<int> {
  /// The parameter `action` of this provider.
  AuditAction get action;
}

class _AuditLogsCountByActionProviderElement
    extends AutoDisposeFutureProviderElement<int>
    with AuditLogsCountByActionRef {
  _AuditLogsCountByActionProviderElement(super.provider);

  @override
  AuditAction get action => (origin as AuditLogsCountByActionProvider).action;
}

String _$auditLogsCountForDaysHash() =>
    r'61c03ec490a23d9030cc70d1320bec13f6074735';

/// Audit logs count for last N days
///
/// Copied from [auditLogsCountForDays].
@ProviderFor(auditLogsCountForDays)
const auditLogsCountForDaysProvider = AuditLogsCountForDaysFamily();

/// Audit logs count for last N days
///
/// Copied from [auditLogsCountForDays].
class AuditLogsCountForDaysFamily extends Family<AsyncValue<int>> {
  /// Audit logs count for last N days
  ///
  /// Copied from [auditLogsCountForDays].
  const AuditLogsCountForDaysFamily();

  /// Audit logs count for last N days
  ///
  /// Copied from [auditLogsCountForDays].
  AuditLogsCountForDaysProvider call(
    int days,
  ) {
    return AuditLogsCountForDaysProvider(
      days,
    );
  }

  @override
  AuditLogsCountForDaysProvider getProviderOverride(
    covariant AuditLogsCountForDaysProvider provider,
  ) {
    return call(
      provider.days,
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
  String? get name => r'auditLogsCountForDaysProvider';
}

/// Audit logs count for last N days
///
/// Copied from [auditLogsCountForDays].
class AuditLogsCountForDaysProvider extends AutoDisposeFutureProvider<int> {
  /// Audit logs count for last N days
  ///
  /// Copied from [auditLogsCountForDays].
  AuditLogsCountForDaysProvider(
    int days,
  ) : this._internal(
          (ref) => auditLogsCountForDays(
            ref as AuditLogsCountForDaysRef,
            days,
          ),
          from: auditLogsCountForDaysProvider,
          name: r'auditLogsCountForDaysProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$auditLogsCountForDaysHash,
          dependencies: AuditLogsCountForDaysFamily._dependencies,
          allTransitiveDependencies:
              AuditLogsCountForDaysFamily._allTransitiveDependencies,
          days: days,
        );

  AuditLogsCountForDaysProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.days,
  }) : super.internal();

  final int days;

  @override
  Override overrideWith(
    FutureOr<int> Function(AuditLogsCountForDaysRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AuditLogsCountForDaysProvider._internal(
        (ref) => create(ref as AuditLogsCountForDaysRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        days: days,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<int> createElement() {
    return _AuditLogsCountForDaysProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AuditLogsCountForDaysProvider && other.days == days;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, days.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AuditLogsCountForDaysRef on AutoDisposeFutureProviderRef<int> {
  /// The parameter `days` of this provider.
  int get days;
}

class _AuditLogsCountForDaysProviderElement
    extends AutoDisposeFutureProviderElement<int>
    with AuditLogsCountForDaysRef {
  _AuditLogsCountForDaysProviderElement(super.provider);

  @override
  int get days => (origin as AuditLogsCountForDaysProvider).days;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
