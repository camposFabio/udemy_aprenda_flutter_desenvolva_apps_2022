class Contants {
  static String productBaseUrl =
      '${const String.fromEnvironment('FIREBASE_URL')}/products';
  static String orderBaseUrl =
      '${const String.fromEnvironment('FIREBASE_URL')}/orders';
}
