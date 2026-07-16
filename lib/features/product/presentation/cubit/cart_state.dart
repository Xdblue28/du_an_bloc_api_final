import 'package:bai8_duan_final_bloc/features/product/domain/entities/cart_item.dart';
import 'package:equatable/equatable.dart';

enum CartStatus { initial, loading, success, failure }

class CartState extends Equatable {
  final CartStatus status;
  final List<CartItem> items;
  final String? errorMessage;
  CartState({
    this.status = CartStatus.initial,
    this.items = const [],
    this.errorMessage = "",
  });

  CartState copyWith({
    CartStatus? status,
    List<CartItem>? items,
    String? errorMessage,
  }) {
    return CartState(
      status: status ?? this.status,
      items: items ?? this.items,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, items, errorMessage];
}
