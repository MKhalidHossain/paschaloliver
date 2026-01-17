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
  // ✅ Match Figma
  Color get _brandGreen => const Color(0xFF3FA96B);

  Color get _bg => Colors.white;
  Color get _textDark => const Color(0xFF333333);
  Color get _hintText => const Color(0xFF777777);
  Color get _borderGrey => const Color(0xFFE0E0E0);

  final ImagePicker _picker = ImagePicker();

  ImageProvider? _selectedImage;
  bool _hasChanges = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: _bg,
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),

              // TOP BAR + PROGRESS (ALIGNED)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 16,
                      width: double.infinity,
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
                      onTap: _handleBackPressed, // ✅ use confirm logic
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Icon(
                          Icons.arrow_back,
                          size: 18,
                          color: _brandGreen,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // TITLE & SUBTITLE
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Profile Picture",
                      style: GoogleFonts.urbanist(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        height: 1.1,
                        letterSpacing: 0,
                        color: _brandGreen,
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

              // CIRCLE PICKER
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
                                color: _brandGreen, // ✅
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

              // INFO CARD
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
                            fontWeight: FontWeight.w700,
                            height: 1.1,
                            letterSpacing: 0,
                            color: const Color(0xFF000000),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AvatarWithBadge(
                            image: Images.good,
                            isGood: true,
                            brandGreen: _brandGreen,
                          ),
                          const SizedBox(width: 44),
                          AvatarWithBadge(
                            image: Images.bad,
                            isGood: false,
                            brandGreen: _brandGreen,
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

              // CONTINUE BUTTON
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
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Continue",
                      style: GoogleFonts.urbanist(
                        fontSize: 16,
                        fontWeight: FontWeight.w500, // ✅ Figma Medium
                        height: 1.1,
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

  Widget _buildHintRow(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            Images.checkIcon,
            width: 20,
            height: 20,
            fit: BoxFit.contain,
          ),
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
        _hasChanges = true;
      });
    } catch (e) {
      debugPrint('Image pick error: $e');
    }
  }

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
                      textAlign: TextAlign.center,
                      style: GoogleFonts.urbanist(
                        fontSize: 14,
                        fontWeight: FontWeight.w400, // Regular
                        height: 1.1,
                        letterSpacing: 0,
                        color: const Color(0xFF000000),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Select photos from your gallery or take new ones with your camera.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.urbanist(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.1,
                        color: const Color(0xFF000000),
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
          style: GoogleFonts.urbanist(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            height: 1.1,
          ),
        ),
      ),
    );
  }

  void _handleBackPressed() async {
    if (!await _onWillPop()) return;
    Get.back();
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
                  Expanded(
                    child: Text(
                      'Do you want to leave without saving?',
                      style: GoogleFonts.urbanist(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        height: 1.1,
                        color: _brandGreen,
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
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.1,
                  color: const Color(0xFF000000),
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
                        style: GoogleFonts.urbanist(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 1.1,
                          color: _brandGreen,
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
                      child: Text(
                        'Stay',
                        style: GoogleFonts.urbanist(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 1.1,
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

/// ✅ MUST be outside State class (no nesting)
class AvatarWithBadge extends StatelessWidget {
  const AvatarWithBadge({
    super.key,
    required this.image,
    required this.isGood,
    required this.brandGreen,
  });

  final String image;
  final bool isGood;
  final Color brandGreen;

  @override
  Widget build(BuildContext context) {
    final badgeColor = isGood ? brandGreen : const Color(0xFFE74C3C);

    return SizedBox(
      width: 62,
      height: 62,
      child: Stack(
        clipBehavior: Clip.none, // ✅ avoid clipping
        children: [
          Align(
            alignment: Alignment.center,
            child: CircleAvatar(
              radius: 28,
              backgroundColor: const Color(0xFFEFEFEF),
              backgroundImage: AssetImage(image),
            ),
          ),

          // badge bottom-right (not clipped)
          Positioned(
            right: 3,
            bottom: 3,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE6E6E6), width: 1),
              ),
              child: Center(
                child: Icon(
                  isGood ? Icons.check_rounded : Icons.close_rounded,
                  size: 12,
                  color: badgeColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
