import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/assets.dart';
import '../controller/role_controller.dart';

import 'sign_up_view.dart';

enum AccountType { client, professional }

class ChooseAccountTypeView extends StatefulWidget {
  const ChooseAccountTypeView({super.key});

  @override
  State<ChooseAccountTypeView> createState() => _ChooseAccountTypeViewState();
}

class _ChooseAccountTypeViewState extends State<ChooseAccountTypeView> {
  AccountType? selectedType;
  final RoleController roleController = Get.put(RoleController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What do you want to do on HanyNaija?',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 24,
                fontWeight: FontWeight.w600,
                height: 1.2,
                color: Color(0xFF000000),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Don't worry—this decision isn't permanent. You can always switch later and use the same account as both a client and a professional.",
              style: TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 32),

            _accountOption(
              title: 'Book a Service',
              subtitle: '(I\'m client)',
              value: AccountType.client,
              imagePath: Images.clientIcon, //
            ),

            _accountOption(
              title: 'Offer Services',
              subtitle: '(I\'m a professional)',
              value: AccountType.professional,
              imagePath: Images.offerIcon, //
            ),

            const Spacer(),

            ElevatedButton(
              onPressed: selectedType == null ? null : _continue,
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedType == null
                    ? Colors.white
                    : AppColors.appColor,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Continue',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _continue() {
    final role = selectedType == AccountType.client ? 'client' : 'professional';
    roleController.setRole(role);
    Get.to(() => const SignUpScreen());
  }

  Widget _accountOption({
    required String title,
    required String subtitle,
    required AccountType value,
    required String imagePath, // ✅ new param
  }) {
    final isSelected = selectedType == value;

    return GestureDetector(
      onTap: () => setState(() => selectedType = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? Colors.black : Colors.white),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFFFAFAFA),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    imagePath, // ✅ use different image
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: Colors.black)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
