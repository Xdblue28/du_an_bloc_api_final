import 'package:bai8_duan_final_bloc/features/auth/data/models/auth_model.dart';
import 'package:bai8_duan_final_bloc/features/auth/domain/repositories/auth_repository.dart';

class AuthLoginUsecase {
  final AuthRepository _repo;
  AuthLoginUsecase(this._repo);
  Future<AuthModel> call(String username, String password) async {
    return _repo.login(username: username, password: password);
  }
}
//