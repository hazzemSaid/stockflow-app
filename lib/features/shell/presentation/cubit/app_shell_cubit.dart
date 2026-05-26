import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_strings.dart';
import '../models/search_result_item.dart';
import 'app_shell_state.dart';

class AppShellCubit extends Cubit<AppShellState> {
  AppShellCubit() : super(const AppShellState());

  static const List<String> routeOrder = AppRoutes.shellRoutes;

  static const Map<SearchGroup, List<SearchResultItem>> _seedResults = {
    SearchGroup.products: [
      SearchResultItem(titleAr: 'سكر ١ كجم', subtitleAr: 'قطاع التجزئة'),
      SearchResultItem(titleAr: 'زيت ٧٥٠ مل', subtitleAr: 'زيوت الطعام'),
      SearchResultItem(titleAr: 'أرز بسمتي', subtitleAr: 'توريد شهري'),
    ],
    SearchGroup.customers: [
      SearchResultItem(titleAr: 'متجر الهدى', subtitleAr: 'المنصورة'),
      SearchResultItem(titleAr: 'سوبر ماركت النور', subtitleAr: 'المحلة'),
      SearchResultItem(titleAr: 'شركة الصفوة', subtitleAr: 'القاهرة'),
    ],
    SearchGroup.invoices: [
      SearchResultItem(
        titleAr: 'فاتورة #5841',
        subtitleAr: 'متجر الهدى',
        amountAr: '١٢٬٨٥٠',
        currencyAr: AppStrings.currencyEg,
      ),
      SearchResultItem(
        titleAr: 'فاتورة #5833',
        subtitleAr: 'سوبر ماركت النور',
        amountAr: '٦٬٣٢٠',
        currencyAr: AppStrings.currencyEg,
      ),
    ],
  };

  int indexForRoute(String route) {
    final idx = routeOrder.indexOf(route);
    return idx >= 0 ? idx : 0;
  }

  void syncRoute(String route, int selectedIndex) {
    if (route == state.currentRoute && selectedIndex == state.selectedIndex) {
      return;
    }
    emit(state.copyWith(currentRoute: route, selectedIndex: selectedIndex));
  }

  void openSearch() {
    emit(state.copyWith(isSearchOpen: true));
  }

  void closeSearch() {
    emit(state.copyWith(isSearchOpen: false));
  }

  void updateSearchQuery(String query) {
    final trimmed = query.trim();
    final results = _filterResults(trimmed);
    final status = _statusFor(
      trimmed,
      state.selectedSearchGroup,
      results,
    );
    emit(state.copyWith(
      searchQuery: trimmed,
      searchResults: results,
      status: status,
      messageAr: _messageFor(status),
    ));
  }

  void selectSearchGroup(SearchGroup group) {
    final status = _statusFor(
      state.searchQuery,
      group,
      state.searchResults,
    );
    emit(state.copyWith(
      selectedSearchGroup: group,
      status: status,
      messageAr: _messageFor(status),
    ));
  }

  Map<SearchGroup, List<SearchResultItem>> _filterResults(String query) {
    if (query.isEmpty) {
      return const {
        SearchGroup.products: [],
        SearchGroup.customers: [],
        SearchGroup.invoices: [],
      };
    }
    return _seedResults.map(
      (group, items) => MapEntry(
        group,
        items.where((item) => item.matches(query)).toList(),
      ),
    );
  }

  ShellStatus _statusFor(
    String query,
    SearchGroup group,
    Map<SearchGroup, List<SearchResultItem>> results,
  ) {
    if (query.isEmpty) {
      return ShellStatus.initial;
    }
    final groupResults = results[group] ?? const [];
    return groupResults.isEmpty ? ShellStatus.empty : ShellStatus.success;
  }

  String? _messageFor(ShellStatus status) {
    switch (status) {
      case ShellStatus.empty:
        return AppStrings.searchEmpty;
      case ShellStatus.error:
        return AppStrings.searchError;
      default:
        return null;
    }
  }
}
