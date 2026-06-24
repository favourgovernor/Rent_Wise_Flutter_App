import 'package:flutter/material.dart';
import 'package:rentwise_app/stateless%20widgets/DotGrid.dart';

class AnimatedBackground extends StatelessWidget {
  final Animation<double> animation;
  final Size size;

  const AnimatedBackground({
    super.key,
    required this.animation,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) {
        return Stack(
          children: [
            // Base gradient
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
            // Floating teal orb top-right
            Positioned(
              top: -40 + (20 * animation.value),
              right: -40,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _C.teal.withOpacity(0.12),
                ),
              ),
            ),
            // Floating orb bottom-left
            Positioned(
              bottom: size.height * 0.45 - (15 * animation.value),
              left: -30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _C.teal.withOpacity(0.08),
                ),
              ),
            ),
            // Small dot pattern
            Positioned(
              top: size.height * 0.1 + (10 * animation.value),
              left: 30,
              child: DotGrid(color: _C.teal.withOpacity(0.1)),
            ),
          ],
        );
      },
    );
  }
}

class _C {
  static const Color teal = Colors.teal;
}
