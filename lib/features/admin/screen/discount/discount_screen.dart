import 'package:buynow/features/admin/controllers/discount_controller.dart';
import 'package:buynow/features/admin/model/discount_model.dart';
import 'package:buynow/features/admin/screen/discount/add_discount_screen.dart';
import 'package:buynow/utils/app_method.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DiscountScreen extends StatefulWidget {
  DiscountScreen({super.key});

  @override
  State<DiscountScreen> createState() => _DiscountScreenState();
}

class _DiscountScreenState extends State<DiscountScreen> {
  final disct = Get.put(DiscountController());
  @override
  void initState() {
    loadDiscount();

    super.initState();
  }

  void loadDiscount() async {
    await disct.getDiscount();
    print("discount method called");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddEditDiscountScreen());
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(title: Text("Discounts")),
      body: GetBuilder<DiscountController>(
        builder: (context) {
          return disct.isloading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: disct.discounts.length,
                itemBuilder: (context, index) {
                  final discount = disct.discounts[index];
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(discount.name),
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
                                  () => AddEditDiscountScreen(
                                    discountModel: discount,
                                  ),
                                );
                              } else {
                                bool
                                confirm = await AppMethod.deleteConfirmatinDialog(
                                  context,
                                  "Delete Discount",
                                  "Are you sure you want to delele this Discount?",
                                );
                                if (confirm) {
                                  disct.deleteDiscount(discount.id!);
                                }
                              }
                            },
                          ),
                          subtitle: Text(discount.percentage.toString()),
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
