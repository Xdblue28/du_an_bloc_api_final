import 'package:bai8_duan_final_bloc/features/product/domain/entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> loadProduct(int? categoryId);
  Future<void> addProduct(Product product);
  Future<void> deleteProduct(int id);
  Future<void> updateProduct(Product product);
}
