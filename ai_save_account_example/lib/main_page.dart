import 'package:air_design/air_design.dart';
import 'package:flutter/material.dart';

///
/// MainPage
class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("主页面"),
      ),
      body: Center(
        child: MaterialButton(
          onPressed: () {
            Airoute.pushReplacementNamed(routeName: "/LoginPage");
          },
          child: Text("去登录"),
        ),
      ),
    );
  }
}
