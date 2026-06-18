class Product {
  final String id;
  final String title;
  final double price;
  final String description;
  final String imageUrl;
  final double rating;
  final String category;
  final String sku;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.category,
    required this.sku,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
