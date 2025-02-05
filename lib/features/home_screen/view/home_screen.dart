import 'package:dion_app/features/home_screen/view/widget/card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/custom_dialog.dart';
import '../viewmodel/loaning_bloc.dart';
import '../../authintication_feature/viewmodel/auth_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoaningBloc()..add(FetchLoaningData()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ديون'),
          centerTitle: true,
          leading: IconButton(onPressed: (){
            context.push("/profile_screen");

          }, icon: Icon(Icons.person,color: AppTheme.textColor,)),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout,color: AppTheme.textColor,),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => CustomDialog(
                    title: "تسجيل الخروج",
                    content: "هل أنت متأكد أنك تريد تسجيل الخروج؟",
                    confirmText: "نعم",
                    cancelText: "إلغاء",
                    onConfirm: () {
                      context.read<AuthenticationBloc>().add(LogoutEvent());
                    },
                  ),
                );
              },
            ),
          ],
        ),
        body: BlocListener<AuthenticationBloc, AuthState>(
          listener: (context, state) {
            if (state is Unauthenticated || state is LogOutSucess) {
              context.go('/login');
            } else if (state is LogOutError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.message}')),
              );
            }
          },
          child: BlocConsumer<LoaningBloc, LoaningState>(
            listener: (context, state) {
              if (state is LoaningError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${state.message}')),
                );
              }
            },
            builder: (context, state) {
              if (state is LoaningLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is LoaningLoaded) {
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<LoaningBloc>().add(FetchLoaningData());
                  },
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '"اهلا "اسم المستخدم"',
                            style: TextStyle(
                              color: AppTheme.textColor,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.fontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'الديون المستحقة',
                            style: TextStyle(
                              color: AppTheme.textColor,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.fontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
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
      ),
    );
  }
}
