import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/util/number_format_util.dart';

class RewardsPage extends ConsumerStatefulWidget {
  const RewardsPage({super.key});
  @override
  ConsumerState<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends ConsumerState<RewardsPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController animation = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1400))
    ..forward();
  bool gift = false;

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduce = MediaQuery.disableAnimationsOf(context);
    return Scaffold(
      body: ListView(
        children: [
          Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 24, right: 24, top: 24),
                      child: const Text(
                        'J’ Donuts Rewards',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Spacer(),
                    Container(
                      margin: const EdgeInsets.only(left: 24, top: 24),
                      padding: EdgeInsets.only(
                          left: 14, top: 12, bottom: 12, right: 4),
                      decoration: BoxDecoration(
                          color: Colors.orangeAccent.shade700,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20))),
                      child: Row(
                        children: [
                          const Text(
                            'Rewards',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            width: 25,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15)),
                            child: Center(
                              child: const Text(
                                '3',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Expanded(child: _currentLevelWidget()),
                      Expanded(
                        child: _totalPointWiget(reduce),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SegmentedButton<bool>(segments: const [
                ButtonSegment(value: false, label: Text('Eat more earn more')),
                ButtonSegment(value: true, label: Text('Gift'))
              ], selected: {
                gift
              }, onSelectionChanged: (s) => setState(() => gift = s.first))),
          const SizedBox(height: 20),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            child: gift ? _giftWidget() : _challengeWidget(context),
          )
        ],
      ),
    );
  }

  Widget? _challengeWidget(BuildContext context) {
    return ref.watch(challengesProvider).when(
          data: (challenges) => Column(
            key: const ValueKey('challenges'),
            children: [
              for (final challenge in challenges)
                Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        _currentProgressImgWidget(challenge),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(challenge['title'] as String,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16)),
                              const SizedBox(height: 2),
                              Text(
                                  '${challenge['current']}/${challenge['target']}'),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  FilledButton(
                                    onPressed: () =>
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text('Rewards demo'))),
                                    style: FilledButton.styleFrom(
                                        backgroundColor: challenge['current'] ==
                                                challenge['target']
                                            ? Palette.cyan
                                            : Colors.grey.shade300),
                                    child: const Text('EARN'),
                                  ),
                                  const SizedBox(width: 10),
                                  const Text('100 pts')
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, s) => Text('$e'),
        );
  }

  SizedBox _currentProgressImgWidget(Map<String, dynamic> challenge) {
    return SizedBox(
      width: 95,
      height: 95,
      child: TweenAnimationBuilder<double>(
        tween: Tween(
          begin: 0,
          end: ((challenge['current'] as int) / (challenge['target'] as int))
              .clamp(0.0, 1.0),
        ),
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeOutCubic,
        builder: (context, progress, child) {
          final imagePath = challenge['image'] as String;

          return Stack(
            fit: StackFit.expand,
            children: [
              // Grayscale image
              ColorFiltered(
                colorFilter: const ColorFilter.matrix([
                  0.2126,
                  0.7152,
                  0.0722,
                  0,
                  0,
                  0.2126,
                  0.7152,
                  0.0722,
                  0,
                  0,
                  0.2126,
                  0.7152,
                  0.0722,
                  0,
                  0,
                  0,
                  0,
                  0,
                  1,
                  0,
                ]),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),

              // Original color image with progress mask
              ShaderMask(
                blendMode: BlendMode.dstIn,
                shaderCallback: (bounds) {
                  return SweepGradient(
                    startAngle: -math.pi / 2,
                    endAngle: math.pi * 3 / 2,
                    colors: const [
                      Colors.white,
                      Colors.white,
                      Colors.transparent,
                      Colors.transparent,
                    ],
                    stops: [
                      0,
                      progress,
                      progress,
                      1,
                    ],
                  ).createShader(bounds);
                },
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Center _giftWidget() {
    return const Center(
        key: ValueKey('gift'),
        child: Padding(
            padding: EdgeInsets.all(40),
            child: Text('Gifts are coming soon 🎁')));
  }

  AnimatedBuilder _totalPointWiget(bool reduce) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => SizedBox(
        height: 210,
        child: CustomPaint(
          painter: PointsRingPainter(reduce ? 1 : animation.value),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Total points',
                    style: TextStyle(color: Palette.pink)),
                Text(
                    NumberFormatUtil.formatInt(
                        ((reduce ? 1 : animation.value) * 680000).round()),
                    style: const TextStyle(
                        fontSize: 29,
                        fontWeight: FontWeight.w900,
                        color: Palette.pink))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column _currentLevelWidget() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      for (final tier in ['Silver', 'Gold', 'Platinum'])
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Row(children: [
              CircleAvatar(
                  backgroundColor:
                      tier == 'Silver' ? Colors.grey.shade300 : Palette.pale,
                  child:
                      const Icon(Icons.workspace_premium, color: Palette.pink)),
              const SizedBox(width: 10),
              Expanded(
                  child: Text(tier,
                      style: const TextStyle(fontWeight: FontWeight.bold)))
            ]))
    ]);
  }
}

class PointsRingPainter extends CustomPainter {
  PointsRingPainter(this.progress);
  final double progress;
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2),
        radius = math.min(size.width, size.height) * .37;
    final bg = Paint()
      ..color = const Color(0xFFF2F3F3)
      ..strokeWidth = 28
      ..style = PaintingStyle.stroke;
    final fg = Paint()
      ..color = Palette.pink
      ..strokeWidth = 28
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, bg);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2, 2 * math.pi * .76 * progress, false, fg);
  }

  @override
  bool shouldRepaint(covariant PointsRingPainter old) =>
      old.progress != progress;
}
