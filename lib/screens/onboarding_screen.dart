import 'package:flutter/material.dart';

// ════════════════════════════════════════════════════
//  ONBOARDING SCREEN
//
//  This is a thin bridge. The splash screen navigates
//  here after the landlord taps "Anza kutumia RentWise".
//  It immediately redirects to the login screen.
//
//  It exists as a named route so the splash screen code
//  does not need to be changed.
//
//  If you want to add an onboarding walkthrough later
//  (features tour, how-it-works slides etc.) you can
//  build it here without touching the splash screen.
// ════════════════════════════════════════════════════
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to login immediately on next frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show the loading screen briefly while navigation fires
    return const Scaffold(
      backgroundColor: Color(0xFF0E2233),
      body: Center(
        child: CircularProgressIndicator(
          color: Color(0xFF00BFA5),
          strokeWidth: 2.5,
        ),
      ),
    );
  }
}
