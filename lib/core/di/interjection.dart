import 'package:bai8_duan_final_bloc/core/api/api_client.dart';
import 'package:bai8_duan_final_bloc/features/auth/data/datasource/auth_local_datasource.dart';
import 'package:bai8_duan_final_bloc/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:bai8_duan_final_bloc/features/auth/data/models/repositories/auth_repository_impl.dart';
import 'package:bai8_duan_final_bloc/features/auth/domain/repositories/auth_repository.dart';
import 'package:bai8_duan_final_bloc/features/auth/domain/usecase/auth_login_usecase.dart';
import 'package:bai8_duan_final_bloc/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:bai8_duan_final_bloc/features/auth/presentation/cubit/login_cubit.dart';
import 'package:bai8_duan_final_bloc/features/product/presentation/cubit/cart_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  final authBox = Hive.box('auth_Box');
  final cartBox = Hive.box('cart_Box');
  sl.registerSingleton<Box>(authBox, instanceName: 'auth_Box');
  sl.registerSingleton<Box>(cartBox, instanceName: 'cart_Box');
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(sl<Box>(instanceName: 'auth_Box')),
  );
  sl.registerLazySingleton<CartCubit>(
    () => CartCubit(cartBox: sl<Box>(instanceName: 'cart_Box')),
  );
  //data source
  sl.registerLazySingleton<AuthLocalDatasource>(
    () => AuthLocalDatasourceImpl(authBox: sl<Box>(instanceName: 'auth_Box')),
  );

  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(apiClient: sl<ApiClient>()),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteData: sl<AuthRemoteDatasource>(),
      localData: sl<AuthLocalDatasource>(),
    ),
  );

  sl.registerLazySingleton(() => AuthLoginUsecase(sl<AuthRepository>()));
  sl.registerLazySingleton(
    () => AuthCubit(sl<Box>(instanceName: 'auth_Box'), localDataSource: sl<AuthLocalDatasource>()),
  );
  sl.registerFactory(() => LoginCubit(loginApp: sl<AuthLoginUsecase>()));
}
  
//