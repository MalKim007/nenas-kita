// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$announcementRepositoryHash() =>
    r'92414c28cdac1abf8c4ddf091a76c2bad9d007a5';

/// Announcement repository provider
///
/// Copied from [announcementRepository].
@ProviderFor(announcementRepository)
final announcementRepositoryProvider =
    Provider<AnnouncementRepository>.internal(
  announcementRepository,
  name: r'announcementRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$announcementRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AnnouncementRepositoryRef = ProviderRef<AnnouncementRepository>;
String _$announcementByIdHash() => r'd00b8fb7582659e5c96498be1d032ee47bc3826b';

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

/// Get announcement by ID
///
/// Copied from [announcementById].
@ProviderFor(announcementById)
const announcementByIdProvider = AnnouncementByIdFamily();

/// Get announcement by ID
///
/// Copied from [announcementById].
class AnnouncementByIdFamily extends Family<AsyncValue<AnnouncementModel?>> {
  /// Get announcement by ID
  ///
  /// Copied from [announcementById].
  const AnnouncementByIdFamily();

  /// Get announcement by ID
  ///
  /// Copied from [announcementById].
  AnnouncementByIdProvider call(
    String announcementId,
  ) {
    return AnnouncementByIdProvider(
      announcementId,
    );
  }

  @override
  AnnouncementByIdProvider getProviderOverride(
    covariant AnnouncementByIdProvider provider,
  ) {
    return call(
      provider.announcementId,
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
  String? get name => r'announcementByIdProvider';
}

/// Get announcement by ID
///
/// Copied from [announcementById].
class AnnouncementByIdProvider
    extends AutoDisposeStreamProvider<AnnouncementModel?> {
  /// Get announcement by ID
  ///
  /// Copied from [announcementById].
  AnnouncementByIdProvider(
    String announcementId,
  ) : this._internal(
          (ref) => announcementById(
            ref as AnnouncementByIdRef,
            announcementId,
          ),
          from: announcementByIdProvider,
          name: r'announcementByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$announcementByIdHash,
          dependencies: AnnouncementByIdFamily._dependencies,
          allTransitiveDependencies:
              AnnouncementByIdFamily._allTransitiveDependencies,
          announcementId: announcementId,
        );

  AnnouncementByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.announcementId,
  }) : super.internal();

  final String announcementId;

  @override
  Override overrideWith(
    Stream<AnnouncementModel?> Function(AnnouncementByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AnnouncementByIdProvider._internal(
        (ref) => create(ref as AnnouncementByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        announcementId: announcementId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<AnnouncementModel?> createElement() {
    return _AnnouncementByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AnnouncementByIdProvider &&
        other.announcementId == announcementId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, announcementId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AnnouncementByIdRef on AutoDisposeStreamProviderRef<AnnouncementModel?> {
  /// The parameter `announcementId` of this provider.
  String get announcementId;
}

class _AnnouncementByIdProviderElement
    extends AutoDisposeStreamProviderElement<AnnouncementModel?>
    with AnnouncementByIdRef {
  _AnnouncementByIdProviderElement(super.provider);

  @override
  String get announcementId =>
      (origin as AnnouncementByIdProvider).announcementId;
}

String _$activeAnnouncementsHash() =>
    r'801231a94319e7b6d2402cc4640d64fb093a33b8';

/// All active announcements
///
/// Copied from [activeAnnouncements].
@ProviderFor(activeAnnouncements)
final activeAnnouncementsProvider =
    AutoDisposeStreamProvider<List<AnnouncementModel>>.internal(
  activeAnnouncements,
  name: r'activeAnnouncementsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$activeAnnouncementsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveAnnouncementsRef
    = AutoDisposeStreamProviderRef<List<AnnouncementModel>>;
String _$myAnnouncementsHash() => r'b519a6aca5f3e8ac959bb842a5cb08a27d4abe85';

/// Active announcements for current user's role
///
/// Copied from [myAnnouncements].
@ProviderFor(myAnnouncements)
final myAnnouncementsProvider =
    AutoDisposeStreamProvider<List<AnnouncementModel>>.internal(
  myAnnouncements,
  name: r'myAnnouncementsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$myAnnouncementsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MyAnnouncementsRef
    = AutoDisposeStreamProviderRef<List<AnnouncementModel>>;
String _$announcementsForRoleHash() =>
    r'a04e51f811f33eb4098d407944e3ed43baf726ce';

/// Announcements for a specific role
///
/// Copied from [announcementsForRole].
@ProviderFor(announcementsForRole)
const announcementsForRoleProvider = AnnouncementsForRoleFamily();

/// Announcements for a specific role
///
/// Copied from [announcementsForRole].
class AnnouncementsForRoleFamily
    extends Family<AsyncValue<List<AnnouncementModel>>> {
  /// Announcements for a specific role
  ///
  /// Copied from [announcementsForRole].
  const AnnouncementsForRoleFamily();

  /// Announcements for a specific role
  ///
  /// Copied from [announcementsForRole].
  AnnouncementsForRoleProvider call(
    UserRole role,
  ) {
    return AnnouncementsForRoleProvider(
      role,
    );
  }

  @override
  AnnouncementsForRoleProvider getProviderOverride(
    covariant AnnouncementsForRoleProvider provider,
  ) {
    return call(
      provider.role,
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
  String? get name => r'announcementsForRoleProvider';
}

/// Announcements for a specific role
///
/// Copied from [announcementsForRole].
class AnnouncementsForRoleProvider
    extends AutoDisposeStreamProvider<List<AnnouncementModel>> {
  /// Announcements for a specific role
  ///
  /// Copied from [announcementsForRole].
  AnnouncementsForRoleProvider(
    UserRole role,
  ) : this._internal(
          (ref) => announcementsForRole(
            ref as AnnouncementsForRoleRef,
            role,
          ),
          from: announcementsForRoleProvider,
          name: r'announcementsForRoleProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$announcementsForRoleHash,
          dependencies: AnnouncementsForRoleFamily._dependencies,
          allTransitiveDependencies:
              AnnouncementsForRoleFamily._allTransitiveDependencies,
          role: role,
        );

  AnnouncementsForRoleProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.role,
  }) : super.internal();

  final UserRole role;

  @override
  Override overrideWith(
    Stream<List<AnnouncementModel>> Function(AnnouncementsForRoleRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AnnouncementsForRoleProvider._internal(
        (ref) => create(ref as AnnouncementsForRoleRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        role: role,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<AnnouncementModel>> createElement() {
    return _AnnouncementsForRoleProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AnnouncementsForRoleProvider && other.role == role;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, role.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AnnouncementsForRoleRef
    on AutoDisposeStreamProviderRef<List<AnnouncementModel>> {
  /// The parameter `role` of this provider.
  UserRole get role;
}

class _AnnouncementsForRoleProviderElement
    extends AutoDisposeStreamProviderElement<List<AnnouncementModel>>
    with AnnouncementsForRoleRef {
  _AnnouncementsForRoleProviderElement(super.provider);

  @override
  UserRole get role => (origin as AnnouncementsForRoleProvider).role;
}

String _$allAnnouncementsHash() => r'201fd8c3246f721decdb195e945a70ecff464b67';

/// All announcements (for admin)
///
/// Copied from [allAnnouncements].
@ProviderFor(allAnnouncements)
final allAnnouncementsProvider =
    AutoDisposeStreamProvider<List<AnnouncementModel>>.internal(
  allAnnouncements,
  name: r'allAnnouncementsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$allAnnouncementsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllAnnouncementsRef
    = AutoDisposeStreamProviderRef<List<AnnouncementModel>>;
String _$activeAnnouncementsCountHash() =>
    r'335a332024a02da3bf833565e1793ce3a88eb36e';

/// Active announcements count
///
/// Copied from [activeAnnouncementsCount].
@ProviderFor(activeAnnouncementsCount)
final activeAnnouncementsCountProvider =
    AutoDisposeFutureProvider<int>.internal(
  activeAnnouncementsCount,
  name: r'activeAnnouncementsCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$activeAnnouncementsCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveAnnouncementsCountRef = AutoDisposeFutureProviderRef<int>;
String _$totalAnnouncementsCountHash() =>
    r'bb63a0dea1806a7bb8bb75792df9846b09e65293';

/// Total announcements count
///
/// Copied from [totalAnnouncementsCount].
@ProviderFor(totalAnnouncementsCount)
final totalAnnouncementsCountProvider = AutoDisposeFutureProvider<int>.internal(
  totalAnnouncementsCount,
  name: r'totalAnnouncementsCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$totalAnnouncementsCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TotalAnnouncementsCountRef = AutoDisposeFutureProviderRef<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
