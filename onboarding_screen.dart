import 'package:flutter/material.dart';
import 'package:hushh/app_theme.dart';
import 'home_screen.dart';
/// I kept the copy punchy — each slide is one idea, not a paragraph.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  static const _pages = [
    _OnboardingPage(
        illustration: '🛡️',
        illustrationColor: Color(0xFF1A3A30),
        title: 'You control\nwhat you share',
        subtitle:
        'Before any data leaves your device, you see exactly whats being asked for — and why.',
    ),
    _OnboardingPage(
      illustration: '🔍',
      illustrationColor: Color(0xFF1A2A3A),
      title: 'Understand the\nrisk before you tap',
      subtitle:
      'Every data field is rated by sensitivity. High-risk requests get a clear warning, not fine print.',
    ),
    _OnboardingPage(
      illustration: '↩️',
      illustrationColor: Color(0xFF2A1A2A),
      title: 'Revoke access\nin seconds',
      subtitle:
      'Changed your mind? Pull back access from any partner at any time — instantly and permanently.',
    ),
  ];

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _goToHome();
    }
  }

  void _goToHome() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, anim, __) => const HomeScreen(),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(
          opacity: anim,
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgBase,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button — always available
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _goToHome,
                child: const Text(
                  'Skip',
                  style: TextStyle(color: AppTheme.textMuted, fontSize: 14),
                ),
              ),
            ),

            // Slides
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (_, i) => _OnboardingSlide(page: _pages[i]),
              ),
            ),

            // Dots + next button
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 40),
              child: Column(
                children: [
                  _PageDots(current: _currentPage, count: _pages.length),
                  const SizedBox(height: 28),
                  ElevatedButton(
                    onPressed: _next,
                    child: Text(
                      _currentPage == _pages.length - 1
                          ? 'Get into it'
                          : 'Next',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Single onboarding slide ──────────────────────────────────────────────────

class _OnboardingSlide extends StatelessWidget {
  const _OnboardingSlide({required this.page});
  final _OnboardingPage page;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration container
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: page.illustrationColor,
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.border),
            ),
            child: Center(
              child: Text(
                page.illustration,
                style: const TextStyle(fontSize: 64),
              ),
            ),
          ),

          const SizedBox(height: 48),

          Text(
            page.title,
            textAlign: TextAlign.center,
            style: AppTheme.headline1,
          ),

          const SizedBox(height: 16),

          Text(
            page.subtitle,
            textAlign: TextAlign.center,
            style: AppTheme.body.copyWith(fontSize: 15, height: 1.7),
          ),
        ],
      ),
    );
  }
}

// ─── Page dots indicator ──────────────────────────────────────────────────────

class _PageDots extends StatelessWidget {
  const _PageDots({required this.current, required this.count});
  final int current;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? AppTheme.teal : AppTheme.textMuted,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
} // Page data class

class _OnboardingPage {
  const _OnboardingPage({
    required this.illustration,
    required this.illustrationColor,
    required this.title,
    required this.subtitle,
  });

  final String illustration;
  final Color illustrationColor;
  final String title;
  final String subtitle;
}
