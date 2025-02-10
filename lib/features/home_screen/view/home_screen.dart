import 'package:dion_app/features/authintication_feature/services/auth_service.dart';
import 'package:dion_app/features/home_screen/view/widget/card_widget.dart';
import 'package:dion_app/features/profile_feature/presentatioon/cubit/profile_cubit.dart';
import 'package:dion_app/features/profile_feature/presentatioon/cubit/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/custom_dialog.dart';
import '../viewmodel/loaning_bloc.dart';
import '../../authintication_feature/viewmodel/auth_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final profileCubit = context.read<ProfileCubit>();
    if (profileCubit.state is ProfileInitial) {
      profileCubit.fetchProfileData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ديون'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            context.push("/profile_screen");
          },
          icon: Icon(Icons.person, color: AppTheme.textColor),
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          // Listen for authentication state changes.
          BlocListener<AuthenticationBloc, AuthState>(
            listener: (context, state) {
              if (state is Unauthenticated || state is LogOutSucess) {
                context.go('/login');
              } else if (state is LogOutError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${state.message}')),
                );
              }
            },
          ),
          // Listen for loaning errors.
          BlocListener<LoaningBloc, LoaningState>(
            listener: (context, state) {
              if (state is LoaningError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${state.message}')),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<LoaningBloc, LoaningState>(
          builder: (context, state) {
            if (state is LoaningLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is LoaningLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  // Refresh loaning data.
                  context.read<LoaningBloc>().add(FetchLoaningData());
                  // Optionally, refresh the profile data as well.
                  context.read<ProfileCubit>().fetchProfileData();
                },
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Display the username or loading indicator using ProfileCubit.
                          BlocBuilder<ProfileCubit, ProfileState>(
                            builder: (context, profileState) {
                              if (profileState is ProfileLoading) {
                                return Row(
                                  children: [
                                    SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                            AppTheme.textColor),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'تحميل...',
                                      style: TextStyle(
                                        color: AppTheme.textColor,
                                        fontSize: Theme.of(context)
                                                .textTheme
                                                .titleLarge
                                                ?.fontSize ??
                                            24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                );
                              } else if (profileState is ProfileLoaded) {
                                final username = profileState.profile.username;
                                return Text(
                                  'أهلا ${username.isNotEmpty ? username : "المستخدم"}',
                                  style: TextStyle(
                                    color: AppTheme.textColor,
                                    fontSize: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.fontSize ??
                                        24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              } else if (profileState is ProfileError) {
                                return Text(
                                  'Error: ${profileState.message}',
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              } else {
                                return Text(
                                  'أهلا المستخدم',
                                  style: TextStyle(
                                    color: AppTheme.textColor,
                                    fontSize: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.fontSize ??
                                        24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'الديون المستحقة',
                            style: TextStyle(
                              color: AppTheme.textColor,
                              fontSize: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.fontSize ??
                                  18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    Center(
                      child: CardWidget(
                        state: state.loaningData,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
