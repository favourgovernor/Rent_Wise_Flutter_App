// lib/services/redis_service.dart
//
// Upstash Redis uses a simple REST API — no special
// package needed, just http calls.
//
// How it works:
//   SET  → stores a JSON string with an expiry
//   GET  → retrieves it (returns null if expired)
//   DEL  → removes a key immediately
//
// Cache keys used by RentWise:
//   landlord:{authId}:data    → all buildings/units/tenants
//   otp:limit:{email}         → OTP rate limiting counter

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class RedisService {
  // ── Replace with your Upstash credentials ────────
  // Get from: upstash.com → your database → REST API
  static const _url = 'https://fast-guinea-39746.upstash.io';
  static const _token =
      'AZtCAAIgcDEzOTU2MzBmMmQ2MTg0MTIyOWRiOGRjNDRlODNmOWYzYg';
  // ─────────────────────────────────────────────────

  static final _headers = {
    'Authorization': 'Bearer $_token',
    'Content-Type': 'application/json',
  };

  // ── Cache expiry times (seconds) ─────────────────
  static const _landlordDataTTL = 300; // 5 minutes
  // ignore: unused_field
  static const _vacanciesTTL = 600; // 10 minutes
  static const _otpRateTTL = 60; // 1 minute

  // ════════════════════════════════════════════════
  //  SET  — store a value with expiry
  // ════════════════════════════════════════════════
  static Future<void> set(
    String key,
    dynamic value, {
    int ttl = _landlordDataTTL,
  }) async {
    try {
      final encoded = jsonEncode(value);
      // Upstash REST: SET key value EX ttl
      await http.post(
        Uri.parse('$_url/set/$key'),
        headers: _headers,
        body: jsonEncode([encoded, 'EX', ttl]),
      );
    } catch (e) {
      // Cache failure is never fatal — app still works
      debugPrint('Redis SET error [$key]: $e');
    }
  }

  // ════════════════════════════════════════════════
  //  GET  — retrieve a value (null if missing/expired)
  // ════════════════════════════════════════════════
  static Future<T?> get<T>(String key) async {
    try {
      final res = await http.get(
        Uri.parse('$_url/get/$key'),
        headers: _headers,
      );
      if (res.statusCode != 200) return null;

      final body = jsonDecode(res.body);
      final result = body['result'];
      if (result == null) return null;

      return jsonDecode(result as String) as T;
    } catch (e) {
      debugPrint('Redis GET error [$key]: $e');
      return null;
    }
  }

  // ════════════════════════════════════════════════
  //  DEL  — remove a key (call after any write)
  // ════════════════════════════════════════════════
  static Future<void> del(String key) async {
    try {
      await http.get(
        Uri.parse('$_url/del/$key'),
        headers: _headers,
      );
    } catch (e) {
      debugPrint('Redis DEL error [$key]: $e');
    }
  }

  // ════════════════════════════════════════════════
  //  CONVENIENCE KEYS
  //  Centralised so key names never drift out of sync
  // ════════════════════════════════════════════════
  static String landlordKey(String authId) => 'landlord:$authId:data';

  static String vacanciesKey() => 'vacancies:all';

  static String otpRateLimitKey(String email) => 'otp:limit:$email';

  // ════════════════════════════════════════════════
  //  OTP RATE LIMITING
  //  Returns true if the email is allowed to request
  //  a new OTP, false if they have been rate-limited.
  //  Allows max 3 attempts per 60 seconds.
  // ════════════════════════════════════════════════
  static Future<bool> checkOtpRateLimit(String email) async {
    try {
      final key = otpRateLimitKey(email);

      // INCR returns the new count after incrementing
      final res = await http.get(
        Uri.parse('$_url/incr/$key'),
        headers: _headers,
      );
      if (res.statusCode != 200) return true; // allow on error

      final count = jsonDecode(res.body)['result'] as int? ?? 1;

      // On first increment set the expiry
      if (count == 1) {
        await http.get(
          Uri.parse('$_url/expire/$key/$_otpRateTTL'),
          headers: _headers,
        );
      }

      // Allow up to 3 OTP requests per minute
      return count <= 3;
    } catch (e) {
      debugPrint('Redis OTP rate limit error: $e');
      return true; // allow on error — fail open
    }
  }

  // ════════════════════════════════════════════════
  //  INVALIDATE LANDLORD CACHE
  //  Call this after any write (add building, add
  //  tenant, update payment etc.) so the next read
  //  fetches fresh data from Supabase.
  // ════════════════════════════════════════════════
  static Future<void> invalidateLandlord(String authId) =>
      del(landlordKey(authId));
}
