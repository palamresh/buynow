import 'package:get/get.dart';
import '../../../database/db_helper.dart';
import '../model/address_model.dart';

class AddressController extends GetxController {
  var addresses = <AddressModel>[].obs;
  var isAdding = false.obs;

  Future<void> loadAddresses(int userId) async {
    addresses.value = await DbHelper.instance.getAddresses(userId);
    update();
  }

  Future<void> addAddress(AddressModel address) async {
    await DbHelper.instance.insertAddress(address);
    await loadAddresses(address.userId);
    isAdding.value = false; // 🔹 form band karo
  }

  Future<void> deleteAddress(int id, int userId) async {
    await DbHelper.instance.deleteAddress(id);
    await loadAddresses(userId);
  }

  Future<void> setDefault(int userId, int addressId) async {
    await DbHelper.instance.setDefaultAddress(userId, addressId);
    await loadAddresses(userId);
  }

  AddressModel? get defaultAddress {
    if (addresses.isEmpty) return null;
    return addresses.firstWhereOrNull((a) => a.isDefault == 1) ??
        addresses.first;
  }
}
