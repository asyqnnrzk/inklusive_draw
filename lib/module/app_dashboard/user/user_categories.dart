import 'package:flutter/material.dart';
import '../../../model/user/user_categories_model.dart';
import '../../../source/colors.dart';
import '../../../source/text_theme.dart';

class UserCategories extends StatelessWidget {
  const UserCategories({super.key});

  @override
  Widget build(BuildContext context) {
    
    final list = UserDashboardCategories.list;
    
    return SizedBox(
      height: 60,
      child: ListView.builder(
        itemCount: list.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) =>
            GestureDetector(
              onTap: list[index].onPress,
              child: SizedBox(
                width: 170,
                height: 50,
                child: Row(
                  children: [
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: primaryColor
                      ),
                      child: Center(
                        child: Text(
                          list[index].title,
                          style: LightTextTheme.dashboardTxt.apply(
                              color: Colors.white70
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            list[index].heading,
                            style: LightTextTheme.dashboardTxtBold,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            list[index].subHeading,
                            style: LightTextTheme.dashboardTxt,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
        // children: [
        //   SizedBox(
        //     width: 170,
        //     height: 50,
        //     child: Row(
        //       children: [
        //         Container(
        //           width: 45,
        //           height: 45,
        //           decoration: BoxDecoration(
        //               borderRadius: BorderRadius.circular(10),
        //               color: primaryColor
        //           ),
        //           child: Center(
        //             child: Text(
        //               '1',
        //               style: LightTextTheme.dashboardTxt.apply(
        //                   color: Colors.white70
        //               ),
        //             ),
        //           ),
        //         ),
        //         const SizedBox(width: 5),
        //         Flexible(
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             children: [
        //               Text(
        //                 'This',
        //                 style: LightTextTheme.dashboardTxtBold,
        //                 overflow: TextOverflow.ellipsis,
        //               ),
        //               Text(
        //                 'That',
        //                 style: LightTextTheme.dashboardTxt,
        //                 overflow: TextOverflow.ellipsis,
        //               )
        //             ],
        //           ),
        //         )
        //       ],
        //     ),
        //   ),
        //   SizedBox(
        //     width: 170,
        //     height: 50,
        //     child: Row(
        //       children: [
        //         Container(
        //           width: 45,
        //           height: 45,
        //           decoration: BoxDecoration(
        //               borderRadius: BorderRadius.circular(10),
        //               color: primaryColor
        //           ),
        //           child: Center(
        //             child: Text(
        //               '2',
        //               style: LightTextTheme.dashboardTxt.apply(
        //                   color: Colors.white70
        //               ),
        //             ),
        //           ),
        //         ),
        //         const SizedBox(width: 5),
        //         Flexible(
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             children: [
        //               Text(
        //                 'This',
        //                 style: LightTextTheme.dashboardTxtBold,
        //                 overflow: TextOverflow.ellipsis,
        //               ),
        //               Text(
        //                 'That',
        //                 style: LightTextTheme.dashboardTxt,
        //                 overflow: TextOverflow.ellipsis,
        //               )
        //             ],
        //           ),
        //         )
        //       ],
        //     ),
        //   ),
        //   SizedBox(
        //     width: 170,
        //     height: 50,
        //     child: Row(
        //       children: [
        //         Container(
        //           width: 45,
        //           height: 45,
        //           decoration: BoxDecoration(
        //               borderRadius: BorderRadius.circular(10),
        //               color: primaryColor
        //           ),
        //           child: Center(
        //             child: Text(
        //               '3',
        //               style: LightTextTheme.dashboardTxt.apply(
        //                   color: Colors.white70
        //               ),
        //             ),
        //           ),
        //         ),
        //         const SizedBox(width: 5),
        //         Flexible(
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             children: [
        //               Text(
        //                 'This',
        //                 style: LightTextTheme.dashboardTxtBold,
        //                 overflow: TextOverflow.ellipsis,
        //               ),
        //               Text(
        //                 'That',
        //                 style: LightTextTheme.dashboardTxt,
        //                 overflow: TextOverflow.ellipsis,
        //               )
        //             ],
        //           ),
        //         )
        //       ],
        //     ),
        //   ),
        // ],
      ),
    );
  }
}
