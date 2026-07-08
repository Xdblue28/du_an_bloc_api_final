import 'package:bai8_duan_final_bloc/features/product/domain/entities/product.dart';

class ProductPage {
  List<Product> data;
  int page;
  int limit;
  int count;

  ProductPage({
    required this.data,
    required this.page,
    required this.limit,
    required this.count,
  });
}
