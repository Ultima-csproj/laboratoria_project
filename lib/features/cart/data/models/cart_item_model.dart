import 'package:random_coffee/features/menu/data/models/product_model.dart';

class CartItemModel {
  final ProductModel product;
  final int quantity;
  final int totalPrice;

  const CartItemModel({
    required this.product,
    required this.quantity,
    required this.totalPrice,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      product: ProductModel.fromJson(
        json['product'] as Map<String, dynamic>? ?? {},
      ),
      quantity: _normalizeQuantity((json['quantity'] as num?)?.toInt() ?? 0),
      totalPrice: (json['total_price'] as num?)?.toInt() ?? 0,
    );
  }

  static int _normalizeQuantity(int quantity) {
    if (quantity < 0) return 0;
    if (quantity > 10) return 10;
    return quantity;
  }
}

class CartModel {
  final List<CartItemModel> items;
  final int total;

  const CartModel({
    required this.items,
    required this.total,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toInt() ?? 0,
    );
  }

  bool get isEmpty => items.isEmpty;
}