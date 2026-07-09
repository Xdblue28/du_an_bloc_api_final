import 'package:bai8_duan_final_bloc/features/auth/data/models/auth_model.dart';

abstract class AuthRepository {
  Future<AuthModel> login({required String username, required String password});
}
//