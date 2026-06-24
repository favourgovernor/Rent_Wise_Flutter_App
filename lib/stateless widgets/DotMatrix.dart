import 'package:flutter/material.dart';

class DotMatrix extends StatelessWidget {
  final Color color;
  const DotMatrix({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      height: 70,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemCount: 25,
        itemBuilder: (_, __) => Container(
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
      ),
    );
  }
}
