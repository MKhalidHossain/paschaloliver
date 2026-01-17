import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

import '../work/work_schedule_screen.dart';

class WorkAreaScreen extends StatefulWidget {
  const WorkAreaScreen({super.key});

  @override
  State<WorkAreaScreen> createState() => _WorkAreaScreenState();
}

enum _WorkAreaViewMode { map, list }

class _WorkAreaScreenState extends State<WorkAreaScreen> {
  Color get _brandGreen => const Color(0xFF27AE60);

  _WorkAreaViewMode _viewMode = _WorkAreaViewMode.map;

  // sample work areas
  final List<WorkArea> _areas = const [
    WorkArea(id: 'ajeromi', name: 'Ajeromi-Ifelodun'),
    WorkArea(id: 'alimosho', name: 'Alimosho'),
    WorkArea(id: 'kosofe', name: 'Kosofe'),
    WorkArea(id: 'mushin', name: 'Mushin'),
    WorkArea(id: 'oshodi', name: 'Oshodi-Isolo'),
    WorkArea(id: 'ojo', name: 'Ojo'),
    WorkArea(id: 'ikorodu', name: 'Ikorodu'),
    WorkArea(id: 'surulere', name: 'Surulere'),
  ];

  final Set<String> _selectedIds = {};
  bool _hasChanges = false;

  bool get _hasSelection => _selectedIds.isNotEmpty;

  // ---------------- MAP STATE ----------------
  GoogleMapController? _mapCtrl;
  CameraPosition _initialCamera = const CameraPosition(
    target: LatLng(6.5244, 3.3792), // default Lagos
    zoom: 10.5,
  );

  bool _mapLoading = true;

  /// IMPORTANT: you must provide center points for each WorkArea id
  /// Replace these with correct lat/lng for your areas.
  final Map<String, LatLng> _areaCenters = const {
    'ajeromi': LatLng(6.4550, 3.3190),
    'alimosho': LatLng(6.6040, 3.2580),
    'kosofe': LatLng(6.5970, 3.3870),
    'mushin': LatLng(6.5350, 3.3480),
    'oshodi': LatLng(6.5560, 3.3450),
    'ojo': LatLng(6.4620, 3.1660),
    'ikorodu': LatLng(6.6194, 3.5105),
    'surulere': LatLng(6.4967, 3.3566),
  };

  @override
  void initState() {
    super.initState();
    _tryCenterFromPreviousCity();
  }

  /// Optional: if you pass {country,state,city} from previous screen, it will auto-center map
  Future<void> _tryCenterFromPreviousCity() async {
    try {
      // If previous screen sends: Get.to(() => WorkAreaScreen(), arguments: {'city': 'Abuja', ...})
      final args = Get.arguments;
      final city = (args is Map && args['city'] != null)
          ? "${args['city']}"
          : null;
      final country = (args is Map && args['country'] != null)
          ? "${args['country']}"
          : null;

      if (city == null) {
        setState(() => _mapLoading = false);
        return;
      }

      // Geocode "City, Country" if possible
      final query = country == null ? city : "$city, $country";
      final results = await locationFromAddress(query);

      if (results.isNotEmpty) {
        final loc = results.first;
        _initialCamera = CameraPosition(
          target: LatLng(loc.latitude, loc.longitude),
          zoom: 11.0,
        );
      }
    } catch (_) {
      // ignore geocoding errors, fallback to default camera
    } finally {
      if (mounted) setState(() => _mapLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
              _buildTitle(),
              const SizedBox(height: 12),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: _viewMode == _WorkAreaViewMode.map
                      ? _buildMapView()
                      : _buildListView(),
                ),
              ),
              _buildViewToggle(),
              const SizedBox(height: 12),
              _buildContinueButton(),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- TOP BAR + PROGRESS ----------------

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                onPressed: _handleBackPressed,
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: 0.6,
              minHeight: 10,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(_brandGreen),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- TITLE ----------------

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Work areas',
            style: GoogleFonts.urbanist(
              fontSize: 24,
              fontWeight: FontWeight.w600, // SemiBold
              height: 1.1,
              letterSpacing: 0,
              color: const Color(0xFF3FA96B),
            ),
          ),

