import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Column(
        children: [
          const Center(
            child: Text("SECOND PAGE"),
          ),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Navigator.pushNamed(context, RoutesName.SECOND_PAGE);
              },
              child: const Text("NAVIGATE")),
        ],
      ),
    );
  }
}
