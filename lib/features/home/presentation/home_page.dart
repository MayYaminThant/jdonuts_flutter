import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/util/number_format_util.dart';
import '../../../core/widgets/common.dart';
import '../domain/catalog_repository.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final PageController _bannerController = PageController(
    viewportFraction: 0.88,
  );
  Timer? _bannerTimer;

  @override
  void initState() {
    super.initState();

    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!_bannerController.hasClients) return;

      final count = ref.read(bannersProvider).valueOrNull?.length ?? 0;
      if (count <= 1) return;

      final next = ((_bannerController.page?.round() ?? 0) + 1) % count;

      _bannerController.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productsProvider);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(productsProvider);
            ref.invalidate(memberProvider);
            await ref.read(productsProvider.future);
          },
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _homeHeader(),
              const SizedBox(height: 22),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: _productsWidget(context, products),
              ),
              const SizedBox(height: 20),
              ..._nearShopsWidget(ref),
              // Other sections...
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _nearShopsWidget(WidgetRef ref) {
    return [
      ref.watch(shopsProvider).when(
            data: (shops) => Container(
              height: 365,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                color: Color(0xFF54CDE5),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -55,
                    top: 35,
                    child: CircleAvatar(
                      radius: 85,
                      backgroundColor: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  Positioned(
                    right: -90,
                    bottom: -80,
                    child: const CircleAvatar(
                      radius: 140,
                      backgroundColor: Color(0xFFF4DEB5),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'There are ${shops.length} J’Donut shops\nnear you.',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 9,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Text(
                            'EXPLORE NOW',
                            style: TextStyle(
                              color: Color(0xFF54CDE5),
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          height: 190,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.only(right: 16),
                            itemCount: shops.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final shop = shops[index];

                              return Container(
                                width: MediaQuery.sizeOf(context).width / 1.5,
                                padding: const EdgeInsets.all(9),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.sizeOf(context).width /
                                          1.5,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(9),
                                        child: DonutImage(
                                          image: 'shop.jpg',
                                          imageUrl: '',
                                          fit: BoxFit.fitWidth,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      shop['name'] as String,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      shop['location'] as String,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const Spacer(),
                                    const Text(
                                      'Order Online',
                                      style: TextStyle(
                                        color: Color(0xFFFF4D91),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            loading: () => const LinearProgressIndicator(),
            error: (e, s) => Text('$e'),
          ),
    ];
  }

  Widget _homeHeader() {
    final memberAsync = ref.watch(memberProvider);
    return memberAsync.when(
        data: (member) => Container(
              decoration: const BoxDecoration(
                color: Color(0xFFFFE9D8),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
                        child: const CircleAvatar(
                          radius: 23,
                          backgroundImage: AssetImage(
                            'assets/images/member.png',
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              member.name,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              "${member.tier} member",
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.deepOrange,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.notifications_none,
                              size: 22,
                              color: Colors.white,
                            ),
                            Text(
                              '2',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Container(
                    margin: const EdgeInsets.fromLTRB(18, 2, 18, 2),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '1290 points left to become Gold Member',
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _bannerWidget(ref),
                ],
              ),
            ),
        loading: () => Column(children: [
              for (var i = 0; i < 3; i++)
                Container(
                    margin: const EdgeInsets.all(8),
                    height: 160,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)))
            ]),
        error: (e, s) => Center(child: Text('Products unavailable: $e')));
    ;
  }

  Widget _bannerWidget(WidgetRef ref) {
    return SizedBox(
      height: 165,
      child: ref.watch(bannersProvider).when(
            data: (banners) => PageView.builder(
              controller: _bannerController,
              padEnds: false,
              itemCount: banners.length,
              itemBuilder: (context, index) {
                final banner = banners[index];

                return Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 16 : 4,
                    right: 8,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/${banner.image}',
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                );
              },
            ),
            loading: () => const SizedBox.shrink(),
            error: (e, s) => Text('Banners unavailable: $e'),
          ),
    );
  }

  Widget _productsWidget(
      BuildContext context, AsyncValue<List<Product>> products) {
    return products.when(
        data: (items) => Column(children: [
              _section(context, 'Seasonal specials', items),
              _section(context, 'Popular 🔥', items.reversed.toList()),
              _section(context, 'Order again', items.take(3).toList())
            ]),
        loading: () => Column(children: [
              for (var i = 0; i < 3; i++)
                Container(
                    margin: const EdgeInsets.all(8),
                    height: 160,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)))
            ]),
        error: (e, s) => Center(child: Text('Products unavailable: $e')));
  }

  Widget _section(BuildContext context, String title, List<Product> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(title,
                style: const TextStyle(
                    fontSize: 21, fontWeight: FontWeight.w900))),
        SizedBox(
          height: 210,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              final p = products[i];
              return InkWell(
                onTap: () => context.push('/product/${p.id}'),
                child: SizedBox(
                  width: 140,
                  child: Column(
                    children: [
                      Card(
                        color: Colors.white,
                        clipBehavior: Clip.antiAlias,
                        child: Hero(
                            tag: '${title}_${p.id}',
                            child: SizedBox(
                              height: 150,
                              width: double.infinity,
                              child: DonutImage(
                                image: p.image,
                                imageUrl: p.imageUrl,
                                fit: BoxFit.fitHeight,
                              ),
                            )),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 9),
                          child: Text(p.name,
                              maxLines: 2,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold))),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 9),
                        child: Text(
                          '${NumberFormatUtil.formatPrice(p.price)} MMK',
                          style: const TextStyle(
                              fontSize: 11, color: Palette.pink),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12)
      ],
    );
  }
}
