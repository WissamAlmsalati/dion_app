import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../home_screen/view/home_screen.dart';
import '../../../loaning_feature/views/loaning_screen.dart';
import '../../../loans_list/views/loans_screen.dart';
import '../../viewmodel/screen_bloc.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigationBloc(),
      child: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          int currentIndex = 0;
          if (state is NavigationChanged) {
            currentIndex = state.screenIndex;
          }

          final PageController pageController =
              PageController(initialPage: currentIndex);

          List<Widget> screens = [
            const HomeScreen(),
            const LoaningScreen(),
            LoanListScreen()
          ];

          return Scaffold(
            backgroundColor: Colors.white,
            body: PageView(
              controller: pageController,
              children: screens,
              onPageChanged: (index) {
                context.read<NavigationBloc>().add(NavigateToScreen(index));
              },
            ),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
              child: BottomNavigationBar(
                currentIndex: currentIndex,
                onTap: (index) {
                  try {
                    pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                    context.read<NavigationBloc>().add(NavigateToScreen(index));
                  } catch (e) {
                    if (kDebugMode) {
                      print(e);
                    }
                  }
                },
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home), label: 'الرئيسية'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.add), label: "إنشاء قرض"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.attach_money), label: 'القروض'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
