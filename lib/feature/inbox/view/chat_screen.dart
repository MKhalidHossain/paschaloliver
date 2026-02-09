import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paschaloliver/feature/profile/view/personal_details_screen.dart';

/// ✅ Pro Chat Details Screen (same UI)
/// ✅ Now Camera / Photos / Files are WORKING:
/// - Tap + => bottom sheet
/// - Tap Camera => opens camera, adds image message
/// - Tap Photos => opens gallery, adds image message
/// - Tap Files  => opens file picker, adds file message (name)
///
/// NOTE:
/// 1) Add packages:
///    image_picker: ^1.1.2
///    file_picker: ^8.0.6
///
/// 2) AndroidManifest.xml (above <application>):
///    <uses-permission android:name="android.permission.CAMERA" />
///
/// 3) iOS Info.plist:
///    NSCameraUsageDescription, NSPhotoLibraryUsageDescription
class ChatDetailsScreen extends StatefulWidget {
  const ChatDetailsScreen({
    super.key,
    required this.name,
    required this.jobTitle,
    this.avatarUrl,
    this.professionalId,
  });

  final String name;
  final String jobTitle;
  final String? avatarUrl;
  final String? professionalId;

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen> {
  final _msgCtrl = TextEditingController();
  final _picker = ImagePicker();

  // demo messages (replace with your API data)
  final List<_Msg> _messages = [
    _Msg.image(
      who: _Who.other,
      time: "12:44",
      // demo placeholder (no path)
    ),
    _Msg.text(who: _Who.other, text: "Need a service", time: "12:44"),
    _Msg.text(who: _Who.me, text: "Need a service", time: "12:44"),
    _Msg.text(who: _Who.me, text: "Need a service", time: "12:44"),
    _Msg.text(who: _Who.me, text: "Need a service", time: "12:44"),
  ];

  final _listCtrl = ScrollController();

  @override
  void dispose() {
    _msgCtrl.dispose();
    _listCtrl.dispose();
    super.dispose();
  }

  // ✅ OPEN SHEET (same UI, just callbacks)
  void _openAttachments() {
    showModalBottomSheet(
      context: context,
      useSafeArea: false, // ✅ important for correct bottom fill
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(.25),
      isScrollControlled: false,
      builder: (_) => _AttachmentSheet(
        onCamera: () {
          Navigator.pop(context);
          _pickCamera();
        },
        onPhotos: () {
          Navigator.pop(context);
          _pickGallery();
        },
        onFiles: () {
          Navigator.pop(context);
          _pickFiles();
        },
      ),
    );
  }

  void _send() {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_Msg.text(who: _Who.me, text: text, time: _nowLabel()));
    });

    _msgCtrl.clear();
    FocusScope.of(context).unfocus();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    // safe post-frame scroll
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_listCtrl.hasClients) return;
      _listCtrl.animateTo(
        _listCtrl.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  String _nowLabel() {
    final t = TimeOfDay.now();
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return "$h:$m";
  }

  // =============================================================================
  // ✅ FUNCTIONAL: Camera / Photos / Files
  // =============================================================================

  Future<void> _pickCamera() async {
    try {
      final XFile? x = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      if (x == null) return;

      setState(() {
        _messages.add(
          _Msg.image(who: _Who.me, time: _nowLabel(), path: x.path),
        );
      });
      _scrollToBottom();
    } catch (e) {
      _toast("Camera error: $e");
    }
  }

  Future<void> _pickGallery() async {
    try {
      final XFile? x = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (x == null) return;

      setState(() {
        _messages.add(
          _Msg.image(who: _Who.me, time: _nowLabel(), path: x.path),
        );
      });
      _scrollToBottom();
    } catch (e) {
      _toast("Photos error: $e");
    }
  }

  Future<void> _pickFiles() async {
    try {
      final res = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.any,
      );
      if (res == null || res.files.isEmpty) return;

      final f = res.files.first;
      final path = f.path;
      if (path == null) return;

      setState(() {
        _messages.add(
          _Msg.file(
            who: _Who.me,
            time: _nowLabel(),
            fileName: f.name,
            path: path,
          ),
        );
      });
      _scrollToBottom();
    } catch (e) {
      _toast("Files error: $e");
    }
  }

  void _toast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _openProfessionalProfile() {
    final id = widget.professionalId;
    if (id == null || id.isEmpty) {
      _toast("Professional id missing");
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PersonalDetailsScreen(professionalId: id),
      ),
    );
  }

  // =============================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ✅ Header
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
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
                        color: _C.text,
                      ),
                    ),
                  ),
                  const SizedBox(width: 2),
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: const Color(0xFFDADADA),
                    backgroundImage:
                        (widget.avatarUrl == null || widget.avatarUrl!.isEmpty)
                        ? null
                        : NetworkImage(widget.avatarUrl!),
                    child:
                        (widget.avatarUrl == null || widget.avatarUrl!.isEmpty)
                        ? const Icon(
                            Icons.person,
                            size: 16,
                            color: Color(0xFF666666),
                          )
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            color: _C.green,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.jobTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _C.subText,
                            height: 1.15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, thickness: 1, color: _C.divider),

            // ✅ Service completed block
            // ✅ Replace BOTH blocks with this single widget call:
            _ServiceMetaBar(
              title: "Service completed:",
              timeLine: "Thursday 09/10 - 12:25 - 15:15",
              onService: () {},
              onShare: _openProfessionalProfile,
            ),

            const Divider(height: 1, thickness: 1, color: _C.divider),

            // ✅ Messages
            Expanded(
              child: ListView.builder(
                controller: _listCtrl,
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
                itemCount: _messages.length,
                itemBuilder: (context, i) {
                  final m = _messages[i];

                  if (m.kind == _MsgKind.image) {
                    return _ImageBubble(
                      isMe: m.who == _Who.me,
                      time: m.time,
                      // ✅ show actual selected image if path exists
                      path: m.path,
                    );
                  }

                  // file message uses text bubble (keeps same UI)
                  return _TextBubble(
                    isMe: m.who == _Who.me,
                    text: m.text ?? "",
                    time: m.time,
                  );
                },
              ),
            ),

            // ✅ Input bar
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: _C.divider, width: 1)),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: _openAttachments,
                        borderRadius: BorderRadius.circular(10),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Icon(Icons.add, size: 22, color: _C.green),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: _C.inputBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: TextField(
                            controller: _msgCtrl,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) => _send(),
                            decoration: const InputDecoration(
                              hintText: "Write a massage",
                              hintStyle: TextStyle(
                                color: _C.subText,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                              border: InputBorder.none,
                              isCollapsed: true,
                            ),
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: _C.text,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: Material(
                          color: _C.green,
                          shape: const CircleBorder(),
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: _send,
                            child: const Icon(
                              Icons.arrow_forward_rounded,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceMetaBar extends StatelessWidget {
  const _ServiceMetaBar({
    required this.title,
    required this.timeLine,
    required this.onService,
    required this.onShare,
  });

  final String title;
  final String timeLine;
  final VoidCallback onService;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: _C.divider,
            width: 1,
          ), // ✅ one bottom line only
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: _C.subText,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            timeLine,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              color: _C.green,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start, // or center
              children: [
                SizedBox(
                  width: 140,
                  height: 36,
                  child: _ActionChip(
                    icon: Icons.home_outlined,
                    label: "Service",
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 140,
                  height: 36,
                  child: _ActionChip(
                    icon: Icons.ios_share_rounded,
                    label: "View profile",
                    onTap: onShare,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: Material(
        color: _C.chipBg,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: _C.subTextDark),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: _C.text,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ===========================================================================
/// Attachment bottom sheet (same UI, now clickable)
/// ===========================================================================

class _AttachmentSheet extends StatelessWidget {
  const _AttachmentSheet({
    required this.onCamera,
    required this.onPhotos,
    required this.onFiles,
  });

  final VoidCallback onCamera;
  final VoidCallback onPhotos;
  final VoidCallback onFiles;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        color: Colors.white,
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(18, 10, 18, 12 + bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, color: _C.green),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDEDED),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _AttachItem(
                        icon: Icons.photo_camera_outlined,
                        label: "Camera",
                        onTap: onCamera,
                      ),
                      _AttachItem(
                        icon: Icons.photo_outlined,
                        label: "Photos",
                        onTap: onPhotos,
                      ),
                      _AttachItem(
                        icon: Icons.insert_drive_file_outlined,
                        label: "Files",
                        onTap: onFiles,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AttachItem extends StatelessWidget {
  const _AttachItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // ✅ UI unchanged (same Column), just clickable
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22, color: _C.text),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _C.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ===========================================================================
/// Chips + Bubbles
/// ===========================================================================

class _ChipBtn extends StatelessWidget {
  const _ChipBtn({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      width: 20,
      child: Material(
        color: _C.chipBg,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: _C.subTextDark),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: _C.text,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TextBubble extends StatelessWidget {
  const _TextBubble({
    required this.isMe,
    required this.text,
    required this.time,
  });

  final bool isMe;
  final String text;
  final String time;

  @override
  Widget build(BuildContext context) {
    // ✅ TOP align (upper)
    final align = isMe ? Alignment.topRight : Alignment.topLeft;
    final cross = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    final radius = BorderRadius.only(
      topLeft: const Radius.circular(18),
      topRight: const Radius.circular(18),
      bottomLeft: Radius.circular(isMe ? 18 : 6),
      bottomRight: Radius.circular(isMe ? 6 : 18),
    );

    return Align(
      alignment: align,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start, // ✅ keep upper
        crossAxisAlignment: cross,
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 260),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: _C.bubbleBg,
              borderRadius: radius,
            ),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _C.text,
                height: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            time,
            textAlign: isMe ? TextAlign.right : TextAlign.left,
            style: const TextStyle(fontSize: 10, color: _C.subText),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class _ImageBubble extends StatelessWidget {
  const _ImageBubble({required this.isMe, required this.time, this.path});

  final bool isMe;
  final String time;

  // ✅ picked image local path
  final String? path;

  @override
  Widget build(BuildContext context) {
    final file = (path != null && path!.isNotEmpty) ? File(path!) : null;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 220,
              height: 140,
              color: const Color(0xFFEDEDED),
              alignment: Alignment.center,
              child: (file != null && file.existsSync())
                  ? Image.file(file, width: 220, height: 140, fit: BoxFit.cover)
                  : const Icon(
                      Icons.image_outlined,
                      size: 40,
                      color: Color(0xFF9A9A9A),
                    ),
            ),
          ),
          const SizedBox(height: 4),
          Text(time, style: const TextStyle(fontSize: 10, color: _C.subText)),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

/// ===========================================================================
/// Simple internal message model
/// ===========================================================================

enum _Who { me, other }

enum _MsgKind { text, image }

class _Msg {
  final _Who who;
  final _MsgKind kind;
  final String? text;
  final String time;

  // ✅ for image/file path (no UI change needed)
  final String? path;

  const _Msg._({
    required this.who,
    required this.kind,
    this.text,
    required this.time,
    this.path,
  });

  factory _Msg.text({
    required _Who who,
    required String text,
    required String time,
  }) => _Msg._(who: who, kind: _MsgKind.text, text: text, time: time);

  factory _Msg.image({required _Who who, required String time, String? path}) =>
      _Msg._(who: who, kind: _MsgKind.image, time: time, path: path);

  factory _Msg.file({
    required _Who who,
    required String time,
    required String fileName,
    required String path,
  }) => _Msg._(
    who: who,
    kind: _MsgKind.text,
    time: time,
    text: fileName, // shows file name in normal bubble
    path: path,
  );
}

/// ===========================================================================
/// Colors
/// ===========================================================================

class _C {
  static const green = Color(0xFF27AE60);

  static const text = Color(0xFF111111);
  static const subText = Color(0xFF8A8A8A);
  static const subTextDark = Color(0xFF6F6F6F);

  static const divider = Color(0xFFEDEDED);

  static const chipBg = Color(0xFFEFEFEF);
  static const bubbleBg = Color(0xFFEDEDED);
  static const inputBg = Color(0xFFF0F0F0);
}
