import 'package:bai8_duan_final_bloc/features/product/data/models/category_model.dart';
import 'package:bai8_duan_final_bloc/features/product/domain/entities/product.dart';

class ProductModel extends Product {
  ProductModel({
    required int id,
    required int status,
    required DateTime create_At,
    required DateTime update_At,
    required String name,
    required String code,
    required double price,
    required int stock,
    required String description,
    required String linkImage,
    required CategoryModel category,
  }) : super(
         id: id,
         status: status,
         create_At: create_At,
         update_At: update_At,
         name: name,
         code: code,
         price: price,
         stock: stock,
         description: description,
         linkImage: linkImage,
         category: category,
       );

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int? ?? 0,
      status: json['status'] as int? ?? 0,
      create_At: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      update_At: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
      name: json['name'] as String? ?? '',
      code: json['code'] as String? ?? '',
      price: (json['price'] as num? ?? 0.0).toDouble(),
      stock: json['stock'] as int? ?? 0,
      description: json['description'] as String? ?? '',
      linkImage: json['image'] as String? ?? '',

      // 👈 CHỖ NÀY LÀ QUAN TRỌNG NHẤT:
      // Không để String, gọi trực tiếp từ CategoryModel
      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'] as Map<String, dynamic>)
          : CategoryModel(id: 0, name: "Chưa phân loại"),
    );
  }
}
//