import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'AboutMeDescriptionScreen.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  static const Color _green = Color(0xFF2FA86A);
  static const Color _muted = Color(0xFF8B8B8B);
  static const Color _text = Color(0xFF2B2B2B);
  static const Color _track = Color(0xFFEAEAEA);

  final double _progress = 0.55;

  final ImagePicker _picker = ImagePicker();

  // ✅ real picked images
  final List<File> _images = [];

  Future<void> _onAddMore() async {
    final XFile? x = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (x == null) return;

    setState(() {
      _images.add(File(x.path)); // ✅ add new image
    });
  }

  void _onContinue() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AboutMeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Small top label (Portfolio)
                      // Center(
                      //   child: Text(
                      //     "Portfolio",
                      //     style: TextStyle(
                      //       color: Colors.black.withOpacity(.45),
                      //       fontSize: 12,
                      //       fontWeight: FontWeight.w500,
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(height: 8),

                      _TopProgressBar(value: _progress, track: _track, fill: _green),
                      const SizedBox(height: 12),

                      // Back + Save and exit
                      Row(
                        children: [
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            borderRadius: BorderRadius.circular(10),
                            child: const Padding(
                              padding: EdgeInsets.all(6),
                              child: Icon(Icons.arrow_back, size: 22, color: _green),
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              foregroundColor: _muted,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              textStyle: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w500),
                            ),
                            child: const Text("Save and exit"),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        "Gallery",
                        style: TextStyle(
                          color: _green,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Add service related photos as portfolio to do your listing",
                        style: TextStyle(
                          color: _text,
                          fontSize: 12.8,
                          fontWeight: FontWeight.w400,
                          height: 1.3,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ✅ RED PORTION behavior:
                      // - if no images => only Add more
                      // - if images exist => show images + Add more at end
                      _GalleryTilesRow(
                        images: _images,
                        onAddMore: _onAddMore,
                      ),

                      const SizedBox(height: 18),

                      _TipsCard(
                        title: "What’s makes a good gallery?",
                        items: const [
                          _TipItem("Photos of previous work", true),
                          _TipItem("Services you provide", true),
                          _TipItem("Good resolution", true),
                          _TipItem("Contact Details", false),
                        ],
                      ),

                      const SizedBox(height: 160),
                    ],
                  ),
                ),
              ),

              // Bottom fixed button
              Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Color(0xFFEDEDED), width: 1)),
                ),
                child: SizedBox(
                  height: 52,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _onContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _green,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text(
                      "Continue",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
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

/* --------------------------- Widgets --------------------------- */

class _GalleryTilesRow extends StatelessWidget {
  const _GalleryTilesRow({
    required this.images,
    required this.onAddMore,
  });

  final List<File> images;
  final VoidCallback onAddMore;

  @override
  Widget build(BuildContext context) {
    // ✅ First time: ONLY Add more
    if (images.isEmpty) {
      return Row(
        children: [
          _AddMoreTile(onTap: onAddMore),
        ],
      );
    }

    // ✅ After adding: show images + Add more at end
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (int i = 0; i < images.length; i++) ...[
            _PhotoTile(file: images[i]),
            const SizedBox(width: 14),
          ],
          _AddMoreTile(onTap: onAddMore), // ✅ always last
        ],
      ),
    );
  }
}

class _TopProgressBar extends StatelessWidget {
  const _TopProgressBar({
    required this.value,
    required this.track,
    required this.fill,
  });

  final double value;
  final Color track;
  final Color fill;

  @override
  Widget build(BuildContext context) {
    final v = value.clamp(0.0, 1.0);

    // same style as your other screens (grey track + green pill)
    return Container(
      height: 14,
      decoration: BoxDecoration(
        color: track,
        borderRadius: BorderRadius.circular(999),
      ),
      padding: const EdgeInsets.all(2),
      child: LayoutBuilder(
        builder: (context, c) {
          final w = c.maxWidth * v;
          return Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: w < 50 ? 50 : w,
              height: double.infinity,
              decoration: BoxDecoration(
                color: fill,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PhotoTile extends StatelessWidget {
  const _PhotoTile({required this.file});
  final File file;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 92,
      height: 92,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(14),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.file(file, fit: BoxFit.cover),
    );
  }
}

class _AddMoreTile extends StatelessWidget {
  const _AddMoreTile({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 92,
        height: 92,
        decoration: BoxDecoration(
          color: const Color(0xFFEDEDED),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.add, size: 22, color: Color(0xFF5C5C5C)),
            SizedBox(height: 6),
            Text(
              "Add more",
              style: TextStyle(
                color: Color(0xFF5C5C5C),
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TipsCard extends StatelessWidget {
  const _TipsCard({
    required this.title,
    required this.items,
  });

  final String title;
  final List<_TipItem> items;

  static const Color _green = Color(0xFF2FA86A);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEAEAEA), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF4A4A4A),
              fontSize: 14.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          ...items.map((e) {
            final icon = e.good ? Icons.check_rounded : Icons.close_rounded;
            final iconColor = e.good ? _green : const Color(0xFF7A7A7A);
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(icon, size: 18, color: iconColor),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      e.text,
                      style: const TextStyle(
                        color: Color(0xFF4A4A4A),
                        fontSize: 13.2,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _TipItem {
  final String text;
  final bool good;
  const _TipItem(this.text, this.good);
}
