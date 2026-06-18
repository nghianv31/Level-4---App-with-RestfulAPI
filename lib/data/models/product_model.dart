import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.title,
    required super.price,
    required super.description,
    required super.imageUrl,
    required super.rating,
    required super.category,
    required super.sku,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      category: json['category'] ?? '',
      sku: json['sku'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
      'rating': rating,
      'category': category,
      'sku': sku,
    };
  }
}
