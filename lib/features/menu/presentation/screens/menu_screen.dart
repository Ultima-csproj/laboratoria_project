import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_coffee/core/constants/app_constants.dart';
import 'package:random_coffee/core/theme/app_images.dart';
import 'package:random_coffee/core/theme/theme_provider.dart';
import 'package:random_coffee/features/cart/presentation/providers/cart_provider.dart';
import 'package:random_coffee/features/cart/presentation/widgets/cart_bottom_sheet.dart';
import 'package:random_coffee/features/menu/data/models/product_model.dart';
import 'package:random_coffee/features/menu/presentation/providers/menu_provider.dart';
import 'package:random_coffee/features/menu/presentation/widgets/category_tabs.dart';
import 'package:random_coffee/features/menu/presentation/widgets/product_card.dart';
import 'package:random_coffee/features/product_detail/presentation/screens/product_detail_screen.dart';

class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key});

  @override
  ConsumerState<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen> {
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _categoryKeys = {};

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToCategory(int categoryIndex) {
    final key = _categoryKeys[categoryIndex];
    final categoryContext = key?.currentContext;

    if (categoryContext == null) return;

    Scrollable.ensureVisible(
      categoryContext,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      alignment: 0.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final menuAsync = ref.watch(menuProvider);
    final cartState = ref.watch(cartProvider);
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            menuAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (_, __) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Не удалось загрузить меню',
                      style: TextStyle(
                        color: cs.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        ref.read(menuProvider.notifier).retry();
                      },
                      child: const Text('Повторить'),
                    ),
                  ],
                ),
              ),
              data: (menuState) {
                for (int i = 0; i < menuState.categories.length; i++) {
                  _categoryKeys.putIfAbsent(i, () => GlobalKey());
                }

                return Column(
                  children: [
                    const SizedBox(height: AppConstants.verticalPadding),

                    CategoryTabs(
                      categories: menuState.categories,
                      selectedIndex: menuState.selectedCategoryIndex,
                      onSelected: (index) {
                        ref.read(menuProvider.notifier).selectCategory(index);
                        _scrollToCategory(index);
                      },
                    ),

                    const SizedBox(height: AppConstants.componentSpacing),

                    Expanded(
                      child: _buildList(menuState),
                    ),
                  ],
                );
              },
            ),

            Positioned(
              left: AppConstants.verticalPadding,
              bottom: AppConstants.verticalPadding,
              child: GestureDetector(
                onTap: () {
                  ref.read(themeModeProvider.notifier).toggle();
                },
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: cs.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ImageIcon(
                    AssetImage(
                      isDark ? AppImages.darkmoon : AppImages.lightsun,
                    ),
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),

            if (!cartState.isEmpty)
              Positioned(
                right: AppConstants.verticalPadding,
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
                          '${cartState.total} ₽',
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

  Widget _buildList(MenuState menuState) {
    final cs = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.verticalPadding,
        vertical: AppConstants.horizontalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < menuState.categories.length; i++) ...[
            if (i > 0) const SizedBox(height: AppConstants.verticalPadding),

            Container(
              key: _categoryKeys[i],
              child: Text(
                menuState.categories[i].name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),
            ),

            const SizedBox(height: AppConstants.verticalPadding),

            _buildGrid(
              menuState.productsByCategory[menuState.categories[i].id] ?? [],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGrid(List<ProductModel> products) {
    final rows = <Widget>[];

    for (int i = 0; i < products.length; i += 2) {
      if (i > 0) {
        rows.add(const SizedBox(height: 20));
      }

      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ProductCard(
                product: products[i],
                onTap: () => _openDetail(products[i]),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: i + 1 < products.length
                  ? ProductCard(
                product: products[i + 1],
                onTap: () => _openDetail(products[i + 1]),
              )
                  : const SizedBox(),
            ),
          ],
        ),
      );
    }

    return Column(children: rows);
  }

  void _openDetail(ProductModel product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailScreen(product: product),
      ),
    );
  }
}