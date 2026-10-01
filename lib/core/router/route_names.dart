class RouteNames {
  RouteNames._();

  static const String splash = '/';
  static const String phoneEntry = '/phone-entry';
  static const String otpVerification = '/otp-verification';

  // Shell tabs
  static const String home = '/home';
  static const String bookmarks = '/bookmarks';
  static const String menu = '/menu';

  static const String projects = '/projects';
  static const String projectDetailPattern = '/projects/:id';
  static String projectDetail(String id) => '/projects/$id';
  static const String units = '/units';

  // Menu pages
  static const String profile = '/profile';
  static const String myUnits = '/my-units';
  static const String myUnitDetail = '/my-units/detail';
  static const String settings = '/settings';
  static const String about = '/about';
  static const String notifications = '/notifications';
}