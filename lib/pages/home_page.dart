import 'package:flutter/material.dart';
import 'package:navigator20/main.dart';

class HomePage extends StatelessWidget {
  final Widget? child;

  const HomePage({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const TextField(),
          ElevatedButton(
              onPressed: () {
                HomeRouterDelegate()
                    .setNewRoutePath(HomeRoutePath.otherPage('/vietnam2k1'));
              },
              child: Text("go to error")),
          ElevatedButton(onPressed: () {}, child: Text("go to home")),
          ElevatedButton(onPressed: () {}, child: Text("go to current"))
        ],
      ),
    );
  }
}
