// screens/profile_screen.dart

import 'package:dion_app/features/profile_feature/data/repostry/profile_data_repostry_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

@override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(profileDataRepostryImpl: ProfileDataRepostryImpl())..fetchProfileData(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الملف الشخصي'),
        ),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileLoaded) {
              final profile = state.profile;
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Name: ${profile.username}'),
                    Text('Email: ${profile.email}'),
                    Text('Phone: ${profile.phoneNumber}'),
                  ],
                ),
              );
            } else if (state is ProfileError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const Center(child: Text('Please wait...'));
          },
        ),
      ),
    );
  }
}
