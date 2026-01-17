import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/assets.dart';
import '../information/information_screen.dart';

class ProfilePictureScreen extends StatefulWidget {
  const ProfilePictureScreen({super.key});

  @override
  State<ProfilePictureScreen> createState() => _ProfilePictureScreenState();
}

class _ProfilePictureScreenState extends State<ProfilePictureScreen> {
  // Brand colors
  Color get _brandGreen => const Color(0xFF27AE60);
  Color get _bg => const Color(0xFFF5F5F5);
  Color get _textDark => const Color(0xFF333333);
  Color get _hintText => const Color(0xFF777777);
  Color get _borderGrey => const Color(0xFFE0E0E0);

  final ImagePicker _picker = ImagePicker();

  // picked image
  ImageProvider? _selectedImage;

  // track unsaved changes (for "leave without saving?")
  bool _hasChanges = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // handle system back
      child: Scaffold(
        backgroundColor: _bg,
        body: SafeArea(
          child: Column(
            children: [
              // ---------------- TOP BAR + PROGRESS ----------------
              const SizedBox(height: 10),
              // TOP BAR + PROGRESS (ALIGNED)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  24,
                  12,
                  24,
                  4,
                ), // same as title/search
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 16,
                      width: double
                          .infinity, // fill inside the 24px padding => aligns perfectly
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(99),
                        child: LinearProgressIndicator(
                          value: 0.25,
                          minHeight: 16,
                          backgroundColor: const Color(0xFFE4E4E4),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _brandGreen,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => Get.back(),
                      child: const Padding(
                        padding: EdgeInsets.all(0),
                        child: Icon(Icons.arrow_back, size: 18),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              const SizedBox(height: 16),

              // ---------------- TITLE & SUBTITLE ----------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Profile Picture",
                      style: GoogleFonts.urbanist(
                        fontSize: 24,
                        fontWeight: FontWeight.w600, // SemiBold
                        height: 1.1,
                        letterSpacing: 0,
                        color: const Color(0xFF3FA96B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "This will be the picture that clients will see of you. "
                      "Try to make it as trustworthy as possible.",
                      style: GoogleFonts.urbanist(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.1,
                        letterSpacing: 0,
                        color: const Color(0xFF000000),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ---------------- CIRCLE PICKER ----------------
              GestureDetector(
                onTap: _openAddPhotoSheet,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: _borderGrey, width: 1.4),
                  ),
                  child: _selectedImage == null
                      ? Center(
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _borderGrey,
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.add,
                                size: 24,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        )
                      : ClipOval(
                          child: Image(
                            image: _selectedImage!,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 24),

              // ---------------- INFO CARD ----------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          "What makes a good profile picture?",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.urbanist(
                            fontSize: 16,
                            fontWeight: FontWeight.w700, // Bold
                            height: 1.1,
                            letterSpacing: 0,
                            color: const Color(0xFF000000),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Row(
                        children: [
                          // good example
                          Column(
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundImage: const AssetImage(Images.good),
                                backgroundColor: Colors.grey.shade300,
                              ),
                              const SizedBox(height: 6),
                              // Icon(Icons.check_circle, color: _brandGreen),
                            ],
                          ),
                          const SizedBox(width: 32),
                          // bad example
                          Column(
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundImage: const AssetImage(Images.bad),
                                backgroundColor: Colors.grey.shade300,
                              ),
                              const SizedBox(height: 6),
                              // const Icon(
                              //   Icons.cancel,
                              //   color: Color(0xFFE74C3C),
                              // ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      _buildHintRow("Good lighting"),
                      _buildHintRow("Good resolution"),
                      _buildHintRow("Visible face"),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // ---------------- CONTINUE BUTTON ----------------
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ).copyWith(bottom: 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _selectedImage == null
                        ? null
                        : () {
                            _hasChanges = false;

                            Get.off(() => const InformationScreen());
                          },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedImage == null
                          ? const Color(0xFFE0E0E0)
                          : _brandGreen,
                      disabledBackgroundColor: const Color(0xFFE0E0E0),
                      disabledForegroundColor: _hintText,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Continue",
                      style: TextStyle(
                        fontSize: 16,
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

  Widget _TopBarProgress({
    required VoidCallback onBack,
    required double progress, // 0.0 - 1.0
    required Color brandGreen,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1) Progress bar (full width)
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: const Color(0xFFE0E0E0),
              valueColor: AlwaysStoppedAnimation<Color>(brandGreen),
            ),
          ),

          const SizedBox(height: 8),

          // 2) Back button row (only)
          SizedBox(
            height: 40, // keep it tight like Figma
            child: Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                visualDensity: VisualDensity.compact,
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back_ios_new, size: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Helper widgets
  // ---------------------------------------------------------------------------

  Widget _buildHintRow(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: _brandGreen, size: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.urbanist(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.1,
              letterSpacing: 0,
              color: const Color(0xFF000000),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Image picking
  // ---------------------------------------------------------------------------

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? file = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 90,
      );
      if (file == null) return;

      setState(() {
        _selectedImage = FileImage(File(file.path));
        _hasChanges = true; // user selected/changed picture
      });
    } catch (e) {
      debugPrint('Image pick error: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // Bottom Sheet for picking image
  // ---------------------------------------------------------------------------

  void _openAddPhotoSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(color: Colors.transparent),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 18,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0E0E0),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Add Photo",
                      style: TextStyle(
                        color: _textDark,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Select photos from your gallery or take new ones with your camera.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _hintText,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _bottomSheetButton(
                      label: "Camera",
                      filled: false,
                      onTap: () async {
                        Navigator.of(ctx).pop();
                        await _pickImage(ImageSource.camera);
                      },
                    ),
                    const SizedBox(height: 8),
                    _bottomSheetButton(
                      label: "Gallery",
                      filled: false,
                      onTap: () async {
                        Navigator.of(ctx).pop();
                        await _pickImage(ImageSource.gallery);
                      },
                    ),
                    const SizedBox(height: 12),
                    _bottomSheetButton(
                      label: "Cancel",
                      filled: true,
                      onTap: () => Navigator.of(ctx).pop(),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _bottomSheetButton({
    required String label,
    required bool filled,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          backgroundColor: filled ? _brandGreen : Colors.white,
          foregroundColor: filled ? Colors.white : _brandGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: filled
                ? BorderSide.none
                : BorderSide(color: _brandGreen, width: 1.2),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // LEAVE WITHOUT SAVING? (same behavior as WorkSchedule)
  // ---------------------------------------------------------------------------

  void _handleBackPressed() async {
    if (!await _onWillPop()) return;
    Get.back(); // go back to WorkScheduleScreen
  }

  Future<bool> _onWillPop() async {
    if (!_hasChanges) return true;

    final result = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18),
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
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Do you want to leave without saving?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context, false),
                    icon: const Icon(Icons.close, size: 18),
                    splashRadius: 20,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'If you leave without saving, you will lose all the '
                'information completed in this section.',
                style: TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: _brandGreen),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () =>
                          Navigator.pop<bool>(context, true), // leave anyway
                      child: Text(
                        'Leave anyway',
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
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () =>
                          Navigator.pop<bool>(context, false), // stay
                      child: const Text(
                        'Stay',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );

    return result ?? false;
  }
}
