class ProductModel {
  final int id;
  final String name;
  final String? description;
  final int price;
  final String? imageUrl;
  final int categoryId;

  const ProductModel({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.imageUrl,
    required this.categoryId,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
        id: json['id'] as int,
        name: json['name'] as String,
        description: json['description'] as String?,
        price: json['price'] as int,
        imageUrl: json['image_url'] as String?,
        categoryId: json['category_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image_url': imageUrl,
      'category_id': categoryId,
    };
  }
}