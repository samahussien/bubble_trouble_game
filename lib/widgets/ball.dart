import 'package:flutter/material.dart';

class MyBall extends StatelessWidget {
  const MyBall({super.key, required this.ballX, required this.ballY});
  final double ballX, ballY;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(ballX,ballY),
      child: Container(
        height: 20,
        width: 20,
        decoration:const BoxDecoration(color:Colors.brown, shape: BoxShape.circle),
      ),
    )
    ;
  }
}
