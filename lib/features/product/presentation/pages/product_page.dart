import 'package:bai8_duan_final_bloc/core/di/interjection.dart';
import 'package:bai8_duan_final_bloc/features/product/presentation/cubit/cart_cubit.dart';
import 'package:bai8_duan_final_bloc/features/product/presentation/cubit/product_cubit.dart';
import 'package:bai8_duan_final_bloc/features/product/presentation/cubit/product_state.dart';
import 'package:bai8_duan_final_bloc/features/product/presentation/pages/addproduct_page.dart';
import 'package:bai8_duan_final_bloc/features/product/presentation/pages/editProductPage.dart';
import 'package:bai8_duan_final_bloc/features/product/presentation/pages/cart_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProductCubit>()..loadProduct(categoryId: null),
      child: Builder(
        builder: (newContext) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "Danh Sách Sản Phẩm",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                BlocBuilder<CartCubit, List<Map<String, dynamic>>>(
                  builder: (context, cartState) {
                    int totalCount = context.read<CartCubit>().totalCount();
                    return Badge(
                      label: Text('$totalCount'),
                      isLabelVisible: totalCount > 0,
                      backgroundColor: Colors.green,
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CartPage()),
                          );
                        },
                        icon: Icon(Icons.shopping_cart_sharp),
                        color: Colors.black,
                        iconSize: 28,
                      ),
                    );
                  },
                ),
                const SizedBox(width: 10),
              ],
              centerTitle: true,
            ),
            backgroundColor: const Color.fromARGB(255, 151, 51, 51),
            drawer: Builder(
              builder: (drawerContext) {
                return Drawer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const DrawerHeader(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 151, 51, 51),
                        ),
                        child: Text(
                          'Bộ Lọc Danh Mục',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.all_inclusive),
                        title: const Text('Tất cả sản phẩm'),
                        onTap: () {
                          drawerContext.read<ProductCubit>().loadProduct(
                            categoryId: null,
                          );
                          Navigator.pop(drawerContext);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.apple),
                        title: const Text('Trái cây'),
                        onTap: () {
                          drawerContext.read<ProductCubit>().loadProduct(
                            categoryId: 25,
                          );
                          Navigator.pop(drawerContext);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.cake),
                        title: const Text('Bánh'),
                        onTap: () {
                          drawerContext.read<ProductCubit>().loadProduct(
                            categoryId: 24,
                          );
                          Navigator.pop(drawerContext);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),

            body: BlocConsumer<ProductCubit, ProductState>(
              builder: (context, state) {
                if (state is productLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is productSuccess) {
                  final products = state.products;
                  if (products.isEmpty) {
                    return const Center(child: Text("Không có sản phẩm"));
                  }

                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];

                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(
                                  product.linkImage,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,

                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                        width: 80,
                                        height: 80,
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.image),
                                      ),
                                ),
                                const SizedBox(width: 10),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "Mã: ${product.code}",
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        "Giá: ${product.price} đ",
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text("Kho: ${product.stock}"),
                                      Text(
                                        product.status == 1
                                            ? "Trạng thái: Đang bán"
                                            : "Trạng thái: Dừng bán",
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const Divider(height: 20),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () async {
                                    final mainCubit = newContext
                                        .read<ProductCubit>();
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditProductPage(product: product),
                                      ),
                                    );
                                    mainCubit.loadProduct(categoryId: null);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Xác nhận xóa'),
                                        content: Text(
                                          'Bạn có chắc chắn muốn xóa sản phẩm "${product.name}"?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: const Text('Hủy'),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            child: const Text(
                                              'Xóa',
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (confirm == true) {
                                      if (!context.mounted) return;
                                      final cubit = newContext
                                          .read<ProductCubit>();
                                      final success = await cubit.deleteProduct(
                                        product.id,
                                        categoryId: null,
                                      );
                                      if (!context.mounted) return;
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            success
                                                ? 'Xóa sản phẩm thành công!'
                                                : 'Xóa sản phẩm thất bại!',
                                          ),
                                          backgroundColor: success
                                              ? Colors.green
                                              : Colors.red,
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.add_shopping_cart,
                                    color: Color.fromARGB(255, 151, 51, 51),
                                  ),
                                  onPressed: () {
                                    context.read<CartCubit>().addItem(product);
                                    ScaffoldMessenger.of(
                                      context,
                                    ).hideCurrentSnackBar();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Đã thêm "${product.name}" vào giỏ hàng!',
                                        ),
                                        backgroundColor: Colors.green,
                                        behavior: SnackBarBehavior.floating,
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
              listener: (context, state) {
                if (state is productFailure) {
                  print("[TOKEN UI]: Gọi API thất bại");
                }
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                final mainCubit = newContext.read<ProductCubit>();
                mainCubit.clearForm();
                mainCubit.selectedCategoryId = null;
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: mainCubit,
                      child: AddproductPage(),
                    ),
                  ),
                );
                mainCubit.loadProduct(categoryId: null);
              },
              child: Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}
