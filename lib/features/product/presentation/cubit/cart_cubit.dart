import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class CartCubit extends Cubit<List<Map<String, dynamic>>> {
  final Box _cartBox = Hive.box('cart_Box');
  CartCubit() : super([]) {
    loadItem();
  }

  void loadItem() {
    List<dynamic> storedItems = _cartBox.get('cart_item', defaultValue: []);
    final items = storedItems.map((e) => Map<String, dynamic>.from(e)).toList();
    emit(items);
  }

  void addItem(dynamic product) {
    List<Map<String, dynamic>> currentItems = state
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
    final index = currentItems.indexWhere(
      (item) => item['id'] == product.id && item['name'] == product.name,
    );

    if (index != -1) {
      currentItems[index]['count'] = (currentItems[index]['count'] as int) + 1;
    } else {
      currentItems.add({
        'id': product.id,
        'name': product.name,
        'code': product.code,
        'price': product.price,
        'stock': product.stock,
        'image': product.linkImage,
        'description': product.description,
        'count': 1,
      });
    }
    saveAndEmit(currentItems);
  }

  void removeCart(int index) {
    List<Map<String, dynamic>> currentItems = state
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
    if (index >= 0 && index < currentItems.length) {
      final count = currentItems[index]['count'] as int;

      if (count > 1) {
        currentItems[index]['count'] = count - 1;
      } else {
        currentItems.removeAt(index);
      }

      saveAndEmit(currentItems);
    }
  }

  void incrementCart(int index) {
    List<Map<String, dynamic>> currentItems = state
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
    if (index >= 0 && index < currentItems.length) {
      currentItems[index]['count'] = (currentItems[index]['count'] as int) + 1;
      saveAndEmit(currentItems);
    }
  }

  void deleteCartItem(int index) {
    List<Map<String, dynamic>> currentItems = state
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
    if (index >= 0 && index < currentItems.length) {
      currentItems.removeAt(index);
      saveAndEmit(currentItems);
    }
  }

  void clearCart() {
    saveAndEmit([]);
  }

  void saveAndEmit(List<Map<String, dynamic>> items) {
    _cartBox.put('cart_item', items);
    emit(items);
  }

  int totalCount() {
    int total = 0;
    for (var item in state) {
      total += (item['count'] as int);
    }
    return total;
  }
}
