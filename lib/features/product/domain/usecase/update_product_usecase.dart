import 'package:bai8_duan_final_bloc/features/product/domain/entities/product.dart';
import 'package:bai8_duan_final_bloc/features/product/domain/repositories/product_repository.dart';

class UpdateProductUsecase {
  ProductRepository _repo;
  UpdateProductUsecase(this._repo);
  Future<void> call(Product product) async {
    return _repo.updateProduct(product);
  }
}
//