class ApiConstants {
  static const String baseUrl = 'https://coffee-backend.caravanlabs.ru';
  static const String products = '/products';
  static const String categories = '/categories';
  static const String orders = '/orders';

  static const int connectTimeout = 10000;
  static const int receiveTimeout = 10000;
  static const int maxRetries = 3;
  static const int retryDelayMs = 1000;
}