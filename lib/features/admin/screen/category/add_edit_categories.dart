import 'package:buynow/features/admin/controllers/categories_controller.dart';
import 'package:buynow/features/admin/controllers/discount_controller.dart';
import 'package:buynow/features/admin/model/categories_model.dart';
import 'package:buynow/features/admin/model/discount_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddEditCategoryScreen extends StatefulWidget {
  CategoryModel? categoryModel;
  AddEditCategoryScreen({super.key, this.categoryModel});

  @override
  State<AddEditCategoryScreen> createState() => _AddEditCategoryScreenState();
}

class _AddEditCategoryScreenState extends State<AddEditCategoryScreen> {
  final categoryCtr = Get.put(CategoryController());
  @override
  void initState() {
    if (widget.categoryModel != null) {
      categoryCtr.setCategoryForEdit(widget.categoryModel!);
    } else {
      categoryCtr.clearText();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryModel != null ? "Edit Category" : "Add Category",
        ),
      ),
      body: GetBuilder<CategoryController>(
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: categoryCtr.formKey,
              child: ListView(
                children: [
                  // Discount Name
                  TextFormField(
                    controller: categoryCtr.nameController,
                    decoration: const InputDecoration(
                      labelText: "Category Name",
                      border: OutlineInputBorder(),
                    ),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? "Enter category name"
                                : null,
                  ),
                  const SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: () async {
                      if (widget.categoryModel != null) {
                        await categoryCtr.addEditCategory(
                          id: widget.categoryModel!.id,
                        );
                      } else {
                        await categoryCtr.addEditCategory();
                      }
                    },
                    child:
                        controller.isloading
                            ? Center(child: CircularProgressIndicator())
                            : Text(
                              widget.categoryModel != null
                                  ? "Edit Category"
                                  : "Save Category",
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
