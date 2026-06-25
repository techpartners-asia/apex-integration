import 'package:flutter/material.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

// card padding (16+16) + icon/text row (~36) with some breathing room
const double _kCardHeight = 82.0;

/// Carousel that shows one pending order card at a time with swipe navigation.
/// Falls back to a plain card when there is only one order.
class OverviewPendingOrdersCarousel extends StatefulWidget {
  final List<IpsOrder> orders;
  final double? packAmount;
  final double? packFee;
  final String currency;

  const OverviewPendingOrdersCarousel({
    super.key,
    required this.orders,
    this.packAmount,
    this.packFee,
    this.currency = '',
  });

  @override
  State<OverviewPendingOrdersCarousel> createState() =>
      _OverviewPendingOrdersCarouselState();
}

class _OverviewPendingOrdersCarouselState
    extends State<OverviewPendingOrdersCarousel> {
  late final PageController _controller;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<IpsOrder> orders = widget.orders;

    if (orders.length == 1) {
      return OverviewPendingOrderCard(
        order: orders.first,
        packAmount: widget.packAmount,
        packFee: widget.packFee,
        currency: widget.currency,
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          height: _kCardHeight,
          child: PageView.builder(
            controller: _controller,
            itemCount: orders.length,
            onPageChanged: (int index) => setState(() => _current = index),
            itemBuilder: (BuildContext ctx, int index) {
              return OverviewPendingOrderCard(
                order: orders[index],
                packAmount: widget.packAmount,
                packFee: widget.packFee,
                currency: widget.currency,
              );
            },
          ),
        ),
        if (orders.length > 1) ...<Widget>[
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List<Widget>.generate(orders.length, (int i) {
            final bool active = i == _current;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: active ? 16 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: active
                    ? const Color(0xFFF59E0B)
                    : const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
        ],
      ],
    );
  }
}
