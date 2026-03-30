import 'package:flutter/material.dart';
import 'package:random_coffee/core/constants/app_constants.dart';

class CartBottomSheet extends StatelessWidget {
  const CartBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

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
                      _buildHeader(context, cs),
                      Divider(
                          height: 1, color: cs.outline.withValues(alpha: 0.3)),
                      Flexible(
                        flex: 2,
                        child: ListView(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          children: [
                            _buildItem(context, 'Олеато 2', 278),
                            _buildItem(context, 'Капучино', 229),
                            _buildItem(context, 'Олеато 2', 278),
                            _buildItem(context, 'Капучино', 229),
                            _buildItem(context, 'Капучино', 229),
                            _buildItem(context, 'Капучино', 229),
                            _buildItem(context, 'Олеато 2', 278),
                            _buildItem(context, 'Капучино', 229),
                            _buildItem(context, 'Капучино', 229),
                            _buildItem(context, 'Капучино', 229),
                            _buildItem(context, 'Олеато 2', 278),
                            _buildItem(context, 'Капучино', 229),
                            _buildItem(context, 'Капучино', 229),

                          ],
                        ),
                      ),
                      Divider(
                          height: 1, color: cs.outline.withValues(alpha: 0.3)),
                      _buildTotal(cs),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _buildOrderButton(context, cs),
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

  Widget _buildHeader(BuildContext context, ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.horizontalPadding,
        vertical: AppConstants.verticalPadding,
      ),
      child: Row(
        children: [
          Text(
            "Ваш заказ",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w400,
              color: cs.onSurface,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.delete,
              color: cs.outline,
              size: 32,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, String name, int price) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.horizontalPadding,
        vertical: AppConstants.verticalPadding,
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            color: cs.surface,
            child: Image.asset(
              "assets/images/coffee.png",
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(
            width: AppConstants.verticalPadding,
          ),
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
                fontSize: 16, color: cs.onSurface, fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }

  Widget _buildTotal(ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.horizontalPadding,
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
            '507 ₽',
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

  Widget _buildOrderButton(BuildContext context, ColorScheme cs) {
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
          onPressed: () {
            //отправить заказ
          },
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
          child: const Text('Оформить заказ'),
        ),
      ),
    );
  }
}
