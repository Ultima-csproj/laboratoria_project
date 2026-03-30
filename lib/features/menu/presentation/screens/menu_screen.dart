import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_coffee/core/constants/app_constants.dart';
import 'package:random_coffee/core/theme/theme_provider.dart';
import 'package:random_coffee/features/menu/presentation/widgets/category_tabs.dart';
import 'package:random_coffee/features/menu/presentation/widgets/product_card.dart';
import 'package:random_coffee/features/product_detail/presentation/screens/product_detail_screen.dart';
import 'package:random_coffee/features/cart/presentation/widgets/cart_bottom_sheet.dart';

class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key});

  @override
  ConsumerState<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen> {
  int _selectedCat = 0;
  final Map<int, int> _cart = {};

  final _mock = const ['Чёрный кофе', 'Дрип кофе', 'Чай', 'Прочее'];

  final _products = List.generate(
    8,
    (i) => _MockProduct(
      id: i,
      name: 'Кофе',
      price: i < 4 ? 451 : 220,
      mock: i < 4 ? 0 : 1,
    ),
  );

  void _add(int id) => setState(() => _cart[id] = 1);

  void _inc(int id) => setState(() {
        if ((_cart[id] ?? 0) < AppConstants.maxItemQuantity) {
          _cart[id] = (_cart[id] ?? 0) + 1;
        }
      });

  void _dec(int id) => setState(() {
        final c = _cart[id] ?? 0;
        if (c > 1) {
          _cart[id] = c - 1;
        } else {
          _cart.remove(id);
        }
      });

  int get _total => _cart.entries.fold(0, (s, e) {
        final p = _products.firstWhere((p) => p.id == e.key);
        return s + p.price * e.value;
      });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: AppConstants.verticalPadding),
                CategoryTabs(
                  categories: _mock,
                  selectedIndex: _selectedCat,
                  onSelected: (i) => setState(() => _selectedCat = i),
                ),
                const SizedBox(height: AppConstants.componentSpacing),
                Expanded(child: _buildList()),
              ],
            ),
            Positioned(
              left: AppConstants.horizontalPadding,
              bottom: AppConstants.verticalPadding,
              child: GestureDetector(
                onTap: () => ref.read(themeModeProvider.notifier).toggle(),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: cs.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isDark ? Icons.nightlight : Icons.wb_sunny_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
            if (_cart.isNotEmpty)
              Positioned(
                right: AppConstants.horizontalPadding,
                bottom: AppConstants.verticalPadding,
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => const CartBottomSheet(),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: cs.primary,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$_total ₽',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    final cs = Theme.of(context).colorScheme;

    final grouped = <int, List<_MockProduct>>{};
    for (final p in _products) {
      grouped.putIfAbsent(p.mock, () => []).add(p);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.horizontalPadding,
        vertical: AppConstants.verticalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int ci = 0; ci < _mock.length; ci++) ...[
            if (ci > 0) const SizedBox(height: AppConstants.verticalPadding),
            if (grouped.containsKey(ci)) ...[
              Text(
                _mock[ci],
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w400,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: AppConstants.verticalPadding),
              _buildGrid(grouped[ci]!),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildGrid(List<_MockProduct> items) {
    final rows = <Widget>[];

    for (int i = 0; i < items.length; i += 2) {
      if (i > 0) {
        rows.add(const SizedBox(height: AppConstants.componentSpacing));
      }

      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildCard(items[i])),
            const SizedBox(width: AppConstants.componentSpacing),
            Expanded(
              child: i + 1 < items.length
                  ? _buildCard(items[i + 1])
                  : const SizedBox(),
            ),
          ],
        ),
      );
    }

    return Column(children: rows);
  }

  Widget _buildCard(_MockProduct p) {
    final qty = _cart[p.id] ?? 0;

    return ProductCard(
      name: p.name,
      price: p.price,
      quantity: qty,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(
              name: p.name,
              price: p.price,
              description:
                  "Кофейный напиток с неожиданным сочетанием ингредиентов – "
                  "кофе арабика Starbucks с добавлением ложки оливкового"
                  " масла Partanna extra virgin холодного отжима, "
                  "что создает восхитительный вкус",
            ),
          ),
        );
      },
      onAdd: () => _add(p.id),
      onIncrement: () => _inc(p.id),
      onDecrement: () => _dec(p.id),
    );
  }
}

class _MockProduct {
  final int id;
  final String name;
  final int price;
  final int mock;

  const _MockProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.mock,
  });
}
