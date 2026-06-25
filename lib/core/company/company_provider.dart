import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockflow/core/company/company_cubit.dart';

class CompanyProvider extends BlocProvider<CompanyCubit> {
  CompanyProvider({super.key, required CompanyCubit cubit, required super.child})
      : super(create: (_) => cubit);
}
