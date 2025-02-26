import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../data/models/loaning_data.dart';

class CardWidget extends StatelessWidget {
  final LoaningData state;
  const CardWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return  Stack(
      children: [
        Positioned(
          bottom: 90,
          left: 0,
          right: 0,
          child: Container(
            child: Stack(
                children:[
                  SvgPicture.asset(
                    "assets/images/decoration.svg",
                    fit: BoxFit.fill,
                    height: 150,
                    color: Color(0xff353F4F),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,

                      top: 15
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("You Owe",style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Color(0xffFD6972),
                            ),),
                            Container(
                              margin: EdgeInsets.only(bottom: 5),
                              height: MediaQuery.sizeOf(context).height*0.05,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text("Lyd",style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Color(0xffFD6972),
                                  ),),
                                  Text(state.totalSettledDebts.toString(),style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                    color: Color(0xffFD6972),
                                  ),),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Text("Debts",style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Color(0xffFD6972),
                                  fontSize: 18,
                                ),),
                                Text(state.borrowersCount.toString(),style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Color(0xffFD6972),
                                  fontSize: 18,
                                ),),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("You Give",style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Color(0xff42FFF9),
                            ),),
                            Container(
                              margin: EdgeInsets.only(bottom: 5),
                              height: MediaQuery.sizeOf(context).height*0.05,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text("Lyd",style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Color(0xff42FFF9),
                                    fontSize:10,
                                  ),),
                                  Text(state.totalSettledDebtors.toString(),style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                    color: Color(0xff42FFF9),
                                  ),),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Text("Debtors",style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Color(0xff42FFF9),
                                  fontSize: 18,
                                ),),
                                Text(state.lendersCount.toString(),style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Color(0xff42FFF9),
                                  fontSize: 18,
                                ),),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),


                  Positioned(
                    top: 20,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                     margin: EdgeInsets.all(20),
                        child: SvgPicture.asset("assets/images/balance.svg")),
                  ),

                ]
            ),
          ),

        ),
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Stack(
              children:[ SvgPicture.asset(
                "assets/images/decoration.svg",
                fit: BoxFit.fill,
                height: 120,
                color: Color(0xff5678B0),
              ),
                Padding(
                  padding:  EdgeInsets.only(
                    top: MediaQuery.sizeOf(context).height*0.03,
                    left: MediaQuery.sizeOf(context).width*0.05,
                    right: MediaQuery.sizeOf(context).width*0.05,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [

                          Text("TAKE",style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Color(0xffFD6972),
                            fontSize: 30
                          ),),
                          SvgPicture.asset("assets/icons/buttomArr.svg",height: MediaQuery.sizeOf(context).height*0.03,),

                        ],
                      ),
                      Row(
                        children: [

                          Text("GIVE",style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Color(0xff42FFF9),
                              fontSize: 30
                          ),),
                          SvgPicture.asset("assets/icons/topArr.svg",height: MediaQuery.sizeOf(context).height*0.03,),
                        ],
                      )
                    ],
                  ),
                )
    ]
            )),


      ],
    );
  }
}
