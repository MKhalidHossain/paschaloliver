import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/assets.dart';
import 'chat_screen.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  void _openSecureSheet(BuildContext context, _ChatItem chat) {
    showModalBottomSheet(
      context: context,
      useSafeArea: false,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(.45),
      isScrollControlled: true,
      builder: (sheetContext) {
        return _SecureInfoSheet(
          icon: Images.hundredIcon,
          onClose: () => Navigator.pop(sheetContext),
          onGotIt: () async {
            Navigator.pop(sheetContext);
            await Future.delayed(const Duration(milliseconds: 10));
            if (!context.mounted) return;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatDetailsScreen(
                  name: chat.name,
                  jobTitle: chat.jobTitle,
                  avatarUrl: chat.avatarUrl,
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),

              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  "Inbox",
                  style: GoogleFonts.urbanist(
                    fontSize: 24,
                    fontWeight: FontWeight.w600, // SemiBold
                    height: 1.1,
                    color: const Color(0xFF3FA96B),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Tabs
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: _Tabs(),
              ),
              const SizedBox(height: 8),
              const Divider(height: 1, thickness: 1, color: _C.divider),

              Expanded(
                child: TabBarView(
                  children: [
                    // Chat list
                    _ChatList(
                      items: _demoChats,
                      onTapChat: (chat) => _openSecureSheet(context, chat),
                    ),

                    // Alerts list
                    _AlertsList(items: _demoAlerts),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// -------------------------
/// Tabs
/// -------------------------

class _Tabs extends StatelessWidget {
  const _Tabs();

  @override
  Widget build(BuildContext context) {
    return TabBar(
      labelColor: const Color(0xFF727272),
      unselectedLabelColor: const Color(0xFF727272), // change if Figma shows different
      labelStyle: GoogleFonts.urbanist(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        height: 1.2,
      ),
      unselectedLabelStyle: GoogleFonts.urbanist(
        fontSize: 16,
        fontWeight: FontWeight.w700, // set w500 if your unselected is lighter
        height: 1.2,
      ),
      indicatorColor: _C.line,
      indicatorWeight: 2,
      indicatorSize: TabBarIndicatorSize.tab,
      dividerColor: Colors.transparent,
      tabs: const [
        Tab(text: "Chat"),
        Tab(text: "Alerts"),
      ],
    );
  }
}

/// ===========================================================================
/// CHAT TAB
/// ===========================================================================
class _ChatList extends StatelessWidget {
  const _ChatList({
    required this.items,
    required this.onTapChat,
    this.emptyText,
  });

  final List<_ChatItem> items;
  final ValueChanged<_ChatItem> onTapChat;
  final String? emptyText;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Text(
          emptyText ?? "No chats yet.",
          style: const TextStyle(color: _C.subText, fontWeight: FontWeight.w600),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(height: 1, thickness: 1, color: _C.divider),
      itemBuilder: (context, i) {
        return _ChatRow(
          item: items[i],
          onTap: () => onTapChat(items[i]),
        );
      },
    );
  }
}

class _ChatRow extends StatelessWidget {
  const _ChatRow({
    required this.item,
    required this.onTap,
  });

  final _ChatItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: const Color(0xFFDADADA),
                backgroundImage: item.avatarUrl == null ? null : NetworkImage(item.avatarUrl!),
                child: item.avatarUrl == null
                    ? const Icon(Icons.person, size: 18, color: Color(0xFF666666))
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.urbanist(
                              fontSize: 14,              // change if your Figma text size differs
                              fontWeight: FontWeight.w500,
                              height: 1.1,
                              color: _C.text,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          item.timeLabel,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _C.subText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.jobTitle,
                      style: const TextStyle(
                        fontSize: 11.2,
                        fontWeight: FontWeight.w600,
                        color: _C.subText,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w400, // Regular
                        height: 1.2,
                        color: const Color(0xFF181919),
                      ),
                    ),
                  ],
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
/// SECURE SHEET (fills bottom safe area ✅)
/// ===========================================================================
class _SecureInfoSheet extends StatelessWidget {
  const _SecureInfoSheet({
    required this.icon,
    required this.onGotIt,
    required this.onClose,
  });

  final dynamic icon; // String asset path OR Widget
  final VoidCallback onGotIt;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final maxH = screenH * 0.82;

    // ✅ IMPORTANT: White background OUTSIDE the rounded clip, so bottom safe-area is white too.
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        color: Colors.white,
        child: SafeArea(
          top: false,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxH),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    // handle
                    Container(
                      width: 46,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDADADA),
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),

                    // close icon (top-right)
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: const Icon(Icons.close, size: 18, color: _C.subText),
                        onPressed: onClose,
                      ),
                    ),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        child: Column(
                          children: [
                            const Spacer(),

                            _HundredIconWidget(icon: icon),

                            const SizedBox(height: 18),

                            const Text(
                              "Helps us to protect you",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: _C.green,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 10),

                            const Text(
                              "Book and communicate with User always\nthough handynaija.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: _C.text,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                height: 1.35,
                              ),
                            ),
                            const SizedBox(height: 14),

                            const Text(
                              "This way you will be protected against scams and our\nsatisfaction guarantee.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: _C.subText,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w500,
                                height: 1.35,
                              ),
                            ),

                            const Spacer(),
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 0, 18, 14),
                      child: SizedBox(
                        width: double.infinity,
                        height: 46,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _C.greenSoft,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: onGotIt,
                          child: const Text(
                            "Got it",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HundredIconWidget extends StatelessWidget {
  const _HundredIconWidget({required this.icon});
  final dynamic icon;

  @override
  Widget build(BuildContext context) {
    if (icon is String) {
      return Image.asset(
        icon as String,
        width: 150,
        height: 150,
        fit: BoxFit.contain,
      );
    }
    if (icon is Widget) {
      return SizedBox(width: 150, height: 150, child: Center(child: icon as Widget));
    }
    return const Icon(Icons.verified_user, size: 120, color: _C.green);
  }
}

/// ===========================================================================
/// ALERTS TAB
/// ===========================================================================
class _AlertsList extends StatelessWidget {
  const _AlertsList({required this.items});
  final List<_AlertItem> items;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(height: 1, thickness: 1, color: _C.divider),
      itemBuilder: (context, i) => _AlertRow(item: items[i]),
    );
  }
}

class _AlertRow extends StatelessWidget {
  const _AlertRow({required this.item});
  final _AlertItem item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _AlertIcon(type: item.type),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: _C.text,
                            height: 1.15,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        item.timeLabel,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _C.subText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.subtitle,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: _C.subTextDark,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            const Padding(
              padding: EdgeInsets.only(top: 18),
              child: Icon(Icons.chevron_right, size: 22, color: _C.text),
            ),
          ],
        ),
      ),
    );
  }
}

