import 'package:bank_application/data/dummy/onboarding_item.dart';
import 'package:bank_application/presentation/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OboardingScreen extends StatefulWidget {
  const OboardingScreen({super.key});

  @override
  State<OboardingScreen> createState() => _OboardingScreenState();
}

class _OboardingScreenState extends State<OboardingScreen> {
  final OnboardingItem onboardingItem = OnboardingItem();
  final pageController = PageController();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildPageView(),
        ),
        bottomNavigationBar: isLastPage ? getStarted() : _nextPreviewPage());
  }

  Widget _buildPageView() {
    TextTheme textTheme = Theme.of(context).textTheme;
    return PageView.builder(
        onPageChanged: (index) => setState(() {
              isLastPage = onboardingItem.items.length - 1 == index;
            }),
        controller: pageController,
        itemCount: onboardingItem.items.length,
        itemBuilder: (contex, index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                onboardingItem.items[index].image,
                height: 400,
              ),
              const SizedBox(height: 20),
              Text(
                onboardingItem.items[index].title,
                style: textTheme.displayMedium,
              ),
              const SizedBox(height: 20),
              Text(
                onboardingItem.items[index].description,
                textAlign: TextAlign.center,
                style: textTheme.labelLarge?.copyWith(color: Colors.grey),
              ),
            ],
          );
        });
  }

  Widget _nextPreviewPage() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
                onPressed: () {
                  pageController.jumpToPage(onboardingItem.items.length - 1);
                },
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                )),
            SmoothPageIndicator(
              controller: pageController,
              count: onboardingItem.items.length,
              effect: WormEffect(
                activeDotColor: isDarkMode
                    ? const Color(0xFFFFFFFF)
                    : const Color(0xFF1B1B1B),
              ),
            ),
            SizedBox(
              width: 80,
              child: ElevatedButton(
                  onPressed: () {
                    pageController.nextPage(
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeIn);
                  },
                  child: const Icon(Iconsax.arrow_circle_right)),
            )
          ],
        ),
      ),
    );
  }

  Widget getStarted() {
    TextTheme textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext contex) => const SignInScreen()),
              (Route<dynamic> route) => false,
            );
          },
          child: Text(
            'Get Started',
            style: textTheme.titleLarge?.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
