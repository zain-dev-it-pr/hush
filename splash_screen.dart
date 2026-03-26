import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:hushh/app_theme.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _shieldCtrl;
  late final AnimationController _iconCtrl;
  late final AnimationController _taglineCtrl;
  late final AnimationController _ctaCtrl;

  late final Animation<double> _shieldArc;
  late final Animation<double> _iconFade;
  late final Animation<Offset> _taglineSlide;
  late final Animation<double> _taglineFade;
  late final Animation<double> _ctaFade;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    _buildControllers();
    _runSequence();
  }

  void _buildControllers() {
    _shieldCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _shieldArc = CurvedAnimation(
      parent: _shieldCtrl,
      curve: Curves.easeOutCubic,
    );

    _iconCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _iconFade = CurvedAnimation(parent: _iconCtrl, curve: Curves.easeIn);

    _taglineCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _taglineSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _taglineCtrl, curve: Curves.easeOutCubic));
    _taglineFade = CurvedAnimation(parent: _taglineCtrl, curve: Curves.easeIn);

    _ctaCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _ctaFade = CurvedAnimation(parent: _ctaCtrl, curve: Curves.easeIn);
  }

  Future<void> _runSequence() async {
    await Future.delayed(const Duration(milliseconds: 350));
    await _shieldCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 80));
    await _iconCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 120));
    _taglineCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 380));
    await _ctaCtrl.forward();
  }

  @override
  void dispose() {
    _shieldCtrl.dispose();
    _iconCtrl.dispose();
    _taglineCtrl.dispose();
    _ctaCtrl.dispose();
    super.dispose();
  }

  void _goToOnboarding() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, anim, __) => const OnboardingScreen(),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(
          opacity: anim,
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppTheme.bgBase,
      body: Stack(
        children: [
          _GlowBackground(size: size),
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 2),
                _ShieldWidget(shieldArc: _shieldArc, iconFade: _iconFade),
                const SizedBox(height: 40),
                _BrandSection(slide: _taglineSlide, fade: _taglineFade),
                const Spacer(flex: 2),
                _CtaSection(fade: _ctaFade, onPressed: _goToOnboarding),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class _GlowBackground extends StatelessWidget {
  const _GlowBackground({required this.size});
  final Size size;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: size.height * 0.22,
      left: size.width / 2 - 160,
      child: Container(
        width: 320,
        height: 320,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              AppTheme.teal.withOpacity(0.15),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}
class _ShieldWidget extends StatelessWidget {
  const _ShieldWidget({required this.shieldArc, required this.iconFade});
  final Animation<double> shieldArc;
  final Animation<double> iconFade;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: AnimatedBuilder(
        animation: shieldArc,
        builder: (_, child) => CustomPaint(
          painter: _ShieldPainter(progress: shieldArc.value),
          child: child,
        ),
        child: Center(
          child: FadeTransition(
            opacity: iconFade,
            child: const Icon(
              Icons.lock_outline_rounded,
              color: AppTheme.teal,
              size: 36,
            ),
          ),
        ),
      ),
    );
  }
}
class _BrandSection extends StatelessWidget {
  const _BrandSection({required this.slide, required this.fade});
  final Animation<Offset> slide;
  final Animation<double> fade;
  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: slide,
      child: FadeTransition(
        opacity: fade,
        child: Column(
          children: [
            const Text(
              'hushh',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 38,
                fontWeight: FontWeight.w300,
                letterSpacing: 9,
              ),
            ),
            const SizedBox(height: 14),
            Container(
              width: 40,
              height: 1,
              color: AppTheme.teal.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'Your data.\nYour terms. Always.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 15,
                height: 1.65,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class _CtaSection extends StatelessWidget {
  const _CtaSection({required this.fade, required this.onPressed});
  final Animation<double> fade;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fade,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: ElevatedButton(
          onPressed: onPressed,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Get Started'),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward_rounded, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
class _ShieldPainter extends CustomPainter {
  _ShieldPainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final path = _shieldPath(size);

    if (progress > 0.5) {
      final glow = Paint()
        ..color = AppTheme.teal.withOpacity(((progress - 0.5) * 2) * 0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18)
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, glow);
    }

    final stroke = Paint()
      ..color = AppTheme.teal
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    for (final m in path.computeMetrics()) {
      canvas.drawPath(m.extractPath(0, m.length * progress), stroke);
    }

    if (progress > 0.05 && progress < 1.0) {
      final m = path.computeMetrics().first;
      final tan = m.getTangentForOffset(m.length * progress);
      if (tan != null) {
        canvas.drawCircle(
          tan.position,
          3,
          Paint()..color = AppTheme.teal,
        );
      }
    }
  }

  Path _shieldPath(Size s) {
    const p = 14.0;
    return Path()
      ..moveTo(s.width / 2, p)
      ..cubicTo(s.width - p, p, s.width - p, s.height * 0.3, s.width - p, s.height * 0.45)
      ..cubicTo(s.width - p, s.height * 0.65, s.width / 2 + 16, s.height * 0.82, s.width / 2, s.height - p)
      ..cubicTo(s.width / 2 - 16, s.height * 0.82, p, s.height * 0.65, p, s.height * 0.45)
      ..cubicTo(p, s.height * 0.3, p, p, s.width / 2, p)
      ..close();
  }

  @override
  bool shouldRepaint(_ShieldPainter old) => old.progress != progress;
}
