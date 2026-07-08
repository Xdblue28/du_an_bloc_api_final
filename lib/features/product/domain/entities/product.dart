import 'package:bai8_duan_final_bloc/features/product/domain/entities/product_category.dart';

class Product {
  int id;
  int status;
  DateTime create_At;
  DateTime update_At;
  String name;
  String code;
  double price;
  int stock;
  String description;
  String linkImage;
  ProductCategory category;
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
