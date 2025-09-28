import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HiveScreen extends StatefulWidget {
  const HiveScreen({super.key});

  @override
  State<HiveScreen> createState() => _HiveScreenState();
}

class _HiveScreenState extends State<HiveScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var box = await Hive.openBox("box");
          var box1 = await Hive.openBox("box1");
          box.put("name", "Suraj");
          box.put("age", 25);
          box.put("isLogin", true);
          box.put("users", {"name": "Suraj", "age": 25, "isLogin": true});

          print(box.get("name"));
          print(box.get("age"));
          print(box.get("isLogin"));
          print(box.get("users"));

          box1.put("course1", "BCA");
          box1.put("course2", "MCA");
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(title: Text("Hive Screen")),
      body: Column(
        children: [
          FutureBuilder(
            future: Hive.openBox("box"),
            builder: (context, snapshot) {
              return ListTile(
                title: Text("Name: ${snapshot.data?.get("name") ?? ""}"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Age: ${snapshot.data?.get("age") ?? ""}"),
                    Text("isLogin: ${snapshot.data?.get("isLogin") ?? ""}"),
                    Text("Users: ${snapshot.data?.get("users") ?? ""}"),
                  ],
                ),
                trailing: IconButton(
                  onPressed: () {
                    setState(() {
                      snapshot.data?.delete("age");
                    });
                  },
                  icon: Icon(Icons.edit),
                ),
              );
            },
          ),
          FutureBuilder(
            future: Hive.openBox("box1"),
            builder: (context, snapshot) {
              return ListTile(
                title: Text("Course 1: ${snapshot.data?.get("course1") ?? ""}"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Course 2: ${snapshot.data?.get("course2") ?? ""}"),
                  ],
                ),
                trailing: IconButton(
                  onPressed: () {
                    setState(() {});
                    snapshot.data?.put("course2", "MBA");
                  },
                  icon: Icon(Icons.edit),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
