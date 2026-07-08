import 'package:bai8_duan_final_bloc/features/product/domain/entities/product.dart';
import 'package:bai8_duan_final_bloc/features/product/domain/repositories/product_repository.dart';

class LoadProductUsecase {
  final ProductRepository _repo;
  LoadProductUsecase(this._repo);
  Future<List<Product>> call({int? categoryId}) async {
    return _repo.loadProduct(categoryId);
  }
}
