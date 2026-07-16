import 'package:bai8_duan_final_bloc/features/product/domain/entities/product_category.dart';

class CategoryModel extends ProductCategory {
  CategoryModel({required super.id, required super.name});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
//