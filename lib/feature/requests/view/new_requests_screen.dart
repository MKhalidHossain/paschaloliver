import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paschaloliver/feature/requests/view/request_details_screen.dart';
import '../models/requests_model.dart';

/// ✅ Status for card UI
enum RequestStatus { newRequest, completed, canceled }

class RequestsHistoryScreen extends StatefulWidget {
  const RequestsHistoryScreen({super.key});

  @override
  State<RequestsHistoryScreen> createState() => _RequestsHistoryScreenState();
}

class _RequestsHistoryScreenState extends State<RequestsHistoryScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int _bottomIndex = 1; // Requests selected

  final _newRequests = <RequestItem>[
    RequestItem(
      name: 'Mr. Hamid',
      price: 20,
      date: '12 July 2025',
      time: '10:00 AM - 11 AM',
      service: 'Cleaner',
      email: 'example@gmail.com',
      phone: '012562589663',
      location: '13th Street 47 W 13th St, New York, NY 10011',
      avatarUrl: null,
    ),
    RequestItem(
      name: 'Willems',
      price: 20,
      date: '12 July 2025',
      time: '10:00 AM - 11 AM',
      service: 'Cleaner',
      email: 'example@gmail.com',
      phone: '012562589663',
      location: '13th Street 47 W 13th St, New York, NY 10011',
      avatarUrl: null,
    ),
  ];

  final _completed = <RequestItem>[
    RequestItem(
      name: 'Mr. Hamid',
      price: 20,
      date: '12 July 2025',
      time: '10:00 AM - 11 AM',
      service: 'Cleaner',
      email: 'example@gmail.com',
      phone: '012562589663',
      location: '13th Street 47 W 13th St, New York, NY 10011',
      avatarUrl: null,
    ),
  ];

  final _canceled = <RequestItem>[
    RequestItem(
      name: 'Mr. Hamid',
      price: 20,
      date: '12 July 2025',
      time: '10:00 AM - 11 AM',
      service: 'Cleaner',
      email: 'example@gmail.com',
      phone: '012562589663',
      location: '13th Street 47 W 13th St, New York, NY 10011',
      avatarUrl: null,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ✅ View details navigation (4th -> 2nd screen)
  void _onViewDetails(RequestItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ViewDetails(item: item)),
    );
  }

  void _onLocation(RequestItem item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Open location: ${item.name}')),
    );
  }

  void _onCompleted(RequestItem item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Completed: ${item.name}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Text(
                "Requests History",
                style: GoogleFonts.urbanist(
                  fontSize: 24,
                  fontWeight: FontWeight.w600, // SemiBold
                  height: 1.1, // 110%
                  letterSpacing: 0,
                  color: const Color(0xFF3FA96B),
                ),
              ),

            ),
            const SizedBox(height: 14),

            // Tabs (match screenshot style)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: TabBar(
                controller: _tabController,
                labelColor: const Color(0xFF181919),
                unselectedLabelColor: _C.subtext,
                labelStyle: GoogleFonts.urbanist(
                  fontSize: 15,
                  fontWeight: FontWeight.w500, // Medium
                  height: 1.2, // 120%
                  letterSpacing: 0,
                ),
                unselectedLabelStyle: GoogleFonts.urbanist(
                  fontSize: 15,
                  fontWeight: FontWeight.w500, // Medium
                  height: 1.2, // 120%
                  letterSpacing: 0,
                ),
                indicatorColor: _C.green,
                indicatorWeight: 2.5,
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: 'New Requests'),
                  Tab(text: 'Completed'),
                  Tab(text: 'Cancelled'),
                ],
              ),
            ),


            const SizedBox(height: 8),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _RequestsList(
                    items: _newRequests,
                    status: RequestStatus.newRequest,
                    onViewDetails: _onViewDetails,
                    onLocation: _onLocation,
                    onCompleted: _onCompleted,
                  ),
                  _RequestsList(
                    items: _completed,
                    status: RequestStatus.completed,
                    emptyText: 'No completed requests yet.',
                    onViewDetails: _onViewDetails,
                    onLocation: _onLocation,
                    onCompleted: _onCompleted,
                  ),
                  _RequestsList(
                    items: _canceled,
                    status: RequestStatus.canceled,
                    emptyText: 'No canceled requests yet.',
                    onViewDetails: _onViewDetails,
                    onLocation: _onLocation,
                    onCompleted: _onCompleted,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Bottom nav
      bottomNavigationBar: _BottomNav(
        index: _bottomIndex,
        onChanged: (i) => setState(() => _bottomIndex = i),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// LIST
/// ---------------------------------------------------------------------------
class _RequestsList extends StatelessWidget {
  const _RequestsList({
    required this.items,
    required this.status,
    required this.onViewDetails,
    required this.onLocation,
    required this.onCompleted,
    this.emptyText = 'No requests found.',
  });

  final List<RequestItem> items;
  final RequestStatus status;
  final String emptyText;

  final ValueChanged<RequestItem> onViewDetails;
  final ValueChanged<RequestItem> onLocation;
  final ValueChanged<RequestItem> onCompleted;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Text(emptyText, style: const TextStyle(color: _C.subtext)),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final item = items[index];
        return RequestCard(
          item: item,
          status: status,
          onViewDetails: () => onViewDetails(item),
          onLocation: () => onLocation(item),
          onCompleted: () => onCompleted(item),
        );
      },
    );
  }
}

