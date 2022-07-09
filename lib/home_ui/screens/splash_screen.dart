import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splashScreen';

  SplashScreen({Key? key}) : super(key: key);
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
      width: size.width,
      height: size.height,
      child: Image.asset(
        'assets/images/splashImage.jpeg',
        fit: BoxFit.cover,
      ),
    ));
  }
}
