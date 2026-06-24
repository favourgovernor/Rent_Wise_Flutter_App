// lib/screens/auth/setup_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../providers/property_provider.dart';
import 'auth_widgets.dart';

// ════════════════════════════════════════════
//  SETUP SCREEN
//
//  Shown after OTP is verified on first signup.
//  Pre-fills phone from signup screen.
//
//  Collects:
//    • Role  (Landlord / Caretaker / Property Manager)
//    • Number of properties
//    • Each property's name and type
//
//  On submit:
//    • Updates landlord row with phone, role,
//      is_complete = true
//    • Saves property names to PropertyProvider
//    • Navigates to /home
// ════════════════════════════════════════════
class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});
  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final _form = GlobalKey<FormState>();
  final _phoneFN = FocusNode();
  final _numFN = FocusNode();
  final _phoneCtrl = TextEditingController();
  final _numCtrl = TextEditingController();

  String _role = 'Landlord';
  bool _loading = false;
  bool _showProps = false;
  String? _error;
  bool _prefilled = false; // guard so we only pre-fill once

  final List<_PropEntry> _props = [];

  static const _roles = [
    'Landlord',
    'Caretaker',
    'Property Manager',
  ];

  @override
  void initState() {
    super.initState();
    _numCtrl.addListener(_syncProps);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Pre-fill phone from signup args — only once
    if (!_prefilled) {
      _prefilled = true;
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final phone = args?['phone'] as String? ?? '';
      if (phone.isNotEmpty) {
        _phoneCtrl.text = phone;
      }
    }
  }

  // ── Keep property list in sync with count ──
  void _syncProps() {
    final n = (int.tryParse(_numCtrl.text.trim()) ?? 0).clamp(0, 50);
    if (n == _props.length) return;
    setState(() {
      if (n > _props.length) {
        while (_props.length < n) {
          final idx = _props.length + 1;
          _props.add(_PropEntry(
            ctrl: TextEditingController(text: 'Property $idx'),
            type: PropertyType.apartment,
          ));
        }
        _showProps = true;
      } else {
        while (_props.length > n) {
          _props.last.ctrl.dispose();
          _props.removeLast();
        }
      }
    });
  }

  @override
  void dispose() {
    _phoneFN.dispose();
    _numFN.dispose();
    _phoneCtrl.dispose();
    _numCtrl.dispose();
    for (final p in _props) p.ctrl.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────
  //  SUBMIT
  // ─────────────────────────────────────────
  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_form.currentState!.validate()) return;

    if (_props.isEmpty) {
      setState(
          () => _error = 'Please enter the number of properties you manage.');
      return;
    }

    // Validate all property names filled
    for (final p in _props) {
      if (p.ctrl.text.trim().isEmpty) {
        setState(() {
          _showProps = true;
          _error = 'Please name all your properties.';
        });
        return;
      }
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) throw Exception('No active session.');

      final phone = _phoneCtrl.text.trim();

      // Get landlord's internal database ID
      final landlordRow = await Supabase.instance.client
          .from('landlords')
          .select('id')
          .eq('auth_id', user.id)
          .maybeSingle();
      final landlordId = landlordRow?['id'] as String? ?? '';

      // Check if another account uses this phone number
      final conflict = await Supabase.instance.client
          .from('landlords')
          .select('id')
          .eq('phone', phone)
          .neq('auth_id', user.id)
          .maybeSingle();

      if (conflict != null) {
        if (!mounted) return;
        setState(() {
          _loading = false;
          _error = 'This phone number is already registered '
              'to another account. Please use a different number.';
        });
        return;
      }

      // Update landlord profile
      await Supabase.instance.client.from('landlords').update({
        'phone': phone,
        'role': _role,
        'is_complete': true,
      }).eq('auth_id', user.id);

      // Push buildings into PropertyProvider
      if (!mounted) return;
      final provider = context.read<PropertyProvider>();
      provider.initFromSignup(
        _props
            .map((p) => {
                  'name': p.ctrl.text.trim(),
                  'type': p.type,
                })
            .toList(),
      );

      // Guard — landlordId must not be empty before saving
      if (landlordId.isEmpty) {
        if (!mounted) return;
        setState(() {
          _loading = false;
          _error = 'Could not find your landlord profile. '
              'Please try signing up again.';
        });
        return;
      }

      // Save buildings to Supabase so they persist
      // when the landlord logs in again later
      final saved = await provider.saveToSupabase(landlordId);

      if (!saved) {
        if (!mounted) return;
        setState(() {
          _loading = false;
          _error = 'Your properties could not be saved. '
              'Please check your connection and try again.';
        });
        return; // do NOT navigate to /home if save failed
      }

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      debugPrint('SetupScreen submit error: \$e');
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Could not save: \$e';
      });
      debugPrint('Setup error: $e');
    }
  }

  // ─────────────────────────────────────────
  //  BUILD
  // ─────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E2233),
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          // ── Dark header ──────────────────
          const AuthHeader(
            title: 'Almost Done! 🏠',
            subtitle: 'Tell us about your role\nand properties',
          ),

          // ── White scrollable form ────────
          AuthCard(
            child: Form(
              key: _form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Phone (pre-filled) ───
                  const AuthLabel('Phone Number'),
                  AuthField(
                    controller: _phoneCtrl,
                    focusNode: _phoneFN,
                    hint: '07XX XXX XXX',
                    icon: Icons.phone_outlined,
                    keyboard: TextInputType.phone,
                    formatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    action: TextInputAction.next,
                    onNext: () => FocusScope.of(context).requestFocus(_numFN),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Phone number is required';
                      }
                      if (v.trim().length < 9) {
                        return 'Enter a valid phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // ── Role selector ────────
                  const AuthLabel('Your Role'),
                  const SizedBox(height: 10),
                  _RoleSelector(
                    roles: _roles,
                    selected: _role,
                    onChanged: (r) => setState(() => _role = r),
                  ),
                  const SizedBox(height: 20),

                  // ── Divider ──────────────
                  Row(children: [
                    const Expanded(child: Divider(color: Color(0xFFE5E7EB))),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('Your Properties',
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: const Color(0xFF9CA3AF),
                              fontWeight: FontWeight.w500)),
                    ),
                    const Expanded(child: Divider(color: Color(0xFFE5E7EB))),
                  ]),
                  const SizedBox(height: 16),

                  // ── Number of properties ──
                  const AuthLabel('How many properties do you manage?'),
                  AuthField(
                    controller: _numCtrl,
                    focusNode: _numFN,
                    hint: 'e.g. 2',
                    icon: Icons.apartment_outlined,
                    keyboard: TextInputType.number,
                    formatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(2),
                    ],
                    action: TextInputAction.done,
                    onNext: () => FocusScope.of(context).unfocus(),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Required — enter number of properties';
                      }
                      final n = int.tryParse(v);
                      if (n == null || n < 1) {
                        return 'Enter a valid number (1 or more)';
                      }
                      return null;
                    },
                  ),

                  // ── Property rows ─────────
                  if (_props.isNotEmpty) ...[
                    const SizedBox(height: 14),

                    // Tab preview
                    _TabPreview(entries: _props),
                    const SizedBox(height: 12),

                    // Expand / collapse
                    GestureDetector(
                      onTap: () => setState(() => _showProps = !_showProps),
                      child: Row(children: [
                        AnimatedRotation(
                            turns: _showProps ? 0.25 : 0,
                            duration: const Duration(milliseconds: 200),
                            child: const Icon(Icons.chevron_right_rounded,
                                color: Color(0xFF00897B), size: 22)),
                        const SizedBox(width: 6),
                        Text('Name your properties',
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF00897B))),
                      ]),
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 280),
                      curve: Curves.easeInOut,
                      child: _showProps
                          ? Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Column(
                                children: List.generate(
                                  _props.length,
                                  (i) => _PropRow(
                                    index: i,
                                    entry: _props[i],
                                    onChanged: () => setState(() {}),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],

                  const SizedBox(height: 20),

                  // ── Error ─────────────────
                  if (_error != null) ...[
                    AuthError(_error!),
                    const SizedBox(height: 16),
                  ],

                  // ── Submit ────────────────
                  AuthButton(
                    label: 'Go to Dashboard',
                    loading: _loading,
                    onTap: _submit,
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════
//  ROLE SELECTOR
//  Three pill chips — only one active at a time
// ════════════════════════════════════════════
class _RoleSelector extends StatelessWidget {
  final List<String> roles;
  final String selected;
  final ValueChanged<String> onChanged;

  const _RoleSelector({
    required this.roles,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: roles.map((r) {
        final on = r == selected;
        return GestureDetector(
          onTap: () => onChanged(r),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
            decoration: BoxDecoration(
              color: on ? const Color(0xFF0E2233) : Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                  color: on ? const Color(0xFF0E2233) : const Color(0xFFE5E7EB),
                  width: 1.5),
              boxShadow: on
                  ? [
                      BoxShadow(
                          color: const Color(0xFF0E2233).withOpacity(0.18),
                          blurRadius: 8,
                          offset: const Offset(0, 3))
                    ]
                  : [],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  r == 'Landlord'
                      ? Icons.home_rounded
                      : r == 'Caretaker'
                          ? Icons.manage_accounts_rounded
                          : Icons.business_center_rounded,
                  size: 16,
                  color: on ? Colors.white : const Color(0xFF9CA3AF),
                ),
                const SizedBox(width: 7),
                Text(r,
                    style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: on ? Colors.white : const Color(0xFF374151))),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ════════════════════════════════════════════
//  TAB PREVIEW
//  Live preview of how building tabs look
// ════════════════════════════════════════════
class _TabPreview extends StatefulWidget {
  final List<_PropEntry> entries;
  const _TabPreview({required this.entries});
  @override
  State<_TabPreview> createState() => _TabPreviewState();
}

class _TabPreviewState extends State<_TabPreview> {
  int _sel = 0;

  IconData _icon(PropertyType t) {
    switch (t) {
      case PropertyType.hostel:
        return Icons.hotel_rounded;
      case PropertyType.mixed:
        return Icons.villa_rounded;
      default:
        return Icons.apartment_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Preview:',
            style: GoogleFonts.poppins(
                fontSize: 12, color: const Color(0xFF9CA3AF))),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(widget.entries.length, (i) {
              final e = widget.entries[i];
              final sel = i == _sel;
              final name = e.ctrl.text.trim().isEmpty
                  ? 'Property ${i + 1}'
                  : e.ctrl.text.trim();
              return GestureDetector(
                onTap: () => setState(() => _sel = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                  decoration: BoxDecoration(
                    color: sel ? const Color(0xFF0E2233) : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                        color: sel
                            ? const Color(0xFF0E2233)
                            : const Color(0xFFE5E7EB)),
                    boxShadow: sel
                        ? [
                            BoxShadow(
                                color: const Color(0xFF0E2233).withOpacity(0.2),
                                blurRadius: 6,
                                offset: const Offset(0, 2))
                          ]
                        : [],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_icon(e.type),
                          size: 13,
                          color:
                              sel ? Colors.white70 : const Color(0xFF9CA3AF)),
                      const SizedBox(width: 6),
                      Text(name,
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: sel
                                  ? Colors.white
                                  : const Color(0xFF374151))),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════
//  PROPERTY CONFIG ROW
// ════════════════════════════════════════════
class _PropEntry {
  final TextEditingController ctrl;
  PropertyType type;
  _PropEntry({required this.ctrl, required this.type});
}

class _PropRow extends StatelessWidget {
  final int index;
  final _PropEntry entry;
  final VoidCallback onChanged;

  const _PropRow({
    // ignore: unused_element_parameter
    super.key,
    required this.index,
    required this.entry,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row number badge
          Row(children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: const Color(0xFF0E2233),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                  child: Text('${index + 1}',
                      style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white))),
            ),
            const SizedBox(width: 8),
            Text('Property ${index + 1}',
                style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0E2233))),
          ]),
          const SizedBox(height: 12),

          // Property name
          Text('Name',
              style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF6B7280))),
          const SizedBox(height: 6),
          TextFormField(
            controller: entry.ctrl,
            onChanged: (_) => onChanged(),
            style: GoogleFonts.poppins(
                fontSize: 14, color: const Color(0xFF0E2233)),
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'Property name required'
                : null,
            decoration: InputDecoration(
              hintText: 'e.g. Sunrise Court, Campus Hostel',
              hintStyle: GoogleFonts.poppins(
                  fontSize: 13, color: const Color(0xFFBBC5D4)),
              prefixIcon: const Icon(Icons.home_work_outlined,
                  color: Color(0xFF9CA3AF), size: 18),
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: Color(0xFF00BFA5), width: 1.8)),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: Color(0xFFD32F2F), width: 1.2)),
            ),
          ),
          const SizedBox(height: 12),

          // Property type chips
          Text('Type',
              style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF6B7280))),
          const SizedBox(height: 8),
          Row(children: [
            _TypeChip(
              label: 'Apartment',
              icon: Icons.apartment_rounded,
              desc: '1 tenant per unit',
              sel: entry.type == PropertyType.apartment,
              onTap: () {
                entry.type = PropertyType.apartment;
                onChanged();
              },
            ),
            const SizedBox(width: 8),
            _TypeChip(
              label: 'Hostel',
              icon: Icons.hotel_rounded,
              desc: 'Multiple per room',
              sel: entry.type == PropertyType.hostel,
              onTap: () {
                entry.type = PropertyType.hostel;
                onChanged();
              },
            ),
            const SizedBox(width: 8),
            _TypeChip(
              label: 'Mixed',
              icon: Icons.villa_rounded,
              desc: 'Both types',
              sel: entry.type == PropertyType.mixed,
              onTap: () {
                entry.type = PropertyType.mixed;
                onChanged();
              },
            ),
          ]),

          // Info note for hostel/mixed
          if (entry.type == PropertyType.hostel ||
              entry.type == PropertyType.mixed) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFE0F7FA),
                borderRadius: BorderRadius.circular(8),
                border:
                    Border.all(color: const Color(0xFF00BFA5).withOpacity(0.3)),
              ),
              child: Row(children: [
                const Icon(Icons.info_outline_rounded,
                    color: Color(0xFF00897B), size: 14),
                const SizedBox(width: 8),
                Expanded(
                    child: Text(
                  entry.type == PropertyType.hostel
                      ? 'Each room holds multiple tenants with individual leases.'
                      : 'Mix of apartments and hostel rooms.',
                  style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: const Color(0xFF00695C),
                      height: 1.4),
                )),
              ]),
            ),
          ],
        ],
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final String desc;
  final bool sel;
  final VoidCallback onTap;

  const _TypeChip({
    required this.label,
    required this.icon,
    required this.desc,
    required this.sel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          decoration: BoxDecoration(
            color: sel ? const Color(0xFF0E2233) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: sel ? const Color(0xFF0E2233) : const Color(0xFFE5E7EB)),
            boxShadow: sel
                ? [
                    BoxShadow(
                        color: const Color(0xFF0E2233).withOpacity(0.18),
                        blurRadius: 6,
                        offset: const Offset(0, 2))
                  ]
                : [],
          ),
          child: Column(children: [
            Icon(icon,
                size: 20, color: sel ? Colors.white : const Color(0xFFBBC5D4)),
            const SizedBox(height: 4),
            Text(label,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: sel ? Colors.white : const Color(0xFF374151))),
            const SizedBox(height: 2),
            Text(desc,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 9,
                    color: sel ? Colors.white60 : const Color(0xFFBBC5D4),
                    height: 1.2)),
          ]),
        ),
      ),
    );
  }
}
