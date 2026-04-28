import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/property_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/verify_otp_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/tenants_screen.dart';
import 'screens/tenant_details_screen.dart';
import 'screens/units_screen.dart';
//import 'screens/add_unit_screen.dart';
import 'screens/messages_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PropertyProvider()),
      ],
      child: MaterialApp(
        title: 'RentWise',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
          '/onboarding': (context) => OnboardingScreen(),
          '/signup': (context) => SignupScreen(),
          '/verify-otp': (context) => VerifyOtpScreen(),
          '/login': (context) => LoginScreen(),
          '/home': (context) => HomeScreen(),
          '/tenants': (context) => TenantsScreen(),
          '/tenant-details': (context) => TenantDetailsScreen(),
          '/units': (context) => UnitsScreen(),
          //'/units': (context) => UnitsScreen(),
          '/messages': (context) => MessagesScreen(),
          '/profile': (context) => ProfileScreen(),
        },
      ),
    );
  }
}
