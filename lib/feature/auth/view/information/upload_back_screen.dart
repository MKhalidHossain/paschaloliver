import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/assets.dart';
import '../../../professional/controller/professional_registration_controller.dart';
import 'information_screen.dart';

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

final _subtitleStyle = GoogleFonts.urbanist(
  fontSize: 16,
  fontWeight: FontWeight.w400,
  height: 1.2,
  letterSpacing: 0,
  color: const Color(0xFF060807),
);

/// ---------------------------------------------------------------------------
/// 1) UPLOAD BACK ID SCREEN
/// ---------------------------------------------------------------------------

class UploadBackIdScreen extends StatefulWidget {
  /// Front image from the previous flow (optional but recommended)
  final ImageProvider? frontImage;

  const UploadBackIdScreen({super.key, this.frontImage});

  @override
  State<UploadBackIdScreen> createState() => _UploadBackIdScreenState();
}

class _UploadBackIdScreenState extends State<UploadBackIdScreen> {
  final _picker = ImagePicker();

  Future<void> _pickFromCamera() async {
    final file = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 70,
    );
    if (file == null) return;

    final regC = Get.find<ProfessionalRegistrationController>();
    regC.documentBackImage = File(file.path);

    final backImage = FileImage(File(file.path));
    Get.to(
      () => UploadedBackIdScreen(
        frontImage: widget.frontImage,
        backImage: backImage,
      ),
    );
  }

  Future<void> _pickFromGallery() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 70,
    );
    if (file == null) return;

    final regC = Get.find<ProfessionalRegistrationController>();
    regC.documentBackImage = File(file.path);

    final backImage = FileImage(File(file.path));
    Get.to(
      () => UploadedBackIdScreen(
        frontImage: widget.frontImage,
        backImage: backImage,
      ),
    );
  }

  void _openUploadSheet() {
    showModalBottomSheet(
      context: context,
      useSafeArea: true, // ✅ FIX
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) {
        final safeBottom = MediaQuery.of(ctx).padding.bottom;

        return Padding(
          padding: EdgeInsets.fromLTRB(24, 16, 24, 16 + safeBottom), // ✅ FIX
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
                  fontWeight: FontWeight.w400,
                  height: 1.2,
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
        toolbarHeight: 110, // ✅ space for arrow + title

        title: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back, size: 18),
                color: _textDark,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                splashRadius: 22,
                alignment: Alignment.centerLeft,
              ),
              const SizedBox(height: 4),
              Text(
                'Upload ID (Back Side)',
                style: GoogleFonts.urbanist(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                  color: _textDark,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              'Take a clear photo of the Back side of your ID',
              style: GoogleFonts.urbanist(
                fontSize: 16,
                fontWeight: FontWeight.w400, // Regular
                height: 1.2, // 120%
                letterSpacing: 0,
                color: const Color(0xFF181919),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE0E0E0)),
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
                    children: const [
                      SizedBox(
                        width: 48,
                        height: 48,
                        child: Center(
                          child: Icon(
                            Icons.photo_camera_outlined,
                            size: 32,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Position you ID within the frame',
                        style: TextStyle(
                          fontFamily: 'SF Pro',
                          fontSize: 16,
                          fontWeight: FontWeight.w600, // closest to 510
                          height: 1.2,
                          color: Color(0xFF181919),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),

          // ✅ FIXED: bottom safe area so it never goes under navigation bar
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
                          Get.to(
                            () => TakeBackPhotoScreen(
                              frontImage: widget.frontImage,
                            ),
                          );
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
/// 2) TAKE BACK PHOTO SCREEN (blurred background + Capture)
/// ---------------------------------------------------------------------------

class TakeBackPhotoScreen extends StatefulWidget {
  /// Front side (already captured)
  final ImageProvider? frontImage;

  const TakeBackPhotoScreen({super.key, this.frontImage});

  @override
  State<TakeBackPhotoScreen> createState() => _TakeBackPhotoScreenState();
}

class _TakeBackPhotoScreenState extends State<TakeBackPhotoScreen> {
  final _picker = ImagePicker();

  Future<void> _captureBack() async {
    final file = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1600,
      maxHeight: 1600,
      imageQuality: 90,
    );
    if (file == null) return;

    final backImage = FileImage(File(file.path));

    Get.to(
      () => UploadedBackIdScreen(
        frontImage: widget.frontImage,
        backImage: backImage,
      ),
    );
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
                  '2/2',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    'Place the Back side of your ID card on the in a square',
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
                    color: Colors.white.withAlpha(230),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.asset(Images.idBack, fit: BoxFit.cover),
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

                // ✅ FIXED: bottom safe area for Capture button
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      24,
                      0,
                      24,
                      16 + MediaQuery.of(context).padding.bottom,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: _captureBack,
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
          const Icon(Icons.check_circle, color: _brandGreen, size: 18),
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
/// 3) UPLOADED BACK ID SCREEN
/// ---------------------------------------------------------------------------

class UploadedBackIdScreen extends StatelessWidget {
  final ImageProvider? frontImage; // may be null
  final ImageProvider backImage;

  const UploadedBackIdScreen({
    super.key,
    required this.frontImage,
    required this.backImage,
  });

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
          'Uploaded ID (Back Side)',
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
                  child: Image(image: backImage, fit: BoxFit.cover),
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

          // ✅ FIXED: bottom safe area for Return / Continue
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
                          () => ReviewDocumentScreen(
                            frontImage: frontImage,
                            backImage: backImage,
                          ),
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
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// 4) REVIEW DOCUMENT SCREEN (front + back preview)
/// ---------------------------------------------------------------------------

class ReviewDocumentScreen extends StatelessWidget {
  final ImageProvider? frontImage; // optional
  final ImageProvider backImage;

  const ReviewDocumentScreen({
    super.key,
    required this.frontImage,
    required this.backImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 18),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.white,
        foregroundColor: _textDark,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
            ).copyWith(top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Review Your Document', style: _titleStyle),
                const SizedBox(height: 4),
                Text(
                  'Make sure both images are clear and readable',
                  style: _subtitleStyle,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _documentCard(title: 'Front Side', image: frontImage),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _documentCard(
              title: 'Back Side',
              image: backImage,
              isMandatoryImage: true,
            ),
          ),
          const Spacer(),

          // ✅ FIXED: bottom safe area for Return / Continue
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
                      onPressed: () async {
                        Get.to(() => const VerificationUnderReviewScreen());
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
        ],
      ),
    );
  }

  Widget _documentCard({
    required String title,
    required ImageProvider? image,
    bool isMandatoryImage = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.urbanist(
              fontSize: 16,
              fontWeight: FontWeight.w500, // Medium 500
              height: 1.2, // 120%
              letterSpacing: 0,
              color: const Color(0xFF060807),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _brandGreen, width: 1.3),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: image != null
                    ? Image(image: image, fit: BoxFit.cover)
                    : Container(
                        color: Colors.grey.shade200,
                        child: Center(
                          child: Text(
                            isMandatoryImage
                                ? 'No image'
                                : 'No image (optional)',
                            style: const TextStyle(
                              fontSize: 13,
                              color: _hintText,
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// 5) VERIFICATION UNDER REVIEW SCREEN
/// ---------------------------------------------------------------------------

class VerificationUnderReviewScreen extends StatelessWidget {
  const VerificationUnderReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 20),
          onPressed: () => Get.back(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: SizedBox(
                height: 34,
                child: OutlinedButton(
                  onPressed: () =>
                      Get.to(() => const VerificationSuccessScreen()),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: _brandGreen, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    minimumSize: const Size(0, 34),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    backgroundColor: Colors.white,
                    foregroundColor: _brandGreen,
                    elevation: 0,
                  ),
                  child: Text(
                    'Skip',
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                      color: _brandGreen,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
            ).copyWith(top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Verification Under Review', style: _titleStyle),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Your identity is under review. You’ll be notified once approved.",
                    textAlign: TextAlign.center,
                    style: _subtitleStyle,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: const [
                _ReviewStepRow(
                  icon: Icons.check_circle,
                  iconColor: _brandGreen,
                  title: 'Documents uploaded',
                  subtitle: 'Completed',
                ),
                SizedBox(height: 12),
                _ReviewStepRow(
                  icon: Icons.history,
                  iconColor: _hintText,
                  title: 'Admin review in progress',
                  subtitle: 'Usually takes 5–15 minutes',
                ),
                SizedBox(height: 12),
                _ReviewStepRow(
                  icon: Icons.history,
                  iconColor: _hintText,
                  title: 'Approval & activation',
                  subtitle: 'Pending',
                ),
              ],
            ),
          ),
          const Spacer(),

          // ✅ FIXED: bottom safe area for disabled button
          SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                24,
                0,
                24,
                16 + MediaQuery.of(context).padding.bottom,
              ),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                  onPressed: () => Get.to(
                    () => const InformationScreen(),
                    arguments: {'fromWaiting': true},
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE0E0E0),
                    disabledBackgroundColor: const Color(0xFFE0E0E0),
                    disabledForegroundColor: _hintText,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Waiting for admin approval',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewStepRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;

  const _ReviewStepRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _textDark,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: _hintText),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// ---------------------------------------------------------------------------
/// 6) VERIFIED / COMPLETED SCREEN
/// ---------------------------------------------------------------------------

class VerificationSuccessScreen extends StatelessWidget {
  const VerificationSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 20),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: _textDark,
      ),
      body: Column(
        children: [
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Congratulations! 🎉 You’re Now Verified",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: _textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your documents have been reviewed and approved.'
                  'You are now a verified Professional on HandyNaija.',
                  style: _subtitleStyle,
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _brandGreen.withAlpha(31),
            ),
            child: Center(
              child: Container(
                width: 130,
                height: 130,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: _brandGreen,
                ),
                child: const Icon(Icons.check, size: 64, color: Colors.white),
              ),
            ),
          ),
          const Spacer(),

          // ✅ FIXED: bottom safe area for Continue
          SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                24,
                0,
                24,
                16 + MediaQuery.of(context).padding.bottom,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _brandGreen,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
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
