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
    this.brandId,
    this.categoryId,
    this.minPrice,
    this.maxPrice,
    this.sort,
    this.make,
    this.model,
    this.year,
    this.width,
    this.aspectRatio,
    this.rimDiameter,
  });

  final String? search;
  final int? brandId;
  final int? categoryId;
  final num? minPrice;
  final num? maxPrice;
  final String? sort;
  final String? make;
  final String? model;
  final int? year;
  final num? width;
  final num? aspectRatio;
  final num? rimDiameter;

  ProductFilters copyWith({
    String? search,
    int? brandId,
    bool clearBrand = false,
    int? categoryId,
    num? minPrice,
    num? maxPrice,
    String? sort,
    String? make,
    bool clearMake = false,
    String? model,
    bool clearModel = false,
    int? year,
    bool clearYear = false,
    num? width,
    num? aspectRatio,
    num? rimDiameter,
    bool clearSize = false,
  }) {
    return ProductFilters(
      search: search ?? this.search,
      brandId: clearBrand ? null : (brandId ?? this.brandId),
      categoryId: categoryId ?? this.categoryId,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      sort: sort ?? this.sort,
      make: clearMake ? null : (make ?? this.make),
      model: clearModel ? null : (model ?? this.model),
      year: clearYear ? null : (year ?? this.year),
      width: clearSize ? null : (width ?? this.width),
      aspectRatio: clearSize ? null : (aspectRatio ?? this.aspectRatio),
      rimDiameter: clearSize ? null : (rimDiameter ?? this.rimDiameter),
    );
  }

  Map<String, dynamic> toQuery(int page) {
    return {
      'page': page,
      'per_page': 15,
      if (search != null && search!.isNotEmpty) 'search': search,
      if (brandId != null) 'brand_id': brandId,
      if (categoryId != null) 'category_id': categoryId,
      if (minPrice != null) 'min_price': minPrice,
      if (maxPrice != null) 'max_price': maxPrice,
      if (sort != null) 'sort': sort,
      if (make != null) 'make': make,
      if (model != null) 'model': model,
      if (year != null) 'year': year,
      if (width != null) 'width': width,
      if (aspectRatio != null) 'aspect_ratio': aspectRatio,
      if (rimDiameter != null) 'rim_diameter': rimDiameter,
    };
  }
}

class StoreRepository {
  StoreRepository(this._dio);

  final Dio _dio;

  Future<PaginatedResponse<Product>> fetchProducts({
    required int page,
    required ProductFilters filters,
  }) async {
    final response = await _dio.get('products', queryParameters: filters.toQuery(page));
    return PaginatedResponse.fromJson(
      response.data as Map<String, dynamic>,
      (json) => Product.fromJson(json),
    );
  }

  Future<List<Brand>> fetchBrands() async {
    final response = await _dio.get('brands');
    final data = (response.data as Map<String, dynamic>)['data'] as List<dynamic>;
    return data.map((e) => Brand.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<String>> fetchVehicleMakes() async {
    final response = await _dio.get('vehicles/makes');
    final data = (response.data as Map<String, dynamic>)['data'] as List<dynamic>;
    return data.map((e) => e.toString()).toList();
  }

  Future<List<String>> fetchVehicleModels(String make) async {
    final response = await _dio.get('vehicles/makes/$make/models');
    final data = (response.data as Map<String, dynamic>)['data'] as List<dynamic>;
    return data.map((e) => e.toString()).toList();
  }

  Future<List<int>> fetchVehicleYears(String model) async {
    final response = await _dio.get('vehicles/models/$model/years');
    final data = (response.data as Map<String, dynamic>)['data'] as List<dynamic>;
    return data.map((e) => (e as num).toInt()).toList();
  }

  Future<List<TyreSize>> fetchTyreSizes() async {
    final response = await _dio.get('fitments/sizes');
    final data = (response.data as Map<String, dynamic>)['data'] as List<dynamic>;
    return data.map((e) => TyreSize.fromJson(e as Map<String, dynamic>)).toList();
  }
}

final storeRepositoryProvider = Provider<StoreRepository>((ref) {
  return StoreRepository(ref.watch(apiClientProvider));
});

final brandsProvider = FutureProvider<List<Brand>>((ref) {
  return ref.watch(storeRepositoryProvider).fetchBrands();
});

final vehicleMakesProvider = FutureProvider<List<String>>((ref) {
  return ref.watch(storeRepositoryProvider).fetchVehicleMakes();
});

final vehicleModelsProvider = FutureProvider.family<List<String>, String>((ref, make) {
  return ref.watch(storeRepositoryProvider).fetchVehicleModels(make);
});

final vehicleYearsProvider = FutureProvider.family<List<int>, String>((ref, model) {
  return ref.watch(storeRepositoryProvider).fetchVehicleYears(model);
});

final tyreSizesProvider = FutureProvider<List<TyreSize>>((ref) {
  return ref.watch(storeRepositoryProvider).fetchTyreSizes();
});
