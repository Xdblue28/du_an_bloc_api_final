import 'package:bai8_duan_final_bloc/core/api/api_client.dart';
import 'package:bai8_duan_final_bloc/core/network/base_remote_data_source.dart';
import 'package:bai8_duan_final_bloc/features/product/data/models/product_model.dart';
import 'package:bai8_duan_final_bloc/features/product/domain/entities/product.dart';

abstract class ProductRemoteDatasource {
  // Future<List<ProductModel>> loadProduct() async {
  //   try {
  //     final response = await apiClient.dio.get('products');
  //     if (response == 200) {
  //       if (response.data == null || response.data['data'] == null) {
  //         throw Exception("[PRODUCT REMOTE]: api 200 -> nhưng ko có data ");
  //       }
  //       print("[PRODUCT REMOTE]: lấy api thành công");
  //       print(response.data);
  //       final data = response.data['data'];
  //       final result = <ProductModel>[];
  //       for (var item in data) {
  //         result.add(ProductModel.fromJson(item as Map<String, dynamic>));
  //       }
  //       return result;
  //     } else {
  //       throw Exception("[PRODUCT-remotedata] lỗi: Mã ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     print("Product remote có lỗi loadproducy");
  //     rethrow;
  //   }
  // }
  Future<List<ProductModel>> loadProduct(int? categoryId);
  Future<void> addProduct(Product product);
  Future<void> deleteProduct(int id);
  Future<void> updateProduct(Product product);
}

class ProductRemoteDatasourceImpl extends BaseRemoteDataSource
    implements ProductRemoteDatasource {
  ProductRemoteDatasourceImpl({required ApiClient apiClient})
    : super(apiClient);

  // @override
  // Future<List<ProductModel>> loadProduct(int? categoryId) async {
  //   final response = await performApiCall<Map<String, dynamic>>(
  //     () => apiClient.dio.get('products'),
  //   );
  //   print("Dữ liệu thô từ product $response");
  //   if (!response.containsKey('data') || response['data'] == null) {
  //     print(
  //       "[PRODUCT REMOTE]: Cấu trúc Response không có 'data' hoặc API gặp lỗi.",
  //     );
  //     return [];
  //   }
  //   final data = response['data'];
  //   final result = <ProductModel>[];
  //   for (var item in data) {
  //     result.add(ProductModel.fromJson(item as Map<String, dynamic>));
  //   }
  //   return result;
  // }
  @override
  Future<List<ProductModel>> loadProduct(int? categoryId) async {
    final queryParameters = <String, dynamic>{};
    if (categoryId != null) {
      queryParameters['category_id'] = categoryId;
    }

    final response = await performApiCall<Map<String, dynamic>>(
      () => apiClient.dio.get(
        'products',
        queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
      ),
    );
    print("Dữ liệu thô từ product $response");
    if (!response.containsKey('data') || response['data'] == null) {
      print(
        "[PRODUCT REMOTE]: Cấu trúc Response không có 'data' hoặc API gặp lỗi.",
      );
      return [];
    }
    final data = response['data'];
    final result = <ProductModel>[];
    for (var item in data) {
      result.add(ProductModel.fromJson(item as Map<String, dynamic>));
    }
    return result;
  }

  @override
  Future<void> addProduct(Product product) async {
    await performApiCall(
      () => apiClient.dio.post(
        'products',
        data: {
          'name': product.name,
          'code': product.code,
          'price': product.price,
          'stock': product.stock,
          'description': product.description,
          'image': product.linkImage,
          'category_id': product.category.id,
        },
      ),
    );
  }

  @override
  Future<void> deleteProduct(int id) async {
    await performApiCall(() => apiClient.dio.delete('products/$id'));
  }

  @override
  Future<void> updateProduct(Product product) async {
    await performApiCall(
      () => apiClient.dio.put(
        'products/${product.id}',
        data: {
          'name': product.name,
          'code': product.code,
          'price': product.price,
          'stock': product.stock,
          'description': product.description,
          'image': product.linkImage,
          'category_id': product.category.id,
        },
      ),
    );
  }
}
//