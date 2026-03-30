import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_coffee/core/network/api_client.dart';
import 'package:random_coffee/features/cart/data/models/cart_item_model.dart';

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  return CartRepository(ref.read(apiClientProvider));
});

class CartRepository {
  final ApiClient _api;

  CartRepository(this._api);

  Future<CartModel> getCart() async {
    final res = await _api.get('/cart');
    return CartModel.fromJson(res.data as Map<String, dynamic>);
  }

  Future<CartModel> addItem(int productId, {int quantity = 1}) async {
    final res = await _api.post('/cart/items', data: {
      'product_id': productId,
      'quantity': quantity,
    });
    return CartModel.fromJson(res.data as Map<String, dynamic>);
  }

  Future<CartModel> updateQuantity(int productId, int quantity) async {
    final res = await _api.put('/cart/items/$productId', data: {
      'quantity': quantity,
    });
    return CartModel.fromJson(res.data as Map<String, dynamic>);
  }

  Future<CartModel> removeItem(int productId) async {
    final res = await _api.delete('/cart/items/$productId');
    return CartModel.fromJson(res.data as Map<String, dynamic>);
  }

  Future<CartModel> clearCart() async {
    final res = await _api.delete('/cart');
    return CartModel.fromJson(res.data as Map<String, dynamic>);
  }
}