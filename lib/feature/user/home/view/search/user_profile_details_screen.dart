import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paschaloliver/feature/user/home/view/search/payment_screen.dart';
import 'package:paschaloliver/feature/user/home/view/search/rating_screen.dart';
import 'package:paschaloliver/feature/user/home/view/search/view_availability_screen.dart';
import 'package:paschaloliver/core/constants/api_endpoints.dart';
import 'package:paschaloliver/core/network/api_service/api_client.dart';
import 'package:paschaloliver/feature/user/favourite/controller/professional_detail_controller.dart';
import 'package:paschaloliver/feature/user/favourite/services/professional_detail_interface.dart';
import 'package:paschaloliver/feature/user/favourite/services/professional_detail_interface_impl.dart';

import '../../../../../core/constants/assets.dart';
import '../../../../inbox/view/inbox_screen.dart';

/// ---------------------------------------------------------------------------
/// ✅ Nicolas Profile Screen (ONE SCREEN) — FULL REPLACEABLE FILE
/// UI matches your screenshot structure:
/// - Header (back + title)
/// - Big photo
/// - Name + role + heart
/// - Rating + location + badges
/// - “Send message” button
/// - About me
/// - Photos and video (horizontal)
/// - My Services (chips + list)
/// - Information of interest
/// - Client’s ratings + comments
/// - Guarantee + FAQ + Cancellation policy + Contact us
/// - Bottom sticky bar: price + View Availability
///
/// Open:
/// Get.to(() => const NicolasProfileScreen());
/// ---------------------------------------------------------------------------

class _C {
  static const green = Color(0xFF2FA86A);
  static const text = Color(0xFF1F1F1F);
  static const muted = Color(0xFF8B8B8B);
  static const line = Color(0xFFEDEDED);
  static const chipBg = Color(0xFFF3F3F3);
  static const soft = Color(0xFFF6F6F6);
  static const star = Color(0xFFF4B400);
}

class NicolasProfileController extends GetxController {
  final selectedTopCategory = "Hanging".obs;
}

class NicolasProfileScreen extends StatefulWidget {
  const NicolasProfileScreen({super.key, this.professionalId});

  final String? professionalId;

  @override
  State<NicolasProfileScreen> createState() => _NicolasProfileScreenState();
}

class _NicolasProfileScreenState extends State<NicolasProfileScreen> {
  late final ProfessionalDetailController _controller;
  String? _id;
  bool _didPopOnError = false;

  String _timeAgo(dynamic value) {
    if (value == null) return "Just now";
    DateTime? dt;
    if (value is DateTime) {
      dt = value;
    } else if (value is String) {
      dt = DateTime.tryParse(value);
    }
    if (dt == null) return value.toString();

    final diff = DateTime.now().difference(dt);
    if (diff.inDays >= 1) {
      final d = diff.inDays;
      return "$d day${d == 1 ? '' : 's'} ago";
    }
    if (diff.inHours >= 1) {
      final h = diff.inHours;
      return "$h hour${h == 1 ? '' : 's'} ago";
    }
    if (diff.inMinutes >= 1) {
      final m = diff.inMinutes;
      return "$m min ago";
    }
    return "Just now";
  }

