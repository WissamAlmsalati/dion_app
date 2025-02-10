import 'package:dion_app/core/theme/app_theme.dart';
import 'package:dion_app/core/widgets/custom_dialog.dart';
import 'package:dion_app/features/authintication_feature/services/auth_service.dart';
import 'package:dion_app/features/authintication_feature/viewmodel/auth_bloc.dart';
import 'package:dion_app/features/profile_feature/data/models/profile_data.dart';
import 'package:dion_app/features/profile_feature/data/repostry/profile_data_repostry_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger fetching of the profile data when the screen loads.
    // Ensure that your ProfileCubit has a method called fetchProfile() (or similar).
    context.read<ProfileCubit>().fetchProfileData();
  }

  /// Builds the main content of the profile screen.
  Widget _buildProfileContent(BuildContext context, ProfileData profile) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blueGrey.shade300,
              child: Text(
                profile.username.isNotEmpty
                    ? profile.username.substring(0, 1).toUpperCase()
                    : '',
                style: const TextStyle(fontSize: 40, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              profile.username,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: Column(
                  children: [
                    _buildInfoRow(
                      icon: Icons.email,
                      label: 'Email',
                      value: profile.email,
                    ),
                    const Divider(),
                    _buildInfoRow(
                      icon: Icons.phone,
                      label: 'Phone',
                      value: profile.phoneNumber,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper method to build a row of information.
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.textColor),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.textColor,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الملف الشخصي'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return WillPopScope(
                    onWillPop: () async => false,
                    child: CustomDialog(
                      title: "تسجيل الخروج",
                      content: "هل أنت متأكد أنك تريد تسجيل الخروج؟",
                      confirmText: "نعم",
                      cancelText: "إلغاء",
                      onConfirm: () {
                        // Dispatch logout event.
                        context.read<AuthenticationBloc>().add(LogoutEvent());
                        // Reset the profile state.
                        context.read<ProfileCubit>().resetProfile();
                      },
                    ),
                  );
                },
              );
            },
            icon: const Icon(Icons.logout, color: AppTheme.textColor),
          ),
        ],
        leading: IconButton(
          onPressed: () {
            context.push("/main_screen");
          },
          icon: Icon(Icons.arrow_back, color: AppTheme.textColor),
        ),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            // While the profile data is loading, show a loading indicator.
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            // When the profile is loaded, show the profile content.
            return _buildProfileContent(context, state.profile);
          } else if (state is ProfileError) {
            // If there is an error, display the error message.
            return Center(child: Text('Error: ${state.message}'));
          }
          // Optionally, if the state is initial or unknown, you can show a loading message.
          return const Center(child: Text('Loading profile...'));
        },
      ),
    );
  }
}
