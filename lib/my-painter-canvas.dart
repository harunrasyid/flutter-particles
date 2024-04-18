import 'dart:math';
import 'package:flutter/material.dart';
import 'package:particles/particle.dart';

Offset polarToCartesian(double speed, double theta) {
  return Offset(speed * cos(theta), speed * sin(theta));
}

class MyPainterCanvas extends CustomPainter {
  List<Particle> particles;
  Random rgn;
  double animationValue;
  MyPainterCanvas(this.rgn, this.particles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      var velocity = polarToCartesian(particle.speed, particle.theta);
      var dx = particle.position.dx + velocity.dx;
      var dy = particle.position.dy + velocity.dy;

      if (particle.position.dx < 0 || particle.position.dx > size.width) {
        dx = rgn.nextDouble() * size.width;
      }
      if (particle.position.dy < 0 || particle.position.dy > size.height) {
        dy = rgn.nextDouble() * size.height;
      }
      particle.position = Offset(dx, dy);
    }

    for (var particle in particles) {
      var paint = Paint();
      paint.color = particle.color;
      canvas.drawCircle(particle.position, particle.radius, paint);
    }

    final paint = Paint();
    paint.color = Colors.white;
    final center = Offset(size.width / 2, size.height / 2);

    Path path1 = Path()
      ..addOval(Rect.fromCenter(
          center: Offset(
            center.dx - 20,
            center.dy + 15,
          ),
          width: size.width / 2,
          height: size.height / 4));

    Path path2 = Path()
      ..addOval(Rect.fromCenter(
          center: center, width: size.width / 2, height: size.height / 4));

    canvas.drawPath(
      // path2,
      Path.combine(PathOperation.difference, path1, path2),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
