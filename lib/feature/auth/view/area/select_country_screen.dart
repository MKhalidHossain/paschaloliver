import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/csc_data.dart';
import 'choose_city_screen.dart';

class SelectCountryScreen extends StatefulWidget {
  const SelectCountryScreen({super.key});

  @override
  State<SelectCountryScreen> createState() => _SelectCountryScreenState();
}

class _SelectCountryScreenState extends State<SelectCountryScreen> {
  Color get _brandGreen => const Color(0xFF27AE60);

  final _searchCtrl = TextEditingController();
  List<CSCountry> _all = [];
  List<CSCountry> _filtered = [];
  CSCountry? _selected;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final list = await CSCData.loadCountries();
    if (!mounted) return;
    setState(() {
      _all = list;
      _filtered = list;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    final q = query.trim().toLowerCase();
    setState(() {
      _filtered = _all.where((c) => c.name.toLowerCase().contains(q)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        valueColor: AlwaysStoppedAnimation<Color>(_brandGreen),
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

            // TITLE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select country',
                    style: GoogleFonts.urbanist(
                      fontSize: 24,
                      fontWeight: FontWeight.w600, // SemiBold
                      height: 1.1, // 110%
                      letterSpacing: 0,
                      color: const Color(0xFF3FA96B),
                    ),
                  ),

                  const SizedBox(height: 6),
                  Text(
                    'In which country do you want to offer your services?',
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.1, // 110%
                      letterSpacing: 0,
                      color: const Color(0xFF000000),
                    ),
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
                  hintText: 'Search country',
                  hintStyle: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade500,
                  ),
                  prefixIcon: const Icon(Icons.search, size: 20),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
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

            // LIST
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.separated(
                      itemCount: _filtered.length,
                      separatorBuilder: (_, __) =>
                          Divider(height: 1, color: Colors.grey.shade200),
                      itemBuilder: (context, index) {
                        final country = _filtered[index];
                        final isSelected = _selected?.id == country.id;

                        return InkWell(
                          onTap: () {
                            setState(() => _selected = country);

                            // Go to state screen
                            Get.to(
                              () => const SelectStateScreen(),
                              arguments: country,
                            );
                          },
                          child: Container(
                            color: isSelected
                                ? const Color(0xFFF2FFF7)
                                : Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 14,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  country.emoji,
                                  style: const TextStyle(fontSize: 22),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    country.name,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  Icon(
                                    Icons.check_circle,
                                    size: 18,
                                    color: _brandGreen,
                                  ),
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
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 12,
              ),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(
                      text: "Haven't we reached your area yet?\n",
                      style: GoogleFonts.urbanist(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        height: 1.1,
                        letterSpacing: 0,
                        color: const Color(0xFF181919),
                      ),
                    ),
                    TextSpan(
                      text: 'Request an opening in your area',
                      style: GoogleFonts.urbanist(
                        fontSize: 14,
                        fontWeight: FontWeight.w500, // Medium
                        height: 1.1,
                        letterSpacing: 0,
                        color: const Color(0xFF3FA96B),
                        decoration: TextDecoration.underline,
                        decorationStyle: TextDecorationStyle.solid,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = () {},
                    ),

                    TextSpan(
                      text:
                          ' and we will do our best to reach you as soon as possible.',
                      style: GoogleFonts.urbanist(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.1,
                        letterSpacing: 0,
                        color: const Color(0xFF181919), // or Colors.black
                      ),
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
