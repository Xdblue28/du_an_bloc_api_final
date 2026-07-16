import 'package:bai8_duan_final_bloc/features/product/data/models/cart_item_model.dart';
import 'package:bai8_duan_final_bloc/features/product/domain/entities/cart_item.dart';
import 'package:bai8_duan_final_bloc/features/product/domain/entities/product.dart';
import 'package:bai8_duan_final_bloc/features/product/presentation/cubit/cart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class CartCubit extends Cubit<CartState> {
  final Box _cartBox;

  CartCubit({required Box cartBox})
    : _cartBox = cartBox,
      super(CartState(items: [], status: CartStatus.initial)) {
    loadItem();
  }

  void loadItem() {
    emit(state.copyWith(status: CartStatus.loading));

    try {
      List<dynamic> storedItems = _cartBox.get('cart_item', defaultValue: []);
      final items = storedItems.map((e) {
        return CartItemModel.fromJson(Map<String, dynamic>.from(e)).toEntity();
      }).toList();

      emit(state.copyWith(items: items, status: CartStatus.success));
    } catch (e) {
      emit(state.copyWith(status: CartStatus.failure));
    }
  }

  void addItem(Product product) {
    final currentItems = List<CartItem>.from(state.items);
    final index = currentItems.indexWhere((item) => item.id == product.id);

    if (index != -1) {
      currentItems[index].count += 1;
    } else {
      currentItems.add(CartItem(
        id: product.id,
        name: product.name,
        code: product.code,
        price: product.price,
        stock: product.stock,
        image: product.linkImage,
        description: product.description,
        count: 1,
      ));
    }
    _saveAndEmit(currentItems);
  }

  void removeCart(int index) {
    final currentItems = List<CartItem>.from(state.items);
    if (index >= 0 && index < currentItems.length) {
      if (currentItems[index].count > 1) {
        currentItems[index].count -= 1;
      } else {
        currentItems.removeAt(index);
      }
      _saveAndEmit(currentItems);
    }
  }

  void incrementCart(int index) {
    final currentItems = List<CartItem>.from(state.items);
    if (index >= 0 && index < currentItems.length) {
      currentItems[index].count += 1;
      _saveAndEmit(currentItems);
    }
  }

  void deleteCartItem(int index) {
    final currentItems = List<CartItem>.from(state.items);
    if (index >= 0 && index < currentItems.length) {
      currentItems.removeAt(index);
      _saveAndEmit(currentItems);
    }
  }

  void clearCart() {
    _saveAndEmit([]);
  }

  int totalCount() {
    return state.items.fold(0, (sum, item) => sum + item.count);
  }

  void _saveAndEmit(List<CartItem> items) {
    final jsonList = items.map((item) {
      return CartItemModel.fromEntity(item).toJson();
    }).toList();
    _cartBox.put('cart_item', jsonList);
    emit(state.copyWith(items: items, status: CartStatus.success));
  }
}
