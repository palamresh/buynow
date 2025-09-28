import 'package:buynow/database/db_helper.dart';
import 'package:buynow/features/admin/model/discount_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class DiscountController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController percentageController = TextEditingController();
  List<DiscountModel> discounts = [];
  bool isloading = false;
  final formKey = GlobalKey<FormState>();
  void clearText() {
    nameController.clear();
    percentageController.clear();
  }

  void setDiscountForEdit(DiscountModel discount) {
    nameController.text = discount.name;
    percentageController.text = discount.percentage.toString();
  }

  Future<void> addEditDiscount({int? id}) async {
    try {
      isloading = true;
      update();
      if (formKey.currentState!.validate()) {
        final discount = DiscountModel(
          id: id,
          name: nameController.text,
          percentage: double.tryParse(percentageController.text) ?? 0.0,
        );
        if (id == null) {
          int insertRow = await DbHelper.instance.insertDiscount(discount);
          if (insertRow > 0) {
            clearText();
            await getDiscount();
            print("data insert successfully");
          } else {
            print("data not insert");
          }
        } else {
          int editRow = await DbHelper.instance.updateDiscount(discount);
          if (editRow > 0) {
            int index = discounts.indexWhere((discount) => discount.id == id);
            discounts[index] = discount;
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

  Future<void> getDiscount() async {
    try {
      isloading = true;
      update();
      var result = await DbHelper.instance.getDiscounts();
      discounts = result;
      print("discount ${discounts.length}");
      update();
    } catch (e) {
      print("get discount failed $e");
    } finally {
      isloading = false;
      update();
    }
  }

  Future<void> updateDiscount() async {}

  Future<void> deleteDiscount(int id) async {
    final result = await DbHelper.instance.deleteDiscount(id);
    if (result > 0) {
      discounts.removeWhere((disc) => disc.id == id);
      update();
    }
  }

  @override
  void onInit() {
    getDiscount();
    super.onInit();
  }
}
