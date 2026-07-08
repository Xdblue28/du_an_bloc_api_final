import 'package:bai8_duan_final_bloc/core/errors/exceptions.dart';
import 'package:bai8_duan_final_bloc/features/product/domain/entities/product.dart';
import 'package:bai8_duan_final_bloc/features/product/domain/entities/product_category.dart';
import 'package:bai8_duan_final_bloc/features/product/domain/usecase/add_product_usecase.dart';
import 'package:bai8_duan_final_bloc/features/product/domain/usecase/delete_product_usecase.dart';
import 'package:bai8_duan_final_bloc/features/product/domain/usecase/load_product_usecase.dart';
import 'package:bai8_duan_final_bloc/features/product/domain/usecase/update_product_usecase.dart';
import 'package:bai8_duan_final_bloc/features/product/presentation/cubit/product_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductCubit extends Cubit<ProductState> {
  final LoadProductUsecase _get;
  final AddProductUsecase _add;
  final DeleteProductUsecase _delete;
  final UpdateProductUsecase _update;

  ProductCubit({
    required LoadProductUsecase get,
    required AddProductUsecase add,
    required DeleteProductUsecase delete,
    required UpdateProductUsecase update,
  }) : _get = get,
       _add = add,
       _delete = delete,
       _update = update,
       super(productInitial());

  int? selectedCategoryId;
  TextEditingController nameP = TextEditingController();
  TextEditingController codeP = TextEditingController();
  TextEditingController priceP = TextEditingController();
  TextEditingController stockP = TextEditingController();
  TextEditingController descriptionP = TextEditingController();
  TextEditingController linkImageP = TextEditingController();

  @override
  Future<void> close() {
    nameP.dispose();
    codeP.dispose();
    priceP.dispose();
    stockP.dispose();
    descriptionP.dispose();
    linkImageP.dispose();
    return super.close();
  }

  void clearForm() {
    nameP.clear();
    codeP.clear();
    priceP.clear();
    stockP.clear();
    descriptionP.clear();
    linkImageP.clear();
  }

  Future<void> loadProduct({required int? categoryId}) async {
    selectedCategoryId = categoryId;
    if (isClosed) return;
    emit(productLoading());
    try {
      final products = await _get(categoryId: categoryId);
      if (isClosed) return;
      emit(productSuccess(products: products));
    } on UnauthorizedException {
      print("[ProductCubit] loadProduct: hết token, đợi AuthCubit navigate...");
    } catch (e) {
      print("Có lỗi trong việc gọi tới server $e");
      if (isClosed) return;
      emit(productFailure());
    }
  }

  Future<void> addProduct({required int categoryId}) async {
    if (isClosed) return;
    emit(productLoading());
    try {
      final newProduct = Product(
        id: 0,
        status: 1,
        create_At: DateTime.now(),
        update_At: DateTime.now(),
        name: nameP.text,
        code: codeP.text,
        price: double.tryParse(priceP.text.trim()) ?? 0.0,
        stock: int.tryParse(stockP.text.trim()) ?? 0,
        description: descriptionP.text,
        linkImage: linkImageP.text,
        category: ProductCategory(id: categoryId, name: ""),
      );
      await _add(newProduct);
      if (isClosed) return;
      await loadProduct(categoryId: selectedCategoryId);
      clearForm();
      print("cubit: thêm thành công");
    } on UnauthorizedException {
      print("[ProductCubit] addProduct: hết token, đợi AuthCubit navigate...");
    } catch (e) {
      print("Có lỗi ở việc gọi server || cubit");
      if (isClosed) return;
      emit(productFailure());
    }
  }

  Future<bool> deleteProduct(int id, {required int? categoryId}) async {
    try {
      await _delete(id);
      if (isClosed) return false;
      await loadProduct(categoryId: categoryId);
      print("cubit: Xóa thành công");
      return true;
    } on UnauthorizedException {
      print(
        "[ProductCubit] deleteProduct: hết token, đợi AuthCubit navigate...",
      );
      return false;
    } catch (e) {
      print("Có lỗi cubit delete Product");
      if (isClosed) return false;
      emit(productFailure());
      return false;
    }
  }

  Future<void> updateProduct(Product product, {required int categoryId}) async {
    if (isClosed) return;
    emit(productLoading());
    try {
      final updateP = Product(
        id: product.id,
        status: 1,
        create_At: product.create_At,
        update_At: DateTime.now(),
        name: nameP.text,
        code: codeP.text,
        price: double.tryParse(priceP.text.trim()) ?? 0.0,
        stock: int.tryParse(stockP.text.trim()) ?? 0,
        description: descriptionP.text,
        linkImage: linkImageP.text,
        category: ProductCategory(id: categoryId, name: ""),
      );
      await _update(updateP);
      if (isClosed) return;
      await loadProduct(categoryId: selectedCategoryId);
      clearForm();
      print("cubit: Cập nhật thành công");
    } on UnauthorizedException {
      print(
        "[ProductCubit] updateProduct: hết token, đợi AuthCubit navigate...",
      );
    } catch (e) {
      print("Có lỗi trong update ở cubit");
      if (isClosed) return;
      emit(productFailure());
    }
  }
}
