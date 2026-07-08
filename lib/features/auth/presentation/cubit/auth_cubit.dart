import 'package:bai8_duan_final_bloc/features/auth/data/datasource/auth_local_datasource.dart';
import 'package:bai8_duan_final_bloc/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class AuthCubit extends Cubit<AuthState> {
  final Box _authBox;
  final AuthLocalDatasource _localDataSource;
  AuthCubit(this._authBox, {required AuthLocalDatasource localDataSource})
    : _localDataSource = localDataSource,
      super(AuthInitial());

  void checkAuth() {
    emit(AuthLoading());
    try {
      final token = _localDataSource.getToken();
      if (token != null && token.isNotEmpty) {
        emit(Authenticated());
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(Unauthenticated());
    }
  }

  void forceLogout() {
    _authBox.delete('accessToken');
    emit(Unauthenticated(message: 'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.'));
    print("Phát trạng thái");
  }
}
