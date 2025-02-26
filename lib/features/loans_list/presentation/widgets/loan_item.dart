import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/models/loan.dart';
import '../../../loand_detail_feature/presentation/view/loan_detail.dart';

class LoanListItem extends StatelessWidget {
  final String loadType;
  final Loan loan;

  const LoanListItem({super.key, required this.loan, required this.loadType});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoanDetailScreen(
              loanId: loan.id,
              loadType: loadType,
            ),
          ),
        );
      },
      child: Container(
        height: MediaQuery.sizeOf(context).height * 0.1,
        decoration: BoxDecoration(
          color: Color(0xff353F4F), // You can change the color if needed
          // Apply border only on top
          border: Border(
            bottom: BorderSide(
              color: Colors.white, // Set the color of the border
              width: 1, // Set the width of the border
            ),

          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Leading Icon
              CircleAvatar(
                backgroundColor: Colors.blueGrey.shade100,
                child: Icon(
                  Icons.monetization_on,
                  color: Colors.blueGrey.shade800,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                width: 1,
                color: Colors.white,
              ),
              SizedBox(width: 12), // Spacing between the icon and text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Text
                    Text(
                      loan.deptName,
                      style:Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white
                      )
                    ),
                    SizedBox(height: 4), // Space between title and subtitle
                    // Subtitle Text
                    Text(
                      'القيمة: ${loan.amount.toStringAsFixed(2)} د.ل',
                      style:Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white
                    )
                    ),
                  ],
                ),
              ),


              Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                width: 1,
                color: Colors.white,
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
