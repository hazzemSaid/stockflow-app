import 'package:flutter_test/flutter_test.dart';
import 'package:makhzanflow/features/customers/data/models/customer_model.dart';

void main() {
  group('CustomerModel fromJson', () {
    test('parses basic customer fields without invoices or payments', () {
      final json = {
        'id': '123e4567-e89b-12d3-a456-426614174000',
        'name': 'متجر العز',
        'name_official': 'أحمد محمد',
        'phone': '01001234567',
        'address': 'القاهرة',
        'total_debt': 0,
        'image_url': 'https://example.com/image.jpg',
        'created_at': '2026-06-01T10:00:00Z',
      };

      final model = CustomerModel.fromJson(json);

      expect(model.id, '123e4567-e89b-12d3-a456-426614174000');
      expect(model.name, 'متجر العز');
      expect(model.nameOfficial, 'أحمد محمد');
      expect(model.phone, '01001234567');
      expect(model.address, 'القاهرة');
      expect(model.totalDebt, 0);
      expect(model.imageUrl, 'https://example.com/image.jpg');
      expect(model.createdAt, DateTime.utc(2026, 6, 1, 10));
      expect(model.totalPurchases, 0);
      expect(model.totalPaid, 0);
      expect(model.transactions, isEmpty);
    });

    test('computes totalPurchases and totalPaid from invoices and payments', () {
      final json = {
        'id': '123e4567-e89b-12d3-a456-426614174000',
        'name': 'متجر العز',
        'total_debt': 1500,
        'created_at': '2026-06-01T10:00:00Z',
        'invoices': [
          {
            'id': 'inv-001',
            'total_amount': 2000,
            'remaining_amount': 1000,
            'payment_status': 'partial',
            'created_at': '2026-06-10T12:00:00Z',
          },
          {
            'id': 'inv-002',
            'total_amount': 500,
            'remaining_amount': 500,
            'payment_status': 'debt',
            'created_at': '2026-06-15T12:00:00Z',
          },
        ],
        'payments': [
          {
            'id': 'pay-001',
            'amount': 1000,
            'created_at': '2026-06-12T12:00:00Z',
          },
        ],
      };

      final model = CustomerModel.fromJson(json);

      expect(model.totalPurchases, 2500);
      expect(model.totalPaid, 1000);
    });

    test('constructs transactions list sorted descending by date', () {
      final json = {
        'id': '123e4567-e89b-12d3-a456-426614174000',
        'name': 'متجر العز',
        'total_debt': 1500,
        'created_at': '2026-06-01T10:00:00Z',
        'invoices': [
          {
            'id': 'inv-001',
            'total_amount': 2000,
            'remaining_amount': 1000,
            'payment_status': 'partial',
            'created_at': '2026-06-10T12:00:00Z',
          },
        ],
        'payments': [
          {
            'id': 'pay-001',
            'amount': 1000,
            'created_at': '2026-06-12T12:00:00Z',
          },
        ],
      };

      final model = CustomerModel.fromJson(json);

      expect(model.transactions.length, 3);

      expect(model.transactions[0].type, 'payment');
      expect(model.transactions[0].id, 'pay-001');

      expect(model.transactions[1].type, 'invoice');
      expect(model.transactions[1].id, 'inv-001');

      expect(model.transactions[2].type, 'opening_debt');
      expect(model.transactions[2].id, 'opening_debt');
      expect(model.transactions[2].amount, 1500);
      expect(model.transactions[2].title, 'رصيد افتتاحي');
    });

    test('omits opening_debt transaction when total_debt is zero', () {
      final json = {
        'id': '123e4567-e89b-12d3-a456-426614174000',
        'name': 'متجر العز',
        'total_debt': 0,
        'created_at': '2026-06-01T10:00:00Z',
        'invoices': [],
        'payments': [],
      };

      final model = CustomerModel.fromJson(json);

      expect(model.transactions, isEmpty);
    });

    test('sets correct invoice status labels', () {
      final json = {
        'id': 'id',
        'name': 'test',
        'total_debt': 0,
        'created_at': '2026-06-01T10:00:00Z',
        'invoices': [
          {
            'id': 'inv-paid',
            'total_amount': 100,
            'remaining_amount': 0,
            'payment_status': 'paid',
            'created_at': '2026-06-10T12:00:00Z',
          },
          {
            'id': 'inv-partial',
            'total_amount': 200,
            'remaining_amount': 100,
            'payment_status': 'partial',
            'created_at': '2026-06-11T12:00:00Z',
          },
          {
            'id': 'inv-debt',
            'total_amount': 300,
            'remaining_amount': 300,
            'payment_status': 'debt',
            'created_at': '2026-06-12T12:00:00Z',
          },
        ],
        'payments': [],
      };

      final model = CustomerModel.fromJson(json);

      final paidInvoice =
          model.transactions.firstWhere((t) => t.id == 'inv-paid');
      expect(paidInvoice.statusLabel, 'مدفوع');

      final partialInvoice =
          model.transactions.firstWhere((t) => t.id == 'inv-partial');
      expect(partialInvoice.statusLabel, 'مدفوع جزئياً');

      final debtInvoice =
          model.transactions.firstWhere((t) => t.id == 'inv-debt');
      expect(debtInvoice.statusLabel, 'آجل');
    });

    test('toEntity maps all fields correctly', () {
      final json = {
        'id': '123e4567-e89b-12d3-a456-426614174000',
        'name': 'متجر العز',
        'name_official': 'أحمد محمد',
        'phone': '01001234567',
        'address': 'القاهرة',
        'total_debt': 1500,
        'image_url': 'https://example.com/image.jpg',
        'created_at': '2026-06-01T10:00:00Z',
        'invoices': [
          {
            'id': 'inv-001',
            'total_amount': 2000,
            'remaining_amount': 1000,
            'payment_status': 'partial',
            'created_at': '2026-06-10T12:00:00Z',
          },
        ],
        'payments': [],
      };

      final model = CustomerModel.fromJson(json);
      final entity = model.toEntity();

      expect(entity.id, model.id);
      expect(entity.name, model.name);
      expect(entity.totalDebt, model.totalDebt);
      expect(entity.totalPurchases, model.totalPurchases);
      expect(entity.totalPaid, model.totalPaid);
      expect(entity.transactions.length, model.transactions.length);
    });

    test('fromEntity preserves all fields', () {
      final json = {
        'id': 'id',
        'name': 'test',
        'total_debt': 100,
        'created_at': '2026-06-01T10:00:00Z',
        'total_purchases': 500,
        'total_paid': 200,
        'invoices': [
          {
            'id': 'inv-001',
            'total_amount': 500,
            'remaining_amount': 300,
            'payment_status': 'partial',
            'created_at': '2026-06-10T12:00:00Z',
          },
        ],
        'payments': [
          {
            'id': 'pay-001',
            'amount': 200,
            'created_at': '2026-06-12T12:00:00Z',
          },
        ],
      };

      final model = CustomerModel.fromJson(json);
      final entity = model.toEntity();
      final model2 = CustomerModel.fromEntity(entity);

      expect(model2.id, model.id);
      expect(model2.name, model.name);
      expect(model2.totalDebt, model.totalDebt);
      expect(model2.totalPurchases, model.totalPurchases);
      expect(model2.totalPaid, model.totalPaid);
      expect(model2.transactions.length, model.transactions.length);
    });

    test('parses is_opening_balance invoices as opening_debt transactions and overrides legacy', () {
      final json = {
        'id': '123e4567-e89b-12d3-a456-426614174000',
        'name': 'متجر العز',
        'total_debt': 0,
        'created_at': '2026-06-01T10:00:00Z',
        'invoices': [
          {
            'id': 'inv-opening',
            'total_amount': 1500,
            'remaining_amount': 1500,
            'payment_status': 'debt',
            'is_opening_balance': true,
            'created_at': '2026-06-01T09:59:59Z',
          },
        ],
        'payments': [],
      };

      final model = CustomerModel.fromJson(json);

      expect(model.transactions.length, 1);
      expect(model.transactions[0].type, 'opening_debt');
      expect(model.transactions[0].id, 'inv-opening');
      expect(model.transactions[0].amount, 1500);
      expect(model.transactions[0].title, 'رصيد افتتاحي');
      expect(model.transactions[0].subtitle, 'عند إنشاء الحساب');
      expect(model.totalDebt, 1500);
    });

    test('parses invoice_type == opening_balance invoices as opening_debt transactions', () {
      final json = {
        'id': '123e4567-e89b-12d3-a456-426614174000',
        'name': 'متجر العز',
        'total_debt': 0,
        'created_at': '2026-06-01T10:00:00Z',
        'invoices': [
          {
            'id': 'inv-opening',
            'total_amount': 1500,
            'remaining_amount': 1500,
            'payment_status': 'debt',
            'invoice_type': 'opening_balance',
            'created_at': '2026-06-01T09:59:59Z',
          },
        ],
        'payments': [],
      };

      final model = CustomerModel.fromJson(json);

      expect(model.transactions.length, 1);
      expect(model.transactions[0].type, 'opening_debt');
      expect(model.transactions[0].id, 'inv-opening');
      expect(model.transactions[0].amount, 1500);
      expect(model.transactions[0].title, 'رصيد افتتاحي');
      expect(model.transactions[0].subtitle, 'عند إنشاء الحساب');
      expect(model.totalDebt, 1500);
    });
  });
}
