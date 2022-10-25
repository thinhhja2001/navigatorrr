import 'package:flutter/material.dart';
import 'package:navigator20/routes_name.dart';

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: Column(
        children: [
          const Center(
            child: Text("FIRST PAGE"),
          ),
          TextButton(
              onPressed: () {
                Navigator.pushNamed(context, RoutesName.SECOND_PAGE);
              },
              child: const Text("NAVIGATE")),
        ],
      ),
    );
  }
}
