import 'package:bai8_duan_final_bloc/core/di/interjection.dart';
import 'package:bai8_duan_final_bloc/core/di/product_interjection.dart'
    show initProduct;
import 'package:bai8_duan_final_bloc/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:bai8_duan_final_bloc/features/auth/presentation/cubit/auth_state.dart';
import 'package:bai8_duan_final_bloc/features/auth/presentation/pages/Login_Page.dart';
import 'package:bai8_duan_final_bloc/features/product/presentation/cubit/cart_cubit.dart';
import 'package:bai8_duan_final_bloc/features/product/presentation/pages/product_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('auth_Box');
  await Hive.openBox('cart_Box');
  await setupDependencies();
  await initProduct();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<AuthCubit>()..checkAuth()),
        BlocProvider(create: (context) => CartCubit()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        routes: {
          '/login': (context) => const LoginPage(),
          '/product': (context) => ProductPage(),
        },
        builder: (context, child) {
          return BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is Unauthenticated) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  navigatorKey.currentState?.pushNamedAndRemoveUntil(
                    '/login',
                    (route) => false,
                    arguments: state.message,
                  );
                });
              }
            },
            child: child!,
          );
        },
        home: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is Unauthenticated) {
              return const LoginPage();
            }
            return ProductPage();
          },
        ),
      ),
    );
  }
}
///