import 'package:bank_application/data/dummy/onboarding_model.dart';
import '../../presentation/utils/assets.dart';

class OnboardingItem {
  List<OnboardingModel> items = [
    OnboardingModel(
      title: 'Make it simple ',
      description:
          'We pay attention to all your payments and find for saving your money',
      image: Assets.imagesPayOnline,
    ),
    OnboardingModel(
      title: 'New Banking',
      description:
          'Free advisory service mobile banking application visa and master card',
      image: Assets.imagesMobilePay,
    ),
    OnboardingModel(
      title: 'Zero Fees',
      description: 'Bank your Life.We create something new you never before',
      image: Assets.imagesSavings,
    ),
  ];
}
