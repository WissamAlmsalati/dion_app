


import 'package:dion_app/features/profile_feature/data/models/profile_data.dart';

abstract class ProfileDataRepository {
  Future<ProfileData> getProfileData();
  Future<void> updateProfileData(ProfileData profileData);
}