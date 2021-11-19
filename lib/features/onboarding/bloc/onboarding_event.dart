part of 'onboarding_bloc.dart';

@immutable
abstract class OnboardingEvent {}

class NextEvent extends OnboardingEvent{}
class PreviousEvent extends OnboardingEvent{}