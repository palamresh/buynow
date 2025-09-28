import 'package:buynow/features/admin/controllers/categories_controller.dart';
import 'package:buynow/features/admin/controllers/discount_controller.dart';
import 'package:buynow/features/admin/model/discount_model.dart';
import 'package:buynow/features/admin/screen/discount/add_discount_screen.dart';
import 'package:buynow/features/admin/screen/category/add_edit_categories.dart';
import 'package:buynow/utils/app_method.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoriesScreen extends StatefulWidget {
  CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final categoryCtr = Get.put(CategoryController());
  @override
  void initState() {
    loadCategory();

    super.initState();
  }

  void loadCategory() async {
    await categoryCtr.getCategorie();
    print("discount method called");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddEditCategoryScreen());
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(title: Text("Categories")),
      body: GetBuilder<CategoryController>(
        builder: (context) {
          return categoryCtr.isloading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: categoryCtr.categories.length,
                itemBuilder: (context, index) {
                  final category = categoryCtr.categories[index];
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(category.name),
                          trailing: PopupMenuButton(
                            icon: Icon(Icons.more_vert),
                            itemBuilder: (context) {
                              return [
                                PopupMenuItem(
                                  value: "edit",
                                  child: Text("Edit"),
                                ),
                                PopupMenuItem(
                                  value: "delete",
                                  child: Text("Delete"),
                                ),
                              ];
                            },
                            onSelected: (value) async {
                              if (value == "edit") {
                                Get.to(
                                  () => AddEditCategoryScreen(
                                    categoryModel: category,
                                  ),
                                );
                              } else {
                                bool
                                confirm = await AppMethod.deleteConfirmatinDialog(
                                  context,
                                  "Delete Discount",
                                  "Are you sure you want to delele this Categorie?",
                                );
                                if (confirm) {
                                  categoryCtr.deleteCategory(category.id!);
                                }
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
        },
      ),
    );
  }
}
