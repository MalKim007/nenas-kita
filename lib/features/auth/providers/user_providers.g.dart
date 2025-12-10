// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userRepositoryHash() => r'775f0a0cbfe43fcc5b0fbeec8ecf75a7b4fd0859';

/// User repository provider
///
/// Copied from [userRepository].
@ProviderFor(userRepository)
final userRepositoryProvider = Provider<UserRepository>.internal(
  userRepository,
  name: r'userRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserRepositoryRef = ProviderRef<UserRepository>;
String _$currentAppUserHash() => r'f338c463ed97d879ed563ebcc28a9ea4617490ac';

/// Current app user (from Firestore, not Firebase Auth)
///
/// Copied from [currentAppUser].
@ProviderFor(currentAppUser)
final currentAppUserProvider = AutoDisposeStreamProvider<UserModel?>.internal(
  currentAppUser,
  name: r'currentAppUserProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentAppUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentAppUserRef = AutoDisposeStreamProviderRef<UserModel?>;
String _$currentUserRoleHash() => r'5917480bb66ca9ea6a127d1b6aa5954e783502ae';

/// Current user role
///
/// Copied from [currentUserRole].
@ProviderFor(currentUserRole)
final currentUserRoleProvider = AutoDisposeProvider<UserRole?>.internal(
  currentUserRole,
  name: r'currentUserRoleProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentUserRoleHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentUserRoleRef = AutoDisposeProviderRef<UserRole?>;
String _$isCurrentUserAdminHash() =>
    r'8491c77cf7891fdf339ad79402de57115e68f0ae';

/// Is current user admin
///
/// Copied from [isCurrentUserAdmin].
@ProviderFor(isCurrentUserAdmin)
final isCurrentUserAdminProvider = AutoDisposeProvider<bool>.internal(
  isCurrentUserAdmin,
  name: r'isCurrentUserAdminProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isCurrentUserAdminHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsCurrentUserAdminRef = AutoDisposeProviderRef<bool>;
String _$isCurrentUserFarmerHash() =>
    r'aa16a6cc35081980f24541d5188cdd681b6fd09b';

/// Is current user farmer
///
/// Copied from [isCurrentUserFarmer].
@ProviderFor(isCurrentUserFarmer)
final isCurrentUserFarmerProvider = AutoDisposeProvider<bool>.internal(
  isCurrentUserFarmer,
  name: r'isCurrentUserFarmerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isCurrentUserFarmerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsCurrentUserFarmerRef = AutoDisposeProviderRef<bool>;
String _$isCurrentUserBuyerHash() =>
    r'4ad7a91390ac73506513714bf16ce3c3a6005b79';

/// Is current user buyer
///
/// Copied from [isCurrentUserBuyer].
@ProviderFor(isCurrentUserBuyer)
final isCurrentUserBuyerProvider = AutoDisposeProvider<bool>.internal(
  isCurrentUserBuyer,
  name: r'isCurrentUserBuyerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isCurrentUserBuyerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsCurrentUserBuyerRef = AutoDisposeProviderRef<bool>;
String _$isCurrentUserWholesalerHash() =>
    r'97f9d8766a5cb2a6c42b9c9338c053961d7d07d4';

/// Is current user wholesaler
///
/// Copied from [isCurrentUserWholesaler].
@ProviderFor(isCurrentUserWholesaler)
final isCurrentUserWholesalerProvider = AutoDisposeProvider<bool>.internal(
  isCurrentUserWholesaler,
  name: r'isCurrentUserWholesalerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isCurrentUserWholesalerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsCurrentUserWholesalerRef = AutoDisposeProviderRef<bool>;
String _$canViewWholesalePricesHash() =>
    r'd12807e737864d1559c1aed278f94ee45f0e8ddd';

/// Can current user view wholesale prices
///
/// Copied from [canViewWholesalePrices].
@ProviderFor(canViewWholesalePrices)
final canViewWholesalePricesProvider = AutoDisposeProvider<bool>.internal(
  canViewWholesalePrices,
  name: r'canViewWholesalePricesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$canViewWholesalePricesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CanViewWholesalePricesRef = AutoDisposeProviderRef<bool>;
String _$userByIdHash() => r'3252dec57c1f25a9357d8b08ee7eac1f530f6ae6';

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

/// Get user by ID
///
/// Copied from [userById].
@ProviderFor(userById)
const userByIdProvider = UserByIdFamily();

/// Get user by ID
///
/// Copied from [userById].
class UserByIdFamily extends Family<AsyncValue<UserModel?>> {
  /// Get user by ID
  ///
  /// Copied from [userById].
  const UserByIdFamily();

  /// Get user by ID
  ///
  /// Copied from [userById].
  UserByIdProvider call(
    String userId,
  ) {
    return UserByIdProvider(
      userId,
    );
  }

  @override
  UserByIdProvider getProviderOverride(
    covariant UserByIdProvider provider,
  ) {
    return call(
      provider.userId,
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
  String? get name => r'userByIdProvider';
}

/// Get user by ID
///
/// Copied from [userById].
class UserByIdProvider extends AutoDisposeStreamProvider<UserModel?> {
  /// Get user by ID
  ///
  /// Copied from [userById].
  UserByIdProvider(
    String userId,
  ) : this._internal(
          (ref) => userById(
            ref as UserByIdRef,
            userId,
          ),
          from: userByIdProvider,
          name: r'userByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userByIdHash,
          dependencies: UserByIdFamily._dependencies,
          allTransitiveDependencies: UserByIdFamily._allTransitiveDependencies,
          userId: userId,
        );

  UserByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    Stream<UserModel?> Function(UserByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserByIdProvider._internal(
        (ref) => create(ref as UserByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<UserModel?> createElement() {
    return _UserByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserByIdProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserByIdRef on AutoDisposeStreamProviderRef<UserModel?> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserByIdProviderElement
    extends AutoDisposeStreamProviderElement<UserModel?> with UserByIdRef {
  _UserByIdProviderElement(super.provider);

  @override
  String get userId => (origin as UserByIdProvider).userId;
}

String _$allUsersHash() => r'2b907f16ddd45a57c3d734ad12ba0a6c6ea7b220';

/// All users stream
///
/// Copied from [allUsers].
@ProviderFor(allUsers)
final allUsersProvider = AutoDisposeStreamProvider<List<UserModel>>.internal(
  allUsers,
  name: r'allUsersProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$allUsersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllUsersRef = AutoDisposeStreamProviderRef<List<UserModel>>;
String _$usersByRoleHash() => r'9e22008a96c03277732cd1bcf950b878066893aa';

/// Users by role
///
/// Copied from [usersByRole].
@ProviderFor(usersByRole)
const usersByRoleProvider = UsersByRoleFamily();

/// Users by role
///
/// Copied from [usersByRole].
class UsersByRoleFamily extends Family<AsyncValue<List<UserModel>>> {
  /// Users by role
  ///
  /// Copied from [usersByRole].
  const UsersByRoleFamily();

  /// Users by role
  ///
  /// Copied from [usersByRole].
  UsersByRoleProvider call(
    UserRole role,
  ) {
    return UsersByRoleProvider(
      role,
    );
  }

  @override
  UsersByRoleProvider getProviderOverride(
    covariant UsersByRoleProvider provider,
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
  String? get name => r'usersByRoleProvider';
}

/// Users by role
///
/// Copied from [usersByRole].
class UsersByRoleProvider extends AutoDisposeStreamProvider<List<UserModel>> {
  /// Users by role
  ///
  /// Copied from [usersByRole].
  UsersByRoleProvider(
    UserRole role,
  ) : this._internal(
          (ref) => usersByRole(
            ref as UsersByRoleRef,
            role,
          ),
          from: usersByRoleProvider,
          name: r'usersByRoleProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$usersByRoleHash,
          dependencies: UsersByRoleFamily._dependencies,
          allTransitiveDependencies:
              UsersByRoleFamily._allTransitiveDependencies,
          role: role,
        );

  UsersByRoleProvider._internal(
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
    Stream<List<UserModel>> Function(UsersByRoleRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UsersByRoleProvider._internal(
        (ref) => create(ref as UsersByRoleRef),
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
  AutoDisposeStreamProviderElement<List<UserModel>> createElement() {
    return _UsersByRoleProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UsersByRoleProvider && other.role == role;
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
mixin UsersByRoleRef on AutoDisposeStreamProviderRef<List<UserModel>> {
  /// The parameter `role` of this provider.
  UserRole get role;
}

class _UsersByRoleProviderElement
    extends AutoDisposeStreamProviderElement<List<UserModel>>
    with UsersByRoleRef {
  _UsersByRoleProviderElement(super.provider);

  @override
  UserRole get role => (origin as UsersByRoleProvider).role;
}

String _$usersByDistrictHash() => r'3cb0d08b0070ca49fe121fb4b8ce7c1c6a48baf4';

/// Users by district
///
/// Copied from [usersByDistrict].
@ProviderFor(usersByDistrict)
const usersByDistrictProvider = UsersByDistrictFamily();

/// Users by district
///
/// Copied from [usersByDistrict].
class UsersByDistrictFamily extends Family<AsyncValue<List<UserModel>>> {
  /// Users by district
  ///
  /// Copied from [usersByDistrict].
  const UsersByDistrictFamily();

  /// Users by district
  ///
  /// Copied from [usersByDistrict].
  UsersByDistrictProvider call(
    String district,
  ) {
    return UsersByDistrictProvider(
      district,
    );
  }

  @override
  UsersByDistrictProvider getProviderOverride(
    covariant UsersByDistrictProvider provider,
  ) {
    return call(
      provider.district,
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
  String? get name => r'usersByDistrictProvider';
}

/// Users by district
///
/// Copied from [usersByDistrict].
class UsersByDistrictProvider
    extends AutoDisposeStreamProvider<List<UserModel>> {
  /// Users by district
  ///
  /// Copied from [usersByDistrict].
  UsersByDistrictProvider(
    String district,
  ) : this._internal(
          (ref) => usersByDistrict(
            ref as UsersByDistrictRef,
            district,
          ),
          from: usersByDistrictProvider,
          name: r'usersByDistrictProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$usersByDistrictHash,
          dependencies: UsersByDistrictFamily._dependencies,
          allTransitiveDependencies:
              UsersByDistrictFamily._allTransitiveDependencies,
          district: district,
        );

  UsersByDistrictProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.district,
  }) : super.internal();

  final String district;

  @override
  Override overrideWith(
    Stream<List<UserModel>> Function(UsersByDistrictRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UsersByDistrictProvider._internal(
        (ref) => create(ref as UsersByDistrictRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        district: district,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<UserModel>> createElement() {
    return _UsersByDistrictProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UsersByDistrictProvider && other.district == district;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, district.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UsersByDistrictRef on AutoDisposeStreamProviderRef<List<UserModel>> {
  /// The parameter `district` of this provider.
  String get district;
}

class _UsersByDistrictProviderElement
    extends AutoDisposeStreamProviderElement<List<UserModel>>
    with UsersByDistrictRef {
  _UsersByDistrictProviderElement(super.provider);

  @override
  String get district => (origin as UsersByDistrictProvider).district;
}

String _$allFarmersHash() => r'9555cca54cc52dc1c8aa4cff440466f4ebe4b8c7';

/// All farmers
///
/// Copied from [allFarmers].
@ProviderFor(allFarmers)
final allFarmersProvider = AutoDisposeStreamProvider<List<UserModel>>.internal(
  allFarmers,
  name: r'allFarmersProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$allFarmersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllFarmersRef = AutoDisposeStreamProviderRef<List<UserModel>>;
String _$allBuyersHash() => r'469b6a654115ed994c325267df764848c0640848';

/// All buyers (including wholesalers)
///
/// Copied from [allBuyers].
@ProviderFor(allBuyers)
final allBuyersProvider = AutoDisposeStreamProvider<List<UserModel>>.internal(
  allBuyers,
  name: r'allBuyersProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$allBuyersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllBuyersRef = AutoDisposeStreamProviderRef<List<UserModel>>;
String _$userCountByRoleHash() => r'08165c6be89b59dbe12d9cb60c7dfddb0c8efc76';

/// User count by role
///
/// Copied from [userCountByRole].
@ProviderFor(userCountByRole)
const userCountByRoleProvider = UserCountByRoleFamily();

/// User count by role
///
/// Copied from [userCountByRole].
class UserCountByRoleFamily extends Family<AsyncValue<int>> {
  /// User count by role
  ///
  /// Copied from [userCountByRole].
  const UserCountByRoleFamily();

  /// User count by role
  ///
  /// Copied from [userCountByRole].
  UserCountByRoleProvider call(
    UserRole role,
  ) {
    return UserCountByRoleProvider(
      role,
    );
  }

  @override
  UserCountByRoleProvider getProviderOverride(
    covariant UserCountByRoleProvider provider,
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
  String? get name => r'userCountByRoleProvider';
}

/// User count by role
///
/// Copied from [userCountByRole].
class UserCountByRoleProvider extends AutoDisposeFutureProvider<int> {
  /// User count by role
  ///
  /// Copied from [userCountByRole].
  UserCountByRoleProvider(
    UserRole role,
  ) : this._internal(
          (ref) => userCountByRole(
            ref as UserCountByRoleRef,
            role,
          ),
          from: userCountByRoleProvider,
          name: r'userCountByRoleProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userCountByRoleHash,
          dependencies: UserCountByRoleFamily._dependencies,
          allTransitiveDependencies:
              UserCountByRoleFamily._allTransitiveDependencies,
          role: role,
        );

  UserCountByRoleProvider._internal(
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
    FutureOr<int> Function(UserCountByRoleRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserCountByRoleProvider._internal(
        (ref) => create(ref as UserCountByRoleRef),
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
  AutoDisposeFutureProviderElement<int> createElement() {
    return _UserCountByRoleProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserCountByRoleProvider && other.role == role;
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
mixin UserCountByRoleRef on AutoDisposeFutureProviderRef<int> {
  /// The parameter `role` of this provider.
  UserRole get role;
}

class _UserCountByRoleProviderElement
    extends AutoDisposeFutureProviderElement<int> with UserCountByRoleRef {
  _UserCountByRoleProviderElement(super.provider);

  @override
  UserRole get role => (origin as UserCountByRoleProvider).role;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
