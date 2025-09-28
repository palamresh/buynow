import 'package:buynow/features/splash/service/splash_service.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashService sp = SplashService();
  @override
  void initState() {
    sp.isLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Splash Screen")),
      // body: Container(
      //   height: double.infinity,
      //   width: double.infinity,
      //   child: Image.network(
      //     'https://tse1.mm.bing.net/th/id/OIP.x6ZtPLjAeOLQzhPRkA9bLwHaHa?pid=Api&P=0&h=220',
      //     fit: BoxFit.fill,
      //   ),
      // ),
    );
  }
}
