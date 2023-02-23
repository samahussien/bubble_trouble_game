
import 'package:flutter/material.dart';

class Player extends StatelessWidget {
   const Player({super.key,required this.playerX,required this.playerY});
  final double playerX, playerY;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(playerX, playerY),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          color: Colors.purple,
          width: 50,
          height: 50,
        ),
      ),
    );
  }
}
