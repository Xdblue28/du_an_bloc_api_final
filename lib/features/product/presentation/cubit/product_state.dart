import 'package:bai8_duan_final_bloc/features/product/domain/entities/product.dart';
import 'package:equatable/equatable.dart';

enum ProductStatus { initial, loading, success, failure }

class ProductState extends Equatable {
  final ProductStatus status;
  final List<Product> products;
  final String errMessage;

  const ProductState({
    this.status = ProductStatus.initial,
    this.products = const [],
    this.errMessage = '',
  });

  ProductState copyWith({
    ProductStatus? status,
    List<Product>? products,
    String? errMessage,
  }) {
    return ProductState(
      status: status ?? this.status,
      products: products ?? this.products,
      errMessage: errMessage ?? this.errMessage,
    );
  }

  @override
  List<Object?> get props => [status, products, errMessage];
}
