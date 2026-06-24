// lib/services/invite_service.dart
//
// Handles creating tenant invite tokens and building
// the shareable link (for WhatsApp / copy) and sending
// the invite email via Resend.

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InviteService {
  // ── Your deployed Next.js portal URL ─────────────
  // Update this once you deploy to Vercel.
  static const _portalBaseUrl = 'https://rentwise-tenant.vercel.app';

  // ════════════════════════════════════════════════
  //  CREATE INVITE
  //  Creates a row in invite_tokens with all the
  //  prefilled lease data, returns the shareable link.
  // ════════════════════════════════════════════════
  static Future<InviteResult> createInvite({
    required String landlordId,
    required String buildingId,
    required String unitId,
    required String buildingName,
    required String houseNo,
    required double monthlyRent,
    required double deposit,
    String? bedLabel,
    String? landlordName,
    String? tenantPhone,
    String? tenantEmail,
  }) async {
    try {
      final row = await Supabase.instance.client
          .from('invite_tokens')
          .insert({
            'landlord_id': landlordId,
            'building_id': buildingId,
            'unit_id': unitId,
            'bed_label': bedLabel,
            'landlord_name': landlordName,
            'building_name': buildingName,
            'house_no': houseNo,
            'monthly_rent': monthlyRent,
            'deposit': deposit,
            'tenant_phone': tenantPhone,
            'tenant_email': tenantEmail,
          })
          .select('token')
          .single();

      final token = row['token'] as String;
      final link = '$_portalBaseUrl/invite/$token';

      return InviteResult(success: true, token: token, link: link);
    } on PostgrestException catch (e) {
      debugPrint('InviteService.createInvite POSTGREST ERROR: '
          'code=${e.code} message=${e.message}');
      return InviteResult(success: false, error: e.message);
    } catch (e) {
      debugPrint('InviteService.createInvite error: $e');
      return InviteResult(success: false, error: e.toString());
    }
  }

  // ════════════════════════════════════════════════
  //  SEND EMAIL INVITE
  //  Calls a Supabase Edge Function which sends the
  //  email via Resend. The Resend API key never
  //  touches the Flutter app — it stays server-side.
  // ════════════════════════════════════════════════
  static Future<bool> sendInviteEmail({
    required String tenantEmail,
    required String tenantName,
    required String landlordName,
    required String buildingName,
    required String houseNo,
    required String link,
  }) async {
    try {
      final response = await Supabase.instance.client.functions.invoke(
        'send-invite-email',
        body: {
          'tenantEmail': tenantEmail,
          'tenantName': tenantName,
          'landlordName': landlordName,
          'buildingName': buildingName,
          'houseNo': houseNo,
          'link': link,
        },
      );

      if (response.status == 200) {
        debugPrint('InviteService: email sent to $tenantEmail ✅');
        return true;
      }
      debugPrint(
          'InviteService: email send failed — status ${response.status}');
      return false;
    } catch (e) {
      debugPrint('InviteService.sendInviteEmail error: $e');
      return false;
    }
  }

  // ════════════════════════════════════════════════
  //  CANCEL INVITE
  //  If landlord wants to revoke a pending invite.
  // ════════════════════════════════════════════════
  static Future<void> cancelInvite(String token) async {
    try {
      await Supabase.instance.client
          .from('invite_tokens')
          .update({'status': 'cancelled'}).eq('token', token);
    } catch (e) {
      debugPrint('InviteService.cancelInvite error: $e');
    }
  }
}

// ── Result wrapper ─────────────────────────────────
class InviteResult {
  final bool success;
  final String? token;
  final String? link;
  final String? error;

  InviteResult({
    required this.success,
    this.token,
    this.link,
    this.error,
  });
}
