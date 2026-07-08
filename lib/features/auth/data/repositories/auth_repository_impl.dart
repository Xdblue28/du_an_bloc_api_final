import 'package:bai8_duan_final_bloc/features/auth/data/datasource/auth_local_datasource.dart';
import 'package:bai8_duan_final_bloc/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:bai8_duan_final_bloc/features/auth/data/models/auth_model.dart';
import 'package:bai8_duan_final_bloc/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteData;
  final AuthLocalDatasource localData;

  AuthRepositoryImpl({required this.remoteData, required this.localData});
  @override
  Future<AuthModel> login({
    required String username,
    required String password,
  }) async {
    try {
      final authModel = await remoteData.login(name: username, pass: password);
      if (authModel.inToken.isNotEmpty) {
        await localData.saveToken(authModel.inToken);
        print("[auth_repo_impl]: thực hiện lưu thành công trong local");
        return authModel;
      }
      throw Exception('Invalid token');
    } catch (e) {
      print("[auth_repo_impl]: có lỗi");
      rethrow;
    }
  }
}