/// ---------------------------------------------------------------------------
/// CARD (UI fixed like screenshot)
/// ---------------------------------------------------------------------------
class RequestCard extends StatelessWidget {
  const RequestCard({
    super.key,
    required this.item,
    required this.status,
    required this.onViewDetails,
    required this.onLocation,
    required this.onCompleted,
  });

  final RequestItem item;
  final RequestStatus status;

  final VoidCallback onViewDetails;
  final VoidCallback onLocation;
  final VoidCallback onCompleted;

  @override
  Widget build(BuildContext context) {
    final isCanceled = status == RequestStatus.canceled;

    return Container(
      decoration: BoxDecoration(
        color: _C.cardFill, // white like screenshot
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _C.green.withOpacity(.55), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
        child: Column(
          children: [
            // Header row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Avatar(url: item.avatarUrl),
                const SizedBox(width: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                        color: _C.text,
                      ),
                    ),
                  ),
                ),
                if (isCanceled)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: _C.red, width: 1.3),
                          ),
                          child: const Center(
                            child: Icon(Icons.close, size: 10, color: _C.red),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Canceled',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: _C.red,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      'Price: \$${item.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: _C.text,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 10),

            // Info (same order like screenshot)
            _InfoRow(icon: Icons.calendar_today_outlined, label: 'Date:', value: item.date),
            _InfoRow(icon: Icons.access_time_rounded, label: 'Time:', value: item.time),
            _InfoRow(icon: Icons.settings_outlined, label: 'Services:', value: item.service),
            _InfoRow(icon: Icons.email_outlined, label: 'Email:', value: item.email),
            _InfoRow(icon: Icons.phone_outlined, label: 'Phone:', value: item.phone),
            _InfoRow(
              icon: Icons.location_on_outlined,
              label: 'Location:',
              value: item.location,
              maxLines: 2,
            ),

            const SizedBox(height: 12),

            // Bottom actions
            if (status == RequestStatus.newRequest)
              _PrimaryButton(
                text: 'View Details',
                onTap: onViewDetails,

              )
            else
              Row(
                children: [
                  Expanded(
                    child: _SolidButton(
                      text: 'Location',
                      icon: Icons.near_me_outlined,
                      color: _C.red,
                      onTap: onLocation,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SolidButton(
                      text: 'Completed',
                      color: _C.greenSoft,
                      onTap: onCompleted,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.text, required this.onTap});
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      width: double.infinity,
      child: Material(
        color: _C.green,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14.5,
                
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SolidButton extends StatelessWidget {
  const _SolidButton({
    required this.text,
    required this.color,
    required this.onTap,
    this.icon,
  });

  final String text;
  final Color color;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18, color: Colors.white),
                  const SizedBox(width: 6),
                ],
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5,
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

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.maxLines = 1,
  });

  final IconData icon;
  final String label;
  final String value;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: maxLines > 1 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: _C.icon),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              color: _C.text,
              fontWeight: FontWeight.w700,
              fontSize: 13,
              height: 1.2,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: _C.value,
                fontWeight: FontWeight.w500,
                fontSize: 13,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({this.url});
  final String? url;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 18,
      backgroundColor: const Color(0xFFE6E6E6),
      backgroundImage: (url == null || url!.isEmpty) ? null : NetworkImage(url!),
      child: (url == null || url!.isEmpty)
          ? const Icon(Icons.person, color: Color(0xFF777777), size: 20)
          : null,
    );
  }
}

/// ---------------------------------------------------------------------------
/// BOTTOM NAV
/// ---------------------------------------------------------------------------
class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.index, required this.onChanged});
  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: index,
      onTap: onChanged,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: _C.green,
      unselectedItemColor: _C.subtext,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), label: 'Calendar'),
        BottomNavigationBarItem(icon: Icon(Icons.list_alt_outlined), label: 'Requests'),
        BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Inbox'),
        BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'Listings'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
      ],
    );
  }
}

/// ---------------------------------------------------------------------------
/// COLORS (match screenshot)
/// ---------------------------------------------------------------------------
class _C {
  static const green = Color(0xFF27AE60);
  static const greenSoft = Color(0xFF3DA86A);
  static const red = Color(0xFFFF1F3D);

  static const bg = Color(0xFFF5F5F5); // ✅ screenshot-like background
  static const cardFill = Colors.white; // ✅ white card like screenshot

  static const text = Color(0xFF111111);
  static const icon = Color(0xFF111111);
  static const value = Color(0xFF6E6E6E);
  static const subtext = Color(0xFF6E6E6E);
}
