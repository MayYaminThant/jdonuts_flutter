import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jdonuts_flutter/core/util/number_format_util.dart';
import 'package:jdonuts_flutter/features/home/domain/catalog_repository.dart';

import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/common.dart';

class ProductPage extends ConsumerStatefulWidget {
  const ProductPage({super.key, required this.id});

  final String id;

  @override
  ConsumerState<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends ConsumerState<ProductPage> {
  int qty = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0F2F3),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ref.watch(productsProvider).when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(child: Text('$e')),
            data: (items) {
              final matching = items.where((p) => p.id == widget.id);

              if (matching.isEmpty) {
                return const Center(child: Text('Product not found'));
              }

              final p = matching.first;

              return SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
                      child: Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      _productHeaderWidget(constraints, p),

                                      // Quantity selector overlaps product card
                                      Positioned(
                                        left: 0,
                                        right: 0,
                                        bottom: -23,
                                        child: Center(
                                          child: _quantitySelector(),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 55),
                                  _description(p.description),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _actionWidget(p, context),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
    );
  }

  PrimaryButton _actionWidget(Product p, BuildContext context) {
    return PrimaryButton(
      text:
          'ADD TO CART  |  ${NumberFormatUtil.formatPrice(qty * p.price)} MMK',
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '$qty × ${p.name} added to cart',
            ),
          ),
        );
      },
    );
  }

  Container _productHeaderWidget(BoxConstraints constraints, Product p) {
    return Container(
      width: double.infinity,
      height: constraints.maxHeight * 0.60,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            p.code,
            style: const TextStyle(
              fontSize: 11,
              color: Palette.muted,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Expanded(
                child: Text(
                  p.name,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                  ),
                ),
              ),
              if (p.isNew)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF861D),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'New',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            '${NumberFormatUtil.formatPrice(p.price)} MMK',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
          Expanded(
            child: Center(
              child: Hero(
                tag: p.id,
                child: DonutImage(
                  image: p.image, // later : img will transparent bg color
                  imageUrl: p.imageUrl,
                  size: 270,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _quantitySelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6F7),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _quantityButton(
            Icons.remove,
            qty > 1 ? () => setState(() => qty--) : null,
          ),
          SizedBox(
            width: 45,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: Text(
                '$qty',
                key: ValueKey(qty),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF303741),
                ),
              ),
            ),
          ),
          _quantityButton(
            Icons.add,
            () => setState(() => qty++),
          ),
        ],
      ),
    );
  }

  Widget _quantityButton(IconData icon, VoidCallback? onPressed) {
    return SizedBox(
      width: 30,
      height: 30,
      child: IconButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        style: IconButton.styleFrom(
          backgroundColor: const Color(0xFF54CDE5),
          disabledBackgroundColor: const Color(0xFF54CDE5),
          foregroundColor: Colors.white,
          disabledForegroundColor: Colors.white,
        ),
        icon: Icon(icon, size: 18),
      ),
    );
  }

  Widget _description(String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 75,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.help,
                color: Color(0xFF8CBF49),
                size: 15,
              ),
              const SizedBox(height: 8),
              const Text(
                "What's\nthis?",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  height: 1.05,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            "Enjoy our scrumptious donuts – soft,"
            " sweet, and satisfying in every bite. "
            "Choose from classic glazed, rich chocolate, or fun sprinkles. "
            "Dive into deliciousness now!", // description,// later show only description
            style: const TextStyle(
              fontSize: 12,
              height: 1.5,
              color: Color(0xFF81868C),
            ),
          ),
        ),
      ],
    );
  }
}
