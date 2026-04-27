import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Auto-navigate after 3 seconds if no button is tapped
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/onboarding');
      }
    });
  }

  void _navigateTo(String route) {
    Navigator.pushReplacementNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF3A7A96), // dark teal top
              Color(0xFF6DBFBF), // mid teal
              Color(0xFF9ED8D3), // light teal bottom
            ],
            stops: [0.0, 0.45, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── Top: radial overlay + logo ──────────────────────────
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Subtle dark radial at top-right (matches design)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 260,
                        height: 260,
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xFF1E4E6A).withOpacity(0.55),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),

                    // App name
                    const Text(
                      'RentWise',
                      style: TextStyle(
                        fontFamily:
                            'Georgia', // swap for a script font if added
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A3A4A),
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Bottom: buttons ─────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 0, 32, 48),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _SplashButton(
                      label: 'Sign Up',
                      onPressed: () => _navigateTo('/signup'),
                    ),
                    const SizedBox(height: 12),
                    _SplashButton(
                      label: 'Login',
                      onPressed: () => _navigateTo('/login'),
                    ),
                    const SizedBox(height: 12),
                    _SplashButton(
                      label: 'Explore',
                      isPrimary: true,
                      onPressed: () => _navigateTo('/explore'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Reusable button ──────────────────────────────────────────────────────────

class _SplashButton extends StatelessWidget {
  final String label;
  final bool isPrimary;
  final VoidCallback onPressed;

  const _SplashButton({
    required this.label,
    required this.onPressed,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isPrimary ? const Color(0xFF0E2233) : const Color(0xFF1A3A5C),
          foregroundColor: isPrimary ? Colors.white : const Color(0xFFB0CFE0),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          elevation: 0,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: isPrimary ? 17 : 15,
            fontWeight: isPrimary ? FontWeight.bold : FontWeight.w500,
            letterSpacing: isPrimary ? 1.2 : 0.5,
          ),
        ),
      ),
    );
  }
}
