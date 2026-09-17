/// Mirrors `apiMetaRes.type.ts`'s `IApiMetaRes` pagination meta shape:
/// `{ pagination: { total, per_page, current_page, last_page } }`.
class ApiPagination {
  const ApiPagination({
    required this.total,
    required this.perPage,
    required this.currentPage,
    required this.lastPage,
  });

  factory ApiPagination.fromJson(Map<String, dynamic> json) => ApiPagination(
        total: json['total'] as int,
        perPage: json['per_page'] as int,
        currentPage: json['current_page'] as int,
        lastPage: json['last_page'] as int,
      );

  final int total;
  final int perPage;
  final int currentPage;
  final int lastPage;

  Map<String, dynamic> toJson() => {
        'total': total,
        'per_page': perPage,
        'current_page': currentPage,
        'last_page': lastPage,
      };
}

/// Mirrors `IApiMetaRes`: `{ pagination: {...} }`.
class ApiMetaRes {
  const ApiMetaRes({required this.pagination});

  factory ApiMetaRes.fromJson(Map<String, dynamic> json) => ApiMetaRes(
        pagination: ApiPagination.fromJson(
          json['pagination'] as Map<String, dynamic>,
        ),
      );

  final ApiPagination pagination;
}

/// Mirrors `IProductReviewMeta extends IApiMetaRes` — pagination plus
/// aggregate rating info.
class ProductReviewMeta extends ApiMetaRes {
  const ProductReviewMeta({
    required super.pagination,
    required this.ratingAvg,
    required this.ratingCount,
  });

  factory ProductReviewMeta.fromJson(Map<String, dynamic> json) =>
      ProductReviewMeta(
        pagination: ApiPagination.fromJson(
          json['pagination'] as Map<String, dynamic>,
        ),
        ratingAvg: (json['rating_avg'] as num).toDouble(),
        ratingCount: json['rating_count'] as int,
      );

  final double ratingAvg;
  final int ratingCount;
}

/// Generic wrapper for a Laravel-paginated list response:
/// `{ data: T[], pagination: {...} }`.
class PaginatedResponse<T> {
  const PaginatedResponse({required this.data, required this.pagination});

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final rawData = json['data'] as List<dynamic>? ?? const [];
    return PaginatedResponse<T>(
      data: rawData
          .map((e) => fromJsonT(e as Map<String, dynamic>))
          .toList(growable: false),
      pagination: ApiPagination.fromJson(
        json['pagination'] as Map<String, dynamic>,
      ),
    );
  }

  final List<T> data;
  final ApiPagination pagination;
}
