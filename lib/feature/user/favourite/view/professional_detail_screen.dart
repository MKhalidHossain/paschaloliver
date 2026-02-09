import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/professional_detail_controller.dart';

class ProfessionalDetailScreen extends StatefulWidget {
  const ProfessionalDetailScreen({super.key, required this.professionalId});

  final String professionalId;

  @override
  State<ProfessionalDetailScreen> createState() =>
      _ProfessionalDetailScreenState();
}

class _ProfessionalDetailScreenState extends State<ProfessionalDetailScreen> {
  static const _green = Color(0xFF2FA86A);
  static const _muted = Color(0xFF8B8B8B);
  static const _line = Color(0xFFEDEDED);

  late final ProfessionalDetailController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<ProfessionalDetailController>();
    _controller.fetch(widget.professionalId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() {
          if (_controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_controller.error.isNotEmpty) {
            return Center(
              child: Text(
                _controller.error.value,
                style: const TextStyle(color: _muted),
              ),
            );
          }

          final detail = _controller.detail.value;
          if (detail == null) {
            return const Center(child: Text("No data"));
          }

          return Column(
            children: [
              _TopBar(title: detail.user.name, onBack: () => Get.back()),
              const Divider(height: 1, thickness: 1, color: _line),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  children: [
                    Text(
                      detail.user.name,
                      style: GoogleFonts.urbanist(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1F1F1F),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      detail.user.about,
                      style: GoogleFonts.urbanist(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w400,
                        color: _muted,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 14),

                    _InfoRow(
                      label: "Experience",
                      value: detail.profileDetails.experienceLevel,
                    ),
                    _InfoRow(
                      label: "Industry Experience",
                      value: detail.profileDetails.hasIndustryExperience
                          ? "Yes"
                          : "No",
                    ),
                    _InfoRow(
                      label: "Employment",
                      value: detail.profileDetails.employmentStatus,
                    ),
                    _InfoRow(
                      label: "Current Situation",
                      value: detail.profileDetails.currentSituation,
                    ),

                    const SizedBox(height: 16),
                    Text(
                      "Gallery",
                      style: GoogleFonts.urbanist(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1F1F1F),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 72,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: detail.gallery.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(width: 10),
                        itemBuilder: (context, i) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              detail.gallery[i],
                              width: 72,
                              height: 72,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 72,
                                height: 72,
                                color: const Color(0xFFEDEDED),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 6),
                    if (detail.gallery.isEmpty)
                      const Text(
                        "No gallery images",
                        style: TextStyle(color: _muted, fontSize: 12),
                      ),
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

class _TopBar extends StatelessWidget {
  const _TopBar({required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  static const _green = Color(0xFF2FA86A);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: onBack,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: _green,
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                title,
                style: GoogleFonts.urbanist(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                  color: const Color(0xFF000000),
                ),
              ),
            ),
          ),
          const SizedBox(width: 36),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF6D6F73),
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF1F1F1F),
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
