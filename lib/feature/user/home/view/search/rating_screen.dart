import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// ---------------------------------------------------------------------------
/// ✅ Ratings & Reviews Screen (FULL REPLACEABLE FILE) — GetX
/// UI like your screenshot:
/// - Top appbar: back + title
/// - Divider line
/// - List of review items (avatar + name + time + verified + stars + comment)
///
/// Open:
/// Get.to(() => const RatingsReviewsScreen());
/// ---------------------------------------------------------------------------

class _C {
  static const green = Color(0xFF2FA86A);
  static const text = Color(0xFF1F1F1F);
  static const muted = Color(0xFF8B8B8B);
  static const line = Color(0xFFEDEDED);
  static const soft = Color(0xFFF6F6F6);
  static const star = Color(0xFFF4B400);
}

class ReviewModel {
  final String name;
  final String timeAgo;
  final String comment;
  final bool verified;
  final int stars; // 1..5

  const ReviewModel({
    required this.name,
    required this.timeAgo,
    required this.comment,
    required this.verified,
    required this.stars,
  });
}

class RatingsReviewsController extends GetxController {
  final reviews = <ReviewModel>[
    const ReviewModel(
      name: "Esther",
      timeAgo: "3 day ago",
      verified: true,
      stars: 5,
      comment: "Service is very good",
    ),
    const ReviewModel(
      name: "Esther",
      timeAgo: "3 day ago",
      verified: true,
      stars: 5,
      comment: "Service is very good",
    ),
    const ReviewModel(
      name: "Esther",
      timeAgo: "3 day ago",
      verified: true,
      stars: 5,
      comment: "Service is very good",
    ),
    const ReviewModel(
      name: "Esther",
      timeAgo: "3 day ago",
      verified: true,
      stars: 5,
      comment: "Service is very good",
    ),
    const ReviewModel(
      name: "Esther",
      timeAgo: "3 day ago",
      verified: true,
      stars: 5,
      comment: "Service is very good",
    ),
    const ReviewModel(
      name: "Esther",
      timeAgo: "3 day ago",
      verified: true,
      stars: 5,
      comment: "Service is very good",
    ),
    const ReviewModel(
      name: "Esther",
      timeAgo: "3 day ago",
      verified: true,
      stars: 5,
      comment: "Service is very good",
    ),
  ].obs;
}

class RatingsReviewsScreen extends StatelessWidget {
  const RatingsReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(RatingsReviewsController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 4),

            // Top bar
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 8),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Get.back(),
                    borderRadius: BorderRadius.circular(10),
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: _C.text),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      "Ratings and Reviews",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: _C.text),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, thickness: 1, color: _C.line),

            // List
            Expanded(
              child: Obx(() {
                return ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: c.reviews.length,
                  separatorBuilder: (_, __) => const Divider(height: 1, thickness: 1, color: _C.line),
                  itemBuilder: (_, i) => _ReviewTile(model: c.reviews[i]),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  const _ReviewTile({required this.model});
  final ReviewModel model;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: _C.soft),
            alignment: Alignment.center,
            child: const Icon(Icons.person, size: 18, color: _C.muted),
          ),

          const SizedBox(width: 10),

          // Left text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // name + time
                Row(
                  children: [
                    Text(
                      model.name,
                      style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w900, color: _C.text),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      model.timeAgo,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: _C.muted),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Verified service
                Row(
                  children: [
                    if (model.verified) ...[
                      const Icon(Icons.verified_outlined, size: 14, color: _C.muted),
                      const SizedBox(width: 6),
                      const Text(
                        "Verified service",
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: _C.muted),
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 6),

                // Comment
                Text(
                  model.comment,
                  style: const TextStyle(fontSize: 11.2, fontWeight: FontWeight.w700, color: _C.muted),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // Stars (right)
          _Stars(count: model.stars),
        ],
      ),
    );
  }
}

class _Stars extends StatelessWidget {
  const _Stars({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    final c = count.clamp(0, 5);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
            (i) => Icon(
          i < c ? Icons.star_rounded : Icons.star_border_rounded,
          size: 16,
          color: _C.star,
        ),
      ),
    );
  }
}
