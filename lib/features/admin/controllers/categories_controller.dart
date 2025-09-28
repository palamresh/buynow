import 'package:buynow/database/db_helper.dart';
import 'package:buynow/features/admin/model/discount_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../model/categories_model.dart';

class CategoryController extends GetxController {
  final TextEditingController nameController = TextEditingController();

  List<CategoryModel> categories = [];
  bool isloading = false;
  final formKey = GlobalKey<FormState>();
  void clearText() {
    nameController.clear();
  }

  void setCategoryForEdit(CategoryModel categorie) {
    nameController.text = categorie.name;
  }

  Future<void> addEditCategory({int? id}) async {
    try {
      isloading = true;
      update();
      if (formKey.currentState!.validate()) {
        final category = CategoryModel(id: id, name: nameController.text);
        if (id == null) {
          int insertRow = await DbHelper.instance.insertCategory(category);
          if (insertRow > 0) {
            clearText();
            await getCategorie();
            print("data insert successfully");
          } else {
            print("data not insert");
          }
        } else {
          int editRow = await DbHelper.instance.updateCategory(category);
          if (editRow > 0) {
            int index = categories.indexWhere((discount) => discount.id == id);
            categories[index] = category;
            print("data update successfully");
          } else {
            print("data not edit");
          }
        }
      }
    } catch (e) {
      print("e $e");
    } finally {
      isloading = false;
      update();
    }
  }

  Future<void> getCategorie() async {
    try {
      isloading = true;
      update();
      var result = await DbHelper.instance.getCategories();
      categories = result;
      print("category ${categories.length}");
      update();
    } catch (e) {
      print("get category failed $e");
    } finally {
      isloading = false;
      update();
    }
  }

  Future<void> deleteCategory(int id) async {
    final result = await DbHelper.instance.deleteCategory(id);
    if (result > 0) {
      categories.removeWhere((disc) => disc.id == id);
      update();
    }
  }

  @override
  void onInit() {
    getCategorie();
    super.onInit();
  }
}
