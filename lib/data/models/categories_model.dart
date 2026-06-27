import '../../domain/entities/categories.dart';

class CategoriesModel {
  int id;
  String name;

  CategoriesModel({required this.id, required this.name});

  factory CategoriesModel.fromJson(Map<String, dynamic> json) => CategoriesModel(
    id: json['id'],
    name: json['name'],
  );

  Map<String, dynamic> toJson() => {
    'name': name,
  };

  CategoriesEntity toEntity() => CategoriesEntity(name: name, id: id);
}