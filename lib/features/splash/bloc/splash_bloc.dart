import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<SplashEvent>((event, emit)async {
      if(event is StartTimerEvent){
        await Future.delayed(const Duration(seconds: 2));
        emit(SplashCompleted());
      }
    });
  }
}
