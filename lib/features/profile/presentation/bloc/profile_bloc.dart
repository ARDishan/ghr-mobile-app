import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/profile_usecases.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfile getProfile;

  ProfileBloc({required this.getProfile}) : super(ProfileInitial()) {
    on<ProfileLoadRequested>(_onLoad);
  }

  Future<void> _onLoad(
    ProfileLoadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    final result = await getProfile();
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (profile) => emit(ProfileLoaded(profile)),
    );
  }
}