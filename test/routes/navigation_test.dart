import 'package:flutter_test/flutter_test.dart';
import 'package:stockflow/core/constants/app_routes.dart';

void main() {
  group('App Routes', () {
    test('all shell routes are valid', () {
      expect(AppRoutes.shellRoutes.length, 5);
      expect(AppRoutes.shellRoutes[0], AppRoutes.dashboard);
      expect(AppRoutes.shellRoutes[1], AppRoutes.products);
      expect(AppRoutes.shellRoutes[2], AppRoutes.customers);
      expect(AppRoutes.shellRoutes[3], AppRoutes.invoices);
      expect(AppRoutes.shellRoutes[4], AppRoutes.settings);
    });

    test('path helpers generate correct paths', () {
      expect(AppRoutes.customerDetailsPath('123'), '/customers/123');
      expect(AppRoutes.customerEditPath('123'), '/customers/123/edit');
      expect(AppRoutes.customerAddPaymentPath('123'), '/customers/123/payment');
      expect(AppRoutes.customerInvoicesPath('123'), '/customers/123/invoices');
      expect(AppRoutes.productDetailsPath('123'), '/products/123');
      expect(AppRoutes.invoiceDetailsPath('123'), '/invoices/123');
    });

    test('auth routes are defined', () {
      expect(AppRoutes.splash, '/splash');
      expect(AppRoutes.login, '/login');
      expect(AppRoutes.register, '/register');
      expect(AppRoutes.companySelect, '/company-select');
      expect(AppRoutes.companyCreate, '/company-create');
    });

    test('onboarding routes are defined', () {
      expect(AppRoutes.welcome, '/welcome');
      expect(AppRoutes.welcomeCreate, '/welcome/create');
      expect(AppRoutes.welcomeJoin, '/welcome/join');
      expect(AppRoutes.welcomePending, '/welcome/pending');
    });

    test('business routes are defined', () {
      expect(AppRoutes.dashboard, '/dashboard');
      expect(AppRoutes.products, '/products');
      expect(AppRoutes.customers, '/customers');
      expect(AppRoutes.invoices, '/invoices');
      expect(AppRoutes.settings, '/settings');
    });
  });
}
