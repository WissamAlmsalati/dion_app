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

          List<Widget> screens = [
            const HomeScreen(),
            const LoaningScreen(),
            LoanListScreen()
          ];

          return Scaffold(
            body: screens[currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: (index) {
                try {
                  context.read<NavigationBloc>().add(NavigateToScreen(index));
                } catch (e) {
                  if (kDebugMode) {
                    print(e);
                  }
                }
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
                BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifications'),
              ],
            ),
          );
        },
      ),
    );
  }
}