import 'package:bai8_duan_final_bloc/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

import '../di/interjection.dart';

class ApiClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:1997/api/v1/',
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
      headers: {
        'Content-type': 'application/json',
        'accept': 'application/json',
      },
    ),
  );
  final Box _authBox;
  ApiClient(this._authBox) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final String? accessToken = _authBox.get('accessToken');
          if (accessToken != null && accessToken.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $accessToken';
            print("[API CLIENT]: Đã gán token vào Header thành công");
          }
          handler.next(options);
        },
        onError: (DioException e, handle) async {
          if (e.response != null && e.response!.statusCode == 401) {
            print("[API trả về 401 == hết token]");
            await _authBox.delete('accessToken');
            print("Đã chạy dòng này");
            sl<AuthCubit>().forceLogout();
            return handle.reject(
              DioException(
                requestOptions: e.requestOptions,
                error: 'NoToken',
                response: e.response,
              ),
            );
          }
          return handle.next(e);
        },
      ),
    );
  }
  Dio get dio => _dio;
}
