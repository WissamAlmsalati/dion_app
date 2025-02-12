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

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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
                children: const [
                  HomeScreen(),
                  LoaningScreen(),
                  LoanListScreen(),
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
