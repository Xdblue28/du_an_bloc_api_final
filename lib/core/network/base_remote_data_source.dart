import 'package:bai8_duan_final_bloc/core/api/api_client.dart';
import 'package:bai8_duan_final_bloc/core/errors/exceptions.dart';
import 'package:dio/dio.dart';

abstract class BaseRemoteDataSource {
  final ApiClient apiClient;
  BaseRemoteDataSource(this.apiClient);

  Future<T> performApiCall<T>(Future<Response> Function() apiCall) async {
    try {
      final response = await apiCall();
      if (response.statusCode != null && response.statusCode == 200) {
        return response.data as T;
      } else {
        throw Exception(response.data['message'] ?? "Lỗi dữ liệu trả về");
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print("   -> Mã code từ server: ${e.response?.statusCode}");
        print("   -> Data từ server: ${e.response?.data}");
        print("   -> Kiểu dữ liệu của data: ${e.response?.data.runtimeType}");
      }
      print("====================================================");
      // Interceptor đã xử lý 401 và reject với error='NoToken'
      // => Ném UnauthorizedException để cubit biết mà bỏ qua, không emit gì
      if (e.error?.toString() == 'NoToken') {
        throw const UnauthorizedException();
      }
      if (e.error != null) {
        throw Exception(e.error.toString());
      }
      throw Exception(e.message ?? 'Lỗi kết nối mạng');
    } catch (e) {
      if (e is UnauthorizedException) rethrow;
      throw Exception('Đã xảy ra lỗi không xác định: $e');
    }
  }
}
//