import 'package:equatable/equatable.dart';
import 'package:stockflow/features/companies/domain/entities/company.dart';
import 'package:stockflow/features/companies/domain/entities/company_member.dart';

sealed class CompanyState extends Equatable {
  const CompanyState();

  @override
  List<Object?> get props => [];
}

final class CompanyInitial extends CompanyState {
  const CompanyInitial();
}

final class CompanyLoading extends CompanyState {
  const CompanyLoading();
}

final class CompaniesLoaded extends CompanyState {
  final List<Company> companies;
  final List<CompanyMember>? memberships;

  const CompaniesLoaded({required this.companies, this.memberships});

  @override
  List<Object?> get props => [companies, memberships];
}

final class CompanySelected extends CompanyState {
  final Company company;
  final CompanyMember? membership;
  final List<Company> allCompanies;

  const CompanySelected({
    required this.company,
    this.membership,
    this.allCompanies = const [],
  });

  @override
  List<Object?> get props => [company, membership, allCompanies];

  String get companyId => company.id;
}

final class CompanyError extends CompanyState {
  final String message;

  const CompanyError(this.message);

  @override
  List<Object?> get props => [message];
}
