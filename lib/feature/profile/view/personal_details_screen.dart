import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paschaloliver/core/constants/assets.dart';
import 'package:paschaloliver/feature/user/favourite/controller/professional_detail_controller.dart';
import 'package:paschaloliver/core/constants/api_endpoints.dart';
import 'package:paschaloliver/core/network/api_service/api_client.dart';
import 'package:paschaloliver/feature/user/favourite/services/professional_detail_interface.dart';
import 'package:paschaloliver/feature/user/favourite/services/professional_detail_interface_impl.dart';

/// ---------------------------------------------------------------------------
/// PERSONAL DETAILS (matches your screenshot)
/// - Top bar: back + title + Edit (right)
/// - Avatar + name
/// - Reviews + Services stats
/// - About me
/// - Outstanding rating + category bars
/// - Comments list
/// ---------------------------------------------------------------------------
class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({super.key, this.onEdit, this.professionalId});

  final VoidCallback? onEdit;
  final String? professionalId;

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  late final ProfessionalDetailController _controller;
  String? _id;

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
    return Scaffold(
      backgroundColor: _C.bg,
      body: SafeArea(
        child: Obx(() {
          if (_id == null || _id!.isEmpty) {
            return const Center(
              child: Text("Professional id missing"),
            );
          }
          if (_controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (_controller.error.isNotEmpty) {
            return Center(
              child: Text(
                _controller.error.value,
                style: const TextStyle(color: _C.text),
              ),
            );
          }

          final detail = _controller.detail.value;
          final userName = detail?.user.name ?? "Unknown";
          final comments = detail?.comments ?? const [];
          final mappedComments = _mapComments(comments);
          final reviewsCount = mappedComments.length;
          final servicesCount = 0;
          final about = detail?.user.about ?? "";

          final ratingRows = const <_RatingRowData>[
            _RatingRowData(label: "Service", value: 0.0),
            _RatingRowData(label: "Communication", value: 0.0),
            _RatingRowData(label: "Kindness", value: 0.0),
            _RatingRowData(label: "Booked Time", value: 0.0),
            _RatingRowData(label: "Comfort", value: 0.0),
          ];

          final commentItems = mappedComments;

          return Column(
            children: [
              // Top AppBar (custom like screenshot)
              Container(
                padding: const EdgeInsets.fromLTRB(8, 10, 12, 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(color: _C.divider, width: 1)),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(10),
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          size: 18,
                          color: _C.green,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Expanded(
                      child: Text(
                        "Personal Details",
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: _C.text,
                          height: 1.1,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: widget.onEdit,
                      borderRadius: BorderRadius.circular(10),
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          "Edit",
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: _C.green,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 18),
                  children: [
                    const SizedBox(height: 16),

                    // Avatar
                    Center(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          CircleAvatar(
                            radius: 44,
                            backgroundColor: const Color(0xFFE6E6E6),
                            backgroundImage:
                                (detail != null && detail.gallery.isNotEmpty)
                                    ? NetworkImage(detail.gallery.first)
                                    : null,
                            child: (detail == null ||
                                    detail.gallery.isEmpty)
                                ? const Icon(
                                    Icons.person,
                                    size: 34,
                                    color: Color(0xFF777777),
                                  )
                                : null,
                          ),
                          // (No camera button in this screen screenshot)
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Name
                    Center(
                      child: Text(
                        userName,
                        style: GoogleFonts.urbanist(
                          fontSize: 16, // ✅ 16px
                          fontWeight: FontWeight.w700, // ✅ Bold
                          height: 1.1, // ✅ 110%
                          letterSpacing: 0, // ✅ 0%
                          color: const Color(0xFF000000), // ✅ black
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),
                    Divider(height: 1, thickness: 1, color: _C.divider),

                    // Stats row (Reviews / Services)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: Row(
                        children: [
                          Expanded(
                            child: _StatCell(
                              topText: "0",
                              topIcon: Icons.star,
                              bottomText: "$reviewsCount reviews",
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _StatCell(
                              topText: "$servicesCount",
                              bottomText: "Services",
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),
                    const Divider(height: 1, thickness: 1, color: _C.divider),

                    // About me
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 14, 22, 6),
                      child: Text(
                        "About me",
                        style: GoogleFonts.poppins(
                          fontSize: 24, // ✅ 24px
                          fontWeight: FontWeight.w500, // ✅ Medium (500)
                          height: 1.2, // ✅ 120%
                          letterSpacing: 0, // ✅ 0%
                          color: const Color(0xFF3FA96B), // ✅ #3FA96B
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 0, 22, 14),
                      child: Text(
                        about,
                        style: GoogleFonts.poppins(
                          fontSize: 16, // ✅ 16px
                          fontWeight: FontWeight.w400, // ✅ Regular
                          height: 1.2, // ✅ 120%
                          letterSpacing: 0, // ✅ 0%
                          color: const Color(0xFF18191A), // ✅ #18191A
                        ),
                      ),
                    ),

                    const Divider(height: 1, thickness: 1, color: _C.divider),

                    // Outstanding summary
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 14, 22, 10),
                      child: Row(
                        children: [
                          Text(
                            "0",
                            style: GoogleFonts.poppins(
                              fontSize: 24, // ✅ 24px
                              fontWeight: FontWeight.w500, // ✅ Medium (500)
                              height: 1.2, // ✅ 120%
                              letterSpacing: 0, // ✅ 0%
                              color: const Color(0xFF000000), // ✅ #000000
                            ),
                          ),

                          const SizedBox(width: 4),
                          const Icon(
                            Icons.star,
                            size: 24, // ✅ Figma
                            color: Color(0xFFFFC34D), // ✅ #FFC34D
                          ),

                          const SizedBox(width: 8),
                          Text(
                            "Outstanding",
                            style: GoogleFonts.poppins(
                              fontSize: 24, // ✅ 24px
                              fontWeight: FontWeight.w500, // ✅ Medium (500)
                              height: 1.2, // ✅ 120%
                              letterSpacing: 0, // ✅ 0%
                              color: const Color(0xFF18191A), // ✅ #18191A
                            ),
                          ),

                          const SizedBox(width: 6),
                          Text(
                            "($reviewsCount ratings)",
                            style: GoogleFonts.poppins(
                              fontSize: 16, // ✅ 16px
                              fontWeight: FontWeight.w400, // ✅ Regular
                              height: 1.2, // ✅ 120%
                              letterSpacing: 0, // ✅ 0%
                              color: const Color(0xFF6D6F73), // ✅ #6D6F73
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Rating rows
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 0, 22, 12),
                      child: Column(
                        children: ratingRows
                            .map(
                              (r) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6),
                                child: _RatingRow(data: r),
                              ),
                            )
                            .toList(),
                      ),
                    ),

                    // Comments
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 14, 22, 10),
                      child: Text(
                        "Comments",
                        style: GoogleFonts.poppins(
                          fontSize: 24, // ✅ 24px
                          fontWeight: FontWeight.w500, // ✅ Medium (500)
                          height: 1.2, // ✅ 120%
                          letterSpacing: 0, // ✅ 0%
                          color: const Color(0xFF3FA96B), // ✅ #3FA96B
                        ),
                      ),
                    ),

                    if (commentItems.isEmpty)
                      const Padding(
                        padding: EdgeInsets.fromLTRB(22, 10, 22, 10),
                        child: Text(
                          "No comments yet",
                          style: TextStyle(color: _C.text),
                        ),
                      ),
                    ...commentItems.map((c) => _CommentTile(data: c)),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

/// -------------------------
/// Stats cell
/// -------------------------
class _StatCell extends StatelessWidget {
  const _StatCell({
    required this.topText,
    required this.bottomText,
    this.topIcon,
  });

  final String topText;
  final String bottomText;
  final IconData? topIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   borderRadius: BorderRadius.circular(10),
      //   border: Border.all(color: _C.divider, width: 1),
      // ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                topText, // "5"
                style: GoogleFonts.poppins(
                  fontSize: 24, // ✅ 24px
                  fontWeight: FontWeight.w500, // ✅ Medium
                  height: 1.2, // ✅ 120%
                  letterSpacing: 0, // ✅ 0%
                  color: const Color(0xFF000000), // ✅ #000000
                ),
              ),

              if (topIcon != null) ...[
                const SizedBox(width: 4),
                Icon(
                  topIcon,
                  size: 24, // ✅ Figma
                  color: const Color(0xFFFFC34D), // ✅ #FFC34D
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            bottomText, // "13 reviews"
            style: GoogleFonts.urbanist(
              fontSize: 16, // ✅ 16px
              fontWeight: FontWeight.w700, // ✅ Bold
              height: 1.1, // ✅ 110%
              letterSpacing: 0, // ✅ 0%
              color: const Color(0xFF000000), // ✅ black
              decoration: TextDecoration.underline, // ✅ underline
              decorationStyle: TextDecorationStyle.solid,
            ),
          ),
        ],
      ),
    );
  }
}

/// -------------------------
/// Rating row
/// -------------------------
class _RatingRowData {
  final String label;
  final double value;
  const _RatingRowData({required this.label, required this.value});
}

class _RatingRow extends StatelessWidget {
  const _RatingRow({required this.data});
  final _RatingRowData data;

  @override
  Widget build(BuildContext context) {
    final normalized = (data.value / 5.0).clamp(0.0, 1.0);

    return Row(
      children: [
        SizedBox(
          width: 171.5, // ✅ optional (Figma width)
          child: Text(
            data.label,
            style: GoogleFonts.poppins(
              fontSize: 16, // ✅ 16px
              fontWeight: FontWeight.w400, // ✅ Regular
              height: 1.2, // ✅ 120%
              letterSpacing: 0, // ✅ 0%
              color: const Color(0xFF000000), // ✅ #000000
            ),
          ),
        ),

        SizedBox(
          width: 100, // ✅ Figma
          height: 8, // ✅ Figma
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100), // ✅ pill
            child: LinearProgressIndicator(
              value: normalized,
              minHeight: 8, // ✅ Figma height
              backgroundColor: _C.barBg,
              valueColor: const AlwaysStoppedAnimation<Color>(_C.bar),
            ),
          ),
        ),

        const SizedBox(width: 10),
        SizedBox(
          width: data.value == 5 ? 11 : 24, // ✅ Figma widths
          child: Text(
            data.value == 5 ? "5" : data.value.toStringAsFixed(1),
            textAlign: TextAlign.right,
            style: GoogleFonts.poppins(
              fontSize: 16, // ✅ 16px
              fontWeight: FontWeight.w400, // ✅ Regular
              height: 1.2, // ✅ 120%
              letterSpacing: 0,
              color: const Color(0xFF000000), // ✅ black
            ),
          ),
        ),
      ],
    );
  }
}

/// -------------------------
/// Comment tile
/// -------------------------
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

class _CommentTile extends StatelessWidget {
  const _CommentTile({required this.data});
  final _CommentData data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(height: 1, thickness: 1, color: _C.divider),
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 18,
                backgroundColor: Color(0xFFE6E6E6),
                child: Icon(Icons.person, size: 18, color: Color(0xFF777777)),
              ),
              const SizedBox(width: 12),

              // text block
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          data.name,
                          style: GoogleFonts.urbanist(
                            fontSize: 18, // ✅ 18px
                            fontWeight: FontWeight.w500, // ✅ Medium (500)
                            height: 1.1, // ✅ 110%
                            letterSpacing: 0, // ✅ 0%
                            color: const Color(0xFF18191A), // ✅ #18191A
                          ),
                        ),

                        const SizedBox(width: 6),

                        Padding(
                          padding: const EdgeInsets.only(
                            top: 4,
                          ), // aligns with first text line
                          child: Image.asset(
                            Images.roundIcon,
                            width: 9,
                            height: 9,
                            color: const Color(
                              0xFF727272,
                            ), // ✅ #727272 (only works if icon is single-color)
                          ),
                        ),

                        const SizedBox(width: 8),
                        Text(
                          data.timeAgo,
                          style: GoogleFonts.urbanist(
                            fontSize: 14, // ✅ 14px
                            fontWeight: FontWeight.w400, // ✅ Regular
                            height: 1.1, // ✅ 110%
                            letterSpacing: 0, // ✅ 0%
                            color: const Color(0xFF727272), // ✅ #727272
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (data.isVerified)
                      Row(
                        children: [
                          Icon(
                            Icons.verified_outlined, // ✅ outline look
                            size: 13.33, // ✅ Figma size
                            color: const Color(0xFF18191A), // ✅ #18191A
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Verified service",
                            style: GoogleFonts.urbanist(
                              fontSize:
                                  14, // if your Figma text is 14 regular/medium adjust here
                              fontWeight: FontWeight.w400,
                              height: 1.1,
                              color: const Color(0xFF727272),
                            ),
                          ),
                        ],
                      ),

                    const SizedBox(height: 6),
                    Text(
                      data.comment,
                      style: GoogleFonts.urbanist(
                        fontSize: 14, // ✅ 14px
                        fontWeight: FontWeight.w400, // ✅ Regular
                        height: 1.1, // ✅ 110%
                        letterSpacing: 0, // ✅ 0%
                        color: const Color(0xFF18191A), // ✅ #18191A
                      ),
                    ),
                  ],
                ),
              ),

              // rating right
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 11, // ✅ optional (Figma)
                    child: Text(
                      "${data.rating}",
                      textAlign: TextAlign.right,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        height: 1.2,
                        letterSpacing: 0,
                        color: const Color(0xFF000000),
                      ),
                    ),
                  ),
                  const SizedBox(width: 3),
                  const Icon(
                    Icons.star,
                    size: 16, // ✅ Figma
                    color: Color(0xFFFFC34D), // ✅ #FFC34D
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// -------------------------
/// Colors
/// -------------------------
class _C {
  static const bg = Colors.white;

  static const green = Color(0xFF27AE60);
  static const text = Color(0xFF111111);
  static const subText = Color(0xFF7C7C7C);

  static const divider = Color(0xFFEDEDED);

  static const star = Color(0xFFF5B400);

  static const bar = Color(0xFFF5B400);
  static const barBg = Color(0xFFF1F1F1);
}
