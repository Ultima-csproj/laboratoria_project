import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_coffee/core/constants/app_constants.dart';
import 'package:random_coffee/features/cart/presentation/providers/cart_provider.dart';
import 'package:random_coffee/features/menu/data/models/product_model.dart';

class ProductCard extends ConsumerWidget {
  final ProductModel product;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final cartState = ref.watch(cartProvider);
    final quantity = cartState.getQuantity(product.id);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: AppConstants.cardImageHeight,
              width: double.infinity,
              child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                  ? Image.network(
                product.imageUrl!,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.coffee_outlined,
                  size: 48,
                  color: cs.onSurface.withValues(alpha: 0.2),
                ),
              )
                  : Icon(
                Icons.coffee_outlined,
                size: 48,
                color: cs.onSurface.withValues(alpha: 0.2),
              ),
            ),

            Text(
              product.name,
              style: TextStyle(
                fontSize: 14,
                color: cs.onSurface,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: AppConstants.componentSpacing),

            if (quantity == 0)
              _buildBuyRow(ref, cs)
            else
              _buildQuantityRow(ref, cs, quantity),
          ],
        ),
      ),
    );
  }

  Widget _buildBuyRow(WidgetRef ref, ColorScheme cs) {
    return Row(
      children: [
        Text(
          '${product.price} ₽',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: cs.onSurface,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            ref.read(cartProvider.notifier).addItem(product.id);
          },
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: cs.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.add,
              size: 20,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityRow(WidgetRef ref, ColorScheme cs, int quantity) {
    final canInc = quantity < AppConstants.maxItemQuantity;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildQtyBtn(
          icon: Icons.remove,
          cs: cs,
          enabled: true,
          onTap: () {
            ref.read(cartProvider.notifier).decrementItem(product.id);
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            '$quantity',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: cs.onSurface,
            ),
          ),
        ),
        _buildQtyBtn(
          icon: Icons.add,
          cs: cs,
          enabled: canInc,
          onTap: canInc
              ? () {
            ref.read(cartProvider.notifier).incrementItem(product.id);
          }
              : null,
        ),
      ],
    );
  }

  Widget _buildQtyBtn({
    required IconData icon,
    required ColorScheme cs,
    required bool enabled,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: cs.outline.withValues(alpha: enabled ? 0.6 : 0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          icon,
          size: 20,
          color: cs.onSurface.withValues(alpha: enabled ? 0.8 : 0.3),
        ),
      ),
    );
  }
}