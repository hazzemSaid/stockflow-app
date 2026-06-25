import 'package:stockflow/core/constants/app_strings.dart';

/// Maps permission keys to their Arabic display labels.
const Map<String, String> permissionLabels = {
  'products.view': AppStrings.permView,
  'products.create': AppStrings.permCreate,
  'products.update': AppStrings.permUpdate,
  'products.delete': AppStrings.permDelete,
  'customers.view': AppStrings.permCustomersView,
  'customers.create': AppStrings.permCustomersCreate,
  'customers.update': AppStrings.permCustomersUpdate,
  'customers.delete': AppStrings.permCustomersDelete,
  'invoices.view': AppStrings.permInvoicesView,
  'invoices.create': AppStrings.permInvoicesCreate,
  'invoices.update': AppStrings.permInvoicesUpdate,
  'invoices.delete': AppStrings.permInvoicesDelete,
  'payments.view': AppStrings.permPaymentsView,
  'payments.create': AppStrings.permPaymentsCreate,
  'payments.update': AppStrings.permPaymentsUpdate,
  'reports.view': AppStrings.permReportsView,
  'reports.export': AppStrings.permExportExcel,
  'roles.manage': AppStrings.permManageTeam,
  'company.manage': AppStrings.permSystemSettings,
  'dashboard.view': AppStrings.permDashboardView,
  'users.manage': AppStrings.permUsersManage,
};

/// Groups permission keys by section for display.
const Map<String, List<String>> permissionSections = {
  AppStrings.sectionProducts: [
    'products.view',
    'products.create',
    'products.update',
    'products.delete',
  ],
  AppStrings.sectionCustomers: [
    'customers.view',
    'customers.create',
    'customers.update',
    'customers.delete',
  ],
  AppStrings.sectionInvoices: [
    'invoices.view',
    'invoices.create',
    'invoices.update',
    'invoices.delete',
  ],
  AppStrings.sectionPayments: [
    'payments.view',
    'payments.create',
    'payments.update',
  ],
  AppStrings.sectionReports: [
    'dashboard.view',
    'reports.view',
    'reports.export',
  ],
  AppStrings.sectionAdmin: [
    'roles.manage',
    'company.manage',
    'users.manage',
  ],
};
