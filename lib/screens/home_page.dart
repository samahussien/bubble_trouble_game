// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:math';
import 'package:bubble_trouble/widgets/ball.dart';
import 'package:bubble_trouble/widgets/button.dart';
import 'package:bubble_trouble/widgets/missile.dart';
import 'package:bubble_trouble/widgets/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// ignore: camel_case_types
enum direction { LEFT, Right }

class _HomePageState extends State<HomePage> {
  static double playerX = 0;
  double playerY = 1;
  double missleX = playerX;
  bool midShot = false;
  double ballX = 0.5, ballY = 0;
  double missleHeight = 10;
  var ballDirection = direction.LEFT;
  void fireMissle() {
    if (midShot == false) {
      Timer.periodic(const Duration(milliseconds: 20), (timer) {
        //shots fired
        midShot = true;
        //missile grows till touch the top of the screen
        setState(() {
          missleHeight += 10;
        });

        //stop missle when it reaches top of screen
        if (missleHeight > MediaQuery.of(context).size.height * 3 / 4) {
          resetMissle();

          timer.cancel();
        }

        //check if missle touche the ball
        if (ballY > heightToPosition(missleHeight) &&
            (ballX - missleX).abs() < 0.03) {
          resetMissle();
          setState(() {
            ballX = Random().nextDouble();
            ballY = Random().nextDouble();
          });
          print(Random().nextDouble());
          timer.cancel();
        }
      });
    }
  }

  void startGame() {
    double time = 0, height = 0, velocity = 100;
    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      height = -5 * time * time + velocity * time;
      if (height < 0) {
        time = 0;
      }
      setState(() {
        ballY = heightToPosition(height);
      });
      time += 0.1;
      if (ballX - 0.005 < -1) {
        ballDirection = direction.Right;
      } else if (ballX + 0.005 > 1) {
        ballDirection = direction.LEFT;
      }

      if (ballDirection == direction.LEFT) {
        setState(() {
          ballX -= 0.01;
        });
      } else if (ballDirection == direction.Right) {
        setState(() {
          ballX += 0.01;
        });
      }
      //check if the ball hits the player
      if (playerDies()) {
        timer.cancel();
        setState(() {
          ballX = 0.5;
          ballY = 0;
        });
        _showDialog();
      }
    });
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.grey[700],
            title: const Text(
              "You dead bro",
              style: TextStyle(color: Colors.white),
            ),
          );
        });
  }

  void resetMissle() {
    missleX = playerX;
    missleHeight = 10;
    midShot = false;
  }

  void moveLeft() {
    setState(() {
      if (playerX - 0.01 > -1) playerX -= 0.05;
      if (!midShot) {
        missleX = playerX;
      }
    });
  }

  void moveRight() {
    setState(() {
      if (playerX + 0.01 < 1) playerX += 0.05;
      if (!midShot) {
        missleX = playerX;
      }
    });
  }

  double heightToPosition(double height) {
    double totalHeight = MediaQuery.of(context).size.height * 3 / 4;
    double position = 1 - 2 * height / totalHeight;
    return position;
  }

  bool playerDies() {
    if ((ballX - playerX).abs() < 0.05 && ballY > 0.95) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (RawKeyEvent event) {
        if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
          moveLeft();
        } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
          moveRight();
        }
        if (event.isKeyPressed(LogicalKeyboardKey.space)) fireMissle();
      },
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.pink[100],
              child: Center(
                  child: Stack(
                children: [
                  MyBall(ballX: ballX, ballY: ballY),
                  MyMissile(missleX: missleX, missleHeight: missleHeight),
                  Player(playerX: playerX, playerY: playerY),
                ],
              )),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MyButton(icon: Icons.play_arrow, function: startGame),
                  MyButton(icon: Icons.arrow_back, function: moveLeft),
                  MyButton(
                    function: fireMissle,
                    icon: Icons.arrow_upward,
                  ),
                  MyButton(
                    function: moveRight,
                    icon: Icons.arrow_forward,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
