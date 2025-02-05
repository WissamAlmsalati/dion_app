import 'package:flutter/material.dart';

import '../../models/loaning_data.dart';

class CardWidget extends StatelessWidget {
  final LoaningData state;
  const CardWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Card(
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
    );
  }
}
