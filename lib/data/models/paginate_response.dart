class PaginatedResponse<T> {
  final List<T> items;
  final int currentPage;
  final int totalPages;
  final int totalItems;

  PaginatedResponse({
    required this.items,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return PaginatedResponse<T>(
      items: List<T>.from(json['data'].map((item) => fromJsonT(item))),
      currentPage: json['current_page'] ?? 1,
      totalPages: json['last_page'] ?? 1,
      totalItems: json['total'] ?? 0,
    );
  }
}
