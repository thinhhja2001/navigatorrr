import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class PageHandle extends StatelessWidget {
  const PageHandle({super.key, required this.pathName});
  final String pathName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text('This is $pathName'),
      ),
    );
  }
}
