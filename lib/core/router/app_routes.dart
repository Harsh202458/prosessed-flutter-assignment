/// Route paths, kept apart from the router so pages can link to them
/// without importing every page.
abstract final class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String products = '/products';
  static const String cart = '/cart';
  static const String orderConfirmation = '/order-confirmation';
  static const String profile = '/profile';

  static String productDetails(int id) => '$products/$id';
}
