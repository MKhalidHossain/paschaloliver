import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// ✅ SEARCH PAGE (UI like your screenshot)
/// - Rounded grey search field
/// - Close circle button on the right
/// - Simple results list
class HandySearchController extends GetxController {
  final searchCtrl = TextEditingController();
  final results = <String>[].obs;

  final _all = <String>[
    "Handym",
    "Handyman service",
  ];

  @override
  void onInit() {
    super.onInit();
    results.assignAll(_all);
    searchCtrl.addListener(() {
      final q = searchCtrl.text.trim().toLowerCase();
      if (q.isEmpty) {
        results.assignAll(_all);
      } else {
        results.assignAll(_all.where((e) => e.toLowerCase().contains(q)).toList());
      }
    });
  }

  void clearAndClose() {
    searchCtrl.clear();
    Get.back();
  }

  @override
  void onClose() {
    searchCtrl.dispose();
    super.onClose();
  }
}

class HandySearchPage extends StatelessWidget {
  const HandySearchPage({super.key});

  static const _bg = Colors.white;
  static const _field = Color(0xFFEAEAEA);
  static const _text = Color(0xFF1F1F1F);
  static const _muted = Color(0xFF9A9A9A);

  @override
  Widget build(BuildContext context) {
    final c = Get.put(HandySearchController());

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: search field + close circle
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: _field,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search_rounded, size: 20, color: _muted),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: c.searchCtrl,
                              autofocus: true,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: _text,
                              ),
                              decoration: const InputDecoration(
                                hintText: "Handy",
                                hintStyle: TextStyle(
                                  color: _muted,
                                  fontWeight: FontWeight.w700,
                                ),
                                border: InputBorder.none,
                                isCollapsed: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  InkWell(
                    onTap: c.clearAndClose,
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _field,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Icon(Icons.close_rounded, size: 18, color: _muted),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // Results
              Expanded(
                child: Obx(() {
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: c.results.length,
                    itemBuilder: (_, i) {
                      final item = c.results[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 18),
                        child: InkWell(
                          onTap: () => Get.back(result: item),
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                              color: _text,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
