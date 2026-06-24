import 'package:flutter/material.dart';

class DotGrid extends StatelessWidget {
  final Color color;
  const DotGrid({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
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
