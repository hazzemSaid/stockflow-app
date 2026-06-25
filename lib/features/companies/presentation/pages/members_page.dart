import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockflow/core/company/company_cubit.dart';
import 'package:stockflow/core/company/company_state.dart';
import 'package:stockflow/core/constants/app_colors.dart';
import 'package:stockflow/core/constants/app_sizes.dart';
import 'package:stockflow/core/constants/app_strings.dart';
import 'package:stockflow/core/di/service_locator.dart';
import 'package:stockflow/core/widgets/app_snackbar.dart';
import 'package:stockflow/features/companies/domain/entities/company_member.dart';
import 'package:stockflow/features/companies/domain/entities/join_request.dart';
import 'package:stockflow/features/companies/domain/usecases/approve_join_request_usecase.dart';
import 'package:stockflow/features/companies/domain/usecases/get_join_requests_usecase.dart';
import 'package:stockflow/features/companies/domain/usecases/reject_join_request_usecase.dart';
import 'package:stockflow/features/companies/presentation/cubit/company_members_cubit.dart';
import 'package:stockflow/features/companies/presentation/widgets/invite_member_dialog.dart';
import 'package:stockflow/features/companies/presentation/widgets/member_card.dart';

class MembersPage extends StatefulWidget {
  const MembersPage({super.key});

