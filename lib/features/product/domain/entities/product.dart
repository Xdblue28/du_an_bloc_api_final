import 'package:bai8_duan_final_bloc/features/product/domain/entities/product_category.dart';

class Product {
  final int id;
  final int status;
  final DateTime create_At;
  final DateTime update_At;
  final String name;
  final String code;
  final double price;
  final int stock;
  final String description;
  final String linkImage;
  final ProductCategory category;
  Product({
    required this.id,
    required this.status,
    required this.create_At,
    required this.update_At,
    required this.name,
    required this.code,
    required this.price,
    required this.stock,
    required this.description,
    required this.linkImage,
    required this.category,
  });
}
//