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

  static const String customerNew = '/customers/add';
  static const String customerDetails = '/customers/:id';
  static const String customerEdit = '/customers/:id/edit';

  static const String invoiceCreate = '/invoices/create';
  static const String invoiceDetails = '/invoices/:id';

  static String customerDetailsPath(String id) => '/customers/$id';
  static String customerEditPath(String id) => '/customers/$id/edit';
  static String productDetailsPath(String id) => '/products/$id';
  static String invoiceDetailsPath(String id) => '/invoices/$id';

  static const List<String> shellRoutes = [
    dashboard,
    products,
    customers,
    invoices,
    settings,
  ];
}
