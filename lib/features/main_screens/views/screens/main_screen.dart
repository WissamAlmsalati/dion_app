import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import '../../../home_screen/presentation/screens/home_screen.dart';
import '../../../create_loan_feature/presentation/views/loaning_screen.dart';
import '../../../loans_list/presentation/views/loans_screen.dart';
import '../../toggle_screen_bloc/screen_bloc.dart';

final GetIt getIt = GetIt.instance;

class MainScreen extends StatelessWidget {
  MainScreen({Key? key}) : super(key: key);

  // Declared as a final field. Note: It won't be disposed automatically!
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    final bottomNavTheme = Theme.of(context).bottomNavigationBarTheme;

    return BlocProvider<NavigationBloc>(
      create: (context) => getIt<NavigationBloc>(),
      child: BlocListener<NavigationBloc, NavigationState>(
        listener: (context, state) {
          if (state is NavigationChanged) {
            _pageController.animateToPage(
              state.screenIndex,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        },
        child: BlocBuilder<NavigationBloc, NavigationState>(
          builder: (context, state) {
            int currentIndex = 0;
            if (state is NavigationChanged) {
              currentIndex = state.screenIndex;
            }
            return Scaffold(
              backgroundColor: Colors.white,
              body: PageView(
                controller: _pageController,
                children: [
                  const HomeScreen(),
                  LoaningScreen(),
                  const LoanListScreen(),
                ],
                onPageChanged: (index) {
                  context.read<NavigationBloc>().add(NavigateToScreen(index));
                },
              ),
              bottomNavigationBar: CustomNavBar(currentIndex: currentIndex),
            );
          },
        ),
      ),
    );
  }
}








class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  
  const CustomNavBar({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bottomNavTheme = Theme.of(context).bottomNavigationBarTheme;
    
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
            context: context,
            icon: 'assets/icons/home.svg',
            label: 'الرئيسية',
            index: 0,
            currentIndex: currentIndex,
            bottomNavTheme: bottomNavTheme,
          ),
          _buildNavItem(
            context: context,
            icon: 'assets/icons/Wallet.svg',
            label: 'إنشاء قرض',
            index: 1,
            currentIndex: currentIndex,
            bottomNavTheme: bottomNavTheme,
          ),
          _buildNavItem(
            context: context,
            icon: 'assets/icons/Chart.svg',
            label: 'القروض',
            index: 2,
            currentIndex: currentIndex,
            bottomNavTheme: bottomNavTheme,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required String icon,
    required String label,
    required int index,
    required int currentIndex,
    required BottomNavigationBarThemeData bottomNavTheme,
  }) {
    final isSelected = currentIndex == index;
    
    return InkWell(
      onTap: () {
        context.read<NavigationBloc>().add(NavigateToScreen(index));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            icon,
            width: 30,
            height: 30,
            color: isSelected
                ? bottomNavTheme.selectedItemColor!
                : bottomNavTheme.unselectedItemColor!,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? bottomNavTheme.selectedItemColor!
                  : bottomNavTheme.unselectedItemColor!,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}