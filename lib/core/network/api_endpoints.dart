/// Base URL and paths for the DummyJSON REST API.
abstract final class ApiEndpoints {
  static const String baseUrl = 'https://dummyjson.com';

  // Auth
  static const String login = '/auth/login';
  static const String me = '/auth/me';
  static const String refresh = '/auth/refresh';

  // Products
  static const String products = '/products';
  static const String productSearch = '/products/search';
  static const String categories = '/products/categories';
  static String product(int id) => '/products/$id';
  static String productsByCategory(String slug) => '/products/category/$slug';

  // Carts
  static const String addCart = '/carts/add';
}
