import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paschaloliver/core/constants/assets.dart';
import 'package:paschaloliver/feature/user/home/view/search/search_services_find_screen.dart';
import 'package:paschaloliver/feature/user/home/view/subcateogry/available_schedule_screen.dart';

// import 'handy_man_services_screen.dart'; // <-- your next screen

/// ---------------------------------------------------------------------------
/// 1) SEARCH TIME LOADING (NO DUPLICATES ✅)
/// ---------------------------------------------------------------------------
/// - 3 cards
/// - first card has dashed price pill + blue tag "27 Hug × 22 Hug"
/// - bottom text: "Finding Cleaning professionals in UNRWA Kaduna,Nigeria"
class SearchTimeLoadingScreen extends StatefulWidget {
  const SearchTimeLoadingScreen({
    super.key,
    this.serviceName = "Cleaning",
    this.areaLine1 = "UNRWA",
    this.areaLine2 = "Kaduna,Nigeria",
    this.autoGoNext = true,
  });

  final String serviceName;
  final String areaLine1;
  final String areaLine2;

  /// set false if you don't want auto navigation
  final bool autoGoNext;

  @override
  State<SearchTimeLoadingScreen> createState() =>
      _SearchTimeLoadingScreenState();
}

class _SearchTimeLoadingScreenState extends State<SearchTimeLoadingScreen> {
  @override
  void initState() {
    super.initState();

    if (widget.autoGoNext) {
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;

        // ✅ replace with your next screen
        // Get.off(() => const HandyManServicesScreen());
        Future.delayed(const Duration(seconds: 0), () {
          Get.off(() => const HandyManServicesScreen());
        });

        // for now:
        Get.back(); // remove this when you add your real screen
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewPadding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(18, 26, 18, 22 + bottom),
          child: Column(
            children: [
              // const _LoadingProCard(
              //   priceText: r"$ $",
              //   highlightPrice: true,
              //   tagText: "27 Hug × 22 Hug",
              // ),
              const _LoadingProCard(priceText: r"$ $"),
              const SizedBox(height: 14),
              const _LoadingProCard(priceText: r"$ $ $"),
              const SizedBox(height: 14),
              const _LoadingProCard(priceText: r"$"),
              const SizedBox(height: 26),

              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    height: 1.25,
                    color: const Color(0xFF111111),
                    fontWeight: FontWeight.w400,
                  ),
                  children: [
                    const TextSpan(text: "Finding "),
                    TextSpan(
                      text: widget.serviceName,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const TextSpan(text: " professionals in "),
                    TextSpan(
                      text: widget.areaLine1,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const TextSpan(text: "\n"),
                    TextSpan(
                      text: widget.areaLine2,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadingProCard extends StatelessWidget {
  const _LoadingProCard({
    required this.priceText,
    this.tagText,
    this.highlightPrice = false,
  });

  final String priceText;
  final String? tagText;
  final bool highlightPrice;

  @override
  Widget build(BuildContext context) {
    return _Shimmer(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              blurRadius: 18,
              offset: const Offset(0, 8),
              color: Colors.black.withOpacity(.06),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              width: 56,
              height: 56,
              child: ClipOval(
                child: Image.asset(Images.men2Icon, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(child: _GreyPill(h: 14, radius: 999)),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _PricePill(
                            text: priceText,
                            highlight: highlightPrice,
                          ),
                          if (tagText != null) ...[
                            const SizedBox(height: 6),
                            _BlueTag(text: tagText!),
                          ],
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: List.generate(
                      5,
                      (_) => const Padding(
                        padding: EdgeInsets.only(right: 2),
                        child: Icon(
                          Icons.star_rounded,
                          size: 14,
                          color: _C.star,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  const _GreyPill(h: 10, w: 170, radius: 6),
                  const SizedBox(height: 6),
                  const _GreyPill(h: 10, w: 200, radius: 6),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PricePill extends StatelessWidget {
  const _PricePill({required this.text, this.highlight = false});
  final String text;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final pill = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _C.green,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w900,
          height: 1.0,
        ),
      ),
    );

    if (!highlight) return pill;

    return _DashedRRect(
      radius: 999,
      color: Colors.white.withOpacity(.9),
      strokeWidth: 1.4,
      dash: 4,
      gap: 3,
      child: Padding(padding: const EdgeInsets.all(2.2), child: pill),
    );
  }
}

class _BlueTag extends StatelessWidget {
  const _BlueTag({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _C.blue,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          height: 1.0,
        ),
      ),
    );
  }
}

class _GreyPill extends StatelessWidget {
  const _GreyPill({required this.h, this.w, this.radius = 10});
  final double h;
  final double? w;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: h,
      width: w,
      decoration: BoxDecoration(
        color: _C.soft,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

class _C {
  static const green = Color(0xFF3AAE6E);
  static const blue = Color(0xFF2F80ED);
  static const soft = Color(0xFFE6E6E6);
  static const star = Color(0xFFFFB400);
}

class _Shimmer extends StatefulWidget {
  const _Shimmer({required this.child});
  final Widget child;

  @override
  State<_Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<_Shimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      child: widget.child,
      builder: (_, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (rect) {
            final x = (rect.width * 2) * _c.value - rect.width;
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.white.withOpacity(.55),
                Colors.white.withOpacity(.90),
                Colors.white.withOpacity(.55),
              ],
              stops: const [0.35, 0.5, 0.65],
              transform: _SlideGradientTransform(dx: x),
            ).createShader(rect);
          },
          child: child,
        );
      },
    );
  }
}

class _SlideGradientTransform extends GradientTransform {
  const _SlideGradientTransform({required this.dx});
  final double dx;

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(dx, 0, 0);
  }
}

class _DashedRRect extends StatelessWidget {
  const _DashedRRect({
    required this.child,
    required this.radius,
    required this.color,
    required this.strokeWidth,
    required this.dash,
    required this.gap,
  });

  final Widget child;
  final double radius;
  final Color color;
  final double strokeWidth;
  final double dash;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedRRectPainter(
        radius: radius,
        color: color,
        strokeWidth: strokeWidth,
        dash: dash,
        gap: gap,
      ),
      child: child,
    );
  }
}

class _DashedRRectPainter extends CustomPainter {
  _DashedRRectPainter({
    required this.radius,
    required this.color,
    required this.strokeWidth,
    required this.dash,
    required this.gap,
  });

  final double radius;
  final Color color;
  final double strokeWidth;
  final double dash;
  final double gap;

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final path = Path()..addRRect(rrect);
    for (final metric in path.computeMetrics()) {
      double dist = 0;
      while (dist < metric.length) {
        final len = math.min(dash, metric.length - dist);
        final seg = metric.extractPath(dist, dist + len);
        canvas.drawPath(seg, paint);
        dist += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRRectPainter oldDelegate) {
    return oldDelegate.radius != radius ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dash != dash ||
        oldDelegate.gap != gap;
  }
}
