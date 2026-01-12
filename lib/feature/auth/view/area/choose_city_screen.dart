import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paschaloliver/feature/auth/view/area/work_area_screen.dart';

import '../../data/csc_data.dart';


class SelectStateScreen extends StatefulWidget {
  const SelectStateScreen({super.key});

  @override
  State<SelectStateScreen> createState() => _SelectStateScreenState();
}

class _SelectStateScreenState extends State<SelectStateScreen> {
  Color get _brandGreen => const Color(0xFF27AE60);

  final _searchCtrl = TextEditingController();
  late final CSCountry _country;

  late List<CSState> _all;
  late List<CSState> _filtered;
  CSState? _selected;

  @override
  void initState() {
    super.initState();
    _country = Get.arguments as CSCountry;
    _all = _country.states;
    _filtered = _all;
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    final q = query.trim().toLowerCase();
    setState(() {
      _filtered = _all.where((s) => s.name.toLowerCase().contains(q)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final titleCountry = _country.name;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // TOP BAR + PROGRESS
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                        onPressed: () => Get.back(),
                      ),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: LinearProgressIndicator(
                      value: 0.5, // step 2
                      minHeight: 10,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation<Color>(_brandGreen),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // TITLE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select state',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: _brandGreen),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'In which state do you want to offer your services?\nIn $titleCountry',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // SEARCH
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: TextField(
                controller: _searchCtrl,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Search state',
                  hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                  prefixIcon: const Icon(Icons.search, size: 20),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            const Divider(height: 1),

            // STATE LIST
            Expanded(
              child: ListView.separated(
                itemCount: _filtered.length,
                separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey.shade200),
                itemBuilder: (context, index) {
                  final state = _filtered[index];
                  final isSelected = _selected?.id == state.id;

                  return InkWell(
                    onTap: () {
                      setState(() => _selected = state);

                      // Optional next step: go to city list (same style)
                      Get.to(() => const WorkAreaScreen(), arguments: {
                        'country': _country,
                        'state': state,
                      });
                    },
                    child: Container(
                      color: isSelected ? const Color(0xFFF2FFF7) : Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              state.name,
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                          ),
                          if (isSelected)
                            Icon(Icons.check_circle, size: 18, color: _brandGreen),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const Divider(height: 1),

            // BOTTOM INFO
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 12, color: Colors.black87, height: 1.5),
                  children: [
                    const TextSpan(
                      text: "Haven't we reached your area yet?\n",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    TextSpan(
                      text: 'Request an opening in your area',
                      style: TextStyle(
                        color: _brandGreen,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w600,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = () {},
                    ),
                    const TextSpan(
                      text: ' and we will do our best to reach you as soon as possible.',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
