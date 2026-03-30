import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_coffee/features/menu/data/models/category_model.dart';
import 'package:random_coffee/features/menu/data/models/product_model.dart';
import 'package:random_coffee/features/menu/data/repositories/menu_repository.dart';

class MenuState {
  final List<CategoryModel> categories;
  final Map<int, List<ProductModel>> productsByCategory;
  final int selectedCategoryIndex;

  const MenuState({
    this.categories = const [],
    this.productsByCategory = const {},
    this.selectedCategoryIndex = 0,
  });

  MenuState copyWith({
    List<CategoryModel>? categories,
    Map<int, List<ProductModel>>? productsByCategory,
    int? selectedCategoryIndex,
  }) {
    return MenuState(
      categories: categories ?? this.categories,
      productsByCategory: productsByCategory ?? this.productsByCategory,
      selectedCategoryIndex:
          selectedCategoryIndex ?? this.selectedCategoryIndex,
    );
  }
}

final menuProvider =
      AsyncNotifierProvider<MenuNotifier, MenuState>(MenuNotifier.new);

class MenuNotifier extends AsyncNotifier<MenuState> {
  @override
  Future<MenuState> build() async {
    return _loadAll();
  }

  Future<MenuState> _loadAll() async {
    final repo = ref.read(menuRepositoryProvider);

    final categories = await repo.getCategories();

    final productsByCategory = <int, List<ProductModel>>{};
    for (final cat in categories) {
      final products = await repo.getProducts(categoryId: cat.id);
      productsByCategory[cat.id] = products;
    }

    return MenuState(
      categories: categories,
      productsByCategory: productsByCategory,
    );
  }

  void selectCategory(int index) {
    final current = state.value;
    if(current == null) return;
    state = AsyncData(current.copyWith(selectedCategoryIndex: index));
  }

  Future<void> retry() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_loadAll);
  }
}