import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// ------------------------------------------------------------
/// MY ADDRESSES (UI LIKE YOUR SCREENSHOT) - GetX
/// - Top bar: back, title, +
/// - List of addresses (2 rows)
/// - Each row: left green icon in grey square, address text, 3-dots menu
/// - 3-dots menu: "Edit" + "Delete address" (popup)
///
/// Usage:
/// Get.to(() => const MyAddressesScreen());
/// ------------------------------------------------------------

class MyAddressesScreen extends StatelessWidget {
  const MyAddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(MyAddressesController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(
              title: "My Addresses",
              onBack: () => Get.back(),
              onAdd: () {
                // TODO: open add address flow
                // Get.to(() => const AddAddressScreen());
              },
            ),
            const Divider(height: 1, thickness: 1, color: _C.line),

            Expanded(
              child: Obx(() {
                return ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: c.addresses.length,
                  separatorBuilder: (_, __) => const Divider(height: 1, thickness: 1, color: _C.line),
                  itemBuilder: (_, i) {
                    final item = c.addresses[i];
                    return _AddressRow(
                      text: item,
                      onEdit: () {
                        // TODO: edit address
                        // Get.to(() => EditAddressScreen(initial: item));
                        Get.snackbar("Edit", item, snackPosition: SnackPosition.BOTTOM);
                      },
                      onDelete: () {
                        c.deleteAt(i);
                        Get.snackbar("Deleted", "Address removed", snackPosition: SnackPosition.BOTTOM);
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------- CONTROLLER ----------------

class MyAddressesController extends GetxController {
  final addresses = <String>[
    "UNRWA Kifi,802149,Kaduna,Nigeria",
    "Ungwan Kifi,802149,Kaduna,Nigeria",
  ].obs;

  void deleteAt(int index) {
    if (index < 0 || index >= addresses.length) return;
    addresses.removeAt(index);
  }
}

/// ---------------- UI ----------------

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.title,
    required this.onBack,
    required this.onAdd,
  });

  final String title;
  final VoidCallback onBack;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            InkWell(
              onTap: onBack,
              borderRadius: BorderRadius.circular(10),
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: _C.text),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: _C.text),
              ),
            ),
            InkWell(
              onTap: onAdd,
              borderRadius: BorderRadius.circular(10),
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(Icons.add, size: 22, color: _C.green),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddressRow extends StatelessWidget {
  const _AddressRow({
    required this.text,
    required this.onEdit,
    required this.onDelete,
  });

  final String text;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          // Optional: select address
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 12, 10),
          child: Row(
            children: [
              // left icon in grey rounded square
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: _C.iconBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.person_outline_rounded, size: 18, color: _C.green),
              ),
              const SizedBox(width: 12),

              // text
              Expanded(
                child: Text(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12.2, fontWeight: FontWeight.w600, color: _C.text),
                ),
              ),

              // 3-dots menu (Edit / Delete address)
              Theme(
                data: Theme.of(context).copyWith(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: PopupMenuButton<_MenuAction>(
                  padding: EdgeInsets.zero,
                  elevation: 8,
                  offset: const Offset(0, 36),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  color: Colors.white,
                  onSelected: (v) {
                    if (v == _MenuAction.edit) onEdit();
                    if (v == _MenuAction.delete) onDelete();
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: _MenuAction.edit,
                      height: 34,
                      child: Text("Edit", style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
                    ),
                    const PopupMenuItem(
                      value: _MenuAction.delete,
                      height: 34,
                      child: Text("Delete address", style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
                    ),
                  ],
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.more_horiz_rounded, size: 22, color: _C.text),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _MenuAction { edit, delete }

class _C {
  static const green = Color(0xFF27AE60);
  static const text = Color(0xFF111111);
  static const line = Color(0xFFEDEDED);
  static const iconBg = Color(0xFFEFEFEF);
}
