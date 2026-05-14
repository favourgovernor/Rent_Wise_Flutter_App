import 'package:flutter/material.dart';
import 'package:rentwise_app/stateless%20widgets/Logo.dart';

class OnboardingPage extends StatelessWidget {
  final String imagePath;
  const OnboardingPage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Logo(),
        const SizedBox(height: 20),
        Expanded(
          child: Image.asset(
            imagePath,
            width: double.infinity,
            // BoxFit.fitWidth makes the image touch the sides of the screen
            fit: BoxFit.fitWidth,
            alignment: Alignment.topCenter,
            // Error builder prevents the app from crashing if a file is missing
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Text("Image not found. Check filename!"),
              );
            },
          ),
        ),
      ],
    );
  }
}
