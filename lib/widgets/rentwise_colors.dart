import 'package:flutter/material.dart';

/// RentWise Design System v2
/// Palette: Midnight Navy + Warm Amber + Clean White
/// Inspired by Kenyan fintech — premium, high-contrast,
/// works in bright equatorial sunlight on budget screens.
class RentWiseColors {
  RentWiseColors._();

  // ── Brand — Midnight Navy ──────────────────
  // Deep, trustworthy, premium. Used for headers,
  // active tabs, primary buttons.
  static const Color primary = Color(0xFF0D1B2A); // almost-black navy
  static const Color primaryMid = Color(0xFF1B3A5C); // mid navy
  static const Color primaryLight = Color(0xFF2E5F8A); // lighter navy

  // ── Amber — the signature accent ──────────
  // Warm, energetic, optimistic. KES money feels
  // amber. Used for CTAs, stats, active states.
  static const Color amber = Color(0xFFE8A020); // warm gold-amber
  static const Color amberLight = Color(0xFFFFF3D6); // pale amber tint
  static const Color amberDark = Color(0xFFB87C10); // deep amber

  // ── Teal — success / occupancy ────────────
  // Signals growth, occupancy, good health.
  static const Color teal = Color(0xFF00897B);
  static const Color tealLight = Color(0xFFE0F2F1);
  static const Color tealDark = Color(0xFF00695C);
  static const Color tealCard = Color(0xFFD0EFEB);

  // ── Accent green — paid / confirmed ───────
  static const Color accent = Color(0xFF2E7D32);
  static const Color accentMid = Color(0xFF43A047);
  static const Color accentLite = Color(0xFFE8F5E9);

  // ── Coral — danger / overdue ──────────────
  // Warmer than pure red — less alarming, still urgent.
  static const Color danger = Color(0xFFD84315);
  static const Color dangerLite = Color(0xFFFBE9E7);

  // ── Warning / pending ─────────────────────
  static const Color warning = Color(0xFFF57C00);
  static const Color warningLite = Color(0xFFFFF3E0);

  // ── Violet — KRA / finance ────────────────
  // Distinct from the main palette — signals
  // government / compliance without being scary.
  static const Color purple = Color(0xFF5E35B1);
  static const Color purpleLite = Color(0xFFEDE7F6);

  // ── Indigo — messaging ────────────────────
  static const Color indigo = Color(0xFF3949AB);
  static const Color indigoLite = Color(0xFFE8EAF6);

  // ── Hostel — beds / rooms ─────────────────
  static const Color hostelColor = Color(0xFF0277BD);
  static const Color hostelLite = Color(0xFFE1F5FE);

  // ── Surface & Background ──────────────────
  // Warm off-white — not cold blue-grey, not cream.
  // Feels like good quality paper.
  static const Color bg = Color(0xFFF5F7FA);
  static const Color card = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE8ECF2);
  static const Color inputFill = Color(0xFFF9FAFB);
  static const Color divider = Color(0xFFEEF1F6);

  // ── Text ──────────────────────────────────
  static const Color textDark = Color(0xFF0D1B2A); // same as primary
  static const Color textMid = Color(0xFF52647A); // warm slate
  static const Color textLight = Color(0xFFAAB8C8); // muted

  // ── Bottom nav ────────────────────────────
  static const Color navActive = Color(0xFF0D1B2A);
}
