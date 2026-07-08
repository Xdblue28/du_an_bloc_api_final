import 'package:bai8_duan_final_bloc/features/auth/domain/usecase/auth_login_usecase.dart';
import 'package:bai8_duan_final_bloc/features/auth/presentation/cubit/login_state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthLoginUsecase _login;
  LoginCubit({required AuthLoginUsecase loginApp})
    : _login = loginApp,
      super(LoginInitial());

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  Future<void> Login() async {
    emit(LoginLoading());
    try {
      // print("đã chạy dòng này");
      // print("username hien tai $username");
      // print("password hien tai $password");
      await _login(username.text.trim(), password.text.trim());
      emit(LoginSuccess());
    } catch (e, stacktrace) {
      print("Có lỗi trong việc gọi tới server $e");
      print("Chi tiết lỗi là: $stacktrace");
      emit(
        LoginFailure(errMessage: e.toString().replaceAll('Exception: ', '')),
      );
    }
  }

  @override
  Future<void> close() {
    username.dispose();
    password.dispose();
    return super.close();
  }
}
