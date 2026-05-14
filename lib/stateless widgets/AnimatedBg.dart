import 'package:flutter/material.dart';
import 'package:rentwise_app/stateless%20widgets/DotMatrix.dart';

class AnimatedBg extends StatelessWidget {
  final Animation<double> animation;
  final Size size;

  const AnimatedBg({required this.animation, required this.size});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) {
        return Stack(
          children: [
            Container(
              width: size.width,
              height: size.height,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0E2233), Color(0xFF1A3C5E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Positioned(
              top: -30 + (18 * animation.value),
              right: -30,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _C.teal.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              bottom: size.height * 0.5 - (12 * animation.value),
              left: -20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _C.teal.withOpacity(0.07),
                ),
              ),
            ),
            // Grid dots top-left
            Positioned(
              top: size.height * 0.07 + (8 * animation.value),
              left: 24,
              child: DotMatrix(color: _C.teal.withOpacity(0.09)),
            ),
          ],
        );
      },
    );
  }
}

class _C {
  static get teal => null;
}
