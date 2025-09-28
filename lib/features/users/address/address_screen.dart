import 'package:buynow/features/users/controller/home_controller.dart';
import 'package:buynow/services/razor_pay_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/address_controller.dart';
import '../model/address_model.dart';

class AddressScreen extends StatelessWidget {
  final AddressController controller = Get.put(AddressController());
  final int userId;
  final double totalAmount;
  PaymentService paymentService = PaymentService();
  final homeController = Get.find<HomeController>();

  AddressScreen({super.key, required this.userId, required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    controller.loadAddresses(userId);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Address "),
        actions: [
          TextButton(
            onPressed: () {
              controller.isAdding.value = true;
              controller.update();
            },
            child: Text("Add New"),
          ),
        ],
      ),
      body: GetBuilder<AddressController>(
        builder: (ctrl) {
          if (ctrl.addresses.isEmpty || controller.isAdding.value) {
            return _buildAddressForm(ctrl);
          } else {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: ctrl.addresses.length,
                    itemBuilder: (context, index) {
                      final addr = ctrl.addresses[index];
                      return ListTile(
                        title: Text(addr.addressLine1),
                        subtitle: Text(
                          "${addr.city}, ${addr.state}, ${addr.country} - ${addr.pincode}",
                        ),
                        trailing:
                            addr.isDefault == 1
                                ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                                : IconButton(
                                  icon: const Icon(Icons.radio_button_off),
                                  onPressed: () {
                                    ctrl.setDefault(userId, addr.id!);
                                  },
                                ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () async {
                      // Payment call
                      final selected = ctrl.defaultAddress;
                      if (selected != null) {
                        print("Proceeding with address: ${selected.id}");
                        var orderId = await paymentService.createOrder(
                          totalAmount,
                        );
                        if (orderId != null) {
                          paymentService.openCheckout(
                            amount: totalAmount,
                            name: homeController.user!.name,
                            contact: "8888888888",
                            email: homeController.user!.email,
                            orderId: orderId,
                          );
                        } else {
                          Get.snackbar(
                            "Error",
                            "Could not create order. Please try again.",
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      }
                    },
                    child: const Text("Proceed to Payment"),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildAddressForm(AddressController ctrl) {
    final addressController = TextEditingController();
    final cityController = TextEditingController();
    final stateController = TextEditingController();
    final countryController = TextEditingController();
    final pincodeController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: addressController,
            decoration: const InputDecoration(labelText: "Address Line 1"),
          ),
          TextField(
            controller: cityController,
            decoration: const InputDecoration(labelText: "City"),
          ),
          TextField(
            controller: stateController,
            decoration: const InputDecoration(labelText: "State"),
          ),
          TextField(
            controller: countryController,
            decoration: const InputDecoration(labelText: "Country"),
          ),
          TextField(
            controller: pincodeController,
            decoration: const InputDecoration(labelText: "Pincode"),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              final address = AddressModel(
                userId: userId,
                addressLine1: addressController.text,
                city: cityController.text,
                state: stateController.text,
                country: countryController.text,
                pincode: pincodeController.text,
                isDefault: 1,
              );
              ctrl.addAddress(address);
            },
            child: const Text("Save Address"),
          ),
        ],
      ),
    );
  }
}
