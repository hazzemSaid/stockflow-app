import 'package:get_it/get_it.dart';
import 'package:stockflow/features/customers/domain/usecases/get_customer-filtercounts_usecase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/auth_state_changes_usecase.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/domain/usecases/sign_in_usecase.dart';
import '../../features/auth/domain/usecases/sign_up_usecase.dart';
import '../../features/auth/domain/usecases/sign_out_usecase.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/products/data/datasources/product_remote_data_source.dart';
import '../../features/products/data/datasources/product_remote_data_source_impl.dart';
import '../../features/products/data/repositories/product_repository_impl.dart';
import '../../features/products/domain/repositories/product_repository.dart';
import '../../features/products/domain/usecases/get_products_usecase.dart';
import '../../features/products/domain/usecases/create_product_usecase.dart';
import '../../features/products/domain/usecases/upload_product_image_usecase.dart';
import '../../features/products/domain/usecases/get_product_usecase.dart';
import '../../features/products/domain/usecases/update_product_usecase.dart';
import '../../features/products/domain/usecases/delete_product_usecase.dart';
import '../../features/products/domain/usecases/update_product_quantity_usecase.dart';
import '../../features/products/domain/usecases/get_inventory_movements_usecase.dart';
import '../../features/products/presentation/cubit/products/products_cubit.dart';
import '../../features/products/presentation/cubit/add_edit_product/add_edit_product_cubit.dart';
import '../../features/products/presentation/cubit/product_details/product_details_cubit.dart';
import '../../features/customers/data/datasources/customer_remote_data_source.dart';
import '../../features/customers/data/datasources/customer_remote_data_source_impl.dart';
import '../../features/customers/data/repositories/customer_repository_impl.dart';
import '../../features/customers/domain/repositories/customer_repository.dart';
import '../../features/customers/domain/usecases/get_customers_usecase.dart';
import '../../features/customers/domain/usecases/create_customer_usecase.dart';
import '../../features/customers/domain/usecases/upload_customer_image_usecase.dart';
import '../../features/customers/domain/usecases/get_customer_usecase.dart';
import '../../features/customers/domain/usecases/update_customer_usecase.dart';
import '../../features/customers/presentation/cubit/customers/customers_cubit.dart';
import '../../features/customers/presentation/cubit/add_edit_customer/add_edit_customer_cubit.dart';
import '../../features/customers/presentation/cubit/customer_details/customer_details_cubit.dart';
import '../../features/invoice/data/datasources/invoice_remote_data_source.dart';
import '../../features/invoice/data/datasources/invoice_remote_data_source_impl.dart';
import '../../features/invoice/data/repositories/invoice_repository_impl.dart';
import '../../features/invoice/domain/repositories/invoice_repository.dart';
import '../../features/invoice/domain/usecases/add_payment_usecase.dart';
import '../../features/invoice/domain/usecases/create_invoice_usecase.dart';
import '../../features/invoice/domain/usecases/get_invoice_usecase.dart';
import '../../features/invoice/domain/usecases/get_invoices_usecase.dart';
import '../../features/invoice/presentation/cubit/add_payment/add_payment_cubit.dart';
import '../../features/invoice/presentation/cubit/create_invoice/create_invoice_cubit.dart';
import '../../features/invoice/presentation/cubit/invoice_details/invoice_details_cubit.dart';

final sl = GetIt.instance;

