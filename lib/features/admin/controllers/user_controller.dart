import 'package:buynow/database/db_helper.dart';
import 'package:buynow/features/auth/signup/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class UserController extends GetxController {
  bool isloading = false;
  List<UserModel> users = [];
  String searchQuery = "";
  String sortOption = "name_asc";
  int pageSize = 10;
  int currentPage = 0;
  bool hasMore = true;
  final searchController = TextEditingController();
  Future<void> getAllUser({bool reset = false}) async {
    if (reset) {
      currentPage = 0;
      users.clear();
      hasMore = true;
    }
    if (!hasMore) {
      return;
    }
    isloading = true;
    update();
    final newUsers = await DbHelper.instance.getAllUsers(
      search: searchQuery,
      sortOptions: sortOption,
      limit: pageSize,
      offset: currentPage * pageSize,
    );

    if (newUsers.length < pageSize) {
      hasMore = false;
    }
    users.addAll(newUsers);
    print("user length ${users.length}");
    currentPage++;
    isloading = false;
    update();
  }

  void searchUser(String query) {
    searchQuery = query;
    update();
    getAllUser(reset: true);
  }

  void sortingUser(String selectedOptions) {
    sortOption = selectedOptions;
    getAllUser(reset: true);
  }

  @override
  void onInit() {
    getAllUser();
    super.onInit();
  }

  // List<UserModel> getFilteredUsers() {
  //   var filtered =
  //       users.where((user) {
  //         final matchSearch =
  //             user.name.toLowerCase().contains(searchQuery) ||
  //             user.email.toLowerCase().contains(searchQuery);
  //         return matchSearch;
  //       }).toList();

  //   // Sorting
  //   switch (sortOption) {
  //     case "name_asc":
  //       filtered.sort((a, b) => a.name.compareTo(b.name));
  //       break;
  //     case "name_desc":
  //       filtered.sort((a, b) => b.name.compareTo(a.name));
  //       break;
  //     case "email_asc":
  //       filtered.sort((a, b) => a.email.compareTo(b.email));
  //       break;
  //     case "email_desc":
  //       filtered.sort((a, b) => b.email.compareTo(a.email));
  //       break;
  //   }

  //   return filtered;
  // }

  Future<void> deleteUser(int id) async {
    final result = await DbHelper.instance.deleteUser(id);
    if (result > 0) {
      users.removeWhere((user) => user.id == id);
    }
    update();
  }
}
