class AppConstants {

  static const String apiBaseUrl = 'https://jsonplaceholder.typicode.com';
  static const int apiTimeout = 30;
  
  static const String postsBoxName = 'posts_cache';
  static const String userBoxName = 'user_data';
  
  static const int postsPerPage = 10;
  
  static const int otpLength = 4;
  static const String mockOtp = '1234';
  
  static const int mobileNumberLength = 10;
  static const int minPasswordLength = 6;
  
  static const String offlineMessage = 'You are offline. Showing cached data.';
  static const String noInternetMessage = 'No internet connection. Please check your network.';
  static const String errorMessage = 'Something went wrong. Please try again.';
  static const String noCacheMessage = 'No cached data available.';
}