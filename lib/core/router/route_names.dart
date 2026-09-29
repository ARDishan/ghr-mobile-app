class RouteNames {
  RouteNames._();

  static const String splash = '/';
  static const String phoneEntry = '/phone-entry';
  static const String otpVerification = '/otp-verification';
  static const String home = '/home';

  static const String projects = '/projects';
  static const String projectDetailPattern = '/projects/:id';
  static String projectDetail(String id) => '/projects/$id';
}