          const SizedBox(height: 6),
          Text(
            'Select the areas you can travel to in order to offer your '
            'services. Remember that you cannot charge an extra fee for travel.',
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

  // ---------------- MAP VIEW (REAL GOOGLE MAP) ----------------

  Widget _buildMapView() {
    if (_mapLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final markers = _buildMarkers();

    return Stack(
      children: [
        Positioned.fill(
          child: GoogleMap(
            initialCameraPosition: _initialCamera,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            onMapCreated: (c) => _mapCtrl = c,
            markers: markers,
          ),
        ),

        // Small helper card (optional)
        Positioned(
          left: 16,
          right: 16,
          top: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.06),
                  blurRadius: 14,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 18, color: Colors.grey.shade700),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Tap markers to select/unselect work areas',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
                Text(
                  '${_selectedIds.length} selected',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: _brandGreen,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Recenter button
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton(
            heroTag: "recenter",
            backgroundColor: Colors.white,
            elevation: 2,
            onPressed: () {
              _mapCtrl?.animateCamera(
                CameraUpdate.newCameraPosition(_initialCamera),
              );
            },
            child: Icon(Icons.my_location, color: Colors.grey.shade800),
          ),
        ),
      ],
    );
  }

  Set<Marker> _buildMarkers() {
    return _areas.map((area) {
      final pos = _areaCenters[area.id] ?? _initialCamera.target;
      final selected = _selectedIds.contains(area.id);

      return Marker(
        markerId: MarkerId(area.id),
        position: pos,
        infoWindow: InfoWindow(title: area.name),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          selected ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueRed,
        ),
        onTap: () => _toggleArea(area.id, moveCamera: true),
      );
    }).toSet();
  }

  // ---------------- LIST VIEW ----------------

  Widget _buildListView() {
    return Column(
      children: [
        const Divider(height: 1),
        Expanded(
          child: ListView.separated(
            itemCount: _areas.length,
            separatorBuilder: (_, __) =>
                Divider(height: 1, color: Colors.grey.shade200),
            itemBuilder: (context, index) {
              final area = _areas[index];
              final isSelected = _selectedIds.contains(area.id);

              return InkWell(
                onTap: () => _toggleArea(area.id, moveCamera: false),
                child: Container(
                  color: isSelected ? const Color(0xFFF2FFF7) : Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      _buildCheckBox(isSelected),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          area.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCheckBox(bool isSelected) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isSelected ? _brandGreen : Colors.grey.shade400,
          width: 1.5,
        ),
        color: isSelected ? _brandGreen : Colors.white,
      ),
      child: isSelected
          ? const Icon(Icons.check, size: 16, color: Colors.white)
          : null,
    );
  }

  void _toggleArea(String id, {required bool moveCamera}) {
    setState(() {
      _hasChanges = true;
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });

    // If user tapped marker/list, optionally move camera to that area
    if (moveCamera) {
      final pos = _areaCenters[id];
      if (pos != null) {
        _mapCtrl?.animateCamera(CameraUpdate.newLatLngZoom(pos, 12.5));
      }
    }
  }

  // ---------------- VIEW TOGGLE (MAP / LIST) ----------------

  Widget _buildViewToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 120.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            Expanded(
              child: _buildToggleButton(
                label: 'Map',
                isActive: _viewMode == _WorkAreaViewMode.map,
                onTap: () => setState(() => _viewMode = _WorkAreaViewMode.map),
              ),
            ),
            Expanded(
              child: _buildToggleButton(
                label: 'List',
                isActive: _viewMode == _WorkAreaViewMode.list,
                onTap: () => setState(() => _viewMode = _WorkAreaViewMode.list),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.green : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.black87 : Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- CONTINUE BUTTON + FEW AREAS SHEET ----------------

  Widget _buildContinueButton() {
    final enabled = _hasSelection;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: enabled ? _brandGreen : Colors.grey.shade300,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: enabled ? _handleContinue : null,
          child: Text(
            'Continue',
            style: GoogleFonts.urbanist(
              fontSize: 16,
              fontWeight: FontWeight.w500, // Medium
              height: 1.1,
              letterSpacing: 0,
              color: const Color(0xFFFFFFFF),
            ),
          ),
        ),
      ),
    );
  }

  void _handleContinue() {
    if (_selectedIds.isEmpty) return;

    if (_selectedIds.length == 1) {
      _showFewAreasSheet();
    } else {
      _goToSchedule();
    }
  }

  void _goToSchedule() {
    _hasChanges = false;
    Get.to(() => const WorkScheduleScreen(), arguments: _selectedIds.toList());
  }

  void _showFewAreasSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
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
                      'Few selected areas',
                      style: GoogleFonts.urbanist(
                        fontSize: 24,
                        fontWeight: FontWeight.w600, // SemiBold
                        height: 1.1,
                        letterSpacing: 0,
                        color: const Color(0xFF3FA96B),
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, size: 18),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'You have selected very few available work areas. '
                'Remember that your profile will only be visible to clients '
                'searching in the areas you have marked as available.',
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.1,
                  letterSpacing: 0,
                  color: const Color(0xFF000000),
                ),
              ),

              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _brandGreen,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _goToSchedule();
                  },
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  // ---------------- LEAVE WITHOUT SAVING ----------------

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
                      onPressed: () => Navigator.pop<bool>(context, true),
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
                      onPressed: () => Navigator.pop<bool>(context, false),
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

// ---------------- MODEL ----------------
class WorkArea {
  final String id;
  final String name;

  const WorkArea({required this.id, required this.name});
}
