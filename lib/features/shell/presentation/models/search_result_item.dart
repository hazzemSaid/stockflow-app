class SearchResultItem {
  final String titleAr;
  final String subtitleAr;
  final String? amountAr;
  final String? currencyAr;

  const SearchResultItem({
    required this.titleAr,
    required this.subtitleAr,
    this.amountAr,
    this.currencyAr,
  });

  bool matches(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) {
      return false;
    }
    return titleAr.toLowerCase().contains(normalized) ||
        subtitleAr.toLowerCase().contains(normalized);
  }
}
