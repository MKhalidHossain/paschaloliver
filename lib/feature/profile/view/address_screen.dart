import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/assets.dart';

/// ✅ My Addresses screen (UI like your screenshot)
class MyAddressesLikeScreen extends StatelessWidget {
  const MyAddressesLikeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(MyAddressesLikeController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: _A.text,
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
        ),
        title: Text(
          "My Addresses",
          style: GoogleFonts.urbanist(
            fontSize: 16,
            fontWeight: FontWeight.w700, // Bold
            height: 1.1, // 110%
            letterSpacing: 0,
            color: const Color(0xFF000000),
          ),
        ),

        actions: [
          IconButton(
            onPressed: () {
              // TODO: navigate to add address/map screen
              // Get.to(() => const ServiceAddressMapScreen());
            },
            icon: const Icon(Icons.add, color: _A.green),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Obx(() {
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          itemCount: c.items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, i) {
            final item = c.items[i];
            return _AddressTile(
              title: item.title,
              onMore: () => _showMoreSheet(context, item),
              onTap: () {
                // TODO: select address / open details
              },
            );
          },
        );
      }),
    );
  }

  void _showMoreSheet(BuildContext context, AddressItem item) {
    Get.bottomSheet(
      _MoreSheet(
        onEdit: () => Get.back(),
        onDelete: () => Get.back(),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }
}

class MyAddressesLikeController extends GetxController {
  final items = <AddressItem>[
    AddressItem(title: "UNRWA Kifi,802149,Kaduna,Nigeria"),
    AddressItem(title: "Ungwan Kifi,802149,Kaduna,Nigeria"),
  ].obs;
}

class AddressItem {
  final String title;
  AddressItem({required this.title});
}

/* -------------------------------- UI -------------------------------- */

class _AddressTile extends StatelessWidget {
  const _AddressTile({
    required this.title,
    required this.onMore,
    required this.onTap,
  });

  final String title;
  final VoidCallback onMore;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _A.line),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _A.soft, // grey background
                  borderRadius: BorderRadius.circular(8),
                  // ✅ no border here (your screenshot doesn’t have it)
                ),
                child: Center(
                  child: Image.asset(
                    Images.addressLocIcon,
                    width: 22,
                    height: 22,
                    fit: BoxFit.contain,
                    color: _A.green, // ✅ green icon (remove if your png already has green)
                  ),
                ),
              ),

              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: FontWeight.w500, // Medium
                    height: 1.1, // 110%
                    letterSpacing: 0,
                    color: const Color(0xFF181919),
                  ),
                ),
              ),

              const SizedBox(width: 8),
              InkWell(
                onTap: onMore,
                borderRadius: BorderRadius.circular(999),
                child: const Padding(
                  padding: EdgeInsets.all(6),
                  child: Icon(Icons.more_horiz_rounded, size: 20, color: _A.muted),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ---------------------------- More BottomSheet ---------------------------- */

class _MoreSheet extends StatelessWidget {
  const _MoreSheet({required this.onEdit, required this.onDelete});

  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(14, 10, 14, 12 + bottom),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 12),
            _sheetItem(
              icon: Icons.edit_outlined,
              label: "Edit address",
              onTap: onEdit,
            ),
            const SizedBox(height: 8),
            _sheetItem(
              icon: Icons.delete_outline_rounded,
              label: "Delete address",
              onTap: onDelete,
              danger: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _sheetItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool danger = false,
  }) {
    final c = danger ? const Color(0xFFE53935) : _A.text;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _A.line),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: c),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(fontWeight: FontWeight.w800, color: c),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ------------------------------- Colors ------------------------------- */

class _A {
  static const Color green = Color(0xFF2FA86A);
  static const Color text = Color(0xFF1F1F1F);
  static const Color muted = Color(0xFF8B8B8B);
  static const Color line = Color(0xFFEDEDED);
  static const Color soft = Color(0xFFF6F6F6);
}
