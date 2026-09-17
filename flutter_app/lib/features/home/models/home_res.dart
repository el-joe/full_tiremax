import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/models/brand.dart';
import '../../../core/models/governorate.dart';
import '../../product/models/product.dart';

part 'home_res.freezed.dart';
part 'home_res.g.dart';

/// Mirrors `frontend/types/homeRes.type.ts` (`IHomeResponse`).
@freezed
abstract class HomeRes with _$HomeRes {
  const factory HomeRes({
    @Default(<Product>[]) List<Product> featured,
    @Default(<Product>[]) List<Product> best_sellers,
    @Default(<Product>[]) List<Product> new_arrivals,
    @Default(<Product>[]) List<Product> offers,
    @Default(<Brand>[]) List<Brand> brands,
    @Default(<Governorate>[]) List<Governorate> governorates,
  }) = _HomeRes;

  factory HomeRes.fromJson(Map<String, dynamic> json) =>
      _$HomeResFromJson(json);
}
