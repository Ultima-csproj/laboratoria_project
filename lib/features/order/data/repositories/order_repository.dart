import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_coffee/core/network/api_client.dart';
import 'package:random_coffee/features/order/data/models/order_model.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepository(ref.read(apiClientProvider));
});

class OrderRepository {
  final ApiClient _api;

  OrderRepository(this._api);

  Future<CreateOrderResponse> createOrder() async {
    final res = await _api.post('/orders');
    return CreateOrderResponse.fromJson(res.data as Map<String, dynamic>);
  }
}