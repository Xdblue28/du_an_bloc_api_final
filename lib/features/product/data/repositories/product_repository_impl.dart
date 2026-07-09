import 'package:bai8_duan_final_bloc/features/product/data/datasource/product_remote_datasource.dart';
import 'package:bai8_duan_final_bloc/features/product/domain/entities/product.dart';
import 'package:bai8_duan_final_bloc/features/product/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  ProductRemoteDatasource remoteData;
  ProductRepositoryImpl(this.remoteData);
  @override
  Future<void> addProduct(Product product) async {
    await remoteData.addProduct(product);
  }

  @override
  Future<void> deleteProduct(int id) async {
    await remoteData.deleteProduct(id);
  }

  @override
  Future<List<Product>> loadProduct(int? categoryId) async {
    final List<Product> productModel = await remoteData.loadProduct(categoryId);
    return productModel;
  }

  @override
  Future<void> updateProduct(Product product) async {
    await remoteData.updateProduct(product);
  }
}
//