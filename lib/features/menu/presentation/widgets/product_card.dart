import 'package:flutter/material.dart';
import 'package:random_coffee/core/constants/app_constants.dart';
import 'package:random_coffee/core/theme/app_colors.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final int price;
  final int quantity;
  final VoidCallback onTap;
  final VoidCallback onAdd;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    this.quantity = 0,
    required this.onTap,
    required this.onAdd,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: AppConstants.cardImageHeight,
              width: double.infinity,
              child: Image.asset('assets/images/coffee.png', height: AppConstants.cardImageHeight,),
            ),
            SizedBox(height: AppConstants.componentSpacing),
            Text(
              name,
              style: TextStyle(fontSize: 22, color: cs.onSurface, fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppConstants.componentSpacing),
            if (quantity == 0) _buyRow(cs) else _quantityRow(cs),
          ],
        ),
      ),
    );
  }

  Widget _buyRow(ColorScheme cs) {
    return Row(
      children: [
        Text(
          '$price ₽',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: cs.onSurface,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onAdd,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: cs.primary,
              borderRadius: BorderRadius.circular(100),
            ),
            child: const Icon(Icons.add, size: 24, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _quantityRow(ColorScheme cs) {
    final canInc = quantity < AppConstants.maxItemQuantity;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _qtyBtn(Icons.remove, onDecrement, cs, true),
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
        _qtyBtn(Icons.add, canInc ? onIncrement : null, cs, canInc),
      ],
    );
  }

  Widget _qtyBtn(
    IconData icon,
    VoidCallback? onTap,
    ColorScheme cs,
    bool enabled,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.neutral2Dark.withValues(alpha: enabled ? 0.4 : 0.2),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Icon(
          icon,
          size: 24,
          color: cs.onSurface.withValues(alpha: enabled ? 0.8 : 0.3),
        ),
      ),
    );
  }
}
