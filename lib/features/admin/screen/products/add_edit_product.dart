import 'dart:io';
import 'package:buynow/features/admin/controllers/categories_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../controllers/product_controller.dart';
import '../../model/product_model.dart';

class AddEditProductScreen extends StatefulWidget {
  final ProductModel? productModel;
  const AddEditProductScreen({super.key, this.productModel});

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final productCtr = Get.put(ProductController());
  final categoryCtr = Get.put(CategoryController());

  @override
  void initState() {
    if (widget.productModel != null) {
      // delay update until first frame rendered
      WidgetsBinding.instance.addPostFrameCallback((_) {
        productCtr.setProductForEdit(widget.productModel!);
      });
    } else {
      productCtr.clearText();
    }
    categoryCtr.getCategorie();
    super.initState();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      print("product image ${pickedFile.path}");
      setState(() {
        productCtr.imagePath = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.productModel != null ? "Edit Product" : "Add Product",
        ),
      ),
      body: GetBuilder<ProductController>(
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: controller.formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: controller.nameController,
                    decoration: InputDecoration(labelText: "Product Name"),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? "Enter name"
                                : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: controller.descController,
                    decoration: InputDecoration(labelText: "Description"),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: controller.priceController,
                    decoration: InputDecoration(labelText: "Price"),
                    keyboardType: TextInputType.number,
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? "Enter price"
                                : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: controller.stockController,
                    decoration: InputDecoration(labelText: "Stock"),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),

                  // Replace your DropdownButtonFormField part with this 👇
                  GetBuilder<CategoryController>(
                    builder: (catController) {
                      return DropdownButtonFormField<int>(
                        value: controller.selectedCategoryId,
                        validator:
                            (value) =>
                                value == null
                                    ? "Please select a category"
                                    : null,
                        hint: Text("Select Category"),
                        items:
                            catController.categories
                                .map(
                                  (category) => DropdownMenuItem<int>(
                                    value: category.id,
                                    child: Text(category.name),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          controller.selectedCategoryId = value;
                          controller.update();
                          print("controller ${controller.selectedCategoryId}");
                        },
                      );
                    },
                  ),

                  // Image Picker
                  Row(
                    children: [
                      controller.imagePath != null
                          ? Image.file(
                            File(controller.imagePath!),
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                          )
                          : Container(
                            height: 60,
                            width: 60,
                            color: Colors.grey.shade200,
                          ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: pickImage,
                        icon: Icon(Icons.image),
                        label: Text("Pick Image"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () async {
                      if (widget.productModel != null) {
                        await controller.addEditProduct(
                          id: widget.productModel!.id,
                        );
                      } else {
                        await controller.addEditProduct();
                        controller.update();
                      }
                      Get.back();
                    },
                    child:
                        controller.isLoading
                            ? CircularProgressIndicator()
                            : Text(
                              widget.productModel != null
                                  ? "Update Product"
                                  : "Save Product",
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
