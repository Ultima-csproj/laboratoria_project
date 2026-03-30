import 'cart_item_model.dart';

class CartModel {
  final List<CartItemModel> items;
  final int total;

  const CartModel({
    required this.items,
    required this.total,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      items: (json['items'] as List<dynamic>)
          .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
    );
  }

  bool get isEmpty => items.isEmpty;
}