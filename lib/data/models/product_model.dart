import 'package:hive/hive.dart';
import '../../domain/entities/product.dart';

part 'product_model.g.dart';

@HiveType(typeId: 0)
class ProductModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double price;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final String imageUrl;

  @HiveField(5)
  final double rating;

  @HiveField(6)
  final String category;

  @HiveField(7)
  final String sku;

  const ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.category,
    required this.sku,
  });

  Product toEntity() {
    return Product(
      id: id,
      title: title,
      price: price,
      description: description,
      imageUrl: imageUrl,
      rating: rating,
      category: category,
      sku: sku,
    );
  }

  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      title: product.title,
      price: product.price,
      description: product.description,
      imageUrl: product.imageUrl,
      rating: product.rating,
      category: product.category,
      sku: product.sku,
    );
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id']?.toString() ?? '',
      title: json['name'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] ?? '',
      imageUrl: json['image'] ?? '',
      rating: 0.0,
      category: json['category_id'] is Map
          ? (json['category']['name'] ?? '')
          : json['category_id']?.toString() ?? '',
      sku: json['code'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": title,
      "code": sku,
      "price": price,
      "stock": 100,
      "category_id": 100,
      "description": description,
      "image": imageUrl,
    };
  }
}
