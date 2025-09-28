import 'package:buynow/features/admin/controllers/user_controller.dart';
import 'package:buynow/utils/app_method.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../database/db_helper.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     insertDummyUsers();
      //   },
      //   child: Icon(Icons.add),
      // ),
      appBar: AppBar(
        title: Text("Users"),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.filter_list),
            onSelected: (value) {
              userController.sortingUser(value);
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(value: "name_asc", child: Text("Name A-Z")),
                PopupMenuItem(value: "name_desc", child: Text("Name Z - A")),
                PopupMenuItem(value: "email_asc", child: Text("Email A - Z")),
                PopupMenuItem(value: "email_desc", child: Text("Email Z - A")),
              ];
            },
          ),
        ],
      ),
      body: GetBuilder<UserController>(
        builder: (controller) {
          // final fiteredUsers = controller.getFilteredUsers();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: controller.searchController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.black),
                    hintText: "Search by name or email",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    controller.searchUser(value.toLowerCase());
                  },
                ),
              ),

              Expanded(
                child:
                    controller.isloading && controller.users.isEmpty
                        ? Center(child: CircularProgressIndicator())
                        : controller.users.isEmpty
                        ? Center(child: Text("No user found"))
                        : NotificationListener<ScrollNotification>(
                          onNotification: (ScrollNotification scrollInfo) {
                            if (!controller.isloading &&
                                controller.hasMore &&
                                scrollInfo.metrics.pixels ==
                                    scrollInfo.metrics.maxScrollExtent) {
                              controller.getAllUser();
                            }
                            return false;
                          },
                          child: ListView.builder(
                            itemCount:
                                controller.users.length +
                                (controller.hasMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == controller.users.length) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              final user = controller.users[index];
                              return Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(user.name),
                                      subtitle: Text(user.email),
                                      trailing: PopupMenuButton(
                                        onSelected: (value) async {
                                          if (value == "edit") {
                                          } else if (value == "delete") {
                                            bool confirm =
                                                await AppMethod.deleteConfirmatinDialog(
                                                  context,
                                                  "Delete User",
                                                  "Are you sure you want to delele this user?",
                                                );
                                            if (confirm) {
                                              controller.deleteUser(user.id!);
                                            }
                                          } else {
                                            print("not select match");
                                          }
                                        },
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
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
              ),
            ],
          );
        },
      ),
    );
  }
}
