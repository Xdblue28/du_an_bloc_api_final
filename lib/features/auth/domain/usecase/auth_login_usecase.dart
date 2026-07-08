import 'package:bai8_duan_final_bloc/features/auth/data/models/auth_model.dart';
import 'package:bai8_duan_final_bloc/features/auth/domain/repositories/auth_repository.dart';

class AuthLoginUsecase {
  AuthRepository _repo;
  AuthLoginUsecase(this._repo);
  Future<AuthModel> call(username, password) async {
    return _repo.login(username: username, password: password);
  }
}
