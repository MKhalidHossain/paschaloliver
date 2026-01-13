
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paschaloliver/core/constants/app_colors.dart';

import '../auth/view/sign_up_view.dart';



class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  TextStyle onboardingText1 = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w700,
    fontSize: 20,
  );
  TextStyle onboardingText2 = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w400,
    fontSize: 14,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: InkWell(
                  onTap: () {
                    Get.to(() => SignUpScreen());
                  },
                  child: Text(
                    "Skip",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),

          Expanded(
            child: PageView(
              clipBehavior: Clip.none,
              controller: _controller,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              children: [
                _buildOnboardingPage(
                  context,
                  image: '',
                  title: Text(
                    "Compare Prices Worldwide",
                    style: onboardingText1,
                  ),
                  description:
                      'Easily compare product prices between different countries to find the best deals.',
                ),

                _buildOnboardingPage(
                  context,
                  image: '',
                  title: Text(
                    "Automatic Currency Conversion.",
                    style: onboardingText1,
                  ),
                  description:
                      'Get real-time currency conversions and see which country offers the best value.',
                ),

                _buildOnboardingPage(
                  context,
                  image: "assets/images/obg3.png",
                  title: Text(
                    "Save More While Traveling",
                    style: onboardingText1,
                    textAlign: TextAlign.justify,
                  ),
                  description:
                      'Know exactly where to buy your favorite products for the best price while abroad.',
                ),
              ],
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              final bool isActive = _currentPage == index;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: isActive
                    ? Container(
                        height: 8,
                        width: 20,
                        decoration: BoxDecoration(
                          color: AppColors.appColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      )
                    : Container(
                        height: 8,
                        width: 8,
                        decoration: BoxDecoration(
                          color: AppColors.appColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
              );
            }),
          ),

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              // child: ElevatedButton(
              //   onPressed: () {_currentPage == 2 ? Get.to(() => SignUpScreen()) : null;},
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: AppColors.bottomColor1,
              //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8),),
              //   ),
              //   child: _currentPage==2?const Text('Get Started', style: TextStyle(color: Colors.white),):
              //   const Text('Next', style: TextStyle(color: Colors.white),),
              // ),
              child: ElevatedButton(
                onPressed: () {
                  if (_currentPage == 2) {
                    // Last page → Go to SignUp screen
                    Get.to(() => SignUpScreen());
                  } else {
                    // Move to next page
                    _controller.nextPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.appColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  _currentPage == 2 ? 'Get Started' : 'Next',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildOnboardingPage(
    BuildContext context, {
    required String image,
    required Widget title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            height: 327,
            width: 327,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.image, size: 100, color: Colors.grey);
            },
          ),

          const SizedBox(height: 100),
          title,
          const SizedBox(height: 12),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
