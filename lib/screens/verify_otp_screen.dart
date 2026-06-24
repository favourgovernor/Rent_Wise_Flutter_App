import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentwise_app/stateless%20widgets/AnimatedBg.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:rentwise_app/stateless%20widgets/ErrorBanner.dart';
import 'package:rentwise_app/stateless%20widgets/SecurityRow.dart';

// ════════════════════════════════════════════════
//  COLORS  (shared with login_screen)
// ════════════════════════════════════════════════
class _C {
  static const Color primary = Color(0xFF0E2233);
  static const Color teal = Color(0xFF00BFA5);
  static const Color tealDark = Color(0xFF00897B);
  static const Color accent = Color(0xFF2E7D32);
  static const Color accentLite = Color(0xFFE8F5E9);
  static const Color danger = Color(0xFFD32F2F);
  static const Color warning = Color(0xFFF57C00);
  static const Color bg = Color(0xFFF4F6FA);
  static const Color card = Colors.white;
  static const Color border = Color(0xFFDDE1EA);
  static const Color textDark = Color(0xFF0E2233);
  static const Color textMid = Color(0xFF6B7280);
  static const Color textLight = Color(0xFFADB5C7);
}

// ════════════════════════════════════════════════
//  VERIFY OTP SCREEN
// ════════════════════════════════════════════════
class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen>
    with TickerProviderStateMixin {
  static const int _otpLength = 6;
  static const int _expirySeconds = 120; // 2 minutes
  static const int _maxAttempts = 3;

  // OTP state
  final List<TextEditingController> _ctrls =
      List.generate(_otpLength, (_) => TextEditingController());
  final List<FocusNode> _nodes = List.generate(_otpLength, (_) => FocusNode());

  String _enteredOtp = '';
  bool _isLoading = false;
  bool _isSuccess = false;
  bool _isError = false;
  bool _otpExpired = false;
  int _attempts = 0;
  bool _isBlocked = false;

  // Countdown timer
  int _secondsLeft = _expirySeconds;
  Timer? _timer;
  Timer? _blockTimer;
  int _blockSeconds = 60;

  // Animations
  late AnimationController _bgCtrl;
  late AnimationController _slideCtrl;
  late AnimationController _shakeCtrl;
  late AnimationController _successCtrl;
  late AnimationController _pulseCtrl;

  late Animation<double> _bgAnim;
  late Animation<Offset> _slideAnim;
  late Animation<double> _shakeAnim;
  late Animation<double> _successAnim;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();

    // Background float
    _bgCtrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 5))
          ..repeat(reverse: true);
    _bgAnim = CurvedAnimation(parent: _bgCtrl, curve: Curves.easeInOut);

    // Slide reveal
    _slideCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic));

    // Shake on error
    _shakeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _shakeAnim = Tween<double>(begin: 0, end: 1).animate(_shakeCtrl);

    // Success checkmark
    _successCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _successAnim =
        CurvedAnimation(parent: _successCtrl, curve: Curves.elasticOut);

    // Pulse on OTP box focus
    _pulseCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat(reverse: true);
    _pulseAnim = CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut);

    _slideCtrl.forward();
    _startTimer();

    // Auto-focus first box
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _nodes[0].requestFocus();
    });
  }

  // ── Timer ───────────────────────────────────
  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _secondsLeft = _expirySeconds;
      _otpExpired = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() {
        if (_secondsLeft > 0) {
          _secondsLeft--;
        } else {
          _otpExpired = true;
          t.cancel();
        }
      });
    });
  }

  void _startBlockTimer() {
    _blockSeconds = 60;
    _blockTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() {
        if (_blockSeconds > 0) {
          _blockSeconds--;
        } else {
          _isBlocked = false;
          _attempts = 0;
          t.cancel();
        }
      });
    });
  }

  // ── Resend OTP ──────────────────────────────
  void _resendOtp() {
    if (_otpExpired || _secondsLeft > (_expirySeconds - 30)) {
      // Only allow resend after 30 seconds
    }
    for (var c in _ctrls) {
      c.clear();
    }
    _enteredOtp = '';
    setState(() {
      _isError = false;
      _attempts = 0;
    });
    _startTimer();
    _nodes[0].requestFocus();
    // TODO: call AuthProvider.resendOtp()
  }

  // ── Handle digit input ──────────────────────
  void _onDigitEntered(int index, String value) {
    if (value.isEmpty) {
      // Backspace — move back
      if (index > 0) {
        _nodes[index - 1].requestFocus();
      }
      return;
    }

    // Accept only last character in case of paste
    if (value.length > 1) {
      _handlePaste(value);
      return;
    }

    if (index < _otpLength - 1) {
      _nodes[index + 1].requestFocus();
    } else {
      _nodes[index].unfocus();
    }

    setState(() {
      _enteredOtp = _ctrls.map((c) => c.text).join();
      _isError = false;
    });

    // Auto-verify when all 6 filled
    if (_enteredOtp.length == _otpLength) {
      Future.delayed(const Duration(milliseconds: 200), _verify);
    }
  }

  void _handlePaste(String pasted) {
    final digits = pasted.replaceAll(RegExp(r'\D'), '');
    if (digits.length == _otpLength) {
      for (int i = 0; i < _otpLength; i++) {
        _ctrls[i].text = digits[i];
      }
      _nodes[_otpLength - 1].unfocus();
      setState(() => _enteredOtp = digits);
      Future.delayed(const Duration(milliseconds: 200), _verify);
    }
  }

  // ── Verify OTP ──────────────────────────────
  Future<void> _verify() async {
    if (_isBlocked || _otpExpired || _isLoading) return;
    if (_enteredOtp.length < _otpLength) return;

    setState(() {
      _isLoading = true;
      _isError = false;
    });
    await Future.delayed(const Duration(milliseconds: 1500));
    // TODO: replace with context.read<AuthProvider>().verifyOtp(_enteredOtp)

    if (!mounted) return;

    // Simulate: correct OTP is '123456' for demo
    final bool correct = _enteredOtp == '123456';

    if (correct) {
      setState(() {
        _isLoading = false;
        _isSuccess = true;
      });
      _successCtrl.forward();
      _timer?.cancel();
      await Future.delayed(const Duration(milliseconds: 1800));
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() {
        _isLoading = false;
        _isError = true;
        _attempts++;
      });
      _shakeCtrl.forward(from: 0);

      if (_attempts >= _maxAttempts) {
        setState(() => _isBlocked = true);
        _startBlockTimer();
        _timer?.cancel();
      }
    }
  }

  String get _timerDisplay {
    final m = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final s = (_secondsLeft % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  double get _timerProgress => _secondsLeft / _expirySeconds;

  @override
  void dispose() {
    _bgCtrl.dispose();
    _slideCtrl.dispose();
    _shakeCtrl.dispose();
    _successCtrl.dispose();
    _pulseCtrl.dispose();
    _timer?.cancel();
    _blockTimer?.cancel();
    for (final c in _ctrls) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  // ─── BUILD ─────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: _C.primary,
      body: Stack(
        children: [
          // ── Animated background ───────────────
          AnimatedBg(animation: _bgAnim, size: size),

          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // ── Top area ──────────────────
                  SizedBox(
                    height: size.height * 0.3,
                    child: _buildTopSection(),
                  ),

                  // ── Card ──────────────────────
                  SlideTransition(
                    position: _slideAnim,
                    child: FadeTransition(
                      opacity: _slideCtrl,
                      child: _buildCard(size),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Top section ──────────────────────────────
  Widget _buildTopSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 16),

        // Animated shield with checkmark on success
        AnimatedBuilder(
          animation: _bgAnim,
          builder: (_, child) => Transform.translate(
            offset: Offset(0, -5 * _bgAnim.value),
            child: child,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer glow ring
              AnimatedBuilder(
                animation: _pulseAnim,
                builder: (_, child) => Container(
                  width: 90 + (8 * _pulseAnim.value),
                  height: 90 + (8 * _pulseAnim.value),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        _C.teal.withOpacity(0.06 + (0.06 * _pulseAnim.value)),
                  ),
                ),
              ),
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _C.teal.withOpacity(0.16),
                ),
              ),
              // Main circle
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isSuccess ? _C.accent : _C.teal,
                  boxShadow: [
                    BoxShadow(
                      color:
                          (_isSuccess ? _C.accent : _C.teal).withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: _isSuccess
                    ? ScaleTransition(
                        scale: _successAnim,
                        child: const Icon(Icons.check_rounded,
                            color: Colors.white, size: 28),
                      )
                    : const Icon(Icons.sms_rounded,
                        color: Colors.white, size: 26),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'RentWise',
          style: GoogleFonts.pacifico(
            fontSize: 28,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Phone verification',
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.white54,
          ),
        ),
      ],
    );
  }

  // ── Card ─────────────────────────────────────
  Widget _buildCard(Size size) {
    return Container(
      decoration: const BoxDecoration(
        color: _C.bg,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      constraints: BoxConstraints(minHeight: size.height * 0.7),
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Success state ────────────────────
          if (_isSuccess) ...[
            _buildSuccessState(),

            // ── Blocked state ────────────────────
          ] else if (_isBlocked) ...[
            _buildBlockedState(),

            // ── Normal OTP state ─────────────────
          ] else ...[
            _buildOtpState(),
          ],
        ],
      ),
    );
  }

  // ── OTP entry state ──────────────────────────
  Widget _buildOtpState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Heading
        Text(
          'Put Phone Number',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: _C.textDark,
          ),
        ),
        const SizedBox(height: 8),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: GoogleFonts.poppins(fontSize: 13, color: _C.textMid),
            children: const [
              TextSpan(
                  text: 'We have sent you a 6-digit OTP code to the number '),
              TextSpan(
                text: '+254 7XX XXX XXX',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: _C.primary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Timer ring
        _buildTimerRing(),
        const SizedBox(height: 28),

        // OTP boxes - FIXED: Wrapped in SingleChildScrollView to prevent overflow
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: AnimatedBuilder(
            animation: _shakeAnim,
            builder: (_, child) {
              final offset = math.sin(_shakeAnim.value * math.pi * 6) * 8;
              return Transform.translate(
                offset: Offset(offset, 0),
                child: child,
              );
            },
            child: _buildOtpBoxes(),
          ),
        ),
        const SizedBox(height: 10),

        // Error message
        if (_isError)
          ErrorBanner(
            attempts: _attempts,
            maxAttempts: _maxAttempts,
          ),

        if (_otpExpired)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: _C.warning.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _C.warning.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.timer_off_rounded,
                    color: _C.warning, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'The OTP code has expired. Please request a new one.',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: _C.warning,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 28),

        // Verify button
        _buildVerifyButton(),
        const SizedBox(height: 20),

        // Resend
        _buildResendRow(),
        const SizedBox(height: 24),

        // Security info
        _buildSecurityInfo(),
      ],
    );
  }

  // ── Timer ring ───────────────────────────────
  Widget _buildTimerRing() {
    final Color timerColor = _timerProgress > 0.4
        ? _C.teal
        : _timerProgress > 0.2
            ? _C.warning
            : _C.danger;

    return SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Progress ring
          SizedBox(
            width: 80,
            height: 80,
            child: CircularProgressIndicator(
              value: _timerProgress,
              strokeWidth: 5,
              backgroundColor: _C.border,
              valueColor: AlwaysStoppedAnimation<Color>(timerColor),
            ),
          ),
          // Timer text
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _timerDisplay,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: _otpExpired ? _C.danger : _C.textDark,
                ),
              ),
              Text(
                'Phone verification',
                style: GoogleFonts.poppins(fontSize: 9, color: _C.textLight),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── OTP boxes (FIXED: Responsive sizing) ────────────────
  Widget _buildOtpBoxes() {
    // Calculate responsive box size based on screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final boxWidth = screenWidth > 400 ? 48.0 : 42.0;
    final boxHeight = screenWidth > 400 ? 58.0 : 52.0;
    final spacing = screenWidth > 400 ? 8.0 : 4.0;
    final specialSpacing = screenWidth > 400 ? 14.0 : 10.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_otpLength, (i) {
        return AnimatedBuilder(
          animation: _pulseAnim,
          builder: (_, child) {
            final hasFocus = _nodes[i].hasFocus;
            return Container(
              width: boxWidth,
              height: boxHeight,
              margin: EdgeInsets.only(
                right: i == 2
                    ? specialSpacing
                    : (i < _otpLength - 1 ? spacing : 0),
              ),
              decoration: BoxDecoration(
                color: _isError
                    ? _C.danger.withOpacity(0.05)
                    : hasFocus
                        ? _C.teal.withOpacity(0.06)
                        : _C.card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _isError
                      ? _C.danger
                      : hasFocus
                          ? _C.teal
                          : _ctrls[i].text.isNotEmpty
                              ? _C.primary.withOpacity(0.4)
                              : _C.border,
                  width: hasFocus ? 2 : 1.5,
                ),
                boxShadow: hasFocus
                    ? [
                        BoxShadow(
                          color: _C.teal
                              .withOpacity(0.15 + (0.1 * _pulseAnim.value)),
                          blurRadius: 12,
                          spreadRadius: 1,
                        )
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: child,
            );
          },
          child: TextFormField(
            controller: _ctrls[i],
            focusNode: _nodes[i],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            obscureText: false,
            style: GoogleFonts.poppins(
              fontSize: screenWidth > 400 ? 22 : 18,
              fontWeight: FontWeight.w800,
              color: _isError ? _C.danger : _C.primary,
            ),
            decoration: const InputDecoration(
              counterText: '',
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
            onChanged: (v) => _onDigitEntered(i, v),
            onTap: () => setState(() {}), // refresh focus highlight
          ),
        );
      }),
    );
  }

  // ── Verify button ─────────────────────────────
  Widget _buildVerifyButton() {
    final bool canVerify = _enteredOtp.length == _otpLength &&
        !_isLoading &&
        !_otpExpired &&
        !_isBlocked;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: canVerify
            ? const LinearGradient(
                colors: [Color(0xFF0E2233), Color(0xFF1A3C5E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [
                  _C.textLight.withOpacity(0.5),
                  _C.textLight.withOpacity(0.3),
                ],
              ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: canVerify
            ? [
                BoxShadow(
                  color: _C.primary.withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: canVerify ? _verify : null,
          child: Center(
            child: _isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.verified_user_rounded,
                        color: canVerify ? Colors.white : Colors.white54,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Verify OTP',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: canVerify ? Colors.white : Colors.white54,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  // ── Resend row ────────────────────────────────
  Widget _buildResendRow() {
    final bool canResend = _otpExpired || _secondsLeft <= _expirySeconds - 30;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Didn’t receive the code? ',
          style: GoogleFonts.poppins(fontSize: 13, color: _C.textMid),
        ),
        GestureDetector(
          onTap: canResend ? _resendOtp : null,
          child: Text(
            canResend ? 'Resend Code' : 'Resend Code (${_secondsLeft}s)',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: canResend ? _C.tealDark : _C.textLight,
            ),
          ),
        ),
      ],
    );
  }

  // ── Security info ─────────────────────────────
  Widget _buildSecurityInfo() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _C.teal.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _C.teal.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          SecurityRow(
            icon: Icons.timer_rounded,
            text: 'For your security, the OTP expires after 2 minutes.',
          ),
          const SizedBox(height: 8),
          SecurityRow(
            icon: Icons.warning_amber_rounded,
            text:
                'Do not share the OTP with anyone — RentWise will never ask for it.',
          ),
          const SizedBox(height: 8),
          SecurityRow(
            icon: Icons.lock_rounded,
            text:
                'After $_maxAttempts failed attempts, your account will be locked for 1 minute.',
          ),
        ],
      ),
    );
  }

  // ── Success state ─────────────────────────────
  Widget _buildSuccessState() {
    return Column(
      children: [
        const SizedBox(height: 20),
        ScaleTransition(
          scale: _successAnim,
          child: Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _C.accentLite,
              boxShadow: [
                BoxShadow(
                  color: _C.accent.withOpacity(0.25),
                  blurRadius: 24,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: _C.accent,
              size: 48,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Verification Successful! 🎉',
          style: GoogleFonts.poppins(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: _C.textDark,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Your phone number has been verified.\nYou are now logged into your account...',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: _C.textMid,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 32),
        const SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(
            color: _C.accent,
            strokeWidth: 3,
          ),
        ),
      ],
    );
  }

  // ── Blocked state ─────────────────────────────
  Widget _buildBlockedState() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _C.danger.withOpacity(0.1),
          ),
          child: const Icon(
            Icons.gpp_bad_rounded,
            color: _C.danger,
            size: 40,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Verification Blocked',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: _C.textDark,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'You have attempted verification $_maxAttempts times without success.\nFor your safety, please wait.',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: _C.textMid,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 32),
        // Block countdown ring
        SizedBox(
          width: 100,
          height: 100,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: _blockSeconds / 60,
                strokeWidth: 6,
                backgroundColor: _C.danger.withOpacity(0.15),
                valueColor: const AlwaysStoppedAnimation<Color>(_C.danger),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$_blockSeconds',
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: _C.danger,
                    ),
                  ),
                  Text(
                    'seconds',
                    style:
                        GoogleFonts.poppins(fontSize: 10, color: _C.textLight),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _C.danger.withOpacity(0.05),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _C.danger.withOpacity(0.2)),
          ),
          child: SecurityRow(
            icon: Icons.info_outline_rounded,
            text:
                'If you are having trouble logging in, please change your password.',
            color: _C.danger,
          ),
        ),
        const SizedBox(height: 24),
        TextButton(
          onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
          child: Text(
            '← Return to Login Screen',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _C.primary,
            ),
          ),
        ),
      ],
    );
  }
}