class _AlertIcon extends StatelessWidget {
  const _AlertIcon({required this.type});
  final AlertType type;

  @override
  Widget build(BuildContext context) {
    final icon = type == AlertType.review ? Icons.emoji_events_outlined : Icons.calendar_month_outlined;

    return SizedBox(
      width: 44,
      height: 44,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Icon(icon, size: 34, color: _C.green),
          ),
          Positioned(
            right: 0,
            bottom: 4,
            child: Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(color: _C.green, shape: BoxShape.circle),
              child: const Icon(Icons.check, size: 12, color: Colors.white),
            ),
          ),
          if (type == AlertType.review)
            const Positioned(left: 0, top: -2, child: _StarsRow()),
        ],
      ),
    );
  }
}

class _StarsRow extends StatelessWidget {
  const _StarsRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star, size: 10, color: _C.green),
        Icon(Icons.star, size: 10, color: _C.green),
        Icon(Icons.star, size: 10, color: _C.green),
        Icon(Icons.star, size: 10, color: _C.green),
        Icon(Icons.star, size: 10, color: _C.green),
      ],
    );
  }
}

/// ===========================================================================
/// Models + Demo data
/// ===========================================================================
class _ChatItem {
  final String name;
  final String jobTitle;
  final String lastMessage;
  final String timeLabel;
  final String? avatarUrl;

  const _ChatItem({
    required this.name,
    required this.jobTitle,
    required this.lastMessage,
    required this.timeLabel,
    this.avatarUrl,
  });
}

enum AlertType { review, calendar }

class _AlertItem {
  final AlertType type;
  final String title;
  final String subtitle;
  final String timeLabel;
  final VoidCallback? onTap;

  const _AlertItem({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.timeLabel,
    this.onTap,
  });
}

const _demoChats = <_ChatItem>[
  _ChatItem(
    name: "YERXON",
    jobTitle: "Cleaning",
    lastMessage: "Cleaning de ester misomo precio se podtuk...",
    timeLabel: "Thursday",
  ),
  _ChatItem(
    name: "YERXON",
    jobTitle: "Handyman",
    lastMessage: "Cleaning de ester misomo precio se podtuk...",
    timeLabel: "15/6/25",
  ),
  _ChatItem(
    name: "YERXON",
    jobTitle: "Cleaning",
    lastMessage: "Cleaning de ester misomo precio se podtuk...",
    timeLabel: "14/5/25",
  ),
  _ChatItem(
    name: "YERXON",
    jobTitle: "Cleaning",
    lastMessage: "Cleaning de ester misomo precio se podtuk...",
    timeLabel: "25/4/24",
  ),
];

final _demoAlerts = <_AlertItem>[
  _AlertItem(
    type: AlertType.review,
    title: "YERXON has left you a review",
    timeLabel: "Thursday",
    subtitle: "YERXON has left you a review. Check it out\non your profile.",
  ),
  _AlertItem(
    type: AlertType.review,
    title: "Rate your service with\nYERXON",
    timeLabel: "Thursday",
    subtitle: "Let us know how your Cleaning service\nwith YERXON went. Your feedback is very\nimportant for other customers!",
  ),
  _AlertItem(
    type: AlertType.calendar,
    title: "Your service is about to\nbegin",
    timeLabel: "Thursday",
    subtitle: "Just a reminder: in 2 hours , you have\nyour Cleaning service with YERXON.\nEnjoy!",
  ),
  _AlertItem(
    type: AlertType.calendar,
    title: "Booking request\nconfirmed",
    timeLabel: "Wednesday",
    subtitle: "Congratulations! YERXON has confirmed\nyour Cleaning booking request. Enjoy\nyour service!",
  ),
];

class _C {
  static const green = Color(0xFF27AE60);
  static const greenSoft = Color(0xFF3DA86A);

  static const text = Color(0xFF111111);
  static const subText = Color(0xFF8A8A8A);
  static const subTextDark = Color(0xFF6F6F6F);

  static const divider = Color(0xFFEDEDED);
  static const line = Color(0xFF2B2B2B);
}
