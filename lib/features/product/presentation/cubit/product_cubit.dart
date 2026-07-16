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
  final LoadProductUsecase _loadProductUsecase;
  final AddProductUsecase _addProductUsecase;
  final DeleteProductUsecase _deleteProductUsecase;
  final UpdateProductUsecase _updateProductUsecase;

  ProductCubit({
    required LoadProductUsecase get,
    required AddProductUsecase add,
    required DeleteProductUsecase delete,
    required UpdateProductUsecase update,
  }) : _loadProductUsecase = get,
       _addProductUsecase = add,
       _deleteProductUsecase = delete,
       _updateProductUsecase = update,
       super(const ProductState());

  int? selectedCategoryId;
  TextEditingController nameProduct = TextEditingController();
  TextEditingController codeProduct = TextEditingController();
  TextEditingController priceProduct = TextEditingController();
  TextEditingController stockProduct = TextEditingController();
  TextEditingController descriptionProduct = TextEditingController();
  TextEditingController linkImageProduct = TextEditingController();

  @override
  Future<void> close() {
    nameProduct.dispose();
    codeProduct.dispose();
    priceProduct.dispose();
    stockProduct.dispose();
    descriptionProduct.dispose();
    linkImageProduct.dispose();
    return super.close();
  }

  void clearForm() {
    nameProduct.clear();
    codeProduct.clear();
    priceProduct.clear();
    stockProduct.clear();
    descriptionProduct.clear();
    linkImageProduct.clear();
  }

  Future<void> loadProduct({required int? categoryId}) async {
    selectedCategoryId = categoryId;
    if (isClosed) return;
    emit(state.copyWith(status: ProductStatus.loading));
    try {
      final products = await _loadProductUsecase(categoryId: categoryId);
      if (isClosed) return;
      emit(state.copyWith(status: ProductStatus.success, products: products));
    } on UnauthorizedException {
      print("[ProductCubit] loadProduct: hết token, đợi AuthCubit navigate...");
    } catch (e) {
      print("Có lỗi trong việc gọi tới server $e");
      if (isClosed) return;
      emit(
        state.copyWith(status: ProductStatus.failure, errMessage: e.toString()),
      );
    }
  }

  Future<void> addProduct({required int categoryId}) async {
    if (isClosed) return;
    emit(state.copyWith(status: ProductStatus.loading));
    try {
      final newProduct = Product(
        id: 0,
        status: 1,
        create_At: DateTime.now(),
        update_At: DateTime.now(),
        name: nameProduct.text,
        code: codeProduct.text,
        price: double.tryParse(priceProduct.text.trim()) ?? 0.0,
        stock: int.tryParse(stockProduct.text.trim()) ?? 0,
        description: descriptionProduct.text,
        linkImage: linkImageProduct.text,
        category: ProductCategory(id: categoryId, name: ""),
      );
      await _addProductUsecase(newProduct);
      if (isClosed) return;
      await loadProduct(categoryId: selectedCategoryId);
      clearForm();
      print("cubit: thêm thành công");
    } on UnauthorizedException {
      print("[ProductCubit] addProduct: hết token, đợi AuthCubit navigate...");
    } catch (e) {
      print("Có lỗi ở việc gọi server || cubit");
      if (isClosed) return;
      emit(
        state.copyWith(status: ProductStatus.failure, errMessage: e.toString()),
      );
    }
  }

  Future<bool> deleteProduct(int id, {required int? categoryId}) async {
    try {
      await _deleteProductUsecase(id);
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
      emit(
        state.copyWith(status: ProductStatus.failure, errMessage: e.toString()),
      );
      return false;
    }
  }

  void setData(Product product) {
    nameProduct.text = product.name;
    codeProduct.text = product.code;
    priceProduct.text = product.price.toString();
    stockProduct.text = product.stock.toString();
    descriptionProduct.text = product.description;
    linkImageProduct.text = product.linkImage;
    selectedCategoryId = product.category.id;
    emit(state.copyWith());
  }

  Future<void> updateProduct(Product product, {required int categoryId}) async {
    if (isClosed) return;
    emit(state.copyWith(status: ProductStatus.loading));
    try {
      final updateP = Product(
        id: product.id,
        status: 1,
        create_At: product.create_At,
        update_At: DateTime.now(),
        name: nameProduct.text,
        code: codeProduct.text,
        price: double.tryParse(priceProduct.text.trim()) ?? 0.0,
        stock: int.tryParse(stockProduct.text.trim()) ?? 0,
        description: descriptionProduct.text,
        linkImage: linkImageProduct.text,
        category: ProductCategory(id: categoryId, name: ""),
      );
      await _updateProductUsecase(updateP);
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
      emit(
        state.copyWith(status: ProductStatus.failure, errMessage: e.toString()),
      );
    }
  }
}
//