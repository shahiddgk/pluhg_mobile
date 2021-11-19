part of 'onboarding_bloc.dart';

@immutable
abstract class OnboardingState {
  final int currentPage;

  const OnboardingState(this.currentPage);
}

class OnboardingPageState extends OnboardingState {
  const OnboardingPageState(int currentPage) : super(currentPage);
}