  @override
  State<MembersPage> createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  late final CompanyMembersCubit _cubit = sl<CompanyMembersCubit>();
  String? _companyId;
  List<JoinRequest>? _joinRequests;
  bool _joinRequestActionInProgress = false;

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final companyState = context.read<CompanyCubit>().state;
    if (companyState is CompanySelected && _companyId == null) {
      _companyId = companyState.companyId;
      _cubit.loadMembers(companyState.companyId);
      _loadJoinRequests();
    }
  }

  Future<void> _loadJoinRequests() async {
    if (_companyId == null) return;
    final useCase = sl<GetJoinRequestsUseCase>();
    final result = await useCase.call(_companyId!);
    result.fold((_) {}, (requests) => setState(() => _joinRequests = requests));
  }

  Future<void> _approveRequest(String requestId) async {
    if (_companyId == null) return;
    setState(() => _joinRequestActionInProgress = true);

    final result = await sl<ApproveJoinRequestUseCase>().call(requestId);
    result.fold(
      (_) => AppSnackbar.error(context, AppStrings.unexpectedError),
      (_) {
        AppSnackbar.success(context, AppStrings.requestApproved);
        _loadJoinRequests();
        if (_companyId != null) {
          _cubit.loadMembers(_companyId!);
        }
      },
    );

    setState(() => _joinRequestActionInProgress = false);
  }

  Future<void> _rejectRequest(String requestId) async {
    setState(() => _joinRequestActionInProgress = true);
    final useCase = sl<RejectJoinRequestUseCase>();
    final result = await useCase.call(requestId);
    result.fold((_) => AppSnackbar.error(context, AppStrings.unexpectedError), (
      _,
    ) {
      AppSnackbar.success(context, AppStrings.requestRejected);
      _loadJoinRequests();
    });
    setState(() => _joinRequestActionInProgress = false);
  }

  void _showInviteDialog() {
    if (_companyId == null) return;
    showDialog(
      context: context,
      builder: (_) => InviteMemberDialog(
        onInvite: (email) {
          _cubit.inviteMember(_companyId!, email);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<CompanyMembersCubit, CompanyMembersState>(
        listener: (context, state) {
          if (state is CompanyMembersError) {
            AppSnackbar.error(context, state.message);
          }
        },
        builder: (context, state) {

          return Scaffold(
            backgroundColor: AppColors.appBackground,
            appBar: AppBar(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              title: Text(AppStrings.teamMembers, style: TextStyle()),
              actions: [
                IconButton(
                  icon: Icon(Icons.person_add),
                  onPressed: _showInviteDialog,
                ),
              ],
            ),
            body: _buildBody(state),
          );
        },
      ),
    );
  }

  Widget _buildBody(CompanyMembersState state) {
    if (state is CompanyMembersLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is CompanyMembersLoaded) {
      final hasJoinRequests =
          _joinRequests != null && _joinRequests!.isNotEmpty;

      if (state.members.isEmpty && !hasJoinRequests) {
        return Center(
          child: Text(
            AppStrings.noMembersYet,
            style: TextStyle(
              fontSize: AppSizes.fontLarge,
              color: AppColors.textSecondary,
            ),
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () async {
          if (_companyId != null) {
            _cubit.loadMembers(_companyId!);
            await _loadJoinRequests();
          }
        },
        child: ListView(
          padding: EdgeInsets.all(AppSizes.spacingMedium),
          children: [
            if (hasJoinRequests) ...[
              _buildJoinRequestsHeader(),
              ...(_joinRequests!.map((req) => _buildJoinRequestCard(req))),
              SizedBox(height: AppSizes.spacingMedium),
              Divider(color: AppColors.inputBorder),
              SizedBox(height: AppSizes.spacingMedium),
            ],
            ...state.members.map((member) => MemberCard(
              member: member,
              onRemove: () => _confirmRemove(member),
            )),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildJoinRequestsHeader() {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.spacingSmall),
      child: Text(
        '${AppStrings.joinRequests} (${_joinRequests!.length})',
        style: TextStyle(
          fontSize: AppSizes.fontMedium,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildJoinRequestCard(JoinRequest request) {
    return Card(
      margin: EdgeInsets.only(bottom: AppSizes.spacingSmall),
      elevation: 0,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        side: BorderSide(color: AppColors.inputBorder),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSizes.spacingMedium),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.primary.withAlpha(25),
              child: Text(
                request.userName.isNotEmpty
                    ? request.userName[0].toUpperCase()
                    : '?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            SizedBox(width: AppSizes.spacingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    request.userName,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: AppSizes.fontMedium,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (request.userEmail.isNotEmpty)
                    Text(
                      request.userEmail,
                      style: TextStyle(
                        fontSize: AppSizes.fontSmall,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  Text(
                    _formatDate(request.createdAt),
                    style: TextStyle(
                      fontSize: AppSizes.fontSmall,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: AppSizes.spacingSmall),
            TextButton(
              onPressed: _joinRequestActionInProgress
                  ? null
                  : () => _confirmApprove(request.id),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.trendUp,
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.spacingSmall,
                ),
              ),
              child: Text(AppStrings.approve),
            ),
            SizedBox(width: 4),
            TextButton(
              onPressed: _joinRequestActionInProgress
                  ? null
                  : () => _confirmReject(request.id),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.error,
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.spacingSmall,
                ),
              ),
              child: Text(AppStrings.reject),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final local = date.toLocal();
    final now = DateTime.now();
    final diff = now.difference(local);
    if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
    if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعة';
    if (diff.inDays < 7) return 'منذ ${diff.inDays} يوم';
    return '${local.year}/${local.month}/${local.day}';
  }

  void _confirmApprove(String requestId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppStrings.approve),
        content: Text(AppStrings.approveJoinConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _approveRequest(requestId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.trendUp,
              foregroundColor: AppColors.white,
            ),
            child: Text(AppStrings.approve),
          ),
        ],
      ),
    );
  }

  void _confirmReject(String requestId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          AppStrings.rejectJoinConfirm.split('.')[0],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(AppStrings.rejectJoinConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _rejectRequest(requestId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.white,
            ),
            child: Text(AppStrings.reject),
          ),
        ],
      ),
    );
  }

  void _confirmRemove(CompanyMember member) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          AppStrings.removeMember,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          '${AppStrings.removeMemberConfirm} ${member.userName ?? member.userId}?',
          style: TextStyle(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppStrings.cancel, style: TextStyle()),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (_companyId != null) {
                _cubit.removeMember(
                  _companyId!,
                  member.id,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.white,
            ),
            child: Text(AppStrings.remove, style: TextStyle()),
          ),
        ],
      ),
    );
  }
}
