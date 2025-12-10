/// NenasKita route path constants
class RouteNames {
  RouteNames._();

  // Auth routes
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String profileSetup = '/profile-setup';

  // Farmer routes
  static const String farmerHome = '/farmer';
  static const String farmerFarm = '/farmer/farm';
  static const String farmerFarmSetup = '/farmer/farm/setup';
  static const String farmerFarmEdit = '/farmer/farm/edit';
  static const String farmerProducts = '/farmer/products';
  static const String farmerProductDetail = '/farmer/products/:productId';
  static const String farmerProductAdd = '/farmer/products/add';
  static const String farmerProductEdit = '/farmer/products/:productId/edit';
  static const String farmerPlanner = '/farmer/planner';
  static const String farmerPlannerAdd = '/farmer/planner/add';
  static const String farmerPlannerDetail = '/farmer/planner/:planId';
  static const String farmerPlannerEdit = '/farmer/planner/:planId/edit';
  static const String farmerPlannerCalendar = '/farmer/planner/calendar';
  static const String farmerRequests = '/farmer/requests';
  static const String farmerSettings = '/farmer/settings';

  // Buyer routes
  static const String buyerHome = '/buyer';
  static const String buyerFarmDiscovery = '/buyer/farms';
  static const String buyerMarket = '/buyer/market';
  static const String buyerFarmDetail = '/buyer/farms/:farmId';
  static const String buyerProductDetail = '/buyer/products/:productId';
  static const String buyerProductHistory = '/buyer/products/:productId/history';
  static const String buyerFarmProducts = '/buyer/farms/:farmId/products';
  static const String buyerSettings = '/buyer/settings';

  // Admin routes (web portal)
  static const String adminDashboard = '/admin';
  static const String adminFarmers = '/admin/farmers';
  static const String adminFarmerDetail = '/admin/farmers/:farmerId';
  static const String adminVerifications = '/admin/verifications';
  static const String adminVerificationDetail = '/admin/verifications/:farmId';
  static const String adminAudits = '/admin/audits';
  static const String adminAnnouncements = '/admin/announcements';
  static const String adminSettings = '/admin/settings';

  // Shared routes
  static const String settings = '/settings';
  static const String profileEdit = '/settings/profile';
  static const String notifications = '/settings/notifications';
  static const String about = '/settings/about';
  static const String changePassword = '/settings/change-password';

  // Helper methods for parameterized routes
  static String farmerProductDetailPath(String productId) =>
      '/farmer/products/$productId';

  static String farmerProductEditPath(String productId) =>
      '/farmer/products/$productId/edit';

  static String farmerPlannerDetailPath(String planId) =>
      '/farmer/planner/$planId';

  static String farmerPlannerEditPath(String planId) =>
      '/farmer/planner/$planId/edit';

  static String buyerFarmDetailPath(String farmId) => '/buyer/farms/$farmId';

  static String buyerProductDetailPath(String productId, {required String farmId}) =>
      '/buyer/products/$productId?farmId=$farmId';

  static String buyerProductHistoryPath(String productId, {required String farmId}) =>
      '/buyer/products/$productId/history?farmId=$farmId';

  static String buyerFarmProductsPath(String farmId) => '/buyer/farms/$farmId/products';

  static String adminFarmerDetailPath(String farmerId) =>
      '/admin/farmers/$farmerId';

  static String adminVerificationDetailPath(String farmId) =>
      '/admin/verifications/$farmId';
}
