class AppConstants {
  AppConstants._();

  /// Sent to get_my_outstanding_summary. An installment becomes overdue only
  /// after this many days past its due date. Single source of truth for the app.
  static const int overdueGraceDays = 7;

  static const String companyName = 'Global Housing & Real Estate (Private) Limited';
  static const String salesHotlineRaw = '+94768787878';
  static const String salesHotlineDisplay = '+94 768 78 78 78';
  static const String contactEmail = 'info@globalgrouplk.com';
  static const String address =
      'No 52, Sir Marcus Fernando Mawatha, Colombo 07, Sri Lanka';

  static const String websiteUrl = 'https://www.globalhousing.lk';
  static const String termsUrl =
      'https://www.globalhousing.lk/legal/terms-and-conditions';
  static const String privacyUrl =
      'https://www.globalhousing.lk/legal/privacy-policy';

  static const String facebookUrl = 'https://web.facebook.com/ghrglobal';
  static const String instagramUrl = 'https://www.instagram.com/ghrglobal/';
  static const String linkedinUrl = 'https://www.linkedin.com/company/ghrglobal';
  static const String youtubeUrl = 'https://www.youtube.com/@ghrglobal';
}