Future<void> initServiceLocator() async {
  // Auth: Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(Supabase.instance.client),
  );

  // Auth: Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthRemoteDataSource>()),
  );

  // Auth: Use cases
  sl.registerLazySingleton<SignInUseCase>(
    () => SignInUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<SignUpUseCase>(
    () => SignUpUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<SignOutUseCase>(
    () => SignOutUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<GetCurrentUserUseCase>(
    () => GetCurrentUserUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<AuthStateChangesUseCase>(
    () => AuthStateChangesUseCase(sl<AuthRepository>()),
  );

  // Auth: Cubits
  sl.registerLazySingleton<AuthCubit>(
    () => AuthCubit(
      signInUseCase: sl<SignInUseCase>(),
      signUpUseCase: sl<SignUpUseCase>(),
      signOutUseCase: sl<SignOutUseCase>(),
      getCurrentUserUseCase: sl<GetCurrentUserUseCase>(),
      authStateChangesUseCase: sl<AuthStateChangesUseCase>(),
    ),
  );

  // Products: Data sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(Supabase.instance.client),
  );

  // Products: Repositories
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(sl<ProductRemoteDataSource>()),
  );

  // Products: Use cases
  sl.registerLazySingleton<GetProductsUseCase>(
    () => GetProductsUseCase(sl<ProductRepository>()),
  );

  sl.registerLazySingleton<CreateProductUseCase>(
    () => CreateProductUseCase(sl<ProductRepository>()),
  );
  sl.registerLazySingleton<UploadProductImageUseCase>(
    () => UploadProductImageUseCase(sl<ProductRepository>()),
  );
  sl.registerLazySingleton<GetProductUseCase>(
    () => GetProductUseCase(sl<ProductRepository>()),
  );
  sl.registerLazySingleton<UpdateProductUseCase>(
    () => UpdateProductUseCase(sl<ProductRepository>()),
  );
  sl.registerLazySingleton<DeleteProductUseCase>(
    () => DeleteProductUseCase(sl<ProductRepository>()),
  );
  sl.registerLazySingleton<UpdateProductQuantityUseCase>(
    () => UpdateProductQuantityUseCase(sl<ProductRepository>()),
  );
  sl.registerLazySingleton<GetInventoryMovementsUseCase>(
    () => GetInventoryMovementsUseCase(sl<ProductRepository>()),
  );

  // Products: Cubits
  sl.registerLazySingleton<ProductsCubit>(
    () => ProductsCubit(getProductsUseCase: sl<GetProductsUseCase>()),
  );

  sl.registerFactory<AddEditProductCubit>(
    () => AddEditProductCubit(
      createProductUseCase: sl<CreateProductUseCase>(),
      uploadImageUseCase: sl<UploadProductImageUseCase>(),
      getProductUseCase: sl<GetProductUseCase>(),
      updateProductUseCase: sl<UpdateProductUseCase>(),
    ),
  );

  sl.registerFactory<ProductDetailsCubit>(
    () => ProductDetailsCubit(
      getProductUseCase: sl<GetProductUseCase>(),
      deleteProductUseCase: sl<DeleteProductUseCase>(),
      updateQuantityUseCase: sl<UpdateProductQuantityUseCase>(),
      getMovementsUseCase: sl<GetInventoryMovementsUseCase>(),
    ),
  );

  // Customers: Data sources
  sl.registerLazySingleton<CustomerRemoteDataSource>(
    () =>
        CustomerRemoteDataSourceImpl(supabaseClient: Supabase.instance.client),
  );
  sl.registerLazySingleton<GetCustomerFilterCountsUseCase>(
    () => GetCustomerFilterCountsUseCase(sl<CustomerRepository>()),
  );

  // Customers: Repositories
  sl.registerLazySingleton<CustomerRepository>(
    () => CustomerRepositoryImpl(sl<CustomerRemoteDataSource>()),
  );

  // Customers: Use cases
  sl.registerLazySingleton<GetCustomersUseCase>(
    () => GetCustomersUseCase(sl<CustomerRepository>()),
  );
  sl.registerLazySingleton<CreateCustomerUseCase>(
    () => CreateCustomerUseCase(sl<CustomerRepository>()),
  );
  sl.registerLazySingleton<UploadCustomerImageUseCase>(
    () => UploadCustomerImageUseCase(sl<CustomerRepository>()),
  );
  sl.registerLazySingleton<GetCustomerUseCase>(
    () => GetCustomerUseCase(sl<CustomerRepository>()),
  );
  sl.registerLazySingleton<UpdateCustomerUseCase>(
    () => UpdateCustomerUseCase(sl<CustomerRepository>()),
  );

  // Customers: Cubits
  sl.registerLazySingleton<CustomersCubit>(
    () => CustomersCubit(
      getCustomersUseCase: sl<GetCustomersUseCase>(),
      getCustomerFilterCountsUseCase: sl<GetCustomerFilterCountsUseCase>(),
    ),
  );

  sl.registerFactory<AddEditCustomerCubit>(
    () => AddEditCustomerCubit(
      createCustomerUseCase: sl<CreateCustomerUseCase>(),
      uploadImageUseCase: sl<UploadCustomerImageUseCase>(),
      getCustomerUseCase: sl<GetCustomerUseCase>(),
      updateCustomerUseCase: sl<UpdateCustomerUseCase>(),
    ),
  );

  sl.registerFactory<CustomerDetailsCubit>(
    () => CustomerDetailsCubit(getCustomerUseCase: sl<GetCustomerUseCase>()),
  );

  // Invoice: Data sources
  sl.registerLazySingleton<InvoiceRemoteDataSource>(
    () => InvoiceRemoteDataSourceImpl(supabaseClient: Supabase.instance.client),
  );

  // Invoice: Repositories
  sl.registerLazySingleton<InvoiceRepository>(
    () => InvoiceRepositoryImpl(sl<InvoiceRemoteDataSource>()),
  );

  // Invoice: Use cases
  sl.registerLazySingleton<CreateInvoiceUseCase>(
    () => CreateInvoiceUseCase(sl<InvoiceRepository>()),
  );
  sl.registerLazySingleton<AddPaymentUseCase>(
    () => AddPaymentUseCase(sl<InvoiceRepository>()),
  );
  sl.registerLazySingleton<GetInvoiceUseCase>(
    () => GetInvoiceUseCase(sl<InvoiceRepository>()),
  );
  sl.registerLazySingleton<GetInvoicesUseCase>(
    () => GetInvoicesUseCase(sl<InvoiceRepository>()),
  );

  // Invoice: Cubits
  sl.registerFactory<CreateInvoiceCubit>(
    () => CreateInvoiceCubit(createInvoiceUseCase: sl<CreateInvoiceUseCase>()),
  );

  sl.registerFactory<InvoiceDetailsCubit>(
    () => InvoiceDetailsCubit(getInvoiceUseCase: sl<GetInvoiceUseCase>()),
  );

  sl.registerFactory<AddPaymentCubit>(
    () => AddPaymentCubit(
      getInvoicesUseCase: sl<GetInvoicesUseCase>(),
      addPaymentUseCase: sl<AddPaymentUseCase>(),
    ),
  );
}
