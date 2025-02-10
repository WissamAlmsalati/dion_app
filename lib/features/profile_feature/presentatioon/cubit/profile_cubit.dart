// cubit/profile_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:dion_app/features/profile_feature/data/repostry/profile_data_repostry_impl.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileDataRepostryImpl profileDataRepostryImpl;

  ProfileCubit({required this.profileDataRepostryImpl}) : super(ProfileInitial());

  Future<void> fetchProfileData() async {
    emit(ProfileLoading());
    try {
      final profile = await profileDataRepostryImpl.getProfileData();
      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

    void resetProfile() {
    emit(ProfileInitial());
  }
  
}
