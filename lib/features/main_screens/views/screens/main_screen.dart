import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../home_screen/presentation/screens/home_screen.dart';
import '../../../create_loan_feature/presentation/views/loaning_screen.dart';
import '../../../loans_list/presentation/views/loans_screen.dart';
import '../../toggle_screen_bloc/screen_bloc.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve the BottomNavigationBar theme from the current context.
    final bottomNavTheme = Theme.of(context).bottomNavigationBarTheme;

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
            LoanListScreen(),
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
                color: bottomNavTheme.backgroundColor, // Use theme's background color
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
                items: [
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      'assets/icons/home.svg',
                      width: 30,
                      height: 30,
                      // Apply a color filter from the theme based on selection
                      color: currentIndex == 0
                          ? bottomNavTheme.selectedItemColor!
                          : bottomNavTheme.unselectedItemColor!,
                    ),
                    label: 'الرئيسية',
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      'assets/icons/Wallet.svg',
                      width: 30,
                      height: 30,
                      color:  currentIndex == 1
                            ? bottomNavTheme.selectedItemColor!
                            : bottomNavTheme.unselectedItemColor!,
                    ),
                    label: 'إنشاء قرض',
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      'assets/icons/Chart.svg',
                      width: 30,
                      height: 30,
                      color: currentIndex == 2
                          ? bottomNavTheme.selectedItemColor!
                          : bottomNavTheme.unselectedItemColor!,
                       
                    ),
                    label: 'القروض',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
