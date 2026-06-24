import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import '../providers/property_provider.dart';
import '../services/invite_service.dart';
import '../stateless widgets/HomeScreen Stateless Widget/Section_Header.dart';
import '../stateless widgets/HomeScreen Stateless Widget/add_bar.dart';
import '../stateless widgets/HomeScreen Stateless Widget/available_banner.dart';
import '../stateless widgets/HomeScreen Stateless Widget/big_stat_card.dart';
import '../stateless widgets/HomeScreen Stateless Widget/count_chip.dart';
import '../stateless widgets/HomeScreen Stateless Widget/deposits_card.dart';
import '../stateless widgets/HomeScreen Stateless Widget/empty_card.dart';
import '../stateless widgets/HomeScreen Stateless Widget/maintenance_row.dart';
import '../stateless widgets/HomeScreen Stateless Widget/no_space_note.dart';
import '../stateless widgets/HomeScreen Stateless Widget/quick_action.dart';
import '../stateless widgets/HomeScreen Stateless Widget/rev_chip.dart';
import '../stateless widgets/HomeScreen Stateless Widget/stat_bar.dart';
import '../stateless widgets/HomeScreen Stateless Widget/stat_tile.dart';
import '../stateless widgets/HomeScreen Stateless Widget/tax_row.dart';
import '../stateless widgets/HomeScreen Stateless Widget/tenant_row.dart';
import '../stateless widgets/HomeScreen Stateless Widget/unit_card.dart';
import '../widgets/rentwise_colors.dart';
import '../widgets/sheet_widgets.dart';
import '../widgets/building_type_chip.dart';

