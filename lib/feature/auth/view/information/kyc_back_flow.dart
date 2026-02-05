import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/assets.dart';
import '../../../professional/controller/professional_registration_controller.dart';
import 'upload_back_screen.dart'; // 👈 back flow

/// ---------------------------------------------------------------------------
/// Shared styles
/// ---------------------------------------------------------------------------

const _brandGreen = Color(0xFF27AE60);
const _textDark = Color(0xFF333333);
const _hintText = Color(0xFF777777);

TextStyle get _titleStyle => const TextStyle(
  fontSize: 22,
  fontWeight: FontWeight.w700,
  color: _textDark,
);

TextStyle get _subtitleStyle =>
    const TextStyle(fontSize: 14, height: 1.4, color: _hintText);

/// ---------------------------------------------------------------------------
/// 1) UPLOAD FRONT ID SCREEN
/// ---------------------------------------------------------------------------

class UploadFrontIdScreen extends StatefulWidget {
  const UploadFrontIdScreen({super.key});

  @override
  State<UploadFrontIdScreen> createState() => _UploadFrontIdScreenState();
}

class _UploadFrontIdScreenState extends State<UploadFrontIdScreen> {
  final _picker = ImagePicker();

  Future<void> _pickFromCamera() async {
    final file = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1600,
      maxHeight: 1600,
      imageQuality: 90,
    );
    if (file == null) return;

    final regC = Get.find<ProfessionalRegistrationController>();
    regC.documentFrontImage = File(file.path);

