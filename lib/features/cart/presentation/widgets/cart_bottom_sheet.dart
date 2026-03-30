import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_coffee/core/constants/app_constants.dart';
import 'package:random_coffee/core/theme/app_images.dart';
import 'package:random_coffee/features/cart/presentation/providers/cart_provider.dart';
import 'package:random_coffee/core/theme/app_colors.dart';

class CartBottomSheet extends ConsumerWidget {
  const CartBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final cartState = ref.watch(cartProvider);
    final expandedItems = cartState.expandedItems;

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        const SizedBox(height: 106),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 80),
                  child: Column(
                    children: [
                      _buildHandle(cs),
                      _buildHeader(context, ref, cs),
                      Divider(
                        height: 1,
                        color: cs.outline.withValues(alpha: 0.3),
                      ),
                      Flexible(
                        flex: 2,
                        child: expandedItems.isEmpty
                            ? Center(
                          child: Text(
                            'Корзина пуста',
                            style: TextStyle(
                              fontSize: 16,
                              color: cs.onSurface,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )
                            : ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: expandedItems.length,
                          itemBuilder: (context, index) {
                            final item = expandedItems[index];
                            return _buildItem(
                              context,
                              item.product.name,
                              item.product.price,
                              item.product.imageUrl,
                            );
                          },
                        ),
                      ),
                      Divider(
                        height: 1,
                        color: cs.outline.withValues(alpha: 0.3),
                      ),
                      _buildTotal(cs, cartState.total),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _buildOrderButton(context, ref, cs, cartState),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHandle(ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: cs.outline,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: AppConstants.verticalPadding,
      ),
      child: Row(
        children: [
          Text(
            'Ваш заказ',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w400,
              color: cs.onSurface,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () async {
              await ref.read(cartProvider.notifier).clearCart();
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: ImageIcon(
              AssetImage(AppImages.deletetrash),
              color: cs.outline,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(
      BuildContext context,
      String name,
      int price,
      String? imageUrl,
      ) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: AppConstants.verticalPadding,
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            color: cs.surface,
            child: imageUrl != null && imageUrl.isNotEmpty
                ? Image.network(
              imageUrl,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Icon(
                Icons.coffee,
                color: cs.onSurface.withValues(alpha: 0.3),
              ),
            )
                : Icon(
              Icons.coffee,
              color: cs.onSurface.withValues(alpha: 0.3),
            ),
          ),
          const SizedBox(width: AppConstants.verticalPadding),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 16,
                color: cs.onSurface,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Text(
            '$price ₽',
            style: TextStyle(
              fontSize: 16,
              color: cs.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotal(ColorScheme cs, int total) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: AppConstants.verticalPadding,
      ),
      child: Row(
        children: [
          Text(
            'Итого',
            style: TextStyle(
              fontSize: 16,
              color: cs.onSurface,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Spacer(),
          Text(
            '$total ₽',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: cs.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderButton(
      BuildContext context,
      WidgetRef ref,
      ColorScheme cs,
      CartState cartState,
      ) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppConstants.horizontalPadding,
        right: AppConstants.horizontalPadding,
        bottom: AppConstants.horizontalPadding,
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: cartState.isOrdering || cartState.isEmpty
              ? null
              : () => _handleOrder(context, ref),
          style: ElevatedButton.styleFrom(
            backgroundColor: cs.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(26),
            ),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          child: cartState.isOrdering
              ? const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
              : const Text('Оформить заказ'),
        ),
      ),
    );
  }

  Future<void> _handleOrder(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);

    final success = await ref.read(cartProvider.notifier).placeOrder();

    if (!context.mounted) return;

    messenger.clearSnackBars();

    if (success) {
      Navigator.pop(context);

      messenger.showSnackBar(
        const SnackBar(
          content: Text('Заказ создан'),
          duration: Duration(seconds: 2),
          backgroundColor: AppColors.neutral3,
        ),
      );
    } else {
      Navigator.pop(context);

      messenger.showSnackBar(
        const SnackBar(
          content: Text('Возникла ошибка при заказе'),
          duration: Duration(seconds: 2),
          backgroundColor: AppColors.neutral3,
        ),
      );
    }

    ref.read(cartProvider.notifier).resetStatus();
  }
}