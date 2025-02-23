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
              bottomNavigationBar: Container(
               
                decoration: BoxDecoration(
                  color: bottomNavTheme.backgroundColor,
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
                    context.read<NavigationBloc>().add(NavigateToScreen(index));
                  },
                  items: [
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(
                        'assets/icons/home.svg',
                        width: 30,
                        height: 30,
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
                        color: currentIndex == 1
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
      ),
    );
  }
}





class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final ThemeData theme;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.theme,
  }) : super(key: key);

  // Your provided SVG path data
  static const String _svgPath = '''
<svg width="430" height="71" viewBox="0 0 430 71" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M430 17.483V71H-1V17.483C-1 7.83037 11.59 0 27.11 0H136.17C140.22 0 143.92 1.42427 145.73 3.67573L151.17 10.4426C153.84 13.7638 159.3 15.8598 165.27 15.8598H263.73C269.7 15.8598 275.16 13.7638 277.83 10.4426L283.27 3.67573C285.08 1.42427 288.78 0 292.83 0H401.89C417.41 0 430 7.83037 430 17.483Z" fill="white"/>
</svg>
''';

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // SVG Background
        SvgPicture.string(
          _svgPath,
          width: MediaQuery.of(context).size.width,
          height: 71,
          fit: BoxFit.fill,
        ),
        // Navigation Items
        BottomNavigationBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          currentIndex: currentIndex,
          onTap: onTap,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/home.svg',
                width: 30,
                height: 30,
                color: currentIndex == 0
                    ? theme.bottomNavigationBarTheme.selectedItemColor
                    : theme.bottomNavigationBarTheme.unselectedItemColor,
              ),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/Wallet.svg',
                width: 30,
                height: 30,
                color: currentIndex == 1
                    ? theme.bottomNavigationBarTheme.selectedItemColor
                    : theme.bottomNavigationBarTheme.unselectedItemColor,
              ),
              label: 'إنشاء قرض',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/Chart.svg',
                width: 30,
                height: 30,
                color: currentIndex == 2
                    ? theme.bottomNavigationBarTheme.selectedItemColor
                    : theme.bottomNavigationBarTheme.unselectedItemColor,
              ),
              label: 'القروض',
            ),
          ],
        ),
      ],
    );
  }
}