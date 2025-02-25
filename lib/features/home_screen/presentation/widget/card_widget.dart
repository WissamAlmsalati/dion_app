import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Add import for SvgPicture
import '../../data/models/loaning_data.dart';

class CardWidget extends StatelessWidget {
  final LoaningData state;
  const CardWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Bottom Positioned Widgets
        Positioned(
          bottom: 140, // First bottom positioned widget
          left: 0,
          right: 0,
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.13,
                child: SvgPicture.asset(
                  'assets/images/buttom_nav_bar.svg',
                  fit: BoxFit.fill,
                  color: const Color(0xff353F4F),
                ),
              ),
              const Positioned(
                top: 18,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Take",
                      style: TextStyle(
                        fontSize: 40,
                        color: Color(0xffF2F2F2),
                      ),
                    ),
                    SizedBox(width: 100),
                    Text(
                      "Give",
                      style: TextStyle(
                        fontSize: 40,
                        color: Color(0xffF2F2F2),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Positioned(
          bottom: 60, // Second bottom positioned widget
          left: 0,
          right: 0,
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.13,
                child: SvgPicture.asset(
                  'assets/images/buttom_nav_bar.svg',
                  fit: BoxFit.fill,
                  color: const Color(0xff455B7D),
                ),
              ),
              const Positioned(
                top: 18,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Take",
                      style: TextStyle(
                        fontSize: 40,
                        color: Color(0xffF2F2F2),
                      ),
                    ),
                    SizedBox(width: 100),
                    Text(
                      "Give",
                      style: TextStyle(
                        fontSize: 40,
                        color: Color(0xffF2F2F2),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: -20, // Third bottom positioned widget
          left: 0,
          right: 0,
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.13,
                child: SvgPicture.asset(
                  'assets/images/buttom_nav_bar.svg',
                  fit: BoxFit.fill,
                  color: const Color(0xff5678B0),
                ),
              ),
            ],
          ),
        ),
        
        // Main Content Positioned in the center
        Positioned(
          top: 100, // Adjusted to make space for the bottom sections
          left: 16,
          right: 16,
          child: Card(
            color: Colors.white,
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
                        "${state.borrowersCount}",
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
                        "${state.totalSettledDebtors}",
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
                        "${state.lendersCount}",
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
                        "${state.totalSettledDebts}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
