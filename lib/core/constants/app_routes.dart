class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String products = '/products';
  static const String customers = '/customers';
  static const String invoices = '/invoices';
  static const String settings = '/settings';

  static const String productNew = '/products/new';
  static const String productDetails = '/products/:id';
  static const String productEdit = '/products/:id/edit';

  static const List<String> shellRoutes = [
    dashboard,
    products,
    customers,
    invoices,
    settings,
  ];
}