  List<_CommentData> _mapComments(List<dynamic> raw) {
    final List<_CommentData> out = [];
    for (final item in raw) {
      if (item is! Map) continue;
      final user = item['user'];
      String name = "Unknown";
      if (user is Map && user['name'] != null) {
        name = user['name'].toString();
      }
      final rawRating = item['rating'] ?? item['stars'] ?? item['score'];
      int rating = 0;
      if (rawRating is num) {
        rating = rawRating.round();
      } else if (rawRating != null) {
        rating = int.tryParse(rawRating.toString()) ?? 0;
      }
      if (rating < 0) rating = 0;
      if (rating > 5) rating = 5;

      final comment = (item['comment'] ??
              item['message'] ??
              item['review'] ??
              '')
          .toString();
      final verified =
          item['isVerified'] == true || item['verified'] == true;
      final timeAgo = _timeAgo(
        item['createdAt'] ?? item['date'] ?? item['time'],
      );

      out.add(
        _CommentData(
          name: name,
          timeAgo: timeAgo,
          rating: rating,
          comment: comment,
          isVerified: verified,
        ),
      );
    }
    return out;
  }

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<ApiClient>()) {
      Get.put<ApiClient>(ApiClient(ApiEndpoints.baseUrl), permanent: true);
    }
    if (!Get.isRegistered<ProfessionalDetailInterface>()) {
      Get.put<ProfessionalDetailInterface>(
        ProfessionalDetailInterfaceImpl(apiClient: Get.find<ApiClient>()),
      );
    }
    if (!Get.isRegistered<ProfessionalDetailController>()) {
      Get.put<ProfessionalDetailController>(
        ProfessionalDetailController(
          service: Get.find<ProfessionalDetailInterface>(),
        ),
      );
    }
    _controller = Get.find<ProfessionalDetailController>();
    _id = widget.professionalId ??
        (Get.arguments is String ? Get.arguments as String : null);
    if (_id != null && _id!.isNotEmpty) {
      _controller.fetch(_id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.put(NicolasProfileController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() {
          if (_id == null || _id!.isEmpty) {
            return const Center(child: Text("Professional id missing"));
          }
          if (_controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (_controller.error.isNotEmpty) {
            if (!_didPopOnError) {
              _didPopOnError = true;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                final msg = _controller.error.value;
                if (Get.isSnackbarOpen) {
                  Get.closeAllSnackbars();
                }
                Get.snackbar("Error", msg.isEmpty ? "Failed to load profile" : msg);
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              });
            }
            return const Center(child: Text("Failed to load profile"));
          }

          final detail = _controller.detail.value;
          final name = detail?.user.name ?? "Unknown";
          final about = detail?.user.about ?? "";
          final gallery = detail?.gallery ?? const <String>[];
          final comments = detail?.comments ?? const [];
          final mappedComments = _mapComments(comments);
          final reviewsCount = mappedComments.length;
          final titleText = "$name's profile";

          return ListView(
            padding: EdgeInsets.zero,
            children: [
            const SizedBox(height: 4),

            // Top bar
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 10),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Get.back(),
                    borderRadius: BorderRadius.circular(10),
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: _C.text,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      titleText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: _C.text,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Big image (placeholder)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 16 / 10,
                  child: Container(
                    color: _C.soft,
                    child: (gallery.isNotEmpty)
                        ? Image.network(
                            gallery.first,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.person,
                              size: 64,
                              color: _C.muted,
                            ),
                          )
                        : const Icon(Icons.person, size: 64, color: _C.muted),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Name + role + favorite
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: _C.green,
                          ),
                        ),
                        SizedBox(height: 6),
                        _StarsRow(
                          score: 4.8,
                          countText: "4.8  |  $reviewsCount Reviews",
                        ),
                        SizedBox(height: 8),
                        _InfoLine(
                          icon: Icons.location_on_outlined,
                          text: "Ungwan Kifi, Nigeria",
                        ),
                        SizedBox(height: 6),
                        _InfoLine(
                          icon: Icons.verified_outlined,
                          text: "Top Professional",
                        ),
                        SizedBox(height: 6),
                        _InfoLine(
                          icon: Icons.check_circle_outline,
                          text: "122 Completed services",
                        ),
                        SizedBox(height: 6),
                        _InfoLine(
                          icon: Icons.star_outline_rounded,
                          text: "Average rating of 4.9/5",
                        ),
                        SizedBox(height: 6),
                        _InfoLine(
                          icon: Icons.verified_rounded,
                          text: "Verified profile",
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(999),
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: Icon(
                        Icons.favorite_border_rounded,
                        size: 20,
                        color: _C.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Send message button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 44,
                child: OutlinedButton.icon(
                  onPressed: () => Get.to(() => const InboxScreen()),
                  icon: ImageIcon(
                    AssetImage(Images.sendMessageIcon),
                    size: 18,
                    color: _C.muted,
                  ),
                  label: const Text(
                    "Send message",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: _C.text,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: _C.line),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // About me
            const _SectionTitle(title: "About me"),
            const SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                about.isEmpty ? "No bio provided" : about,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: _C.muted,
                  height: 1.35,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Spacer(),
                  InkWell(
                    onTap: () {},
                    child: const Text(
                      "Read more",
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w900,
                        color: _C.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Photos and video
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: Row(
                children: [
                  const Text(
                    "Photos and video",
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w900,
                      color: _C.green,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {},
                    child: const Text(
                      "See all",
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w900,
                        color: _C.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 74,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: gallery.isEmpty ? 4 : gallery.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (_, i) {
                  final url = gallery.isEmpty ? null : gallery[i];
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 98,
                      height: 74,
                      color: _C.soft,
                      child: (url != null)
                          ? Image.network(
                              url,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.image_outlined,
                                color: _C.muted,
                              ),
                            )
                          : const Icon(
                              Icons.image_outlined,
                              color: _C.muted,
                            ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // My Services
            // const _SectionTitle(title: "My Services"),
            const SizedBox(height: 10),

            // Top chips row (like screenshot)
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16),
            //   child: Obx(() {
            //     return SingleChildScrollView(
            //       scrollDirection: Axis.horizontal,
            //       child: Row(
            //         children: [
            //           _ServiceChip(
            //             title: "Hanging",
            //             icon: Icons.hardware_rounded,
            //             selected: c.selectedTopCategory.value == "Hanging",
            //             onTap: () => c.selectedTopCategory.value = "Hanging",
            //           ),
            //           const SizedBox(width: 10),
            //           _ServiceChip(
            //             title: "Small repairs",
            //             icon: Icons.build_circle_outlined,
            //             selected:
            //                 c.selectedTopCategory.value == "Small repairs",
            //             onTap: () =>
            //                 c.selectedTopCategory.value = "Small repairs",
            //           ),
            //           const SizedBox(width: 10),
            //           _ServiceChip(
            //             title: "Furniture\nassembly",
            //             icon: Icons.handyman_outlined,
            //             selected:
            //                 c.selectedTopCategory.value == "Furniture assembly",
            //             onTap: () =>
            //                 c.selectedTopCategory.value = "Furniture assembly",
            //           ),
            //           const SizedBox(width: 10),
            //           _ServiceChip(
            //             title: "Installation",
            //             icon: Icons.power_outlined,
            //             selected: c.selectedTopCategory.value == "Installation",
            //             onTap: () =>
            //                 c.selectedTopCategory.value = "Installation",
            //           ),
            //         ],
            //       ),
            //     );
            //   }),
            // ),
            const SizedBox(height: 10),
            const Divider(height: 1, thickness: 1, color: _C.line),

            // Services list (Lamp / TV / Picture / Mirror / Coat Rack / Other objective)
            _ChevronRow(
              icon: Icons.light_outlined,
              title: "Lamp",
              onTap: () {},
            ),
            const Divider(height: 1, thickness: 1, color: _C.line),
            _ChevronRow(icon: Icons.tv_rounded, title: "TV", onTap: () {}),
            const Divider(height: 1, thickness: 1, color: _C.line),
            _ChevronRow(
              icon: Icons.image_outlined,
              title: "Picture",
              onTap: () {},
            ),
            const Divider(height: 1, thickness: 1, color: _C.line),
            _ChevronRow(
              icon: Icons.crop_square_rounded,
              title: "Mirror",
              onTap: () {},
            ),
            const Divider(height: 1, thickness: 1, color: _C.line),
            _ChevronRow(
              icon: Icons.checkroom_outlined,
              title: "Coat Rack",
              onTap: () {},
            ),
            const Divider(height: 1, thickness: 1, color: _C.line),
            _ChevronRow(
              icon: Icons.inventory_2_outlined,
              title: "Other objective",
              onTap: () {},
            ),
            const Divider(height: 1, thickness: 1, color: _C.line),

            const SizedBox(height: 16),

            // Information of interest
            const _SectionTitle(title: "Information of interest"),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "How much experience do you have as a cleaner?",
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w900,
                  color: _C.text,
                ),
              ),
            ),
            const SizedBox(height: 6),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "5-15 years of experience",
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  color: _C.muted,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Indicate the types of cleaning that you can perform",
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w900,
                  color: _C.text,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: _BulletList(
                items: [
                  "General household cleaning (bedrooms,\nbathrooms and kitchen)",
                  "Deep cleaning",
                  "Post-renovation cleaning",
                  "Window cleaning",
                  "Blinds cleaning",
                  "Oven cleaning",
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 42,
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.white, // ✅ not transparent
                      barrierColor: Colors.black.withOpacity(.35),
                      useSafeArea:
                          false, // ✅ allows sheet to reach screen bottom
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ), // ✅ only top rounded
                      ),
                      clipBehavior: Clip.antiAlias,
                      builder: (_) => const _InformationOfInterestSheet(),
                    );
                  },

                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: _C.line),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "View all",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: _C.text,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 18),

            // Client’s ratings
            const _SectionTitle(title: "Client’s ratings"),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    "Outstanding",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: _C.text,
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.star_rounded, size: 16, color: _C.star),
                  SizedBox(width: 4),
                  Text(
                    "4.8",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: _C.text,
                    ),
                  ),
                  SizedBox(width: 6),
                  Text(
                    "(35 Ratings)",
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      color: _C.muted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const _RatingRow(label: "Service", value: 4.8),
            const _RatingRow(label: "Value for money", value: 5.0),
            const _RatingRow(label: "Professionalism", value: 5.0),
            const _RatingRow(label: "Punctuality", value: 4.8),

            const SizedBox(height: 14),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Comments",
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w900,
                  color: _C.green,
                ),
              ),
            ),
            const SizedBox(height: 10),

            if (mappedComments.isEmpty)
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: Text(
                  "No comments yet",
                  style: TextStyle(
                    fontSize: 11.2,
                    fontWeight: FontWeight.w700,
                    color: _C.muted,
                  ),
                ),
              ),
            ...mappedComments.map(
              (c) => _CommentCard(
                name: c.name,
                daysAgo: c.timeAgo,
                text: c.comment.isEmpty ? "-" : c.comment,
              ),
            ),

            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 42,
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Get.to(() => const RatingsReviewsScreen());
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: _C.line),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "View all reviews",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: _C.text,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 18),

            // Guarantee big section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 86,
                    height: 86,
                    child: Image.asset(
                      Images.hundredIcon,
                      width: 40,
                      height: 40,
                      fit: BoxFit.contain,
                      // if your asset is a PNG and you want it green:
                      // color: _C.green,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "HandyNaija Guaranty",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: _C.text,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Until we are certain that the service has gone as expected, we will not release the payment to the professional."
                      "\n\nIn case of a no-show, we will refund the full amount of the service.",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 11.2,
                        fontWeight: FontWeight.w700,
                        color: _C.muted,
                        height: 1.35,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Don't worry, everything is under control:",
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w900,
                        color: _C.text,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const _CheckBullet(text: "Money-back guarantee"),
                  const _CheckBullet(text: "Support 365 days a year"),
                  const _CheckBullet(text: "Protected payment"),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // FAQ
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Frequent to asked questions",
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w900,
                  color: _C.green,
                ),
              ),
            ),
            const SizedBox(height: 10),

            _FaqRow(title: "How does it work?", onTap: () {}),
            _FaqRow(title: "What does the cleaning included?", onTap: () {}),
            _FaqRow(title: "How much time should i book?", onTap: () {}),
            _FaqRow(
              title:
                  "Can they carry out other tasks ( i.e. cooking or ironing)?",
              onTap: () {},
            ),
            _FaqRow(
              title: "I don't have the necessary materials/ products",
              onTap: () {},
            ),
            _FaqRow(
              title: "I won't be at home during the service",
              onTap: () {},
            ),
            _FaqRow(title: "What if there is time left over?", onTap: () {}),
            _FaqRow(
              title: "Can I book the service on a weekly basis?",
              onTap: () {},
            ),
            _FaqRow(
              title:
                  "National Insurance (UK)/Social Security (US) Registration",
              onTap: () {},
            ),
            _FaqRow(title: "What is the \"minimum price\"?", onTap: () {}),

            const SizedBox(height: 16),

            // Cancellation policy
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Cancellation policy",
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w900,
                  color: _C.green,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                decoration: BoxDecoration(
                  border: Border.all(color: _C.line),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Time before start",
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w900,
                              color: _C.text,
                            ),
                          ),
                        ),
                        Text(
                          "% refund",
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w900,
                            color: _C.text,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    _PolicyRow(
                      left: "Up to 24 hours",
                      right: "Free cancellation",
                    ),
                    _PolicyRow(
                      left: "From 24h to 4h",
                      right: "75% of the amount",
                    ),
                    _PolicyRow(
                      left: "From 4h to 45min",
                      right: "50% of the amount",
                    ),
                    _PolicyRow(
                      left: "From 45m to start",
                      right: "35% of the amount",
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Help / contact
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Can we help you?",
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w900,
                  color: _C.green,
                ),
              ),
            ),
            const SizedBox(height: 6),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Have any questions? Feel free to ask about\ndetails of the service",
                style: TextStyle(
                  fontSize: 11.2,
                  fontWeight: FontWeight.w700,
                  color: _C.muted,
                  height: 1.25,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 44,
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _openContactUsSheet(context),
                  icon: const Icon(
                    Icons.headset_mic_outlined,
                    size: 18,
                    color: _C.muted,
                  ),
                  label: const Text(
                    "Contact Us",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: _C.text,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: _C.line),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 90),
            // space for bottom bar
          ],
        );
        }),
      ),

      // Bottom sticky bar (price + button)
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: _C.line)),
          ),
          child: Row(
            children: [
              const Text(
                "\$ 1350/h",
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w900,
                  color: _C.text,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () {
                      // Get.to(() => const BookingDetailsScreen());
                      Get.to(() => const ConfirmAndPayScreen());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _C.green,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Continue",
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

///----------------------inforation of interest

// ✅ FULL REPLACEABLE: _InformationOfInterestSheet
// ✅ Fixes: fills left/right/bottom (no red gaps), only top corners rounded
// ✅ Works with long content (scrollable), safe bottom padding included

class _InformationOfInterestSheet extends StatelessWidget {
  const _InformationOfInterestSheet();

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;

    return SafeArea(
      top: false,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity, // ✅ fill left/right
          padding: EdgeInsets.fromLTRB(
            16,
            12,
            16,
            16 + bottom,
          ), // ✅ fill bottom area
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), // ✅ only top rounded
              topRight: Radius.circular(20),
            ),
          ),
          child: SingleChildScrollView(
            // ✅ scroll when content is long
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 46,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDADADA),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Information of interest",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: _C.green,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => Get.back(),
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: _C.chipBg,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: _C.line),
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          size: 16,
                          color: _C.muted,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                const Text(
                  "How much experience do you have as a cleaner?",
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w900,
                    color: _C.text,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "5-15 years of experience",
                  style: TextStyle(
                    fontSize: 11.2,
                    fontWeight: FontWeight.w800,
                    color: _C.muted,
                  ),
                ),

                const SizedBox(height: 12),
                const Text(
                  "Indicate the types of cleaning that you can perform",
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w900,
                    color: _C.text,
                  ),
                ),
                const SizedBox(height: 10),

                const _SheetCheckList(
                  items: [
                    ["Electricity", true],
                    ["Plumbing", true],
                    ["Carpentry", true],
                    ["Painting", true],
                    ["Building", true],
                    ["Locksmith", true],
                    ["Fridge cleaning", true],
                    ["Garage/storage cleaning", true],
                    ["Appliance repair", false],
                    ["Gardening", false],
                    ["Welding and metalwork", false],
                  ],
                ),

                const SizedBox(height: 12),
                const Text(
                  "Indicate the tasks you can perform during\nthe service",
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w900,
                    color: _C.text,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 10),

                const _SheetCheckList(
                  items: [
                    ["Laundry", true],
                    ["Ironing", true],
                    ["Cooking", true],
                    ["Childcare", true],
                  ],
                ),

                const SizedBox(height: 12),
                const Text(
                  "Do you have the basic tools ( silicone,\nhammer, screwdriver...) needed to perform\nthe service?",
                  style: TextStyle(
                    fontSize: 11.3,
                    fontWeight: FontWeight.w900,
                    color: _C.text,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Yes",
                  style: TextStyle(
                    fontSize: 11.2,
                    fontWeight: FontWeight.w800,
                    color: _C.muted,
                  ),
                ),

                const SizedBox(height: 10),
                const Text(
                  "Do you currently work professionally in the\ncleaning industry?",
                  style: TextStyle(
                    fontSize: 11.3,
                    fontWeight: FontWeight.w900,
                    color: _C.text,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Yes",
                  style: TextStyle(
                    fontSize: 11.2,
                    fontWeight: FontWeight.w800,
                    color: _C.muted,
                  ),
                ),

                const SizedBox(height: 10),
                const Text(
                  "What are you looking for in handynija?",
                  style: TextStyle(
                    fontSize: 11.3,
                    fontWeight: FontWeight.w900,
                    color: _C.text,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Fill up my schedule",
                  style: TextStyle(
                    fontSize: 11.2,
                    fontWeight: FontWeight.w800,
                    color: _C.muted,
                  ),
                ),

                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: _C.line),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: const Size(0, 44),
                        ),
                        child: const Text(
                          "Edit Areas",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: _C.green,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Get.back(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _C.green,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: const Size(0, 44),
                        ),
                        child: const Text(
                          "Continue",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SheetCheckList extends StatelessWidget {
  const _SheetCheckList({required this.items});

  /// each item: [String label, bool checked]
  final List<List<dynamic>> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.map((e) {
        final String label = e[0] as String;
        final bool checked = e[1] as bool;

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Icon(
                checked ? Icons.check_rounded : Icons.close_rounded,
                size: 16,
                color: checked ? _C.green : _C.muted,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11.2,
                    fontWeight: FontWeight.w800,
                    color: _C.text,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

///--------------------------for contact us

void _openContactUsSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white, // ✅ not transparent
    barrierColor: Colors.black.withOpacity(.35),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(22),
      ), // ✅ only top radius
    ),
    clipBehavior: Clip.antiAlias,
    builder: (ctx) {
      final bottom = MediaQuery.of(ctx).padding.bottom; // ✅ safe area
      return Padding(
        padding: EdgeInsets.fromLTRB(16, 10, 16, 16 + bottom), // ✅ fills bottom
        child: const _ContactUsContent(),
      );
    },
  );
}

class _ContactUsContent extends StatelessWidget {
  const _ContactUsContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // drag handle
        Container(
          width: 46,
          height: 4,
          decoration: BoxDecoration(
            color: const Color(0xFFDADADA),
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        const SizedBox(height: 10),

        Row(
          children: [
            const Expanded(
              child: Text(
                "Contact us",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: _C.green,
                ),
              ),
            ),
            InkWell(
              onTap: () => Get.back(),
              borderRadius: BorderRadius.circular(999),
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: _C.chipBg,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: _C.line),
                ),
                child: const Icon(
                  Icons.close_rounded,
                  size: 16,
                  color: _C.muted,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "If you need to contact us, please write an email to",
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: _C.muted,
              height: 1.35,
            ),
          ),
        ),
        const SizedBox(height: 6),

        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "contact@apphandynaija.com",
            style: TextStyle(
              fontSize: 11.8,
              fontWeight: FontWeight.w900,
              color: _C.green,
            ),
          ),
        ),

        const SizedBox(height: 10),

        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Feel free to share any doubts or suggestions you have.\nWe will be happy to help you.",
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: _C.muted,
              height: 1.35,
            ),
          ),
        ),

        const SizedBox(height: 14),

        SizedBox(
          height: 46,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: _C.green,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              "Got it",
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// ------------------------------ SMALL WIDGETS ------------------------------

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w900,
          color: _C.green,
        ),
      ),
    );
  }
}

