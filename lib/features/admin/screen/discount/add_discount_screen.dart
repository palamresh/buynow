import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/discount_controller.dart';
import '../../model/discount_model.dart';

class AddEditDiscountScreen extends StatefulWidget {
  DiscountModel? discountModel;
  AddEditDiscountScreen({super.key, this.discountModel});

  @override
  State<AddEditDiscountScreen> createState() => _AddEditDiscountScreenState();
}

class _AddEditDiscountScreenState extends State<AddEditDiscountScreen> {
  final disCr = Get.put(DiscountController());
  @override
  void initState() {
    if (widget.discountModel != null) {
      disCr.setDiscountForEdit(widget.discountModel!);
    } else {
      disCr.clearText();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.discountModel != null ? "Edit Discount" : "Add Discount",
        ),
      ),
      body: GetBuilder<DiscountController>(
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: disCr.formKey,
              child: ListView(
                children: [
                  // Discount Name
                  TextFormField(
                    controller: disCr.nameController,
                    decoration: const InputDecoration(
                      labelText: "Discount Name",
                      border: OutlineInputBorder(),
                    ),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? "Enter discount name"
                                : null,
                  ),
                  const SizedBox(height: 16),

                  // Discount Percentage
                  TextFormField(
                    controller: controller.percentageController,
                    decoration: const InputDecoration(
                      labelText: "Discount Percentage (%)",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter discount percentage";
                      }
                      final numValue = double.tryParse(value);
                      if (numValue == null || numValue < 0 || numValue > 100) {
                        return "Enter valid percentage (0-100)";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: () async {
                      if (widget.discountModel != null) {
                        await disCr.addEditDiscount(
                          id: widget.discountModel!.id,
                        );
                      } else {
                        await disCr.addEditDiscount();
                      }
                    },
                    child:
                        controller.isloading
                            ? Center(child: CircularProgressIndicator())
                            : Text(
                              widget.discountModel != null
                                  ? "Edit Discount"
                                  : "Save Discount",
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
