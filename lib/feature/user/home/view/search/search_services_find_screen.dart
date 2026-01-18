import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:paschaloliver/feature/user/home/view/search/user_profile_details_screen.dart';

import '../../../../../core/constants/assets.dart';

/// ---------------------------------------------------------------------------
/// ✅ EXACT FLOW (GetX) – FULL REPLACEABLE FILE
/// 1) SearchTimeLoadingScreen  -> auto goes to HandyManServicesScreen
/// 2) HandyManServicesScreen   -> buttons: Service / Filters / When?
/// 3) ServiceFilterScreen      -> (your service cards + list)  ✅ no overflow
/// 4) FiltersScreen            -> (price/hour + experience + checklists + toggle)
/// 5) WhenScreen               -> (frequency + duration + date row + time picker)
/// 6) ServiceDateSheet         -> "Show month" bottom sheet calendar
///
/// Start:
/// Get.to(() => const SearchTimeLoadingScreen());
/// ---------------------------------------------------------------------------

class _C {
  static const green = Color(0xFF2FA86A);
  static const text = Color(0xFF1F1F1F);
  static const muted = Color(0xFF8B8B8B);
  static const line = Color(0xFFEDEDED);
  static const chipBg = Color(0xFFF3F3F3);
  static const soft = Color(0xFFF6F6F6);
  static const pageBg = Color(0xFFF5F5F5);
  static const star = Color(0xFFF4B400);
  static const shadow = Color(0x14000000);
}

/// ------------------------------ MODELS ------------------------------

class ProModel {
  final String name;
  final String role;
  final double rating;
  final int reviews;
  final int servicesCount;
  final double pricePerHour;
  final bool verified;

  const ProModel({
    required this.name,
    required this.role,
    required this.rating,
    required this.reviews,
    required this.servicesCount,
    required this.pricePerHour,
    required this.verified,
  });
}

/// ------------------------------ CONTROLLER ------------------------------

class HandyServicesController extends GetxController {
  // header
  final location = "Ungwan Kifi, Nigeria".obs;
  final serviceLabel = "Handyman".obs;

  // Service filter (screen 3)
  final selectedTopCategory = "Hanging".obs;
  final selectedServiceItems = <String>{}.obs;

  // Filters (screen 4)
  final priceRange = const RangeValues(13, 24).obs; // ₦13 - ₦24
  final experience = "0-2".obs; // 0-2, 2-5, 5-15, 15+
  final typeServices = <String>{}.obs; // Hanging, Small repairs...
  final otherTasks = <String>{}.obs; // Laundry, Ironing...
  final businessProfilesOnly = false.obs;

  // When (screen 5)
  final frequency = "Just once".obs; // Just once / Weekly
  final durationMinutes = 135.obs; // 2h 15m
  final selectedDate = DateTime(2025, 12, 10).obs; // Wed 10
  final startType = "Flexible".obs; // Flexible / Exact
  final fromTime = "08 : 00".obs;
  final untilTime = "18 : 00".obs;

  // list
  final pros = <ProModel>[
    const ProModel(
      name: "Nicolas bond",
      role: "Handyman",
      rating: 4.8,
      reviews: 4323,
      servicesCount: 656,
      pricePerHour: 20.50,
      verified: true,
    ),
    const ProModel(
      name: "Nicolas bond",
      role: "Handyman",
      rating: 4.8,
      reviews: 4323,
      servicesCount: 656,
      pricePerHour: 20.50,
      verified: true,
    ),
    const ProModel(
      name: "Nicolas bond",
      role: "Handyman",
      rating: 4.8,
      reviews: 4323,
      servicesCount: 656,
      pricePerHour: 20.50,
      verified: true,
    ),
  ].obs;

  Future<void> openService() async {
    final res = await Get.to<Map<String, dynamic>>(
      () => const ServiceFilterScreen(),
    );
    if (res == null) return;
    if (res["top"] is String) selectedTopCategory.value = res["top"] as String;
    if (res["items"] is Set<String>) {
      selectedServiceItems.value = (res["items"] as Set<String>);
    }
  }

  Future<void> openFilters() async {
    final res = await Get.to<Map<String, dynamic>>(() => const FiltersScreen());
    if (res == null) return;

    if (res["price"] is RangeValues) {
      priceRange.value = res["price"] as RangeValues;
    }
    if (res["exp"] is String) experience.value = res["exp"] as String;
    if (res["types"] is Set<String>) {
      typeServices.value = (res["types"] as Set<String>);
    }
    if (res["tasks"] is Set<String>) {
      otherTasks.value = (res["tasks"] as Set<String>);
    }
    if (res["biz"] is bool) businessProfilesOnly.value = res["biz"] as bool;
  }

