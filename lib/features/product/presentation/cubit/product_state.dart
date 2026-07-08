import 'package:bai8_duan_final_bloc/features/product/domain/entities/product.dart';

abstract class ProductState {
  ProductState();
}

class productInitial extends ProductState {}

class productLoading extends ProductState {}

class productSuccess extends ProductState {
  final List<Product> products;
  productSuccess({required this.products});
}

class productFailure extends ProductState {}
