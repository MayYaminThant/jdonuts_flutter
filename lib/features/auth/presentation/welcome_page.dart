import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/common.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF1F5),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final height = constraints.maxHeight;

            return Stack(
              children: [
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(2, (col) {
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: col == 1 ? 18 : 0,
                              top: col == 1 ? height * 0.055 : 0,
                            ),
                            child: Column(
                              children: List.generate(2, (row) {
                                final index = col * 2 + row + 1;

                                return Padding(
                                  padding:
                                      EdgeInsets.only(top: row == 1 ? 18 : 0),
                                  child: _donutCard(
                                    image: 'donut_$index.jpg',
                                    height: height * (col == 0 ? 0.31 : 0.33),
                                  ),
                                );
                              }),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(28, 45, 28, 28),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0x00FFF1F5),
                          Color(0xFFFFF1F5),
                          Color(0xFFFFF1F5),
                        ],
                        stops: [0, 0.32, 1],
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Welcome to the\nworld of J'donuts",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            height: 1.1,
                            color: Color(0xFF292C35),
                          ),
                        ),
                        const SizedBox(height: 26),
                        PrimaryButton(
                          text: "LET'S EXPLORE",
                          onPressed: () => context.go('/home'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _donutCard({
    required String image,
    required double height,
  }) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: DonutImage(
          image: image,
          imageUrl: '',
          size: 180,
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}
