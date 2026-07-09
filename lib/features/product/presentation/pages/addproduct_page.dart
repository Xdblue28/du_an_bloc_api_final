import 'package:bai8_duan_final_bloc/features/product/presentation/cubit/product_cubit.dart';
import 'package:bai8_duan_final_bloc/features/product/presentation/cubit/product_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddproductPage extends StatefulWidget {
  const AddproductPage({super.key});

  @override
  State<AddproductPage> createState() => _AddproductPageState();
}

class _AddproductPageState extends State<AddproductPage> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final _cubit = context.read<ProductCubit>();
    return Scaffold(
      appBar: AppBar(title: Text("Thêm"), backgroundColor: Colors.green),
      body: BlocConsumer<ProductCubit, ProductState>(
        builder: (context, state) {
          final isLoading = state is productLoading;
          final isEditable = !isLoading;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      labelText: "Chọn danh mục",
                      border: OutlineInputBorder(),
                    ),
                    value: _cubit.selectedCategoryId,
                    items: const [
                      DropdownMenuItem(value: 24, child: Text("Bánh")),
                      DropdownMenuItem(value: 25, child: Text("Trái cây")),
                      DropdownMenuItem(value: 26, child: Text("Quà")),
                      DropdownMenuItem(value: 27, child: Text("Rượu")),
                      DropdownMenuItem(value: 28, child: Text("Sữa")),
                    ],
                    onChanged: (int? newValue) {
                      setState(() {
                        _cubit.selectedCategoryId = newValue;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Vui lòng chọn danh mục' : null,
                  ),
                  const Text(
                    "Tên sản phẩm",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  TextFormField(
                    enabled: isEditable,
                    controller: _cubit.nameP,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? "Tên sản phẩm không được để trống"
                        : null,
                  ),
                  const SizedBox(height: 12),

                  const Text(
                    "Mã sản phẩm",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  TextFormField(
                    enabled: isEditable,
                    controller: _cubit.codeP,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? "Mã code không được để trống"
                        : null,
                  ),
                  const SizedBox(height: 12),

                  const Text(
                    "Giá sản phẩm",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  TextFormField(
                    enabled: isEditable,
                    controller: _cubit.priceP,
                    keyboardType: TextInputType.number,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty)
                        return "Giá tiền không được để trống";
                      final price = double.tryParse(v.trim());
                      if (price == null || price < 0)
                        return "Giá tiền phải là số lớn hơn hoặc bằng 0";
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  const Text(
                    "Số lượng tồn kho",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  TextFormField(
                    enabled: isEditable,
                    controller: _cubit.stockP,
                    keyboardType: TextInputType.number,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty)
                        return "Số lượng không được để trống";
                      final stock = int.tryParse(v.trim());
                      if (stock == null || stock < 0)
                        return "Số lượng kho phải là số nguyên lớn hơn hoặc bằng 0";
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  const Text(
                    "Mô tả sản phẩm",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  TextFormField(
                    enabled: isEditable,
                    controller: _cubit.descriptionP,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Link hình ảnh sản phẩm",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    enabled: isEditable,
                    controller: _cubit.linkImageP,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () {
                      if (isLoading) {
                        return;
                      }
                      if (_formKey.currentState!.validate()) {
                        _cubit.addProduct(
                          categoryId: _cubit.selectedCategoryId!,
                        );
                      }
                    },
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "THÊM SẢN PHẨM",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          );
        },
        listener: (context, state) {
          if (!context.mounted) return;
          if (state is productSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Thêm sản phẩm thành công!"),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
            Navigator.pop(context);
          }
          if (state is productFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Thêm sản phẩm thất bại, vui lòng thử lại!"),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
      ),
    );
  }
}
//