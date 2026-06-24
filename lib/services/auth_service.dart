import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  /// Get current user from Supabase Auth
  static User? get currentUser => _supabase.auth.currentUser;

  /// Check if user is logged in
  static bool get isLoggedIn => currentUser != null;

  /// Sign in with Google
  static Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
      );

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return false;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) return false;

      await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
      );

      return true;
    } catch (e) {
      print('Google sign-in error: $e');
      return false;
    }
  }

  /// Sign out
  static Future<void> signOut() async {
    await _supabase.auth.signOut();
    await GoogleSignIn().signOut();
  }

  /// Fetch landlord profile from database
  static Future<Map<String, dynamic>?> fetchProfile() async {
    final user = currentUser;
    if (user == null) return null;

    final response = await _supabase
        .from('landlords')
        .select()
        .eq('auth_id', user.id)
        .maybeSingle();

    return response;
  }

  /// Check if profile is complete
  static Future<bool> isProfileComplete() async {
    final profile = await fetchProfile();
    return profile?['is_complete'] == true;
  }
}
