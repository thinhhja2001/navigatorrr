import 'package:flutter/material.dart';
import 'package:navigator20/main.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController textEditingController = TextEditingController();
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          TextField(controller: textEditingController),
          ElevatedButton(
              onPressed: () =>
                  HomeRouterDelegate().setNewRoutePath(HomeRoutePath.unKnown()),
              child: const Text("go to error")),
          ElevatedButton(
              onPressed: () {
                HomeRouterDelegate().setNewRoutePath(HomeRoutePath.home());
              },
              child: const Text("go to home")),
          ElevatedButton(
              onPressed: () {
                HomeRouterDelegate().setNewRoutePath(
                    HomeRoutePath.otherPage(textEditingController.text));
              },
              child: const Text("go to current"))
        ],
      ),
    );
  }
}
