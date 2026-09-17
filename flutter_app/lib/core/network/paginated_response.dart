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

/// The real API nests pagination (and review rating aggregates) under a
/// top-level `meta` key (`{ data: [...], meta: { pagination: {...} } }`),
/// not at the top level as `apiMetaRes.type.ts` implies. Some endpoints may
/// still put it at the top level, so check both.
Map<String, dynamic>? _metaBlock(Map<String, dynamic> json) {
  final meta = json['meta'];
  if (meta is Map<String, dynamic>) return meta;
  return json;
}

/// Mirrors `IApiMetaRes`: `{ pagination: {...} }`.
class ApiMetaRes {
  const ApiMetaRes({required this.pagination});

  factory ApiMetaRes.fromJson(Map<String, dynamic> json) {
    final meta = _metaBlock(json) ?? const {};
    return ApiMetaRes(
      pagination: ApiPagination.fromJson(
        meta['pagination'] as Map<String, dynamic>? ?? const {},
      ),
    );
  }

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

  factory ProductReviewMeta.fromJson(Map<String, dynamic> json) {
    final meta = _metaBlock(json) ?? const {};
    return ProductReviewMeta(
      pagination: ApiPagination.fromJson(
        meta['pagination'] as Map<String, dynamic>? ?? const {},
      ),
      ratingAvg: (meta['rating_avg'] as num?)?.toDouble() ?? 0,
      ratingCount: meta['rating_count'] as int? ?? 0,
    );
  }

  final double ratingAvg;
  final int ratingCount;
}

/// Generic wrapper for a Laravel-paginated list response:
/// `{ data: T[], meta: { pagination: {...} } }`.
class PaginatedResponse<T> {
  const PaginatedResponse({required this.data, required this.pagination});

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final rawData = json['data'] as List<dynamic>? ?? const [];
    final meta = _metaBlock(json) ?? const {};
    final rawPagination = meta['pagination'] as Map<String, dynamic>?;
    return PaginatedResponse<T>(
      data: rawData
          .map((e) => fromJsonT(e as Map<String, dynamic>))
          .toList(growable: false),
      pagination: rawPagination != null
          ? ApiPagination.fromJson(rawPagination)
          : ApiPagination(
              total: rawData.length,
              perPage: rawData.length,
              currentPage: 1,
              lastPage: 1,
            ),
    );
  }

  final List<T> data;
  final ApiPagination pagination;
}
