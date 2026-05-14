import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/rentwise_colors.dart';
import '../widgets/section_card.dart';
import '../widgets/form_field_widget.dart';
import '../widgets/field_label.dart';
import '../widgets/role_selector.dart';
import '../widgets/apartment_tabs_preview.dart';
import '../widgets/apart_name_field.dart';
import '../widgets/password_strength.dart';

// If ApartmentTabs lives in its own file, import it too:
// import '../widgets/apartment_tabs.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with TickerProviderStateMixin {
  // ── Form key ──
  final _formKey = GlobalKey<FormState>();
  final _scrollCtrl = ScrollController();

  // ── Text controllers ──
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _numApartCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  // ── UI state ──
  String _role = 'Landlord';
  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  bool _showApartNames = false;

  // ── Apartment state ──
  int _selectedTab = 0;
  List<String> _apartmentNames = [];
  List<TextEditingController> _apartNameCtrls = [];

  // ── Fade animation ──
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  static const List<String> _roles = [
    'Landlord',
    'Caretaker',
    'Property Manager',
  ];

  // ────────────────────────────────────────────
  @override
  void initState() {
    super.initState();

    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _fadeCtrl.forward();

    _numApartCtrl.addListener(_onApartCountChanged);

    // Rebuild when password changes so strength bar updates live
    _passwordCtrl.addListener(() => setState(() {}));
  }

  // ── Sync apartment list length with the number field ──
  void _onApartCountChanged() {
    final raw = int.tryParse(_numApartCtrl.text.trim()) ?? 0;
    final count = raw.clamp(0, 50);
    if (count == _apartmentNames.length) return;

    setState(() {
      if (count > _apartmentNames.length) {
        while (_apartmentNames.length < count) {
          final idx = _apartmentNames.length + 1;
          _apartmentNames.add('Apartment $idx');
          _apartNameCtrls.add(TextEditingController(text: 'Apartment $idx'));
        }
      } else {
        while (_apartmentNames.length > count) {
          _apartNameCtrls.last.dispose();
          _apartNameCtrls.removeLast();
          _apartmentNames.removeLast();
        }
        if (_selectedTab >= count && count > 0) {
          _selectedTab = count - 1;
        } else if (count == 0) {
          _selectedTab = 0;
        }
      }
    });
  }

  // ── Push renamed value back into the tabs list ──
  void _syncApartmentName(int index) {
    if (index >= _apartNameCtrls.length) return;
    final val = _apartNameCtrls[index].text.trim();
    setState(() {
      _apartmentNames[index] = val.isEmpty ? 'Apartment ${index + 1}' : val;
    });
  }

  // ── Submit ──
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    // TODO: replace the line above with:
    // await context.read<AuthProvider>().signup(...)

    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.pushReplacementNamed(context, '/verify-otp');
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _scrollCtrl.dispose();
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _numApartCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    for (final c in _apartNameCtrls) {
      c.dispose();
    }
    super.dispose();
  }

  // ────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RentWiseColors.bg,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: CustomScrollView(
          controller: _scrollCtrl,
          slivers: [
            // ══════════════════════════════════
            // APP BAR
            // ══════════════════════════════════
            SliverAppBar(
              expandedHeight: 140,
              pinned: true,
              backgroundColor: RentWiseColors.primary,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white, size: 18),
                onPressed: () => Navigator.pop(context),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF0E2233), Color(0xFF1A3C5E)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 70, 24, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Create Account',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Register and start managing your property.',
                          style: GoogleFonts.poppins(
                              fontSize: 12, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ══════════════════════════════════
            // FORM BODY
            // ══════════════════════════════════
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── 1. Personal Information ──────────────
                      SectionCard(
                        icon: Icons.person_outline_rounded,
                        title: 'Personal Information',
                        children: [
                          FormFieldWidget(
                            controller: _nameCtrl,
                            label: 'Full Name',
                            hint: 'e.g. John Kamau',
                            icon: Icons.badge_outlined,
                            validator: (v) =>
                                (v == null || v.trim().isEmpty) ? 'Name' : null,
                          ),
                          const SizedBox(height: 14),
                          FormFieldWidget(
                            controller: _phoneCtrl,
                            label: 'Phone Number',
                            hint: '07XX XXX XXX',
                            icon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Phone Number';
                              }
                              if (v.trim().length < 9) {
                                return 'Invalid Phone Number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                          FormFieldWidget(
                            controller: _emailCtrl,
                            label: 'Email Address (optional)',
                            hint: 'john@example.com',
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              if (v != null && v.isNotEmpty) {
                                final ok = RegExp(r'^[\w.-]+@[\w.-]+\.\w+$')
                                    .hasMatch(v);
                                if (!ok) return 'Invalid Email Address';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // ── 2. Role ──────────────────────────────
                      SectionCard(
                        icon: Icons.work_outline_rounded,
                        title: 'Your Role',
                        children: [
                          const FieldLabel('Select Role'),
                          const SizedBox(height: 8),
                          RoleSelector(
                            roles: _roles,
                            selected: _role,
                            onChanged: (r) => setState(() => _role = r),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // ── 3. Property Details ──────────────────
                      SectionCard(
                        icon: Icons.home_work_outlined,
                        title: 'Property Details',
                        children: [
                          FormFieldWidget(
                            controller: _numApartCtrl,
                            label: 'Number of Apartments',
                            hint: 'e.g. 3',
                            icon: Icons.apartment_outlined,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(2),
                            ],
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Number of Apartments is required';
                              }
                              final n = int.tryParse(v);
                              if (n == null || n < 1) {
                                return 'Please enter a valid number (1+)';
                              }
                              return null;
                            },
                          ),

                          // Live tab preview
                          if (_apartmentNames.isNotEmpty) ...[
                            const SizedBox(height: 18),
                            const FieldLabel('Preview — Apartment Tabs'),
                            const SizedBox(height: 8),
                            ApartmentTabsPreview(
                              tabs: _apartmentNames,
                              selectedIndex: _selectedTab,
                              onTabSelected: (i) =>
                                  setState(() => _selectedTab = i),
                            ),
                          ],

                          // Optional apartment naming
                          if (_apartmentNames.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            GestureDetector(
                              onTap: () => setState(
                                  () => _showApartNames = !_showApartNames),
                              child: Row(
                                children: [
                                  AnimatedRotation(
                                    turns: _showApartNames ? 0.25 : 0,
                                    duration: const Duration(milliseconds: 250),
                                    child: const Icon(
                                        Icons.chevron_right_rounded,
                                        color: RentWiseColors.accent,
                                        size: 20),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Name your apartments (optional)',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: RentWiseColors.accent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedSize(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              child: _showApartNames
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: Column(
                                        children: List.generate(
                                          _apartmentNames.length,
                                          (i) => Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10),
                                            child: ApartNameField(
                                              index: i,
                                              controller: _apartNameCtrls[i],
                                              onChanged: (_) =>
                                                  _syncApartmentName(i),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 16),

                      // ── 4. Security ──────────────────────────
                      SectionCard(
                        icon: Icons.lock_outline_rounded,
                        title: 'Security',
                        children: [
                          FormFieldWidget(
                            controller: _passwordCtrl,
                            label: 'Password',
                            hint: 'Min 8 characters',
                            icon: Icons.lock_outlined,
                            obscureText: _obscurePass,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePass
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: RentWiseColors.textMid,
                                size: 18,
                              ),
                              onPressed: () =>
                                  setState(() => _obscurePass = !_obscurePass),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Password required';
                              }
                              if (v.length < 8) {
                                return 'Password must be at least 8 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          PasswordStrength(password: _passwordCtrl.text),
                          const SizedBox(height: 14),
                          FormFieldWidget(
                            controller: _confirmCtrl,
                            label: 'Confirm Password',
                            hint: 'Repeat password',
                            icon: Icons.lock_reset_outlined,
                            obscureText: _obscureConfirm,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirm
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: RentWiseColors.textMid,
                                size: 18,
                              ),
                              onPressed: () => setState(
                                  () => _obscureConfirm = !_obscureConfirm),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Confirm password is required';
                              }
                              if (v != _passwordCtrl.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // ── Submit button ────────────────────────
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: RentWiseColors.primary,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor:
                                RentWiseColors.primary.withOpacity(0.6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 3,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Text(
                                  'Create Account  →',
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ── Login redirect ───────────────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: GoogleFonts.poppins(
                                fontSize: 13, color: RentWiseColors.textMid),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pushReplacementNamed(
                                context, '/login'),
                            child: Text(
                              'Sign In',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: RentWiseColors.accent,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
