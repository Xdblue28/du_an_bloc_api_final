import 'package:bai8_duan_final_bloc/features/product/domain/repositories/product_repository.dart';

class DeleteProductUsecase {
  final ProductRepository _repo;
  DeleteProductUsecase(this._repo);
  Future<void> call(int id) async {
    return _repo.deleteProduct(id);
  }
}
//