class _StarsRow extends StatelessWidget {
  const _StarsRow({required this.score, required this.countText});

  final double score;
  final String countText;

  @override
  Widget build(BuildContext context) {
    final full = score.floor().clamp(0, 5);
    return Row(
      children: [
        Row(
          children: List.generate(
            5,
            (i) => Icon(
              i < full ? Icons.star_rounded : Icons.star_border_rounded,
              size: 16,
              color: _C.star,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          countText,
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w800,
            color: _C.muted,
          ),
        ),
      ],
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: _C.green),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
              color: _C.text,
            ),
          ),
        ),
      ],
    );
  }
}

class _ServiceChip extends StatelessWidget {
  const _ServiceChip({
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 92,
        height: 74,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: selected ? _C.green.withOpacity(.12) : const Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? _C.green : _C.line,
            width: selected ? 1.2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: _C.text),
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w900,
                color: _C.text,
                height: 1.15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChevronRow extends StatelessWidget {
  const _ChevronRow({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _C.line),
                color: Colors.white,
              ),
              child: Icon(icon, size: 18, color: _C.muted),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: _C.muted,
                ),
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: _C.muted),
          ],
        ),
      ),
    );
  }
}

class _BulletList extends StatelessWidget {
  const _BulletList({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items
          .map(
            (t) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(Icons.check_rounded, size: 16, color: _C.green),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      t,
                      style: const TextStyle(
                        fontSize: 11.2,
                        fontWeight: FontWeight.w700,
                        color: _C.muted,
                        height: 1.25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _RatingRow extends StatelessWidget {
  const _RatingRow({required this.label, required this.value});

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    final full = value.floor().clamp(0, 5);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
                color: _C.text,
              ),
            ),
          ),
          Row(
            children: List.generate(
              5,
              (i) => Icon(
                i < full ? Icons.star_rounded : Icons.star_border_rounded,
                size: 14,
                color: _C.star,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w900,
              color: _C.text,
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentData {
  final String name;
  final String timeAgo;
  final int rating;
  final String comment;
  final bool isVerified;

  const _CommentData({
    required this.name,
    required this.timeAgo,
    required this.rating,
    required this.comment,
    required this.isVerified,
  });
}

class _CommentCard extends StatelessWidget {
  const _CommentCard({
    required this.name,
    required this.daysAgo,
    required this.text,
  });

  final String name;
  final String daysAgo;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: _C.line),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: _C.soft,
              ),
              child: const Icon(Icons.person, size: 18, color: _C.muted),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w900,
                          color: _C.text,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        daysAgo,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: _C.muted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Row(
                    children: [
                      Icon(Icons.verified_outlined, size: 14, color: _C.muted),
                      SizedBox(width: 6),
                      Text(
                        "Verified service",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: _C.muted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 11.2,
                      fontWeight: FontWeight.w700,
                      color: _C.muted,
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

class _CheckBullet extends StatelessWidget {
  const _CheckBullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          const Icon(Icons.check_circle_rounded, size: 16, color: _C.green),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
                color: _C.muted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqRow extends StatelessWidget {
  const _FaqRow({required this.title, required this.onTap});

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(height: 1, thickness: 1, color: _C.line),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      color: _C.text,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: _C.muted),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PolicyRow extends StatelessWidget {
  const _PolicyRow({required this.left, required this.right});

  final String left;
  final String right;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              left,
              style: const TextStyle(
                fontSize: 11.2,
                fontWeight: FontWeight.w800,
                color: _C.muted,
              ),
            ),
          ),
          Text(
            right,
            style: const TextStyle(
              fontSize: 11.2,
              fontWeight: FontWeight.w800,
              color: _C.muted,
            ),
          ),
        ],
      ),
    );
  }
}
