import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:buynow/database/db_helper.dart';
import '../model/product_model.dart';

class ProductController extends GetxController {
  final nameController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();
  String? imagePath;
  int? selectedCategoryId;

  List<ProductModel> products = [];
  bool isLoading = false;

  final formKey = GlobalKey<FormState>();

  void clearText() {
    nameController.clear();
    descController.clear();
    priceController.clear();
    stockController.clear();
    imagePath = null;
    selectedCategoryId = null;
  }

  void setProductForEdit(ProductModel product) {
    nameController.text = product.name;
    descController.text = product.description ?? '';
    priceController.text = product.price.toString();
    stockController.text = product.stock.toString();
    imagePath = product.image;
    selectedCategoryId = product.categoryId;
    update();
  }

  Future<void> addEditProduct({int? id}) async {
    try {
      isLoading = true;
      update();

      if (formKey.currentState!.validate()) {
        final product = ProductModel(
          id: id,
          name: nameController.text,
          description: descController.text,
          price: double.parse(priceController.text),
          stock: int.tryParse(stockController.text) ?? 0,
          image: imagePath!,
          categoryId: selectedCategoryId!,
        );

        if (id == null) {
          int insertRow = await DbHelper.instance.insertProduct(product);
          if (insertRow > 0) {
            clearText();
            await getProducts();
          }
        } else {
          int editRow = await DbHelper.instance.updateProduct(product);
          if (editRow > 0) {
            int index = products.indexWhere((p) => p.id == id);
            products[index] = product;
          }
        }
      }
    } catch (e) {
      print("Error in addEditProduct: $e");
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> getProducts() async {
    try {
      isLoading = true;
      update();
      products = await DbHelper.instance.getProducts();
    } catch (e) {
      print("Error getProducts: $e");
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> deleteProduct(int id) async {
    final result = await DbHelper.instance.deleteProduct(id);
    if (result > 0) {
      products.removeWhere((p) => p.id == id);
      update();
    }
  }

  @override
  void onInit() {
    getProducts();
    super.onInit();
  }
}
