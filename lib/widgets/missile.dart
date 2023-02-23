import 'package:flutter/material.dart';

class MyMissile extends StatelessWidget {
  const MyMissile({super.key, required this.missleX,required this.missleHeight});
  final double missleX, missleHeight;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(missleX, 1),
      child: Container(
        width: 1,
        height: missleHeight,
        color: Colors.grey,
      ),
    );
  }
}
