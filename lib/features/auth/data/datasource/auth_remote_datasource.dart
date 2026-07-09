import 'package:bai8_duan_final_bloc/core/api/api_client.dart';
import 'package:bai8_duan_final_bloc/core/network/base_remote_data_source.dart';
import 'package:bai8_duan_final_bloc/features/auth/data/models/auth_model.dart';

abstract class AuthRemoteDatasource {
  Future<AuthModel> login({required String name, required String pass});
}

class AuthRemoteDatasourceImpl extends BaseRemoteDataSource
    implements AuthRemoteDatasource {
  AuthRemoteDatasourceImpl({required ApiClient apiClient}) : super(apiClient);

  @override
  Future<AuthModel> login({required String name, required String pass}) async {
    final responseData = await performApiCall<Map<String, dynamic>>(
      () => apiClient.dio.post(
        '/login',
        data: {'username': name, 'password': pass},
      ),
    );
    print("Dữ liệu thô nhận về là: $responseData");
    return AuthModel.fromJson(responseData);
  }
}
//