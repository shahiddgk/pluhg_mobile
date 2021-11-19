import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(const OnboardingPageState(0)) {
    on<OnboardingEvent>((event, emit) {
      int currentPage=state.currentPage;
      if(event is PreviousEvent){
        if(currentPage<=0) {
          currentPage=0;
        } else {
          currentPage--;
        }
        emit(OnboardingPageState(currentPage));
      }else if(event is NextEvent){
        if(currentPage>=3) {
          currentPage=3;
        } else {
          currentPage++;
        }
        emit(OnboardingPageState(currentPage));
      }
    });
  }
}
