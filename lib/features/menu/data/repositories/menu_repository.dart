import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_coffee/core/constants/api_constants.dart';
import 'package:random_coffee/core/network/api_client.dart';
import 'package:random_coffee/features/menu/data/models/category_model.dart';
import 'package:random_coffee/features/menu/data/models/product_model.dart';

final menuRepositoryProvider = Provider<MenuRepository>((ref) {
  return MenuRepository(ref.read(apiClientProvider));
});

class MenuRepository {
  final ApiClient _api;

  MenuRepository(this._api);

  Future<List<CategoryModel>> getCategories() async {
    final res = await _api.get(ApiConstants.categories);
    return (res.data as List)
        .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<ProductModel>> getProducts({int? categoryId}) async {
    final query = <String, dynamic>{};
    if (categoryId != null) query['category_id'] = categoryId;

    final res = await _api.get(ApiConstants.products, queryParameters: query);
    return (res.data as List)
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ProductModel> getProductById(int id) async {
    final res = await _api.get('${ApiConstants.products}/$id');
    return ProductModel.fromJson(res.data as Map<String, dynamic>);
  }
}