// ═══════════════════════════════════════════════
//  HOME SCREEN
// ═══════════════════════════════════════════════
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  static const _uuid = Uuid();

  int _bldg = 0;
  int _nav = 0;

  // ── Real landlord initials from Supabase ───
  String _initials = '?';
  String _landlordName = '';

  late AnimationController _barCtrl;
  late Animation<double> _barAnim;

  @override
  void initState() {
    super.initState();
    _barCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _barAnim = CurvedAnimation(parent: _barCtrl, curve: Curves.easeOutCubic);
    _barCtrl.forward();
    _loadInitials();
  }

  @override
  void dispose() {
    _barCtrl.dispose();
    super.dispose();
  }

  // ── Load real initials from Supabase ──────
  Future<void> _loadInitials() async {
    try {
      final uid = Supabase.instance.client.auth.currentUser?.id;
      if (uid == null) return;

      final row = await Supabase.instance.client
          .from('landlords')
          .select('name')
          .eq('auth_id', uid)
          .maybeSingle();

      if (!mounted) return;
      final name = row?['name'] as String? ?? '';
      final parts = name.trim().split(' ').where((p) => p.isNotEmpty).toList();
      final initials = parts.length >= 2
          ? '${parts[0][0]}${parts[1][0]}'.toUpperCase()
          : name.isNotEmpty
              ? name[0].toUpperCase()
              : '?';

      setState(() {
        _initials = initials;
        _landlordName = name;
      });
    } catch (_) {}
  }

  void _switchBuilding(int i) {
    setState(() => _bldg = i);
    _barCtrl.reset();
    _barCtrl.forward();
  }

  List<AppBuilding> _getBuildings() =>
      context.watch<PropertyProvider>().buildings;

  AppBuilding _currentBuilding(List<AppBuilding> buildings) {
    if (buildings.isEmpty) {
      return AppBuilding(
        id: 'placeholder',
        name: 'No Properties',
        propertyType: PropertyType.apartment,
      );
    }
    if (_bldg >= buildings.length) _bldg = 0;
    return buildings[_bldg];
  }

  // Always reads the LATEST building from the provider.
  // Use this inside sheet callbacks so stale snapshots are never used.
  AppBuilding _liveBuilding() {
    final buildings = context.read<PropertyProvider>().buildings;
    if (buildings.isEmpty) return _currentBuilding([]);
    if (_bldg >= buildings.length) return buildings.last;
    return buildings[_bldg];
  }

  // ── Formatters ──────────────────────────────
  String _fmtK(double v) => v >= 1000
      ? 'KES ${(v / 1000).toStringAsFixed(0)}K'
      : 'KES ${v.toStringAsFixed(0)}';

  String _fmtFull(double v) => 'KES ${v.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+$)'),
        (m) => '${m[1]},',
      )}';

  Color _sc(String s) => s == 'paid'
      ? RentWiseColors.accent
      : s == 'pending'
          ? RentWiseColors.warning
          : RentWiseColors.danger;
  Color _sb(String s) => s == 'paid'
      ? RentWiseColors.accentLite
      : s == 'pending'
          ? RentWiseColors.warningLite
          : RentWiseColors.dangerLite;
  IconData _si(String s) => s == 'paid'
      ? Icons.check_circle_rounded
      : s == 'pending'
          ? Icons.schedule_rounded
          : Icons.error_rounded;
  String _sl(String s) => s == 'paid'
      ? 'Paid'
      : s == 'pending'
          ? 'Pending'
          : 'Overdue';

  // ── Property type badge ──────────────────────
  Widget _propTypeBadge(AppBuilding b) {
    Color color;
    String label;
    IconData icon;
    switch (b.propertyType) {
      case PropertyType.hostel:
        color = RentWiseColors.hostelColor;
        label = 'Hostel';
        icon = Icons.hotel_rounded;
        break;
      case PropertyType.mixed:
        color = RentWiseColors.purple;
        label = 'Mixed';
        icon = Icons.villa_rounded;
        break;
      default:
        color = RentWiseColors.tealDark;
        label = 'Apartment';
        icon = Icons.apartment_rounded;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: color, size: 12),
        const SizedBox(width: 4),
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: 11, fontWeight: FontWeight.w600, color: color)),
      ]),
    );
  }

  void _snack(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg,
          style: GoogleFonts.poppins(fontSize: 13, color: Colors.white)),
      backgroundColor: error ? RentWiseColors.danger : RentWiseColors.accent,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
      duration: Duration(seconds: error ? 4 : 3),
    ));
  }

  // ═══════════════════════════════════════════
  //  INVITE TENANT SHEET
  // ═══════════════════════════════════════════
  void _showInviteTenant(AppBuilding b) {
    final phoneCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    String? selectedUnitId;
    String bedLabel = 'Bed A';

    final availableUnits = b.units.where((u) => !u.isFull).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setS) {
          final selectedUnit = selectedUnitId != null
              ? availableUnits.firstWhere((u) => u.id == selectedUnitId,
                  orElse: () => availableUnits.first)
              : null;

          final List<String> availableBeds =
              selectedUnit != null && selectedUnit.isHostel
                  ? _getAvailableBedLabels(selectedUnit)
                  : [];

          return AppSheet(
            title: 'Invite Tenant',
            icon: Icons.person_add_rounded,
            iconColor: RentWiseColors.accent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: RentWiseColors.accentLite,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: RentWiseColors.accent.withOpacity(0.2)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline_rounded,
                          color: RentWiseColors.accent, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'The tenant will receive a link to fill in their details and sign the lease digitally. Each tenant has their own record.',
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: RentWiseColors.accent,
                              height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SheetLabel(b.isHostel
                    ? 'Select Room (available beds shown)'
                    : 'Select Unit'),
                const SizedBox(height: 10),
                if (availableUnits.isEmpty)
                  NoSpaceNote(isHostel: b.isHostel)
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: availableUnits.map((u) {
                      final on = u.id == selectedUnitId;
                      return GestureDetector(
                        onTap: () {
                          setS(() {
                            selectedUnitId = u.id;
                            final beds = _getAvailableBedLabels(u);
                            if (beds.isNotEmpty) bedLabel = beds.first;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: on ? RentWiseColors.accent : Colors.white,
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(
                                color: on
                                    ? RentWiseColors.accent
                                    : RentWiseColors.border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(u.name,
                                  style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: on
                                          ? Colors.white
                                          : RentWiseColors.textDark)),
                              if (u.isHostel)
                                Text(
                                    '${u.availableBeds} of ${u.capacity} beds free  ·  ${_fmtK(u.rentPerBed)}/bed',
                                    style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        color: on
                                            ? Colors.white70
                                            : RentWiseColors.textMid))
                              else
                                Text('${_fmtK(u.rentTotal)}/mo',
                                    style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        color: on
                                            ? Colors.white70
                                            : RentWiseColors.textMid)),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                if (selectedUnit != null &&
                    selectedUnit.isHostel &&
                    availableBeds.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const SheetLabel('Assign Bed'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: availableBeds.map((bed) {
                      final on = bed == bedLabel;
                      return GestureDetector(
                        onTap: () => setS(() => bedLabel = bed),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color:
                                on ? RentWiseColors.hostelColor : Colors.white,
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(
                                color: on
                                    ? RentWiseColors.hostelColor
                                    : RentWiseColors.border),
                          ),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            Icon(Icons.bed_rounded,
                                size: 14,
                                color:
                                    on ? Colors.white : RentWiseColors.textMid),
                            const SizedBox(width: 6),
                            Text(bed,
                                style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: on
                                        ? Colors.white
                                        : RentWiseColors.textMid)),
                          ]),
                        ),
                      );
                    }).toList(),
                  ),
                ],
                const SizedBox(height: 20),
                const SheetLabel('Tenant Phone Number'),
                const SizedBox(height: 8),
                SheetField(
                  controller: phoneCtrl,
                  hint: '07XX XXX XXX',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  onChanged: (_) => setS(() {}),
                ),
                const SizedBox(height: 14),
                const SheetLabel('Tenant Email'),
                const SizedBox(height: 8),
                SheetField(
                  controller: emailCtrl,
                  hint: 'tenant@example.com',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (_) => setS(() {}),
                ),
                const SizedBox(height: 28),
                SheetBtn(
                  label: 'Create Invite',
                  icon: Icons.send_rounded,
                  color: RentWiseColors.accent,
                  disabled: availableUnits.isEmpty ||
                      selectedUnitId == null ||
                      !RegExp(r'^[\w.+\-]+@[\w\-]+\.\w{2,}$')
                          .hasMatch(emailCtrl.text.trim()),
                  onTap: () async {
                    if (selectedUnitId == null) return;
                    final unit = availableUnits
                        .firstWhere((u) => u.id == selectedUnitId);

                    Navigator.pop(context);
                    await _createAndShowInvite(
                      building: b,
                      unit: unit,
                      bedLabel: unit.isHostel ? bedLabel : null,
                      tenantPhone: phoneCtrl.text.trim(),
                      tenantEmail: emailCtrl.text.trim(),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<String> _getAvailableBedLabels(AppUnit unit) {
    const all = [
      'Bed A',
      'Bed B',
      'Bed C',
      'Bed D',
      'Bed E',
      'Bed F',
      'Bed G',
      'Bed H'
    ];
    return all.skip(unit.tenantIds.length).take(unit.availableBeds).toList();
  }

  // ═══════════════════════════════════════════
  //  CREATE INVITE + SHOW SHARE SHEET
  // ═══════════════════════════════════════════
  Future<void> _createAndShowInvite({
    required AppBuilding building,
    required AppUnit unit,
    String? bedLabel,
    required String tenantPhone,
    required String tenantEmail,
  }) async {
    // Loading indicator while we create the invite
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: RentWiseColors.accent),
      ),
    );

    final landlordId = await _liveLandlordId();
    final result = await InviteService.createInvite(
      landlordId: landlordId,
      buildingId: building.id,
      unitId: unit.id,
      buildingName: building.name,
      houseNo: unit.name,
      monthlyRent: unit.isHostel ? unit.rentPerBed : unit.rentTotal,
      deposit: unit.isHostel ? unit.rentPerBed : unit.rentTotal,
      bedLabel: bedLabel,
      landlordName: _landlordName,
      tenantPhone: tenantPhone,
      tenantEmail: tenantEmail,
    );

    if (!mounted) return;
    Navigator.pop(context); // close loading dialog

    if (!result.success || result.link == null) {
      _snack('Could not create invite: ${result.error ?? "unknown error"}',
          error: true);
      return;
    }

    // Try sending the email — non-blocking for the UI flow
    InviteService.sendInviteEmail(
      tenantEmail: tenantEmail,
      tenantName: 'New Tenant',
      landlordName: _landlordName.isNotEmpty ? _landlordName : 'Your Landlord',
      buildingName: building.name,
      houseNo: unit.name,
      link: result.link!,
    );

    if (!mounted) return;
    _showInviteShareSheet(result.link!, tenantEmail);
  }

  // Look up the current landlord's internal ID fresh
  Future<String> _liveLandlordId() async {
    final uid = Supabase.instance.client.auth.currentUser?.id;
    if (uid == null) return '';
    final row = await Supabase.instance.client
        .from('landlords')
        .select('id')
        .eq('auth_id', uid)
        .maybeSingle();
    return row?['id'] as String? ?? '';
  }

  // ── Share sheet — Copy Link + WhatsApp ───────
  void _showInviteShareSheet(String link, String tenantEmail) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AppSheet(
        title: 'Invite Created 🎉',
        icon: Icons.check_circle_rounded,
        iconColor: RentWiseColors.accent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: RentWiseColors.accentLite,
                borderRadius: BorderRadius.circular(14),
                border:
                    Border.all(color: RentWiseColors.accent.withOpacity(0.2)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.email_outlined,
                      color: RentWiseColors.accent, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'An email has been sent to $tenantEmail. '
                      'You can also share the link directly below.',
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: RentWiseColors.accent,
                          height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const SheetLabel('Invite Link'),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: RentWiseColors.border),
              ),
              child: Text(link,
                  style: GoogleFonts.poppins(
                      fontSize: 12, color: RentWiseColors.textMid),
                  overflow: TextOverflow.ellipsis),
            ),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: link));
                    if (!context.mounted) return;
                    _snack('Link copied to clipboard 📋');
                  },
                  icon: const Icon(Icons.copy_rounded, size: 18),
                  label: Text('Copy Link',
                      style: GoogleFonts.poppins(
                          fontSize: 13, fontWeight: FontWeight.w600)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: RentWiseColors.primary,
                    side: const BorderSide(color: RentWiseColors.border),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _shareToWhatsApp(link),
                  icon: const Icon(Icons.chat_rounded, size: 18),
                  label: Text('WhatsApp',
                      style: GoogleFonts.poppins(
                          fontSize: 13, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28)),
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Done',
                    style: GoogleFonts.poppins(
                        fontSize: 14, color: RentWiseColors.textMid)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _shareToWhatsApp(String link) async {
    final message = Uri.encodeComponent(
        'Hi! Here is your tenant registration link for RentWise. '
        'Please fill in your details: $link');
    final uri = Uri.parse('https://wa.me/?text=$message');
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (!mounted) return;
      _snack('Could not open WhatsApp. Link copied instead.', error: true);
      await Clipboard.setData(ClipboardData(text: link));
    }
  }

  // ═══════════════════════════════════════════
  //  ADD UNIT SHEET
  // ═══════════════════════════════════════════
  void _showAddUnit(AppBuilding b) {
    final nameCtrl = TextEditingController();
    final rentCtrl = TextEditingController();
    final capacityCtrl = TextEditingController(text: '2');
    String roomType = b.isHostel ? 'hostel' : '1br';
    UnitType unitType = b.isHostel ? UnitType.hostelRoom : UnitType.apartment;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setS) => AppSheet(
          title: b.isHostel ? 'Add Hostel Room' : 'Add Unit',
          icon: Icons.meeting_room_rounded,
          iconColor: RentWiseColors.teal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (b.isMixed) ...[
                const SheetLabel('Unit Type'),
                const SizedBox(height: 8),
                Row(children: [
                  Expanded(
                      child: GestureDetector(
                    onTap: () => setS(() {
                      unitType = UnitType.apartment;
                      roomType = '1br';
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: unitType == UnitType.apartment
                            ? RentWiseColors.primary
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: unitType == UnitType.apartment
                                ? RentWiseColors.primary
                                : RentWiseColors.border),
                      ),
                      child: Column(children: [
                        Icon(Icons.apartment_rounded,
                            color: unitType == UnitType.apartment
                                ? Colors.white
                                : RentWiseColors.textLight,
                            size: 22),
                        const SizedBox(height: 4),
                        Text('Apartment',
                            style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: unitType == UnitType.apartment
                                    ? Colors.white
                                    : RentWiseColors.textMid)),
                        Text('1 tenant',
                            style: GoogleFonts.poppins(
                                fontSize: 10,
                                color: unitType == UnitType.apartment
                                    ? Colors.white60
                                    : RentWiseColors.textLight)),
                      ]),
                    ),
                  )),
                  const SizedBox(width: 12),
                  Expanded(
                      child: GestureDetector(
                    onTap: () => setS(() {
                      unitType = UnitType.hostelRoom;
                      roomType = 'hostel';
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: unitType == UnitType.hostelRoom
                            ? RentWiseColors.hostelColor
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: unitType == UnitType.hostelRoom
                                ? RentWiseColors.hostelColor
                                : RentWiseColors.border),
                      ),
                      child: Column(children: [
                        Icon(Icons.hotel_rounded,
                            color: unitType == UnitType.hostelRoom
                                ? Colors.white
                                : RentWiseColors.textLight,
                            size: 22),
                        const SizedBox(height: 4),
                        Text('Hostel Room',
                            style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: unitType == UnitType.hostelRoom
                                    ? Colors.white
                                    : RentWiseColors.textMid)),
                        Text('Multiple tenants',
                            style: GoogleFonts.poppins(
                                fontSize: 10,
                                color: unitType == UnitType.hostelRoom
                                    ? Colors.white60
                                    : RentWiseColors.textLight)),
                      ]),
                    ),
                  )),
                ]),
                const SizedBox(height: 18),
              ],
              SheetLabel(unitType == UnitType.hostelRoom
                  ? 'Room Name / Number'
                  : 'Unit Name / Number'),
              const SizedBox(height: 8),
              SheetField(
                controller: nameCtrl,
                hint: unitType == UnitType.hostelRoom
                    ? 'e.g. Room 4, Dorm B'
                    : 'e.g. A1, Unit 3',
                icon: Icons.door_front_door_outlined,
              ),
              const SizedBox(height: 18),
              if (unitType == UnitType.apartment) ...[
                const SheetLabel('Room Type'),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: {
                    'bedsitter': 'Bedsitter',
                    '1br': '1 Bedroom',
                    '2br': '2 Bedroom',
                    '3br': '3 Bedroom'
                  }.entries.map((e) {
                    final on = e.key == roomType;
                    return GestureDetector(
                      onTap: () => setS(() => roomType = e.key),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 10),
                        decoration: BoxDecoration(
                          color: on ? RentWiseColors.primary : Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                              color: on
                                  ? RentWiseColors.primary
                                  : RentWiseColors.border),
                        ),
                        child: Text(e.value,
                            style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: on
                                    ? Colors.white
                                    : RentWiseColors.textMid)),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),
              ],
              SheetLabel(unitType == UnitType.hostelRoom
                  ? 'Rent per Bed (KES/month)'
                  : 'Monthly Rent (KES)'),
              const SizedBox(height: 8),
              SheetField(
                controller: rentCtrl,
                hint: unitType == UnitType.hostelRoom
                    ? 'e.g. 8000 per bed'
                    : 'e.g. 15000',
                icon: Icons.monetization_on_outlined,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              if (unitType == UnitType.hostelRoom) ...[
                const SizedBox(height: 18),
                const SheetLabel('Number of Beds in this Room'),
                const SizedBox(height: 8),
                Row(children: [
                  SizedBox(
                      width: 90,
                      child: SheetField(
                        controller: capacityCtrl,
                        hint: '2',
                        icon: Icons.bed_rounded,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(2),
                        ],
                      )),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Text(
                    'Each bed is rented separately. Each tenant gets their own invite link and lease.',
                    style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: RentWiseColors.textMid,
                        height: 1.5),
                  )),
                ]),
              ],
              const SizedBox(height: 28),
              SheetBtn(
                label: unitType == UnitType.hostelRoom
                    ? 'Add Hostel Room'
                    : 'Add Unit',
                icon: Icons.add_rounded,
                color: unitType == UnitType.hostelRoom
                    ? RentWiseColors.hostelColor
                    : RentWiseColors.primary,
                onTap: () async {
                  if (nameCtrl.text.trim().isEmpty ||
                      rentCtrl.text.trim().isEmpty) return;
                  final cap = unitType == UnitType.hostelRoom
                      ? (int.tryParse(capacityCtrl.text) ?? 2).clamp(1, 20)
                      : 1;
                  final u = AppUnit(
                    id: _uuid.v4(),
                    name: nameCtrl.text.trim(),
                    roomType: roomType,
                    unitType: unitType,
                    capacity: cap,
                    tenantIds: [],
                    rentPerBed: unitType == UnitType.hostelRoom
                        ? (double.tryParse(rentCtrl.text) ?? 0)
                        : 0,
                    rentTotal: unitType == UnitType.apartment
                        ? (double.tryParse(rentCtrl.text) ?? 0)
                        : 0,
                  );
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  await context
                      .read<PropertyProvider>()
                      .addUnit(_liveBuilding().id, u);
                  _snack(unitType == UnitType.hostelRoom
                      ? 'Room "${u.name}" ($cap beds) added! 🛏️'
                      : 'Unit "${u.name}" added! 🏠');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════
  //  MESSAGE TENANTS SHEET
  // ═══════════════════════════════════════════
  void _showMessageTenants(AppBuilding b) {
    final msgCtrl = TextEditingController();
    String sendTo = 'all';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setS) => AppSheet(
          title: 'Message Tenants',
          icon: Icons.chat_rounded,
          iconColor: RentWiseColors.indigo,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SheetLabel('Send To'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: {
                  'all': 'All Tenants',
                  'overdue': 'Overdue Only',
                  'pending': 'Pending Only',
                }.entries.map((e) {
                  final on = sendTo == e.key;
                  return GestureDetector(
                    onTap: () => setS(() => sendTo = e.key),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 9),
                      decoration: BoxDecoration(
                        color: on ? RentWiseColors.indigo : Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                            color: on
                                ? RentWiseColors.indigo
                                : RentWiseColors.border),
                      ),
                      child: Text(e.value,
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color:
                                  on ? Colors.white : RentWiseColors.textMid)),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              const SheetLabel('Message'),
              const SizedBox(height: 8),
              TextField(
                controller: msgCtrl,
                maxLines: 4,
                style: GoogleFonts.poppins(
                    fontSize: 14, color: RentWiseColors.textDark),
                decoration: InputDecoration(
                  hintText: 'Type your message here...',
                  hintStyle: GoogleFonts.poppins(
                      fontSize: 13, color: RentWiseColors.textLight),
                  filled: true,
                  fillColor: const Color(0xFFF9FAFB),
                  contentPadding: const EdgeInsets.all(14),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide:
                          const BorderSide(color: RentWiseColors.border)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide:
                          const BorderSide(color: RentWiseColors.border)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                          color: RentWiseColors.indigo, width: 1.8)),
                ),
              ),
              const SizedBox(height: 28),
              SheetBtn(
                label: 'Send Message',
                icon: Icons.send_rounded,
                color: RentWiseColors.indigo,
                onTap: () {
                  Navigator.pop(context);
                  _snack('Message sent! 💬');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════
  //  KRA TAX SHEET
  // ═══════════════════════════════════════════
  void _showKraTax(AppBuilding b) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AppSheet(
        title: 'KRA Tax Payment',
        icon: Icons.account_balance_rounded,
        iconColor: RentWiseColors.purple,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: RentWiseColors.purpleLite,
                borderRadius: BorderRadius.circular(14),
                border:
                    Border.all(color: RentWiseColors.purple.withOpacity(0.2)),
              ),
              child: Text(
                'As a landlord in Kenya, rental income is taxed at 7.5% of gross rent under the Monthly Rental Income (MRI) tax.',
                style: GoogleFonts.poppins(
                    fontSize: 12, color: RentWiseColors.purple, height: 1.6),
              ),
            ),
            const SizedBox(height: 20),
            TaxRow('Total Gross Rent', _fmtFull(b.expectedRevenue)),
            const SizedBox(height: 10),
            const TaxRow('MRI Tax Rate', '7.5%'),
            const SizedBox(height: 10),
            TaxRow('Estimated Tax Due', _fmtFull(b.expectedRevenue * 0.075),
                highlighted: true),
            const SizedBox(height: 28),
            SheetBtn(
              label: 'Open KRA iTax Portal',
              icon: Icons.open_in_new_rounded,
              color: RentWiseColors.purple,
              onTap: () {
                Navigator.pop(context);
                _snack('Opening KRA iTax Portal...');
              },
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════
  //  ADD MAINTENANCE SHEET
  // ═══════════════════════════════════════════
  void _showAddMaintenance(AppBuilding b) {
    final titleCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    String type = 'invoice';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setS) => AppSheet(
          title: 'Add Maintenance Record',
          icon: Icons.build_rounded,
          iconColor: RentWiseColors.warning,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SheetLabel('Description'),
              const SizedBox(height: 8),
              SheetField(
                  controller: titleCtrl,
                  hint: 'e.g. Plumbing repair',
                  icon: Icons.description_outlined),
              const SizedBox(height: 18),
              const SheetLabel('Record Type'),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(
                    child: GestureDetector(
                  onTap: () => setS(() => type = 'invoice'),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                        color: type == 'invoice'
                            ? RentWiseColors.warning
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: type == 'invoice'
                                ? RentWiseColors.warning
                                : RentWiseColors.border)),
                    child: Column(children: [
                      Icon(Icons.receipt_long_rounded,
                          color: type == 'invoice'
                              ? Colors.white
                              : RentWiseColors.textLight,
                          size: 22),
                      const SizedBox(height: 4),
                      Text('Invoice',
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: type == 'invoice'
                                  ? Colors.white
                                  : RentWiseColors.textMid)),
                    ]),
                  ),
                )),
                const SizedBox(width: 12),
                Expanded(
                    child: GestureDetector(
                  onTap: () => setS(() => type = 'receipt'),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                        color: type == 'receipt'
                            ? RentWiseColors.accent
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: type == 'receipt'
                                ? RentWiseColors.accent
                                : RentWiseColors.border)),
                    child: Column(children: [
                      Icon(Icons.check_circle_outline_rounded,
                          color: type == 'receipt'
                              ? Colors.white
                              : RentWiseColors.textLight,
                          size: 22),
                      const SizedBox(height: 4),
                      Text('Receipt',
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: type == 'receipt'
                                  ? Colors.white
                                  : RentWiseColors.textMid)),
                    ]),
                  ),
                )),
              ]),
              const SizedBox(height: 18),
              const SheetLabel('Amount (KES)'),
              const SizedBox(height: 8),
              SheetField(
                  controller: amountCtrl,
                  hint: 'e.g. 5000',
                  icon: Icons.monetization_on_outlined,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
              const SizedBox(height: 28),
              SheetBtn(
                label: 'Save Record',
                icon: Icons.save_rounded,
                color: RentWiseColors.warning,
                onTap: () async {
                  if (titleCtrl.text.trim().isEmpty ||
                      amountCtrl.text.trim().isEmpty) return;
                  final item = AppMaintenance(
                    id: _uuid.v4(),
                    title: titleCtrl.text.trim(),
                    unitName: 'General',
                    type: type,
                    status: 'unpaid',
                    amount: double.tryParse(amountCtrl.text) ?? 0,
                    date: DateTime.now(),
                  );
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  await context
                      .read<PropertyProvider>()
                      .addMaintenance(_liveBuilding().id, item);
                  _snack('Maintenance record saved! 🔧');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════
  //  ADD BUILDING SHEET
  // ═══════════════════════════════════════════
  void _showAddBuilding() {
    final nameCtrl = TextEditingController();
    PropertyType type = PropertyType.apartment;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setS) => AppSheet(
          title: 'Add New Building',
          icon: Icons.apartment_rounded,
          iconColor: RentWiseColors.teal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SheetLabel('Building Name'),
              const SizedBox(height: 8),
              SheetField(
                  controller: nameCtrl,
                  hint: 'e.g. Sunrise Court',
                  icon: Icons.home_work_outlined),
              const SizedBox(height: 18),
              const SheetLabel('Building Type'),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(
                    child: BuildingTypeChip(
                  label: 'Apartment',
                  icon: Icons.apartment_rounded,
                  selected: type == PropertyType.apartment,
                  onTap: () => setS(() => type = PropertyType.apartment),
                )),
                const SizedBox(width: 8),
                Expanded(
                    child: BuildingTypeChip(
                  label: 'Hostel',
                  icon: Icons.hotel_rounded,
                  selected: type == PropertyType.hostel,
                  onTap: () => setS(() => type = PropertyType.hostel),
                )),
                const SizedBox(width: 8),
                Expanded(
                    child: BuildingTypeChip(
                  label: 'Mixed',
                  icon: Icons.villa_rounded,
                  selected: type == PropertyType.mixed,
                  onTap: () => setS(() => type = PropertyType.mixed),
                )),
              ]),
              const SizedBox(height: 28),
              SheetBtn(
                label: 'Add Building',
                icon: Icons.add_rounded,
                color: RentWiseColors.primary,
                onTap: () async {
                  if (nameCtrl.text.trim().isEmpty) return;
                  if (!context.mounted) return;
                  final name = nameCtrl.text.trim();
                  Navigator.pop(context);
                  await context
                      .read<PropertyProvider>()
                      .addBuilding(name, type);
                  // _liveBuilding will reflect the new building on next access
                  _snack('"$name" added! 🏢');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════
  //  BUILD
  // ═══════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    final buildings = _getBuildings();
    final b = _currentBuilding(buildings);

    return Scaffold(
      backgroundColor: RentWiseColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 14),
            _buildAptTabs(buildings),
            if (_nav == 0 && buildings.isNotEmpty) ...[
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildStatsCard(b),
              ),
            ],
            const SizedBox(height: 14),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: buildings.isEmpty ? _buildEmptyState() : _buildBody(b),
              ),
            ),
            _buildBottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        const SizedBox(height: 60),
        const Icon(Icons.home_work_outlined,
            size: 64, color: RentWiseColors.textLight),
        const SizedBox(height: 20),
        Text('No Properties Yet',
            style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: RentWiseColors.textDark)),
        const SizedBox(height: 10),
        Text(
          'You have not registered any properties.\nSign up or log in to get started.',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
              fontSize: 14, color: RentWiseColors.textMid, height: 1.6),
        ),
      ],
    );
  }

  // ── Header ───────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 16, 0),
      child: Row(
        children: [
          Text('RentWise',
              style: GoogleFonts.pacifico(
                  fontSize: 26,
                  color: RentWiseColors.teal,
                  letterSpacing: 0.5)),
          const Spacer(),
          Stack(children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined,
                  color: RentWiseColors.textDark, size: 24),
              onPressed: () {},
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 38, minHeight: 38),
            ),
            Positioned(
                right: 4,
                top: 4,
                child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                        color: RentWiseColors.danger, shape: BoxShape.circle))),
          ]),
          const SizedBox(width: 4),
          // ── Real initials from Supabase ──────
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/profile'),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: RentWiseColors.teal, width: 2.5),
                color: RentWiseColors.primary,
              ),
              child: Center(
                  child: Text(_initials,
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white))),
            ),
          ),
        ],
      ),
    );
  }

  // ── Building tabs ─────────────────────────────
  Widget _buildAptTabs(List<AppBuilding> buildings) {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: buildings.length + 1,
        itemBuilder: (_, i) {
          if (i == buildings.length) {
            return GestureDetector(
              onTap: _showAddBuilding,
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border:
                      Border.all(color: RentWiseColors.teal.withOpacity(0.5)),
                ),
                child: Row(children: [
                  Icon(Icons.add_rounded, color: RentWiseColors.teal, size: 16),
                  const SizedBox(width: 4),
                  Text('Add',
                      style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: RentWiseColors.teal)),
                ]),
              ),
            );
          }
          final sel = i == _bldg;
          return GestureDetector(
            onTap: () => _switchBuilding(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: sel ? RentWiseColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                    color:
                        sel ? RentWiseColors.primary : const Color(0xFFCCCCCC)),
                boxShadow: sel
                    ? [
                        BoxShadow(
                            color: RentWiseColors.primary.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 3))
                      ]
                    : [],
              ),
              child: Text(buildings[i].name,
                  style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: sel ? Colors.white : const Color(0xFF333333))),
            ),
          );
        },
      ),
    );
  }

  // ── Stats card ───────────────────────────────
  Widget _buildStatsCard(AppBuilding b) {
    return AnimatedBuilder(
      animation: _barAnim,
      builder: (_, __) => Container(
        decoration: BoxDecoration(
          color: RentWiseColors.tealCard,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: RentWiseColors.teal.withOpacity(0.15),
                blurRadius: 12,
                offset: const Offset(0, 4))
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          StatBar(
            b.isHostel ? 'Beds' : 'Occupancy',
            b.isHostel
                ? '${(b.occupancyRate * 100).round()}%  (${b.occupiedBeds}/${b.totalBeds} beds)'
                : '${(b.occupancyRate * 100).round()}%  (${b.occupiedUnits}/${b.totalUnits})',
            b.occupancyRate * _barAnim.value,
            color: RentWiseColors.accentMid,
          ),
          const SizedBox(height: 10),
          StatBar(
            'Revenue',
            '${(b.revenueRate * 100).round()}%  (${_fmtK(b.totalRevenue)})',
            b.revenueRate * _barAnim.value,
            color: RentWiseColors.tealDark,
          ),
        ]),
      ),
    );
  }

  Widget _buildBody(AppBuilding b) {
    switch (_nav) {
      case 0:
        return _buildAllTab(b);
      case 1:
        return _buildTenantsTab(b);
      case 2:
        return _buildUnitsTab(b);
      case 3:
        return _buildRevenueTab(b);
      default:
        return const SizedBox.shrink();
    }
  }

  // ── ALL TAB ──────────────────────────────────
  Widget _buildAllTab(AppBuilding b) {
    final paid = b.tenants.where((t) => t.status == 'paid').length;
    final pending = b.tenants.where((t) => t.status == 'pending').length;
    final overdue = b.tenants.where((t) => t.status == 'overdue').length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _propTypeBadge(b),
        const SizedBox(height: 16),
        const SectionHeader('Quick Actions'),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(
              child: QuickAction(
                  icon: Icons.chat_rounded,
                  label: 'Message\nTenants',
                  color: RentWiseColors.indigo,
                  bg: RentWiseColors.indigoLite,
                  onTap: () => _showMessageTenants(b))),
          const SizedBox(width: 10),
          Expanded(
              child: QuickAction(
                  icon: Icons.person_add_rounded,
                  label: 'Invite\nTenant',
                  color: RentWiseColors.accent,
                  bg: RentWiseColors.accentLite,
                  onTap: () => _showInviteTenant(b))),
          const SizedBox(width: 10),
          Expanded(
              child: QuickAction(
                  icon: b.isHostel
                      ? Icons.hotel_rounded
                      : Icons.meeting_room_rounded,
                  label: b.isHostel ? 'Add\nRoom' : 'Add\nUnit',
                  color: RentWiseColors.tealDark,
                  bg: RentWiseColors.tealCard,
                  onTap: () => _showAddUnit(b))),
          const SizedBox(width: 10),
          Expanded(
              child: QuickAction(
                  icon: Icons.account_balance_rounded,
                  label: 'Pay\nKRA Tax',
                  color: RentWiseColors.purple,
                  bg: RentWiseColors.purpleLite,
                  onTap: () => _showKraTax(b))),
        ]),
        const SizedBox(height: 28),
        const SectionHeader('Overview'),
        const SizedBox(height: 12),
        (b.isHostel || b.isMixed)
            ? _buildHostelGrid(b)
            : _buildApartmentGrid(b),
        const SizedBox(height: 28),
        const SectionHeader('Payment Status'),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(
              child: BigStatCard(
                  label: 'Paid',
                  value: '$paid',
                  color: RentWiseColors.accent,
                  icon: Icons.check_circle_rounded)),
          const SizedBox(width: 10),
          Expanded(
              child: BigStatCard(
                  label: 'Pending',
                  value: '$pending',
                  color: RentWiseColors.warning,
                  icon: Icons.schedule_rounded)),
          const SizedBox(width: 10),
          Expanded(
              child: BigStatCard(
                  label: 'Overdue',
                  value: '$overdue',
                  color: RentWiseColors.danger,
                  icon: Icons.error_rounded)),
        ]),
        const SizedBox(height: 28),
        if (overdue > 0) ...[
          const SectionHeader('⚠️  Needs Attention',
              color: RentWiseColors.danger),
          const SizedBox(height: 12),
          ...b.tenants.where((t) => t.status == 'overdue').map((t) => TenantRow(
              t, _sc(t.status), _sb(t.status), _si(t.status), _sl(t.status))),
          const SizedBox(height: 28),
        ],
        const SectionHeader('Tenant Deposits'),
        const SizedBox(height: 12),
        DepositsCard(
            tenants: b.tenants, total: b.totalDeposits, fmtFull: _fmtFull),
        const SizedBox(height: 28),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SectionHeader('Maintenance & Repairs'),
            GestureDetector(
              onTap: () => _showAddMaintenance(b),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: RentWiseColors.warningLite,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: RentWiseColors.warning.withOpacity(0.3)),
                ),
                child: Row(children: [
                  const Icon(Icons.add_rounded,
                      color: RentWiseColors.warning, size: 14),
                  const SizedBox(width: 4),
                  Text('Add',
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: RentWiseColors.warning)),
                ]),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (b.maintenance.isEmpty)
          EmptyCard(
              icon: Icons.build_outlined,
              title: 'No Records Yet',
              sub: 'Tap "Add" to record invoices or receipts.',
              color: RentWiseColors.warning)
        else
          ...b.maintenance
              .map((m) => MaintenanceRow(item: m, fmtFull: _fmtFull)),
        const SizedBox(height: 28),
        if (b.isHostel && b.availableBeds > 0)
          AvailableBanner(
              count: b.availableBeds,
              label:
                  '${b.availableBeds} Bed${b.availableBeds > 1 ? 's' : ''} Available',
              sub: 'Some rooms have empty beds.',
              onAdd: () => _showInviteTenant(b))
        else if (!b.isHostel && b.vacantUnits > 0)
          AvailableBanner(
              count: b.vacantUnits,
              label:
                  '${b.vacantUnits} Unit${b.vacantUnits > 1 ? 's' : ''} Vacant',
              sub: 'Invite tenants to fill vacant units.',
              onAdd: () => _showInviteTenant(b)),
      ],
    );
  }

  Widget _buildHostelGrid(AppBuilding b) => GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.7,
        children: [
          StatTile(
              icon: Icons.hotel_rounded,
              label: 'Total Rooms',
              value: '${b.totalUnits}',
              sub: '${b.partialUnits} partial',
              color: RentWiseColors.hostelColor),
          StatTile(
              icon: Icons.bed_rounded,
              label: 'Total Beds',
              value: '${b.totalBeds}',
              sub: '${b.availableBeds} available',
              color: RentWiseColors.tealDark),
          StatTile(
              icon: Icons.people_alt_rounded,
              label: 'Tenants',
              value: '${b.tenants.length}',
              sub: '${b.occupiedBeds} in beds',
              color: RentWiseColors.primary),
          StatTile(
              icon: Icons.monetization_on_rounded,
              label: 'Revenue',
              value: _fmtK(b.totalRevenue),
              sub: 'of ${_fmtK(b.expectedRevenue)}',
              color: RentWiseColors.warning),
        ],
      );

  Widget _buildApartmentGrid(AppBuilding b) => GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.7,
        children: [
          StatTile(
              icon: Icons.meeting_room_rounded,
              label: 'Total Units',
              value: '${b.totalUnits}',
              sub: '${b.vacantUnits} vacant',
              color: RentWiseColors.teal),
          StatTile(
              icon: Icons.people_alt_rounded,
              label: 'Tenants',
              value: '${b.tenants.length}',
              sub: '${b.occupiedUnits} occupied',
              color: RentWiseColors.primary),
          StatTile(
              icon: Icons.check_circle_rounded,
              label: 'Paid',
              value: '${b.tenants.where((t) => t.status == 'paid').length}',
              sub: 'of ${b.tenants.length}',
              color: RentWiseColors.accent),
          StatTile(
              icon: Icons.monetization_on_rounded,
              label: 'Revenue',
              value: _fmtK(b.totalRevenue),
              sub: 'of ${_fmtK(b.expectedRevenue)}',
              color: RentWiseColors.warning),
        ],
      );

  // ── TENANTS TAB ──────────────────────────────
  Widget _buildTenantsTab(AppBuilding b) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AddBar(
              icon: Icons.person_add_rounded,
              label: 'Invite Tenant',
              color: RentWiseColors.accent,
              onTap: () => _showInviteTenant(b)),
          const SizedBox(height: 24),
          SectionHeader('Tenants  (${b.tenants.length})'),
          const SizedBox(height: 12),
          if (b.tenants.isEmpty)
            EmptyCard(
                icon: Icons.people_alt_outlined,
                title: 'No Tenants Yet',
                sub: 'Tap "Invite Tenant" to send a registration link.',
                color: RentWiseColors.accent)
          else
            ...b.tenants.map((t) => TenantRow(
                t, _sc(t.status), _sb(t.status), _si(t.status), _sl(t.status))),
        ],
      );

  // ── UNITS TAB ────────────────────────────────
  Widget _buildUnitsTab(AppBuilding b) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AddBar(
              icon:
                  b.isHostel ? Icons.hotel_rounded : Icons.meeting_room_rounded,
              label: b.isHostel ? 'Add Hostel Room' : 'Add Unit',
              color: b.isHostel
                  ? RentWiseColors.hostelColor
                  : RentWiseColors.tealDark,
              onTap: () => _showAddUnit(b)),
          const SizedBox(height: 24),
          if (b.isHostel || b.isMixed) ...[
            Wrap(spacing: 10, runSpacing: 8, children: [
              CountChip(
                  icon: Icons.bed_rounded,
                  label: 'Occupied Beds',
                  count: b.occupiedBeds,
                  color: RentWiseColors.accent),
              CountChip(
                  icon: Icons.bed_outlined,
                  label: 'Available Beds',
                  count: b.availableBeds,
                  color: RentWiseColors.warning),
            ]),
            const SizedBox(height: 16),
          ] else ...[
            Row(children: [
              CountChip(
                  icon: Icons.home_rounded,
                  label: 'Occupied',
                  count: b.occupiedUnits,
                  color: RentWiseColors.accent),
              const SizedBox(width: 10),
              CountChip(
                  icon: Icons.lock_open_rounded,
                  label: 'Vacant',
                  count: b.vacantUnits,
                  color: RentWiseColors.warning),
            ]),
            const SizedBox(height: 16),
          ],
          SectionHeader(b.isHostel
              ? 'All Rooms  (${b.totalUnits})'
              : 'All Units  (${b.totalUnits})'),
          const SizedBox(height: 12),
          if (b.units.isEmpty)
            EmptyCard(
                icon: b.isHostel
                    ? Icons.hotel_outlined
                    : Icons.meeting_room_outlined,
                title: b.isHostel ? 'No Rooms Yet' : 'No Units Yet',
                sub:
                    'Tap the button above to add your first ${b.isHostel ? 'room' : 'unit'}.',
                color: b.isHostel
                    ? RentWiseColors.hostelColor
                    : RentWiseColors.tealDark)
          else
            ...b.units.map((u) => UnitCard(
                unit: u,
                tenants: b.tenants.where((t) => t.unitId == u.id).toList())),
        ],
      );

  // ── REVENUE TAB ──────────────────────────────
  Widget _buildRevenueTab(AppBuilding b) {
    final paid = b.tenants.where((t) => t.status == 'paid').toList();
    final pending = b.tenants.where((t) => t.status == 'pending').toList();
    final overdue = b.tenants.where((t) => t.status == 'overdue').toList();
    final paidAmt = paid.fold<double>(0, (s, t) => s + t.rent);
    final pendingAmt = pending.fold<double>(0, (s, t) => s + t.rent);
    final overdueAmt = overdue.fold<double>(0, (s, t) => s + t.rent);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [Color(0xFF0D1B2A), Color(0xFF1B3A5C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(22),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Revenue This Month',
                style:
                    GoogleFonts.poppins(fontSize: 12, color: Colors.white60)),
            const SizedBox(height: 6),
            Text(_fmtFull(b.totalRevenue),
                style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Colors.white)),
            Text('of ${_fmtFull(b.expectedRevenue)} expected',
                style:
                    GoogleFonts.poppins(fontSize: 13, color: Colors.white54)),
            const SizedBox(height: 14),
            AnimatedBuilder(
              animation: _barAnim,
              builder: (_, __) => ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: b.revenueRate * _barAnim.value,
                  backgroundColor: Colors.white24,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(RentWiseColors.teal),
                  minHeight: 10,
                ),
              ),
            ),
          ]),
        ),
        const SizedBox(height: 20),
        Row(children: [
          Expanded(
              child: RevChip(
                  'Received', paidAmt, paid.length, RentWiseColors.accent)),
          const SizedBox(width: 10),
          Expanded(
              child: RevChip('Pending', pendingAmt, pending.length,
                  RentWiseColors.warning)),
          const SizedBox(width: 10),
          Expanded(
              child: RevChip('Overdue', overdueAmt, overdue.length,
                  RentWiseColors.danger)),
        ]),
        const SizedBox(height: 28),
        GestureDetector(
          onTap: () => _showKraTax(b),
          child: Container(
            decoration: BoxDecoration(
              color: RentWiseColors.purpleLite,
              borderRadius: BorderRadius.circular(16),
              border:
                  Border.all(color: RentWiseColors.purple.withOpacity(0.25)),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(children: [
              Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: RentWiseColors.purple.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.account_balance_rounded,
                      color: RentWiseColors.purple, size: 22)),
              const SizedBox(width: 14),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('KRA Tax Payment',
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: RentWiseColors.purple)),
                  Text('Est. ${_fmtFull(b.expectedRevenue * 0.075)} (7.5% MRI)',
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: RentWiseColors.textMid)),
                ],
              )),
              const Icon(Icons.chevron_right_rounded,
                  color: RentWiseColors.purple),
            ]),
          ),
        ),
        const SizedBox(height: 28),
        if (overdue.isNotEmpty) ...[
          const SectionHeader('Overdue Payments', color: RentWiseColors.danger),
          const SizedBox(height: 12),
          ...overdue.map((t) => TenantRow(t, RentWiseColors.danger,
              RentWiseColors.dangerLite, Icons.error_rounded, 'Overdue')),
          const SizedBox(height: 24),
        ],
        if (pending.isNotEmpty) ...[
          const SectionHeader('Pending Payments'),
          const SizedBox(height: 12),
          ...pending.map((t) => TenantRow(t, RentWiseColors.warning,
              RentWiseColors.warningLite, Icons.schedule_rounded, 'Pending')),
        ],
      ],
    );
  }

  // ── BOTTOM NAV ───────────────────────────────
  Widget _buildBottomNav() {
    const labels = ['ALL', 'Tenants', 'Units', 'Revenue'];
    const icons = [
      Icons.dashboard_rounded,
      Icons.people_alt_rounded,
      Icons.meeting_room_rounded,
      Icons.bar_chart_rounded
    ];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 16,
              offset: const Offset(0, -3))
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(4, (i) {
          final on = i == _nav;
          return GestureDetector(
            onTap: () => setState(() => _nav = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding:
                  EdgeInsets.symmetric(horizontal: on ? 16 : 10, vertical: 8),
              decoration: BoxDecoration(
                color: on
                    ? (i == 0
                        ? RentWiseColors.navActive
                        : RentWiseColors.primary)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(icons[i],
                    size: 18,
                    color: on ? Colors.white : RentWiseColors.textMid),
                if (on) ...[
                  const SizedBox(width: 6),
                  Text(labels[i],
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                ],
              ]),
            ),
          );
        }),
      ),
    );
  }
}
