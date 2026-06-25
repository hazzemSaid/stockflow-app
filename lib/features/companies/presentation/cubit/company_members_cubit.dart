import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stockflow/features/companies/domain/entities/company_member.dart';
import 'package:stockflow/features/companies/domain/usecases/get_company_members_usecase.dart';
import 'package:stockflow/features/companies/domain/usecases/invite_member_usecase.dart';
import 'package:stockflow/features/companies/domain/usecases/remove_member_usecase.dart';
import 'package:stockflow/features/companies/domain/usecases/update_member_permissions_usecase.dart';

sealed class CompanyMembersState extends Equatable {
  const CompanyMembersState();

  @override
  List<Object?> get props => [];
}

final class CompanyMembersInitial extends CompanyMembersState {
  const CompanyMembersInitial();
}

final class CompanyMembersLoading extends CompanyMembersState {
  const CompanyMembersLoading();
}

final class CompanyMembersLoaded extends CompanyMembersState {
  final List<CompanyMember> members;

  const CompanyMembersLoaded({required this.members});

  @override
  List<Object?> get props => [members];
}

final class CompanyMembersError extends CompanyMembersState {
  final String message;

  const CompanyMembersError(this.message);

  @override
  List<Object?> get props => [message];
}

class CompanyMembersCubit extends Cubit<CompanyMembersState> {
  final GetCompanyMembersUseCase _getCompanyMembersUseCase;
  final InviteMemberUseCase _inviteMemberUseCase;
  final UpdateMemberPermissionsUseCase _updateMemberPermissionsUseCase;
  final RemoveMemberUseCase _removeMemberUseCase;

  CompanyMembersCubit({
    required GetCompanyMembersUseCase getCompanyMembersUseCase,
    required InviteMemberUseCase inviteMemberUseCase,
    required UpdateMemberPermissionsUseCase updateMemberPermissionsUseCase,
    required RemoveMemberUseCase removeMemberUseCase,
  })  : _getCompanyMembersUseCase = getCompanyMembersUseCase,
        _inviteMemberUseCase = inviteMemberUseCase,
        _updateMemberPermissionsUseCase = updateMemberPermissionsUseCase,
        _removeMemberUseCase = removeMemberUseCase,
        super(const CompanyMembersInitial());

  Future<void> loadMembers(String companyId) async {
    emit(const CompanyMembersLoading());
    final result = await _getCompanyMembersUseCase.call(companyId);
    result.fold(
      (failure) => emit(CompanyMembersError(failure.message)),
      (members) => emit(CompanyMembersLoaded(members: members)),
    );
  }

  Future<void> inviteMember(String companyId, String userEmail) async {
    final result = await _inviteMemberUseCase.call(companyId, userEmail);
    result.fold(
      (failure) => emit(CompanyMembersError(failure.message)),
      (_) => loadMembers(companyId),
    );
  }

  Future<void> updateMemberPermissions(String companyId, String memberId, Map<String, bool> permissions) async {
    final result = await _updateMemberPermissionsUseCase.call(companyId, memberId, permissions);
    result.fold(
      (failure) => emit(CompanyMembersError(failure.message)),
      (_) => loadMembers(companyId),
    );
  }

  Future<void> removeMember(String companyId, String memberId) async {
    final result = await _removeMemberUseCase.call(companyId, memberId);
    result.fold(
      (failure) => emit(CompanyMembersError(failure.message)),
      (_) => loadMembers(companyId),
    );
  }
}
