import 'package:flutter/material.dart';
import 'package:rentwise_app/screens/splash_screen.dart';
import 'package:rentwise_app/stateless%20widgets/Onboarding_Page.dart';

class _C {
  static const Color primary = Color(0xFF1A3C6E);
  static const Color dotOff = Color(0xFFD0D5DD);
}

class SplashScreen1 extends StatefulWidget {
  const SplashScreen1({super.key});

  @override
  State<SplashScreen1> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen1> {
  final PageController _pc = PageController();
  int _page = 0;
  static const int _total = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: true,
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pc,
                onPageChanged: (i) => setState(() => _page = i),
                children: const [
                  OnboardingPage(
                      imagePath:
                          "assets/images/ChatGPT Image May 4, 2026, 06_49_20 AM.png"),
                  OnboardingPage(
                      imagePath:
                          "assets/images/ChatGPT Image May 4, 2026, 06_49_37 AM.png"),
                  OnboardingPage(
                      imagePath:
                          "assets/images/ChatGPT Image May 4, 2026, 06_49_52 AM.png"),
                ],
              ),
            ),

            // Bottom Navigation Area
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 10, 24, 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                        List.generate(_total, (i) => _buildDot(i == _page)),
                  ),
                  const SizedBox(height: 32),

                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_page < _total - 1) {
                          // Go to next page in the PageView
                          _pc.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        } else {
                          // NAVIGATION LOGIC:
                          // Replace 'OnboardingScreen()' with the actual class name
                          // inside your OnboardingScreen.dart file.
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SplashScreen(),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _C.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        _page == _total - 1 ? 'Done' : 'Next',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(bool active) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: active ? 24 : 8,
      decoration: BoxDecoration(
        color: active ? _C.primary : _C.dotOff,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
