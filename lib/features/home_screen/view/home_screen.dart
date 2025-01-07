import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../repository/loaning_repository.dart';
import '../viewmodel/loaning_bloc.dart';
import '../../authintication_feature/viewmodel/auth_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ديون'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthenticationBloc>().add(LogoutEvent());
            },
          ),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthenticationBloc, AuthState>(
            listener: (context, state) {
              if (state is Unauthenticated || state is LogOutSucess) {
                context.go('/login');
              }
            },
          ),
          BlocListener<AuthenticationBloc, AuthState>(
            listener: (context, state) {
              if (state is LogOutError) {
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
              return Stack(
                children: [
                  Positioned(
                    top: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.2,
                      decoration: BoxDecoration(
                        color: AppTheme.mainColor,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  const Positioned(
                    top: 0,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '"اهلا "اسم المستخدم"',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'الديون المستحقة',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 100.0),
                        child: Card(
                          color: Colors.white,
                          margin: const EdgeInsets.all(16),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                     Text(
                                      "عدد المقترضين",
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "${state.loaningData.borrowersCount}",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 16),
Text(
  "المبالغ المستحقة",
  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.bold,
  ),
),
                                    const SizedBox(height: 8),
                                    Text(
                                      "${state.loaningData.totalSettledDebtors}",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),




                                const SizedBox(width: 20),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                     Text(
                                      "عدد المقرضين",
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "${state.loaningData.lendersCount}",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 16),
                                     Text(
                                      "المبالغ المستحقة",
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "${state.loaningData.totalSettledDebts}",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else if (state is LoaningError) {
              return Center(child: Text('Error: ${state.message}'));
            } else {
              return const Center(
                  child: Text('Press the button to fetch data'));
            }
          },
        ),
      ),
    );
  }
}