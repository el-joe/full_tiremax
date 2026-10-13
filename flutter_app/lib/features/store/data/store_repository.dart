import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/brand.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/paginated_response.dart';
import '../../product/models/product.dart';
import '../../product/models/tyre_size.dart';

class ProductFilters {
  const ProductFilters({
    this.search,
    this.type,
    this.badge,
    this.brandId,
    this.categoryId,
    this.minPrice,
    this.maxPrice,
    this.sort,
    this.makeId,
    this.modelId,
    this.year,
    this.vehicleId,
    this.width,
    this.aspectRatio,
    this.rimDiameter,
  });

  final String? search;

  /// `tire` | `battery` (web `filter_products_type`); null = all.
  final String? type;

  /// `best_seller` | `new` | `best_choice` | `special_offer` (web `badge`).
  final String? badge;
  final int? brandId;
  final int? categoryId;
  final num? minPrice;
  final num? maxPrice;
  final String? sort;
  final int? makeId;
  final int? modelId;
  final int? year;

  /// Resolved from make/model/year via `GET vehicles`; the only vehicle
  /// value `products` understands (web: `filter_products_vehicle_id`).
  final int? vehicleId;
  final num? width;
  final num? aspectRatio;
  final num? rimDiameter;

  ProductFilters copyWith({
    String? search,
    bool clearSearch = false,
    String? type,
    bool clearType = false,
    String? badge,
    bool clearBadge = false,
    int? brandId,
    bool clearBrand = false,
    int? categoryId,
    num? minPrice,
    num? maxPrice,
    bool clearPrice = false,
    String? sort,
    int? makeId,
    bool clearMake = false,
    int? modelId,
    bool clearModel = false,
    int? year,
    bool clearYear = false,
    int? vehicleId,
    bool clearVehicle = false,
    num? width,
    num? aspectRatio,
    num? rimDiameter,
    bool clearSize = false,
  }) {
    return ProductFilters(
      search: clearSearch ? null : (search ?? this.search),
      type: clearType ? null : (type ?? this.type),
      badge: clearBadge ? null : (badge ?? this.badge),
      brandId: clearBrand ? null : (brandId ?? this.brandId),
      categoryId: categoryId ?? this.categoryId,
      minPrice: clearPrice ? null : (minPrice ?? this.minPrice),
      maxPrice: clearPrice ? null : (maxPrice ?? this.maxPrice),
      sort: sort ?? this.sort,
      makeId: clearMake ? null : (makeId ?? this.makeId),
      modelId: clearModel ? null : (modelId ?? this.modelId),
      year: clearYear ? null : (year ?? this.year),
      vehicleId: clearVehicle ? null : (vehicleId ?? this.vehicleId),
      width: clearSize ? null : (width ?? this.width),
      aspectRatio: clearSize ? null : (aspectRatio ?? this.aspectRatio),
      rimDiameter: clearSize ? null : (rimDiameter ?? this.rimDiameter),
    );
  }

  Map<String, dynamic> toQuery(int page) {
    return {
      'page': page,
      if (search != null && search!.isNotEmpty) 'search': search,
      if (type != null && type!.isNotEmpty) 'type': type,
      if (badge != null && badge!.isNotEmpty) 'badge': badge,
      if (brandId != null) 'brand_id': brandId,
      if (categoryId != null) 'category_id': categoryId,
      if (minPrice != null) 'min_price': minPrice,
      if (maxPrice != null) 'max_price': maxPrice,
      if (sort != null) 'sort': sort,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (width != null) 'width': width,
      if (aspectRatio != null) 'aspect_ratio': aspectRatio,
      if (rimDiameter != null) 'rim_diameter': rimDiameter,
    };
  }
}

class VehicleOption {
  const VehicleOption({required this.id, required this.name});

  final int id;
  final String name;

  factory VehicleOption.fromJson(Map<String, dynamic> json) => VehicleOption(
    id: (json['id'] as num).toInt(),
    name: json['name'].toString(),
  );
}

class VehicleMatch {
  const VehicleMatch({required this.id, required this.label});

  final int id;
  final String label;
}

class StoreRepository {
  StoreRepository(this._dio);

  final Dio _dio;

