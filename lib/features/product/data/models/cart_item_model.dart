// cart_item_model.dart
import 'package:bai8_duan_final_bloc/features/product/domain/entities/cart_item.dart';

class CartItemModel {
  // final CartItem entity;
  // CartItemModel(this.entity);
  final int id;
  final String name;
  final String code;
  final double price;
  final int stock;
  final String image;
  final String description;
  int count;

  CartItemModel({
    required this.id,
    required this.name,
    required this.code,
    required this.price,
    required this.stock,
    required this.image,
    required this.description,
    required this.count,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      price: (json['price'] as num).toDouble(),
      stock: json['stock'],
      image: json['image'],
      description: json['description'],
      count: json['count'],
    );
  }

  factory CartItemModel.fromEntity(CartItem entity) {
    return CartItemModel(
      id: entity.id,
      name: entity.name,
      code: entity.code,
      price: entity.price,
      stock: entity.stock,
      image: entity.image,
      description: entity.description,
      count: entity.count,
    );
  }

  CartItem toEntity() {
    return CartItem(
      id: id,
      name: name,
      code: code,
      price: price,
      stock: stock,
      image: image,
      description: description,
      count: count,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'price': price,
      'stock': stock,
      'image': image,
      'description': description,
      'count': count,
    };
  }
}
