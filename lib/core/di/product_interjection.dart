import 'package:bai8_duan_final_bloc/core/api/api_client.dart';
import 'package:bai8_duan_final_bloc/features/product/data/datasource/product_remote_datasource.dart';
import 'package:bai8_duan_final_bloc/features/product/data/repositories/product_repository_impl.dart';
import 'package:bai8_duan_final_bloc/features/product/domain/repositories/product_repository.dart';
import 'package:bai8_duan_final_bloc/features/product/domain/usecase/add_product_usecase.dart';
import 'package:bai8_duan_final_bloc/features/product/domain/usecase/delete_product_usecase.dart';
import 'package:bai8_duan_final_bloc/features/product/domain/usecase/load_product_usecase.dart';
import 'package:bai8_duan_final_bloc/features/product/domain/usecase/update_product_usecase.dart';
import 'package:bai8_duan_final_bloc/features/product/presentation/cubit/product_cubit.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;
Future<void> initProduct() async {
  sl.registerLazySingleton<ProductRemoteDatasource>(
    () => ProductRemoteDatasourceImpl(apiClient: sl<ApiClient>()),
  );
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => LoadProductUsecase(sl()));
  sl.registerLazySingleton(() => DeleteProductUsecase(sl()));
  sl.registerLazySingleton(() => AddProductUsecase(sl()));
  sl.registerLazySingleton(() => UpdateProductUsecase(sl()));
  sl.registerFactory<ProductCubit>(
    () => ProductCubit(get: sl(), add: sl(), delete: sl(), update: sl()),
  );
}
