import '../../../../core/constants/app_routes.dart';
import '../models/search_result_item.dart';

enum ShellStatus { initial, loading, success, empty, error }

enum SearchGroup { products, customers, invoices }

class AppShellState {
  final String currentRoute;
  final int selectedIndex;
  final bool isSearchOpen;
  final String searchQuery;
  final SearchGroup selectedSearchGroup;
  final ShellStatus status;
  final String? messageAr;
  final Map<SearchGroup, List<SearchResultItem>> searchResults;

  const AppShellState({
    this.currentRoute = AppRoutes.dashboard,
    this.selectedIndex = 0,
    this.isSearchOpen = false,
    this.searchQuery = '',
    this.selectedSearchGroup = SearchGroup.products,
    this.status = ShellStatus.initial,
    this.messageAr,
    this.searchResults = const {
      SearchGroup.products: [],
      SearchGroup.customers: [],
      SearchGroup.invoices: [],
    },
  });

  AppShellState copyWith({
    String? currentRoute,
    int? selectedIndex,
    bool? isSearchOpen,
    String? searchQuery,
    SearchGroup? selectedSearchGroup,
    ShellStatus? status,
    String? messageAr,
    Map<SearchGroup, List<SearchResultItem>>? searchResults,
  }) {
    return AppShellState(
      currentRoute: currentRoute ?? this.currentRoute,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      isSearchOpen: isSearchOpen ?? this.isSearchOpen,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedSearchGroup: selectedSearchGroup ?? this.selectedSearchGroup,
      status: status ?? this.status,
      messageAr: messageAr ?? this.messageAr,
      searchResults: searchResults ?? this.searchResults,
    );
  }
}
