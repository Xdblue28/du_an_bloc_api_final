import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bai8_duan_final_bloc/features/product/domain/entities/product.dart';
import 'package:bai8_duan_final_bloc/features/product/presentation/cubit/product_cubit.dart';
import 'package:bai8_duan_final_bloc/features/product/presentation/cubit/product_state.dart';

class EditProductPage extends StatefulWidget {
  final Product product;
  const EditProductPage({super.key, required this.product});
  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();
  late final ProductCubit _cubit;
  @override
  void initState() {
    super.initState();
    _cubit = context.read<ProductCubit>();
    _cubit.setData(widget.product);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Chỉnh sửa: ${widget.product.name}"),
          backgroundColor: const Color.fromARGB(255, 9, 11, 12),
        ),
        body: BlocConsumer<ProductCubit, ProductState>(
          listener: (context, state) {
            if (!context.mounted) return;
            if (state.status == ProductStatus.loading) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Cập nhật sản phẩm thành công!"),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );

              Navigator.pop(context);
            }

            if (state.status == ProductStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Cập nhật thất bại, vui lòng thử lại!"),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = (state.status == ProductStatus.loading);
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
                      controller: _cubit.nameProduct,
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
                      controller: _cubit.codeProduct,
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
                      controller: _cubit.priceProduct,
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
                      controller: _cubit.stockProduct,
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
                      controller: _cubit.descriptionProduct,
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
                      controller: _cubit.linkImageProduct,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: Colors.blueGrey,
                      ),
                      onPressed: () {
                        if (isLoading) {
                          return;
                        }

                        if (_formKey.currentState!.validate()) {
                          _cubit.updateProduct(
                            widget.product,
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
                              "CẬP NHẬT SẢN PHẨM",
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
        ),
      );
  }
}
//