  Future<void> openWhen() async {
    final res = await Get.to<Map<String, dynamic>>(() => const WhenScreen());
    if (res == null) return;

    if (res["freq"] is String) frequency.value = res["freq"] as String;
    if (res["dur"] is int) durationMinutes.value = res["dur"] as int;
    if (res["date"] is DateTime) selectedDate.value = res["date"] as DateTime;
    if (res["startType"] is String) {
      startType.value = res["startType"] as String;
    }
    if (res["from"] is String) fromTime.value = res["from"] as String;
    if (res["until"] is String) untilTime.value = res["until"] as String;
  }
}

/// ---------------------------------------------------------------------------
/// 1) SEARCH TIME LOADING
/// ---------------------------------------------------------------------------

class SearchTimeLoadingScreen extends StatefulWidget {
  const SearchTimeLoadingScreen({super.key});

  @override
  State<SearchTimeLoadingScreen> createState() =>
      _SearchTimeLoadingScreenState();
}

class _SearchTimeLoadingScreenState extends State<SearchTimeLoadingScreen> {
  // @override
  // void initState() {
  //   super.initState();
  //   Future.delayed(const Duration(seconds: 2), () {
  //     Get.off(() => const HandyManServicesScreen());
  //   });
  // }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Get.off(() => const HandyManServicesScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            children: const [
              SizedBox(height: 6),
              _LoadingProCard(),
              SizedBox(height: 12),
              _LoadingProCard(),
              SizedBox(height: 12),
              _LoadingProCard(),
              SizedBox(height: 18),
              Text(
                "Finding Cleaning professionals in UNRWA\nKaduna,Nigeria",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: _C.text,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadingProCard extends StatelessWidget {
  const _LoadingProCard();

  @override
  Widget build(BuildContext context) {
    return _Shimmer(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: _C.line),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: _C.soft,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: List.generate(
                      5,
                      (_) => const Padding(
                        padding: EdgeInsets.only(right: 2),
                        child: Icon(
                          Icons.star_rounded,
                          size: 14,
                          color: _C.star,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 10,
                    width: 140,
                    decoration: BoxDecoration(
                      color: _C.soft,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 10,
                    width: 180,
                    decoration: BoxDecoration(
                      color: _C.soft,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 34,
              height: 18,
              decoration: BoxDecoration(
                color: _C.green,
                borderRadius: BorderRadius.circular(6),
              ),
              alignment: Alignment.center,
              child: const Text(
                "\$ \$",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// 2) HANDY MAN SERVICES (LIST)
/// ---------------------------------------------------------------------------

class HandyManServicesScreen extends StatelessWidget {
  const HandyManServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(HandyServicesController());

    return Scaffold(
      backgroundColor: _C.pageBg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          children: [
            Obx(() {
              return _TopSearchBar(
                value: "${c.serviceLabel.value}    ${c.location.value}",
                onBack: () => Get.back(),
              );
            }),
            const SizedBox(height: 10),

            // ✅ EXACT SPACING LIKE YOUR 6th SCREENSHOT
            const SizedBox(height: 12),
            const _GuaranteeCard(),
            const SizedBox(height: 12),

            Obx(() {
              return Column(
                children: [
                  for (int i = 0; i < c.pros.length; i++) ...[
                    if (i == 2) ...[
                      const SizedBox(height: 10),
                      const _RecommendedBar(iconPath: Images.checkBadgeIcon),

                      const SizedBox(height: 10),
                    ],
                    _ProCard(model: c.pros[i]),
                    const SizedBox(height: 12),
                  ],
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _TopSearchBar extends StatelessWidget {
  const _TopSearchBar({required this.value, required this.onBack});

  final String value;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _C.line),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: onBack,
            borderRadius: BorderRadius.circular(8),
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(Icons.arrow_back, size: 20, color: _C.text),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: _C.text,
              ),
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _C.line),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: _C.chipBg,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: _C.line),
              ),
              child: Icon(icon, size: 14, color: _C.text),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w900,
                color: _C.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GuaranteeCard extends StatelessWidget {
  const _GuaranteeCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEFEFEF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _C.line),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            height: 80,
            // decoration: BoxDecoration(
            //   color: _C.green.withOpacity(.14),
            //   borderRadius: BorderRadius.circular(12),
            // ),
            child: Center(
              child: Image.asset(
                Images.hundredIcon,
                width: 80,
                height: 80,
                color: _C.green, // remove if you don't want tint
                colorBlendMode: BlendMode.srcIn,
                fit: BoxFit.contain,
              ),
            ),
          ),

          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "HandyNaija Guarantee",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: _C.text,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "All service are protected by HandyNaija money-\nback guarantee",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _C.muted,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
          // const Icon(Icons.chevron_right_rounded, color: _C.muted),
        ],
      ),
    );
  }
}

class _RecommendedBar extends StatelessWidget {
  const _RecommendedBar({this.iconPath});

  final String? iconPath; // e.g. Images.checkBadgeIcon

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 34),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF3FA96B),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (iconPath != null) ...[
            Image.asset(
              iconPath!,
              width: 16,
              height: 16,
              fit: BoxFit.contain,

              // If your icon is black and you want white:
              // color: Colors.white,
              // colorBlendMode: BlendMode.srcIn,
            ),
            const SizedBox(width: 8),
          ],
          Text(
            "Recommended service",
            style: GoogleFonts.urbanist(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              height: 1.1,
              letterSpacing: 0,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProCard extends StatelessWidget {
  const _ProCard({required this.model});
  final ProModel model;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => const NicolasProfileScreen());
        // or if you want to pass data later:
        // Get.to(() => NicolasProfileScreen(model: model));
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _C.line),
          boxShadow: const [
            BoxShadow(color: _C.shadow, blurRadius: 18, offset: Offset(0, 10)),
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 44,
                    height: 44,
                    color: _C.soft,
                    child: const Icon(Icons.person, color: _C.muted),
                  ),
                ),
                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            model.name,
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w900,
                              color: _C.muted,
                            ),
                          ),
                          if (model.verified) ...[
                            const SizedBox(width: 6),
                            Image.asset(
                              Images.checkBadgeIcon, // <-- your asset path
                              width: 13.33,
                              height: 13.33,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        model.role,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: _C.green,
                        ),
                      ),
                      const SizedBox(height: 4),

                      Row(
                        children: [
                          Text(
                            "₦${model.pricePerHour.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w900,
                              color: _C.green,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            "Per hour",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: _C.muted,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "${model.servicesCount} Services",
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: _C.muted,
                            ),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          _Stars(rating: model.rating),
                          const SizedBox(width: 6),
                          Text(
                            "${model.rating.toStringAsFixed(1)}  |  ${model.reviews} Reviews",
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: _C.muted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                InkWell(
                  onTap: () {}, // favorite icon still works separately
                  borderRadius: BorderRadius.circular(999),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      Icons.favorite_border_rounded,
                      size: 18,
                      color: _C.green,
                    ),
                  ),
                ),
              ],
            ),

            // ... keep the rest of your ProCard EXACTLY same ...
            const SizedBox(height: 10),

            const SizedBox(height: 10),

            Row(
              children: const [
                Expanded(
                  child: _MiniPill(
                    icon: Icons.storefront_outlined,
                    label: "Business Profile",
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _MiniPill(
                    icon: Icons.repeat_rounded,
                    label: "7 have repeated",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: const [
                Expanded(
                  child: _MiniPill(
                    icon: Icons.event_available_outlined,
                    label: "Updated schedule",
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _MiniPill(
                    icon: Icons.attach_money_rounded,
                    label: "Minimum charge ₦30",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            const Divider(height: 1, thickness: 1, color: _C.line),
            const SizedBox(height: 10),

            SizedBox(
              height: 58,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (_, __) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 58,
                      height: 58,
                      color: _C.soft,
                      child: const Icon(Icons.image_outlined, color: _C.muted),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Stars extends StatelessWidget {
  const _Stars({required this.rating});
  final double rating;

  @override
  Widget build(BuildContext context) {
    final full = rating.floor().clamp(0, 5);
    return Row(
      children: List.generate(
        5,
        (i) => Icon(
          i < full ? Icons.star_rounded : Icons.star_border_rounded,
          size: 14,
          color: _C.star,
        ),
      ),
    );
  }
}

class _MiniPill extends StatelessWidget {
  const _MiniPill({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: _C.chipBg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: _C.line),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 14, color: _C.muted),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w900,
                color: _C.muted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// 3) SERVICE FILTER (your “Service filter” screen) ✅ FIXED (no overflow)
/// ---------------------------------------------------------------------------

class ServiceFilterScreen extends StatefulWidget {
  const ServiceFilterScreen({super.key});

  @override
  State<ServiceFilterScreen> createState() => _ServiceFilterScreenState();
}

class _ServiceFilterScreenState extends State<ServiceFilterScreen> {
  late String top;
  late Set<String> items;

  final listItems = const ["Lamp", "TV", "Picture", "Mirror", "Coat Rack"];

  @override
  void initState() {
    super.initState();
    final c = Get.find<HandyServicesController>();

    // ✅ local copies (so user can cancel)
    top = c.selectedTopCategory.value;
    items = {...c.selectedServiceItems};
  }

  void _toggleItem(String label) {
    setState(() {
      if (items.contains(label)) {
        items.remove(label);
      } else {
        items.add(label);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Service filter",
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w900,
                  color: _C.muted,
                ),
              ),
              const SizedBox(height: 6),

              Row(
                children: [
                  _CircleIcon(
                    icon: Icons.close_rounded,
                    onTap: () => Get.back(),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () => setState(() => items.clear()),
                    child: const Text(
                      "Delete all",
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w900,
                        color: _C.muted,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              const Text(
                "What service do you need?",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: _C.text,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Select the service you need to find professionals\nwho offer it.",
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: _C.muted,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 14),

              // ✅ horizontal cards
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _TopServiceCard(
                      width: 96,
                      title: "Hanging",
                      icon: Icons.hardware_rounded,
                      selected: top == "Hanging",
                      onTap: () => setState(() => top = "Hanging"),
                    ),
                    const SizedBox(width: 10),
                    _TopServiceCard(
                      width: 96,
                      title: "Small repairs",
                      icon: Icons.build_circle_outlined,
                      selected: top == "Small repairs",
                      onTap: () => setState(() => top = "Small repairs"),
                    ),
                    const SizedBox(width: 10),
                    _TopServiceCard(
                      width: 96,
                      title: "Furniture\nassembly",
                      icon: Icons.handyman_outlined,
                      selected: top == "Furniture assembly",
                      onTap: () => setState(() => top = "Furniture assembly"),
                    ),
                    const SizedBox(width: 10),
                    _TopServiceCard(
                      width: 96,
                      title: "Installation",
                      icon: Icons.power_outlined,
                      selected: top == "Installation",
                      onTap: () => setState(() => top = "Installation"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
              const Divider(height: 1, thickness: 1, color: _C.line),

              // ✅ list
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: listItems.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, thickness: 1, color: _C.line),
                  itemBuilder: (_, i) {
                    final label = listItems[i];
                    final checked = items.contains(label);

                    IconData icon = Icons.lightbulb_outline_rounded;
                    if (label == "TV") icon = Icons.tv_rounded;
                    if (label == "Picture") icon = Icons.image_outlined;
                    if (label == "Mirror") icon = Icons.crop_square_rounded;
                    if (label == "Coat Rack") icon = Icons.checkroom_outlined;

                    return InkWell(
                      onTap: () => _toggleItem(label),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          children: [
                            Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: _C.line),
                                color: Colors.white,
                              ),
                              child: Icon(icon, size: 18, color: _C.muted),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                label,
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w800,
                                  color: _C.muted,
                                ),
                              ),
                            ),
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                border: Border.all(
                                  color: _C.muted.withOpacity(.55),
                                  width: 1.2,
                                ),
                                color: checked ? _C.green : Colors.transparent,
                              ),
                              child: checked
                                  ? const Icon(
                                      Icons.check_rounded,
                                      size: 14,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                height: 46,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // ✅ return to previous screen with selected values
                    Get.back(result: {"top": top, "items": items});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _C.green,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Show professionals",
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
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

class _TopServiceCard extends StatelessWidget {
  const _TopServiceCard({
    required this.width,
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final double width;
  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: width,
        height: 78,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: selected ? _C.green.withOpacity(.12) : const Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? _C.green : _C.line,
            width: selected ? 1.2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: _C.text),
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w900,
                color: _C.text,
                height: 1.15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// 4) FILTERS (price/hour + experience + checklists + toggle)
/// ---------------------------------------------------------------------------

class FiltersScreen extends StatelessWidget {
  const FiltersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<HandyServicesController>();

    // local copies
    final Rx<RangeValues> price = c.priceRange.value.obs;
    final RxString exp = c.experience.value.obs;
    final RxSet<String> types = c.typeServices.toSet().obs;
    final RxSet<String> tasks = c.otherTasks.toSet().obs;
    final RxBool biz = c.businessProfilesOnly.value.obs;

    const typeList = [
      "Hanging",
      "Small repairs",
      "Furniture assembly",
      "Installation",
    ];
    const taskList = ["Laundry", "Ironing", "Cooking", "Childcare"];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          child: Column(
            children: [
              Row(
                children: [
                  _CircleIcon(
                    icon: Icons.close_rounded,
                    onTap: () => Get.back(),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      price.value = const RangeValues(13, 24);
                      exp.value = "0-2";
                      types.clear();
                      tasks.clear();
                      biz.value = false;
                    },
                    child: const Text(
                      "Delete all",
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w900,
                        color: _C.muted,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Price/hour line + slider
              Obx(() {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w900,
                          color: _C.text,
                        ),
                        children: [
                          const TextSpan(text: "Price/Hour "),
                          TextSpan(
                            text:
                                "₦${price.value.start.toStringAsFixed(2)}/h - ₦${price.value.end.toStringAsFixed(2)}/h",
                            style: const TextStyle(color: _C.green),
                          ),
                        ],
                      ),
                    ),
                    RangeSlider(
                      values: price.value,
                      min: 0,
                      max: 30,
                      divisions: 300,
                      activeColor: _C.green,
                      inactiveColor: _C.line,
                      onChanged: (v) => price.value = v,
                    ),
                  ],
                );
              }),

              const Divider(height: 1, thickness: 1, color: _C.line),

              const SizedBox(height: 10),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Professional's experience",
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w900,
                    color: _C.text,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              Obx(() {
                return Column(
                  children: [
                    _RadioRow(
                      title: "0-2 years of experience",
                      value: "0-2",
                      group: exp.value,
                      onTap: () => exp.value = "0-2",
                    ),
                    _RadioRow(
                      title: "2-5 years of experience",
                      value: "2-5",
                      group: exp.value,
                      onTap: () => exp.value = "2-5",
                    ),
                    _RadioRow(
                      title: "5-15 years of experience",
                      value: "5-15",
                      group: exp.value,
                      onTap: () => exp.value = "5-15",
                    ),
                    _RadioRow(
                      title: "+15 years of experience",
                      value: "15+",
                      group: exp.value,
                      onTap: () => exp.value = "15+",
                    ),
                  ],
                );
              }),

              const SizedBox(height: 6),
              const Divider(height: 1, thickness: 1, color: _C.line),
              const SizedBox(height: 10),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Type of Handyman service",
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w900,
                    color: _C.text,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              Obx(() {
                return Column(
                  children: [
                    for (final t in typeList)
                      _CheckRow(
                        title: t,
                        checked: types.contains(t),
                        onTap: () =>
                            types.contains(t) ? types.remove(t) : types.add(t),
                      ),
                  ],
                );
              }),

              const SizedBox(height: 6),
              const Divider(height: 1, thickness: 1, color: _C.line),
              const SizedBox(height: 10),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Other tasks to be carried out",
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w900,
                    color: _C.text,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              Obx(() {
                return Column(
                  children: [
                    for (final t in taskList)
                      _CheckRow(
                        title: t,
                        checked: tasks.contains(t),
                        onTap: () =>
                            tasks.contains(t) ? tasks.remove(t) : tasks.add(t),
                      ),
                  ],
                );
              }),

              const SizedBox(height: 6),
              const Divider(height: 1, thickness: 1, color: _C.line),
              const SizedBox(height: 10),

              // Business Profiles toggle
              Obx(() {
                return Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Business Profiles",
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w900,
                          color: _C.text,
                        ),
                      ),
                    ),
                    Switch(
                      value: biz.value,
                      onChanged: (v) => biz.value = v,
                      activeThumbColor: _C.green,
                    ),
                  ],
                );
              }),
              const SizedBox(height: 4),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Only profile that correspond to a validated\nbusiness or self-employed professional.",
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: _C.muted,
                    height: 1.25,
                  ),
                ),
              ),

              const Spacer(),

              SizedBox(
                height: 46,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back(
                      result: {
                        "price": price.value,
                        "exp": exp.value,
                        "types": types.toSet(),
                        "tasks": tasks.toSet(),
                        "biz": biz.value,
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _C.green,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Show professionals",
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
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

class _RadioRow extends StatelessWidget {
  const _RadioRow({
    required this.title,
    required this.value,
    required this.group,
    required this.onTap,
  });

  final String title;
  final String value;
  final String group;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final selected = value == group;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: _C.muted.withOpacity(.6), width: 1.2),
                color: selected
                    ? _C.green.withOpacity(.15)
                    : Colors.transparent,
              ),
              child: selected
                  ? const Center(
                      child: Icon(Icons.circle, size: 10, color: _C.green),
                    )
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  color: _C.text,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckRow extends StatelessWidget {
  const _CheckRow({
    required this.title,
    required this.checked,
    required this.onTap,
  });

  final String title;
  final bool checked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                border: Border.all(
                  color: _C.muted.withOpacity(.55),
                  width: 1.2,
                ),
                color: checked ? _C.green : Colors.transparent,
              ),
              child: checked
                  ? const Icon(
                      Icons.check_rounded,
                      size: 14,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  color: _C.text,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// 5) WHEN (frequency + duration + date + start time) ✅ NO GETX ERROR
/// ---------------------------------------------------------------------------

class WhenScreen extends StatelessWidget {
  const WhenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<HandyServicesController>();

    // local copies
    final RxString freq = c.frequency.value.obs;
    final RxInt dur = c.durationMinutes.value.obs;
    final Rx<DateTime> date = c.selectedDate.value.obs;
    final RxString startType = c.startType.value.obs;
    final RxString from = c.fromTime.value.obs;
    final RxString until = c.untilTime.value.obs;

    final days = <DateTime>[
      DateTime(2025, 12, 10),
      DateTime(2025, 12, 11),
      DateTime(2025, 12, 12),
      DateTime(2025, 12, 13),
      DateTime(2025, 12, 14),
    ];

    final fromList = const [
      "05 : 00",
      "06 : 00",
      "07 : 00",
      "08 : 00",
      "09 : 00",
      "10 : 00",
      "11 : 00",
      "12 : 00",
    ];
    final untilList = const [
      "05 : 00",
      "06 : 00",
      "07 : 00",
      "18 : 00",
      "09 : 00",
      "10 : 00",
      "11 : 00",
      "12 : 00",
    ];

    String durationLabel(int m) {
      final h = m ~/ 60;
      final mm = m % 60;
      final mmText = mm.toString().padLeft(2, '0');
      return "${h}h ${mmText}min";
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "When",
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w900,
                  color: _C.muted,
                ),
              ),
              const SizedBox(height: 6),

              Row(
                children: [
                  _CircleIcon(
                    icon: Icons.close_rounded,
                    onTap: () => Get.back(),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      freq.value = "Just once";
                      dur.value = 135;
                      date.value = DateTime(2025, 12, 10);
                      startType.value = "Flexible";
                      from.value = "08 : 00";
                      until.value = "18 : 00";
                    },
                    child: const Text(
                      "Delete all",
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w900,
                        color: _C.muted,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              const Text(
                "Frequency",
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w900,
                  color: _C.text,
                ),
              ),
              const SizedBox(height: 10),

              Obx(() {
                return Row(
                  children: [
                    Expanded(
                      child: _FreqPill(
                        title: "Just once",
                        sub: "One-time",
                        selected: freq.value == "Just once",
                        onTap: () => freq.value = "Just once",
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _FreqPill(
                        title: "Weekly",
                        sub: "Recurring",
                        selected: freq.value == "Weekly",
                        onTap: () => freq.value = "Weekly",
                      ),
                    ),
                  ],
                );
              }),

              const SizedBox(height: 14),
              Obx(() {
                return RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w900,
                      color: _C.text,
                    ),
                    children: [
                      const TextSpan(text: "Duration "),
                      TextSpan(
                        text: durationLabel(dur.value),
                        style: const TextStyle(color: _C.green),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 8),

              Obx(() {
                return SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: _C.green,
                    inactiveTrackColor: _C.line,
                    thumbColor: Colors.white,
                    overlayColor: _C.green.withOpacity(.12),
                    trackHeight: 6,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 8,
                    ),
                  ),
                  child: Slider(
                    value: dur.value.toDouble(),
                    min: 60,
                    max: 240,
                    onChanged: (v) => dur.value = v.round(),
                  ),
                );
              }),

              const Divider(height: 1, thickness: 1, color: _C.line),
              const SizedBox(height: 12),

              // Month row
              Row(
                children: [
                  const Text(
                    "December",
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w900,
                      color: _C.text,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () async {
                      final picked = await showModalBottomSheet<DateTime>(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        barrierColor: Colors.black.withOpacity(.35),
                        builder: (_) => ServiceDateSheet(initial: date.value),
                      );
                      if (picked != null) date.value = picked;
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: _C.chipBg,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: _C.line),
                      ),
                      child: const Text(
                        "Show month",
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w900,
                          color: _C.muted,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Date pills row
              Obx(() {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final d in days) ...[
                        _DayPill(
                          day: _dayShort(d.weekday),
                          num: d.day.toString(),
                          selected: _sameDate(date.value, d),
                          onTap: () => date.value = d,
                        ),
                        const SizedBox(width: 10),
                      ],
                    ],
                  ),
                );
              }),

              const SizedBox(height: 12),

              const Text(
                "Start time",
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w900,
                  color: _C.text,
                ),
              ),
              const SizedBox(height: 10),

              // segmented (Flexible / Exact)
              Obx(() {
                return Container(
                  height: 36,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: _C.chipBg,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: _C.line),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _Segment(
                          label: "Flexible start",
                          selected: startType.value == "Flexible",
                          onTap: () => startType.value = "Flexible",
                        ),
                      ),
                      Expanded(
                        child: _Segment(
                          label: "Exact start",
                          selected: startType.value == "Exact",
                          onTap: () => startType.value = "Exact",
                        ),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 12),

              Expanded(
                child: Row(
                  children: [
                    // From
                    Expanded(
                      child: Obx(() {
                        return _TimeColumn(
                          title: "From:",
                          items: fromList,
                          selected: from.value,
                          onPick: (v) => from.value = v,
                        );
                      }),
                    ),
                    const SizedBox(width: 12),
                    // Until
                    Expanded(
                      child: Obx(() {
                        return _TimeColumn(
                          title: "Until:",
                          items: untilList,
                          selected: until.value,
                          onPick: (v) => until.value = v,
                        );
                      }),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                height: 46,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back(
                      result: {
                        "freq": freq.value,
                        "dur": dur.value,
                        "date": date.value,
                        "startType": startType.value,
                        "from": from.value,
                        "until": until.value,
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _C.green,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Show professionals",
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _dayShort(int weekday) {
    const map = {
      1: "Mon",
      2: "Tue",
      3: "Wed",
      4: "Thu",
      5: "Fri",
      6: "Sat",
      7: "Sun",
    };
    return map[weekday] ?? "Day";
  }

  static bool _sameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _FreqPill extends StatelessWidget {
  const _FreqPill({
    required this.title,
    required this.sub,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String sub;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: selected ? _C.green.withOpacity(.12) : _C.chipBg,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: selected ? _C.green : _C.line),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w900,
                color: _C.text,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              sub,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: _C.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          border: selected ? Border.all(color: _C.line) : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            color: _C.text,
          ),
        ),
      ),
    );
  }
}

class _DayPill extends StatelessWidget {
  const _DayPill({
    required this.day,
    required this.num,
    required this.selected,
    required this.onTap,
  });

  final String day;
  final String num;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 56,
        height: 44,
        decoration: BoxDecoration(
          color: selected ? _C.green.withOpacity(.12) : _C.chipBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: selected ? _C.green : _C.line),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              day,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w900,
                color: selected ? _C.green : _C.text,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              num,
              style: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w900,
                color: _C.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeColumn extends StatelessWidget {
  const _TimeColumn({
    required this.title,
    required this.items,
    required this.selected,
    required this.onPick,
  });

  final String title;
  final List<String> items;
  final String selected;
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            color: _C.text,
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (_, i) {
              final v = items[i];
              final isSel = v == selected;
              return InkWell(
                onTap: () => onPick(v),
                child: Container(
                  height: 26,
                  margin: const EdgeInsets.only(bottom: 6),
                  decoration: BoxDecoration(
                    color: isSel ? _C.chipBg : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    v,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: _C.text,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// ---------------------------------------------------------------------------
/// 6) SHOW MONTH (bottom sheet)
/// ---------------------------------------------------------------------------

class ServiceDateSheet extends StatefulWidget {
  const ServiceDateSheet({super.key, required this.initial});
  final DateTime initial;

  @override
  State<ServiceDateSheet> createState() => _ServiceDateSheetState();
}

class _ServiceDateSheetState extends State<ServiceDateSheet> {
  late DateTime viewMonth;
  late DateTime selected;

  @override
  void initState() {
    super.initState();
    selected = widget.initial;
    viewMonth = DateTime(widget.initial.year, widget.initial.month, 1);
  }

  @override
  Widget build(BuildContext context) {
    final days = _buildMonthDays(viewMonth);

    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.18),
              blurRadius: 22,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 46,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFDADADA),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                const Expanded(
                  child: Text(
                    "Service date",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: _C.green,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => Get.back(),
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: _C.chipBg,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: _C.line),
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 16,
                      color: _C.muted,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "What day would you like to receive the service?",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: _C.muted,
                ),
              ),
            ),
            const SizedBox(height: 14),

            Row(
              children: [
                IconButton(
                  onPressed: () => setState(
                    () => viewMonth = DateTime(
                      viewMonth.year,
                      viewMonth.month - 1,
                      1,
                    ),
                  ),
                  icon: const Icon(Icons.chevron_left_rounded),
                ),
                Expanded(
                  child: Text(
                    _monthTitle(viewMonth),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: _C.text,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => setState(
                    () => viewMonth = DateTime(
                      viewMonth.year,
                      viewMonth.month + 1,
                      1,
                    ),
                  ),
                  icon: const Icon(Icons.chevron_right_rounded),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Week header
            const Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      "M",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: _C.muted,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      "T",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: _C.muted,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      "W",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: _C.muted,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      "T",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: _C.muted,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      "F",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: _C.muted,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      "S",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: _C.muted,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      "S",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: days.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisExtent: 34,
              ),
              itemBuilder: (_, i) {
                final d = days[i];
                if (d == null) return const SizedBox.shrink();

                final isSunday = d.weekday == DateTime.sunday;
                final isSel =
                    d.year == selected.year &&
                    d.month == selected.month &&
                    d.day == selected.day;

                return InkWell(
                  onTap: () => setState(() => selected = d),
                  child: Center(
                    child: Text(
                      "${d.day}",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: isSunday ? Colors.red : _C.text,
                        decoration: isSel
                            ? TextDecoration.underline
                            : TextDecoration.none,
                        decorationColor: _C.green,
                        decorationThickness: 2,
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 120,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFDADADA),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(height: 1, child: Container(color: Colors.transparent)),

            const SizedBox(height: 6),
            SizedBox(height: 1, child: Container(color: Colors.transparent)),

            const SizedBox(height: 6),
            SizedBox(height: 1, child: Container(color: Colors.transparent)),

            const SizedBox(height: 6),
            // bottom “home indicator” look
            Container(
              width: 120,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFDADADA),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 10),

            // tap anywhere? no — return selected by button-like action on sheet close
            SizedBox(height: 0, child: const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }

  static String _monthTitle(DateTime d) {
    const names = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return "${names[d.month - 1]} ${d.year}";
  }

  static List<DateTime?> _buildMonthDays(DateTime month) {
    final first = DateTime(month.year, month.month, 1);
    final last = DateTime(month.year, month.month + 1, 0);
    // monday-based index (Mon=1..Sun=7)
    final leading = first.weekday - 1; // 0..6
    final total = leading + last.day;
    final trailing = (7 - (total % 7)) % 7;

    final list = <DateTime?>[];
    for (int i = 0; i < leading; i++) {
      list.add(null);
    }
    for (int d = 1; d <= last.day; d++) {
      list.add(DateTime(month.year, month.month, d));
    }
    for (int i = 0; i < trailing; i++) {
      list.add(null);
    }
    return list;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void deactivate() {
    // when sheet closes by swipe, return selected
    super.deactivate();
    if (mounted == false) return;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant ServiceDateSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
  }
}

/// ---------------------------------------------------------------------------
/// Common
/// ---------------------------------------------------------------------------

class _CircleIcon extends StatelessWidget {
  const _CircleIcon({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: _C.chipBg,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: _C.line),
        ),
        child: Icon(icon, size: 18, color: _C.muted),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// ✅ SIMPLE SHIMMER (no package)
/// ---------------------------------------------------------------------------

class _Shimmer extends StatefulWidget {
  const _Shimmer({required this.child});
  final Widget child;

  @override
  State<_Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<_Shimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ac;

  @override
  void initState() {
    super.initState();
    _ac = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat();
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ac,
      builder: (_, __) {
        final v = _ac.value;
        return ShaderMask(
          shaderCallback: (rect) {
            return LinearGradient(
              begin: Alignment(-1 - 0.2 + v * 2.4, 0),
              end: Alignment(1 + v * 2.4, 0),
              colors: const [
                Color(0xFFEFEFEF),
                Color(0xFFF7F7F7),
                Color(0xFFEFEFEF),
              ],
              stops: const [0.25, 0.5, 0.75],
            ).createShader(rect);
          },
          blendMode: BlendMode.srcATop,
          child: widget.child,
        );
      },
    );
  }
}
