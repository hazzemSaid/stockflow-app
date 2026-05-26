import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/stockflow_empty_state.dart';
import '../../../../shared/widgets/stockflow_search_field.dart';
import '../cubit/app_shell_cubit.dart';
import '../cubit/app_shell_state.dart';
import '../models/search_result_item.dart';

class GlobalSearchSheet extends StatefulWidget {
  const GlobalSearchSheet({super.key});

  @override
  State<GlobalSearchSheet> createState() => _GlobalSearchSheetState();
}

class _GlobalSearchSheetState extends State<GlobalSearchSheet>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _controller;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    final state = context.read<AppShellCubit>().state;
    _controller = TextEditingController(text: state.searchQuery);
    _tabController = TabController(
      length: SearchGroup.values.length,
      vsync: this,
      initialIndex: state.selectedSearchGroup.index,
    );
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        return;
      }
      final group = SearchGroup.values[_tabController.index];
      context.read<AppShellCubit>().selectSearchGroup(group);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppShellCubit, AppShellState>(
      listenWhen: (previous, current) =>
          previous.searchQuery != current.searchQuery ||
          previous.selectedSearchGroup != current.selectedSearchGroup,
      listener: (context, state) {
        if (_controller.text != state.searchQuery) {
          _controller.text = state.searchQuery;
          _controller.selection = TextSelection.collapsed(
            offset: _controller.text.length,
          );
        }
        if (_tabController.index != state.selectedSearchGroup.index) {
          _tabController.animateTo(state.selectedSearchGroup.index);
        }
      },
      child: BlocBuilder<AppShellCubit, AppShellState>(
        builder: (context, state) {
          final height = MediaQuery.of(context).size.height * 0.85;
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              height: height,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppSizes.radiusXLarge),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSizes.spacingMedium,
                    AppSizes.spacingSmall,
                    AppSizes.spacingMedium,
                    AppSizes.spacingMedium,
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 40.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: AppColors.inputBorder,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      SizedBox(height: AppSizes.spacingMedium),
                      Text(
                        AppStrings.searchTitle,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: AppSizes.fontXLarge,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: AppSizes.spacingMedium),
                      StockFlowSearchField(
                        controller: _controller,
                        hintText: AppStrings.searchHint,
                        onChanged: (value) =>
                            context.read<AppShellCubit>().updateSearchQuery(
                                  value,
                                ),
                        onClear: () {
                          _controller.clear();
                          context.read<AppShellCubit>().updateSearchQuery('');
                        },
                        autofocus: true,
                      ),
                      SizedBox(height: AppSizes.spacingMedium),
                      TabBar(
                        controller: _tabController,
                        labelColor: AppColors.primary,
                        unselectedLabelColor: AppColors.textSecondary,
                        indicatorColor: AppColors.primary,
                        labelStyle: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: AppSizes.fontMedium,
                          fontWeight: FontWeight.w600,
                        ),
                        tabs: const [
                          Tab(text: AppStrings.searchProductsTab),
                          Tab(text: AppStrings.searchCustomersTab),
                          Tab(text: AppStrings.searchInvoicesTab),
                        ],
                      ),
                      SizedBox(height: AppSizes.spacingSmall),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _SearchResults(
                              state: state,
                              group: SearchGroup.products,
                            ),
                            _SearchResults(
                              state: state,
                              group: SearchGroup.customers,
                            ),
                            _SearchResults(
                              state: state,
                              group: SearchGroup.invoices,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SearchResults extends StatelessWidget {
  final AppShellState state;
  final SearchGroup group;

  const _SearchResults({
    required this.state,
    required this.group,
  });

  @override
  Widget build(BuildContext context) {
    if (state.searchQuery.isEmpty) {
      return _ScrollableEmptyState(
        icon: Icons.manage_search_outlined,
        message: AppStrings.searchStart,
      );
    }

    if (state.status == ShellStatus.error) {
      return _ScrollableEmptyState(
        icon: Icons.error_outline,
        message: state.messageAr ?? AppStrings.searchError,
      );
    }

    final results = state.searchResults[group] ?? <SearchResultItem>[];
    if (results.isEmpty) {
      return _ScrollableEmptyState(
        icon: Icons.search_off_outlined,
        message: AppStrings.searchEmpty,
      );
    }

    return ListView.separated(
      padding: EdgeInsets.only(top: AppSizes.spacingSmall),
      itemCount: results.length,
      separatorBuilder: (_, __) => Divider(color: AppColors.inputBorder),
      itemBuilder: (context, index) {
        final item = results[index];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: _ResultIcon(group: group),
          title: Text(
            item.titleAr,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: AppSizes.fontLarge,
              color: AppColors.textPrimary,
            ),
          ),
          subtitle: Text(
            item.subtitleAr,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: AppSizes.fontMedium,
              color: AppColors.textSecondary,
            ),
          ),
          trailing: item.amountAr == null
              ? null
              : RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: item.amountAr,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: AppSizes.fontLarge,
                          color: AppColors.primary,
                        ),
                      ),
                      const TextSpan(text: ' '),
                      TextSpan(
                        text: item.currencyAr ?? AppStrings.currencyEg,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: AppSizes.fontSmall,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}

class _ResultIcon extends StatelessWidget {
  final SearchGroup group;

  const _ResultIcon({required this.group});

  @override
  Widget build(BuildContext context) {
    late final IconData icon;
    late final Color background;
    late final Color color;

    switch (group) {
      case SearchGroup.products:
        icon = Icons.inventory_2_outlined;
        background = AppColors.lightGreen;
        color = AppColors.primary;
        break;
      case SearchGroup.customers:
        icon = Icons.people_outline;
        background = AppColors.lightOrange;
        color = AppColors.secondary;
        break;
      case SearchGroup.invoices:
        icon = Icons.receipt_long_outlined;
        background = AppColors.lightRed;
        color = AppColors.accent;
        break;
    }

    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Icon(icon, color: color, size: 20.w),
    );
  }
}

class _ScrollableEmptyState extends StatelessWidget {
  final IconData icon;
  final String message;

  const _ScrollableEmptyState({
    required this.icon,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.only(top: AppSizes.spacingLarge),
        child: StockFlowEmptyState(
          icon: icon,
          message: message,
        ),
      ),
    );
  }
}
