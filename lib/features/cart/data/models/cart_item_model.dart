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
        product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
        quantity: json['quantity'] as int ,
        totalPrice: json['totalPrice'] as int,
    );
  }
}

