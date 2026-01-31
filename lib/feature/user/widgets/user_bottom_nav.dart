import 'package:flutter/material.dart';
import 'package:paschaloliver/core/constants/assets.dart';

class UserBottomNav extends StatelessWidget {
  const UserBottomNav({super.key, required this.index, required this.onTap});

  final int index;
  final ValueChanged<int> onTap;

  static const _green = Color(0xFF2FA86A);
  static const _grey = Color(0xFF1F1F1F);
  static const _line = Color(0xFFEDEDED);
  static const _red = Color(0xFFE53935);

  Color _labelColor(bool selected) => selected ? _green : _grey;

  Color _iconColorForTab(int tab, bool selected) {
    if (!selected) return Colors.black;

    // Favorites + Services are red in your design
    if (tab == 1) return _red;
    // if (tab == 2) return _red;

    // Search + Inbox + Profile are green
    return _green;
  }

  String _labelFor(int i) {
    switch (i) {
      case 0:
        return "Search";
      case 1:
        return "Favorites";
      case 2:
        return "Services";
      case 3:
        return "Inbox";
      case 4:
        return "Profile";
      default:
        return "";
    }
  }

  Widget _iconFor(int tab, bool selected, Color color) {
    // Favorites uses Material icon (heart)
    if (tab == 1) {
      return Icon(
        selected ? Icons.favorite_rounded : Icons.favorite_border_rounded,
        size: 24,
        color: color,
      );
    }

    final String asset = switch (tab) {
      0 => Images.searchIcon,
      2 => Images.serviceIcon,
      3 => Images.messageIcon,
      4 => Images.userIcon,
      _ => Images.searchIcon,
    };

    // Search icon stays original (black) when not selected.
    if (tab == 0 && !selected) {
      return Image.asset(asset, width: 24, height: 24, fit: BoxFit.contain);
    }

    return Image.asset(
      asset,
      width: 24,
      height: 24,
      fit: BoxFit.contain,
      color: color,
      colorBlendMode: BlendMode.srcIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;

    return Container(
      height: 74 + (bottomInset > 0 ? bottomInset : 0),
      padding: EdgeInsets.only(bottom: bottomInset),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: _line, width: 1)),
      ),
      child: Row(
        children: List.generate(5, (i) {
          final selected = index == i;
          final iconColor = _iconColorForTab(i, selected);
          final labelColor = _labelColor(selected);

          return Expanded(
            child: InkWell(
              onTap: () => onTap(i),
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _iconFor(i, selected, iconColor),
                    const SizedBox(height: 6),
                    Text(
                      _labelFor(i),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: labelColor,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
