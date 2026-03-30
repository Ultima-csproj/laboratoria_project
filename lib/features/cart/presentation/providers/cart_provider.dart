import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_coffee/core/constants/app_constants.dart';
import 'package:random_coffee/features/cart/data/models/cart_item_model.dart';
import 'package:random_coffee/features/cart/data/repositories/cart_repository.dart';
import 'package:random_coffee/features/order/data/repositories/order_repository.dart';


class CartState {
  final CartModel? cart;
  final bool isOrdering;
  final String? orderError;
  final bool orderSuccess;
  final String? error;

  const CartState({
    this.cart,
    this.isOrdering = false,
    this.orderError,
    this.orderSuccess = false,
    this.error,
  });

  bool get isEmpty => cart == null || cart!.items.isEmpty;

  int get total => cart?.total ?? 0;

  List<CartItemModel> get items => cart?.items ?? [];

  int get totalItems {
    int sum = 0;
    for (final item in items) {
      sum += item.quantity;
    }
    return sum;
  }

  bool get canAddMore => totalItems < AppConstants.maxItemQuantity;

  int getQuantity(int productId) {
    for (final item in items) {
      if (item.product.id == productId) {
        if (item.quantity < 0) return 0;
        if (item.quantity > AppConstants.maxItemQuantity) {
          return AppConstants.maxItemQuantity;
        }
        return item.quantity;
      }
    }
    return 0;
  }

  List<CartItemModel> get expandedItems {
    final result = <CartItemModel>[];

    for (final item in items) {
      for (int i = 0; i < item.quantity; i++) {
        result.add(
          CartItemModel(
            product: item.product,
            quantity: 1,
            totalPrice: item.product.price,
          ),
        );
      }
    }

    return result;
  }

  CartState copyWith({
    CartModel? cart,
    bool? isOrdering,
    String? orderError,
    bool? orderSuccess,
    String? error,
  }) {
    return CartState(
      cart: cart ?? this.cart,
      isOrdering: isOrdering ?? this.isOrdering,
      orderError: orderError,
      orderSuccess: orderSuccess ?? this.orderSuccess,
      error: error,
    );
  }
}

final cartProvider =
NotifierProvider<CartNotifier, CartState>(CartNotifier.new);

class CartNotifier extends Notifier<CartState> {
  @override
  CartState build() {
    _loadCart();
    return const CartState();
  }

  CartRepository get _cartRepo => ref.read(cartRepositoryProvider);
  OrderRepository get _orderRepo => ref.read(orderRepositoryProvider);

  Future<void> _loadCart() async {
    try {
      final cart = await _cartRepo.getCart();
      state = state.copyWith(cart: cart, error: null);
    } catch (e) {
      debugPrint('Cart load error: $e');
      state = state.copyWith(error: 'Не удалось загрузить корзину');
    }
  }

  Future<void> refresh() async {
    await _loadCart();
  }

  Future<void> addItem(int productId) async {
    if (state.totalItems >= AppConstants.maxItemQuantity) {
      state = state.copyWith(error: 'Нельзя добавить больше 10 товаров');
      return;
    }

    try {
      final cart = await _cartRepo.addItem(productId, quantity: 1);
      state = state.copyWith(cart: cart, error: null);
    } catch (e) {
      debugPrint('Add item error: $e');
      state = state.copyWith(error: 'Не удалось добавить товар');
    }
  }

  Future<void> incrementItem(int productId) async {
    final currentQty = state.getQuantity(productId);

    if (currentQty >= AppConstants.maxItemQuantity) return;

    if (state.totalItems >= AppConstants.maxItemQuantity) {
      state = state.copyWith(error: 'Нельзя добавить больше 10 товаров');
      return;
    }

    try {
      final cart = await _cartRepo.updateQuantity(productId, currentQty + 1);
      state = state.copyWith(cart: cart, error: null);
    } catch (e) {
      debugPrint('Increment item error: $e');
      state = state.copyWith(error: 'Не удалось увеличить количество');
    }
  }

  Future<void> decrementItem(int productId) async {
    final currentQty = state.getQuantity(productId);

    try {
      if (currentQty > 1) {
        final cart = await _cartRepo.updateQuantity(productId, currentQty - 1);
        state = state.copyWith(cart: cart, error: null);
      } else {
        final cart = await _cartRepo.removeItem(productId);
        state = state.copyWith(cart: cart, error: null);
      }
    } catch (e) {
      debugPrint('Decrement item error: $e');
      state = state.copyWith(error: 'Не удалось уменьшить количество');
    }
  }

  Future<void> clearCart() async {
    try {
      final cart = await _cartRepo.clearCart();
      state = state.copyWith(cart: cart, error: null);
    } catch (e) {
      debugPrint('Clear cart error: $e');
      state = state.copyWith(error: 'Не удалось очистить корзину');
    }
  }

  Future<bool> placeOrder() async {
    state = state.copyWith(
      isOrdering: true,
      orderError: null,
      orderSuccess: false,
    );

    try {
      final response = await _orderRepo.createOrder();

      if (response.success) {
        state = const CartState(
          cart: null,
          isOrdering: false,
          orderSuccess: true,
        );
        return true;
      } else {
        state = state.copyWith(
          isOrdering: false,
          orderError: 'Возникла ошибка при заказе',
        );
        return false;
      }
    } on DioException catch (e) {
      debugPrint('Order Dio error: $e');

      state = state.copyWith(
        isOrdering: false,
        orderError: 'Возникла ошибка при заказе',
      );
      return false;
    } catch (e) {
      debugPrint('Order error: $e');

      state = state.copyWith(
        isOrdering: false,
        orderError: 'Возникла ошибка при заказе',
      );
      return false;
    }
  }

  void resetStatus() {
    state = state.copyWith(
      orderError: null,
      orderSuccess: false,
    );
  }

}