    final frontImage = FileImage(File(file.path));
    Get.to(() => UploadedFrontIdScreen(frontImage: frontImage));
  }

  Future<void> _pickFromGallery() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600,
      maxHeight: 1600,
      imageQuality: 90,
    );
    if (file == null) return;

    final regC = Get.find<ProfessionalRegistrationController>();
    regC.documentFrontImage = File(file.path);

    final frontImage = FileImage(File(file.path));
    Get.to(() => UploadedFrontIdScreen(frontImage: frontImage));
  }

  void _openUploadSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) {
        final safeBottom = MediaQuery.of(ctx).padding.bottom;

        return Padding(
          padding: EdgeInsets.fromLTRB(24, 16, 24, 16 + safeBottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              Text(
                'Add Documents',
                textAlign: TextAlign.center,
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  fontWeight: FontWeight.w400, // Regular
                  height: 1.2, // 120%
                  letterSpacing: 0,
                  color: const Color(0xFF181919),
                ),
              ),

              const SizedBox(height: 6),
              Text(
                'Select documents from your gallery or take new ones \nwith your camera',
                textAlign: TextAlign.center,
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  fontWeight: FontWeight.w400, // Regular
                  height: 1.2, // 120%
                  letterSpacing: 0,
                  color: const Color(0xFF181919),
                ),
              ),

              const SizedBox(height: 20),
              _sheetButton(
                label: 'Camera',
                onTap: () async {
                  Navigator.pop(ctx);
                  await _pickFromCamera();
                },
              ),
              const SizedBox(height: 8),
              _sheetButton(
                label: 'Gallery',
                onTap: () async {
                  Navigator.pop(ctx);
                  await _pickFromGallery();
                },
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: _brandGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        toolbarHeight: 120, // ✅ enough for arrow + title + subtitle

        title: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // ✅ Arrow only (top row)
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back, size: 20),
                color: const Color(0xFF181919),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                splashRadius: 22,
                alignment: Alignment.centerLeft,
              ),

              const SizedBox(height: 6),

              // ✅ Title under arrow
              Text(
                'Upload ID (Front Side)',
                style: GoogleFonts.urbanist(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                  color: const Color(0xFF181919),
                ),
              ),

              const SizedBox(height: 6),

              // ✅ Subtitle under title
              Text(
                'Take a clear photo of the front side of your ID',
                style: GoogleFonts.urbanist(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  height: 1.2,
                  color: const Color(0xFF181919),
                ),
              ),
            ],
          ),
        ),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Colors.white,
                border: Border.all(color: Color(0xFFE0E0E0)),
              ),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: _brandGreen, width: 1.6),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 40,
                        height: 38,
                        child: const Center(
                          child: Icon(
                            Icons.photo_camera_outlined,
                            size: 26, // ✅ closer to Figma than 32
                            color: Color(0xFF181919),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Position you ID within the frame',
                        style: GoogleFonts.urbanist(
                          fontSize: 16,
                          fontWeight: FontWeight.w500, // Medium
                          height: 1.2, // 120%
                          letterSpacing: 0,
                          color: const Color(0xFF181919),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // const Spacer(),

          // Padding(
          //   padding: const EdgeInsets.symmetric(
          //     horizontal: 16,
          //   ).copyWith(bottom: 24),
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: SizedBox(
          //           height: 48,
          //           child: ElevatedButton.icon(
          //             style: ElevatedButton.styleFrom(
          //               backgroundColor: _brandGreen,
          //               elevation: 0,
          //               shape: RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.circular(8),
          //               ),
          //             ),
          //             onPressed: () {
          //               Get.to(() => const TakeFrontPhotoScreen());
          //             },
          //             icon: const Icon(
          //               Icons.photo_camera_outlined,
          //               color: Colors.white,
          //               size: 20,
          //             ),
          //             label: const Text(
          //               'Take Photo',
          //               style: TextStyle(
          //                 fontSize: 14,
          //                 fontWeight: FontWeight.w600,
          //                 color: Colors.white,
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //       const SizedBox(width: 12),
          //       Expanded(
          //         child: SizedBox(
          //           height: 48,
          //           child: OutlinedButton.icon(
          //             style: OutlinedButton.styleFrom(
          //               side: const BorderSide(color: _brandGreen),
          //               shape: RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.circular(8),
          //               ),
          //             ),
          //             onPressed: _openUploadSheet,
          //             icon: SizedBox(
          //               width: 20,
          //               height: 20,
          //               child: Image.asset(
          //                 Images.upload2Icon,
          //                 fit: BoxFit.contain,
          //                 // If the icon is single-color and needs to be green:
          //                 color: Colors.green,
          //                 colorBlendMode: BlendMode.srcIn,
          //               ),
          //             ),

          //             label: const Text(
          //               'Upload',
          //               style: TextStyle(
          //                 fontSize: 14,
          //                 fontWeight: FontWeight.w600,
          //                 color: _brandGreen,
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          const Spacer(),

          // ✅ FIXED: bottom safe area padding so buttons don't go under nav bar
          SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                0,
                16,
                16 + MediaQuery.of(context).padding.bottom,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _brandGreen,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Get.to(() => const TakeFrontPhotoScreen());
                        },
                        icon: const Icon(
                          Icons.photo_camera_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                        label: const Text(
                          'Take Photo',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: _brandGreen),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _openUploadSheet,
                        icon: SizedBox(
                          width: 20,
                          height: 20,
                          child: Image.asset(
                            Images.upload2Icon,
                            fit: BoxFit.contain,
                            color: _brandGreen,
                            colorBlendMode: BlendMode.srcIn,
                          ),
                        ),
                        label: const Text(
                          'Upload',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _brandGreen,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sheetButton({required String label, required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFE0E0E0)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onTap,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: _brandGreen,
          ),
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// 2) TAKE FRONT PHOTO SCREEN (blurred background + Capture)
/// ---------------------------------------------------------------------------

class TakeFrontPhotoScreen extends StatefulWidget {
  const TakeFrontPhotoScreen({super.key});

  @override
  State<TakeFrontPhotoScreen> createState() => _TakeFrontPhotoScreenState();
}

class _TakeFrontPhotoScreenState extends State<TakeFrontPhotoScreen> {
  final _picker = ImagePicker();

  Future<void> _captureFront() async {
    final file = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1600,
      maxHeight: 1600,
      imageQuality: 90,
    );
    if (file == null) return;

    final frontImage = FileImage(File(file.path));
    Get.to(() => UploadedFrontIdScreen(frontImage: frontImage));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black87, Colors.black54],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '1/2',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    'Place the front side of your ID card on the in a square',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.white.withOpacity(0.9),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.asset(Images.idFront, fit: BoxFit.cover),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _checkRow('Make sure Image is clear'),
                      _checkRow('Make sure No shadows detected'),
                      _checkRow('Make sure No glare detected'),
                      _checkRow('Make sure Text is readable'),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 24,
                  ).copyWith(bottom: 24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _captureFront,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _brandGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(
                        Icons.photo_camera_outlined,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Capture',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _checkRow(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: Image.asset(
              Images.checkIcon,
              fit: BoxFit.contain,
              // color: _brandGreen, // remove if already green / multi-color
              colorBlendMode: BlendMode.srcIn,
            ),
          ),

          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// 3) UPLOADED FRONT ID SCREEN
/// ---------------------------------------------------------------------------

class UploadedFrontIdScreen extends StatelessWidget {
  final ImageProvider frontImage;

  const UploadedFrontIdScreen({super.key, required this.frontImage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 20),
          onPressed: () => Get.back(),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: _textDark,
        title: const Text(
          'Uploaded ID (Front Side)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: _textDark,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: _brandGreen, width: 1.4),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image(image: frontImage, fit: BoxFit.cover),
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CheckRowGreen('Image is clear'),
                _CheckRowGreen('No shadows detected'),
                _CheckRowGreen('No glare detected'),
                _CheckRowGreen('Text is readable'),
              ],
            ),
          ),
          const Spacer(),

          SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                24,
                0,
                24,
                16 + MediaQuery.of(context).padding.bottom,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: _brandGreen),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size(0, 48),
                      ),
                      onPressed: () => Get.back(),
                      child: const Text(
                        'Return',
                        style: TextStyle(
                          color: _brandGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _brandGreen,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size(0, 48),
                      ),
                      onPressed: () {
                        Get.to(
                          () => UploadBackIdScreen(frontImage: frontImage),
                        );
                      },
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Padding(
          //   padding: const EdgeInsets.symmetric(
          //     horizontal: 24,
          //   ).copyWith(bottom: 24),
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: OutlinedButton(
          //           style: OutlinedButton.styleFrom(
          //             side: const BorderSide(color: _brandGreen),
          //             shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(10),
          //             ),
          //           ),
          //           onPressed: () => Get.back(),
          //           child: const Text(
          //             'Return',
          //             style: TextStyle(
          //               color: _brandGreen,
          //               fontWeight: FontWeight.w600,
          //             ),
          //           ),
          //         ),
          //       ),
          //       const SizedBox(width: 12),
          //       Expanded(
          //         child: ElevatedButton(
          //           style: ElevatedButton.styleFrom(
          //             backgroundColor: _brandGreen,
          //             elevation: 0,
          //             shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(10),
          //             ),
          //           ),
          //           onPressed: () {
          //             // 👉 Continue to back-side capture flow AND pass the front image
          //             Get.to(() => UploadBackIdScreen(frontImage: frontImage));
          //           },
          //           child: const Text(
          //             'Continue',
          //             style: TextStyle(
          //               color: Colors.white,
          //               fontSize: 15,
          //               fontWeight: FontWeight.w600,
          //             ),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}

class _CheckRowGreen extends StatelessWidget {
  final String text;

  const _CheckRowGreen(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: _brandGreen, size: 18),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 13, color: _hintText)),
        ],
      ),
    );
  }
}
