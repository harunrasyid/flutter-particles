import 'dart:math';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import './my-painter-canvas.dart';
import './particle.dart';

class MyPainter extends StatefulWidget {
  const MyPainter({super.key});

  @override
  State<MyPainter> createState() => _MyPainterState();
}

Color getRandomColor(Random rgn) {
  var a = rgn.nextInt(255);
  var r = rgn.nextInt(255);
  var g = rgn.nextInt(255);
  var b = rgn.nextInt(255);
  return Color.fromARGB(a, r, g, b);
}

const maxRadius = 3;
const maxSpeed = 0.2;
const maxTheta = 2.0 * pi;

class _MyPainterState extends State<MyPainter>
    with SingleTickerProviderStateMixin {
  late List<Particle> particles;
  late Animation<double> animation;
  late AnimationController controller;

  Random rgn = Random(DateTime.now().millisecondsSinceEpoch);

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 10));

    animation = Tween<double>(begin: 0, end: 300).animate(controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });

    controller.forward();

    // Initialize particle
    particles = List.generate(500, (index) {
      var p = Particle();
      p.color = Colors.blueGrey;
      p.position = const Offset(-1, -1);
      p.speed = rgn.nextDouble() * maxSpeed;
      p.theta = rgn.nextDouble() * maxTheta;
      p.radius = rgn.nextDouble() * maxRadius;

      return p;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: CustomPaint(
                painter: MyPainterCanvas(rgn, particles, animation.value),
                child: Container(),
              ),
            ),
            const Text(
              'Eid Mubarak!',
              style: TextStyle(color: Colors.white, fontSize: 50),
            ),
          ],
        ),
      ),
    );
  }
}
