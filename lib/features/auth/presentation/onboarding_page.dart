import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/common.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(fit: StackFit.expand, children: [
          const DonutImage(
              image: 'get_started_banner.jpg',
              imageUrl: '',
              size: double.infinity),
          Positioned.fill(
              child: ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black12,
                Colors.black,
                Colors.black
              ],
              stops: [0, .4, .7, 1],
            ).createShader(bounds),
            blendMode: BlendMode.dstIn,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 30, sigmaY: 100),
              child: const DonutImage(
                  image: 'get_started_banner.jpg',
                  imageUrl: '',
                  size: double.infinity),
            ),
          )),
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Text('Round food for\nevery mood',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
                const SizedBox(height: 22),
                PrimaryButton(
                    text: "Let's get started",
                    onPressed: () => context.push('/auth/register')),
                TextButton(
                    onPressed: () => context.push('/auth/login'),
                    child: const Text('Already have an account? Log in')),
                const SizedBox(height: 12),
                const Text('Or continue with',
                    style: TextStyle(color: Palette.muted)),
                const SizedBox(height: 12),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  _social(context, 'Google', Icons.g_mobiledata_rounded),
                  _social(context, 'Apple', Icons.apple),
                  _social(context, 'Facebook', Icons.facebook),
                ]),
                const SizedBox(height: 18),
                const Text(
                    'By continuing, you agree to our Terms of Use and Privacy Policy',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, color: Palette.muted)),
              ]),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _social(BuildContext context, String name, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: IconButton.filledTonal(
        icon: Icon(icon),
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$name sign-in is a demo')),
        ),
      ),
    );
  }
}
