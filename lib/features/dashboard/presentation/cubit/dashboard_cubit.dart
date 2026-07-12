import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:makhzanflow/features/dashboard/domain/usecases/get_dashboard_stats_usecase.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit({required GetDashboardStatsUseCase getDashboardStatsUseCase})
    : _getDashboardStatsUseCase = getDashboardStatsUseCase,
      super(const DashboardInitial());

  final GetDashboardStatsUseCase _getDashboardStatsUseCase;

  String? _companyId;
  int _fetchSeq = 0;

  /// Fetches all dashboard data from scratch — shows full loading shimmer.
  Future<void> loadDashboard(String companyId) async {
    emit(const DashboardLoading());
    _companyId = companyId;
    await _fetch(companyId);
  }

  /// Silently refreshes data without hiding the current data (isRefreshing flag).
  Future<void> refresh() async {
    if (_companyId == null) return;
    if (state is DashboardLoaded) {
      emit((state as DashboardLoaded).copyWith(isRefreshing: true));
    }
    await _fetch(_companyId!);
  }

  Future<void> _fetch(String companyId) async {
    final seq = ++_fetchSeq;
    final result = await _getDashboardStatsUseCase(companyId);
    if (seq != _fetchSeq) return;
    result.fold(
      (failure) => emit(DashboardError(message: failure.message)),
      (stats) => emit(DashboardLoaded(stats: stats)),
    );
  }
}
