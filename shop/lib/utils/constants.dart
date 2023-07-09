class Contants {
  static String productBaseUrl =
      '${const String.fromEnvironment('FIREBASE_URL')}/products';
  static String orderBaseUrl =
      '${const String.fromEnvironment('FIREBASE_URL')}/orders';
  static String userFavoriteUrl =
      '${const String.fromEnvironment('FIREBASE_URL')}/userFavorites';
  static String apiKey = const String.fromEnvironment('API_KEY');
}