  Future<PaginatedResponse<Product>> fetchProducts({
    required int page,
    required ProductFilters filters,
  }) async {
    final response = await _dio.get(
      'products',
      queryParameters: filters.toQuery(page),
    );
    return PaginatedResponse.fromJson(
      response.data as Map<String, dynamic>,
      (json) => Product.fromJson(json),
    );
  }

  Future<List<Brand>> fetchBrands() async {
    final response = await _dio.get('brands');
    final data =
        (response.data as Map<String, dynamic>)['data'] as List<dynamic>;
    return data.map((e) => Brand.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<VehicleOption>> _options(String path) async {
    final response = await _dio.get(path);
    final data =
        (response.data as Map<String, dynamic>)['data'] as List<dynamic>;
    return data
        .map((e) => VehicleOption.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<VehicleOption>> fetchVehicleMakes() => _options('vehicles/makes');

  Future<List<VehicleOption>> fetchVehicleModels(int makeId) =>
      _options('vehicles/makes/$makeId/models');

  /// `models/{id}/years` returns trims with `year_from`..`year_to` ranges
  /// (see web `generateYearsSlots`); flatten to distinct years, newest first.
  Future<List<int>> fetchVehicleYears(int modelId) async {
    final response = await _dio.get('vehicles/models/$modelId/years');
    final data =
        (response.data as Map<String, dynamic>)['data'] as List<dynamic>;
    final years = <int>{};
    for (final e in data) {
      final m = e as Map<String, dynamic>;
      final from = (m['year_from'] as num).toInt();
      final to = (m['year_to'] as num?)?.toInt() ?? from;
      for (var y = from; y <= to; y++) {
        years.add(y);
      }
    }
    return years.toList()..sort((a, b) => b.compareTo(a));
  }

  /// Resolves the vehicle for make/model/year (web `FilterByVehicle`).
  Future<int?> fetchVehicleId({
    required int makeId,
    required int modelId,
    required int year,
  }) async => (await fetchVehicleMatch(
    makeId: makeId,
    modelId: modelId,
    year: year,
  ))?.id;

  /// Same lookup, also returning the "model trim engine" label the web shows
  /// in the green confirmation chip.
  Future<VehicleMatch?> fetchVehicleMatch({
    required int makeId,
    required int modelId,
    required int year,
  }) async {
    final response = await _dio.get(
      'vehicles',
      queryParameters: {'make_id': makeId, 'model_id': modelId, 'year': year},
    );
    final data =
        (response.data as Map<String, dynamic>)['data'] as List<dynamic>;
    if (data.isEmpty) return null;
    final v = data.first as Map<String, dynamic>;
    final model = (v['model'] as Map<String, dynamic>?)?['name'];
    final label = [
      model,
      v['trim_name'],
      v['engine'],
    ].where((e) => e != null && e.toString().isNotEmpty).join(' ');
    return VehicleMatch(id: (v['id'] as num).toInt(), label: label);
  }

  Future<List<TyreSize>> fetchTyreSizes() async {
    final response = await _dio.get('fitments/sizes');
    final data =
        (response.data as Map<String, dynamic>)['data'] as List<dynamic>;
    return data
        .map((e) => TyreSize.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

final storeRepositoryProvider = Provider<StoreRepository>((ref) {
  return StoreRepository(ref.watch(apiClientProvider));
});

final brandsProvider = FutureProvider<List<Brand>>((ref) {
  return ref.watch(storeRepositoryProvider).fetchBrands();
});

final vehicleMakesProvider = FutureProvider<List<VehicleOption>>((ref) {
  return ref.watch(storeRepositoryProvider).fetchVehicleMakes();
});

final vehicleModelsProvider = FutureProvider.family<List<VehicleOption>, int>((
  ref,
  makeId,
) {
  return ref.watch(storeRepositoryProvider).fetchVehicleModels(makeId);
});

final vehicleYearsProvider = FutureProvider.family<List<int>, int>((
  ref,
  modelId,
) {
  return ref.watch(storeRepositoryProvider).fetchVehicleYears(modelId);
});

final tyreSizesProvider = FutureProvider<List<TyreSize>>((ref) {
  return ref.watch(storeRepositoryProvider).fetchTyreSizes();
});
