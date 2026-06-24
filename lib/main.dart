// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentwise_app/screens/login_screen.dart';
import 'package:rentwise_app/screens/signup_screen.dart';
import 'package:rentwise_app/screens/splash_screen1.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'providers/property_provider.dart';
import 'services/sync_service.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/auth/otp_screen.dart';
import 'screens/auth/setup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/tenants_screen.dart';
import 'screens/tenant_details_screen.dart';
import 'screens/units_screen.dart';
import 'screens/messages_screen.dart';
import 'screens/profile_screen.dart';

// ─── PASTE YOUR VALUES FROM ───────────────────────
// Supabase Dashboard → Settings → API
const _kUrl = 'https://foreegocuetktdhdxhcc.supabase.co';
const _kAnon = 'REMOVED';
// ─────────────────────────────────────────────────

/// Global shortcut — use anywhere after main() runs.
/// import 'package:your_app/main.dart' show supabase;
final supabase = Supabase.instance.client;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: _kUrl, anonKey: _kAnon);

  // Start connectivity listener — enables offline-first
  // WhatsApp-style sync
  SyncService.init();

  runApp(const RentWiseApp());
}

class RentWiseApp extends StatelessWidget {
  const RentWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PropertyProvider()),
      ],
      child: MaterialApp(
        title: 'RentWise',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true),
        // ── On launch, AuthGate decides the first screen ──
        home: const _AuthGate(),
        // ── All named routes ──
        onGenerateRoute: (settings) {
          Widget screen;
          switch (settings.name) {
            case '/splash':
              screen = const SplashScreen();
              break;
            case '/splash1':
              screen = const SplashScreen1();
              break;
            case '/onboarding':
              screen = const OnboardingScreen();
              break;
            case '/login':
              screen = const LoginScreen();
              break;
            case '/signup':
              screen = const SignupScreen();
              break;
            case '/otp':
              screen = const OtpScreen();
              break;
            case '/setup':
              screen = const SetupScreen();
              break;
            case '/home':
              screen = const HomeScreen();
              break;
            case '/tenants':
              screen = const TenantsScreen();
              break;
            case '/tenant-details':
              screen = const TenantDetailsScreen();
              break;
            case '/units':
              screen = const UnitsScreen();
              break;
            case '/messages':
              screen = const MessagesScreen();
              break;
            case '/profile':
              screen = const ProfileScreen();
              break;
            default:
              screen = const SplashScreen();
          }
          return PageRouteBuilder(
            settings: settings, // IMPORTANT: passes arguments through
            pageBuilder: (_, __, ___) => screen,
            transitionDuration: const Duration(milliseconds: 260),
            transitionsBuilder: (_, anim, __, child) =>
                FadeTransition(opacity: anim, child: child),
          );
        },
      ),
    );
  }
}

// ════════════════════════════════════════════════
//  AUTH GATE
//  Runs once on every app start.
//  Checks for an existing session and routes to
//  the correct screen without showing any UI flicker.
// ════════════════════════════════════════════════
class _AuthGate extends StatefulWidget {
  const _AuthGate();
  @override
  State<_AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<_AuthGate> {
  @override
  void initState() {
    super.initState();
    _decide();
  }

  Future<void> _decide() async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final onboardingSeen = prefs.getBool('onboarding_seen') ?? false;

    if (!mounted) return;

    // ── CASE 1: Never opened before ───────────────
    // Show onboarding pages first, then LoginScreen
    if (!onboardingSeen) {
      Navigator.pushReplacementNamed(context, '/splash1');
      return;
    }

    // ── CASE 2: App opened before (all other cases) ─
    // Always go to LoginScreen.
    // Do NOT sign out here — the session must stay
    // alive so that after the landlord enters their
    // password, loadFromSupabase() can query Supabase
    // with a valid authenticated session and return
    // their buildings, units and tenants correctly.
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    // Shown for ~400ms while the session check runs
    return const Scaffold(
      backgroundColor: Color(0xFF0E2233),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home_work_rounded, color: Color(0xFF00BFA5), size: 56),
            SizedBox(height: 20),
            SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                  color: Color(0xFF00BFA5), strokeWidth: 2.5),
            ),
          ],
        ),
      ),
    );
  }
}
