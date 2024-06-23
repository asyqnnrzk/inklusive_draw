import 'package:InklusiveDraw/model/user/user_content_model.dart';
import 'package:flutter/material.dart';
import '../../../source/colors.dart';
import '../../../source/image_strings.dart';
import '../../../source/text_theme.dart';

class UserContent extends StatelessWidget {
  const UserContent({super.key});

  @override
  Widget build(BuildContext context) {

    final list = UserDashboardContent.list;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent activities',
          style: LightTextTheme.dashboardHeadline,
        ),
        // SizedBox(
        //   height: 200,
        //   child: ListView.builder(
        //     itemCount: list.length,
        //     shrinkWrap: true,
        //     scrollDirection: Axis.horizontal,
        //     itemBuilder: (context, index) =>
        //         GestureDetector(
        //           onTap: list[index].onPress,
        //           child: SizedBox(
        //             width: 320,
        //             height: 200,
        //             child: Padding(
        //               padding: const EdgeInsets.only(right: 10, top: 10),
        //               child: Container(
        //                 decoration: BoxDecoration(
        //                     borderRadius: BorderRadius.circular(10),
        //                     color: primaryColor
        //                 ),
        //                 padding: const EdgeInsets.all(10),
        //                 child: Column(
        //                   crossAxisAlignment: CrossAxisAlignment.start,
        //                   children: [
        //                     Row(
        //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                       children: [
        //                         Flexible(
        //                           child: Text(
        //                             list[index].title,
        //                             style: LightTextTheme.dashboardTxt,
        //                             maxLines: 2,
        //                             overflow: TextOverflow.ellipsis,
        //                           ),
        //                         ),
        //                         const Flexible(
        //                           child: Image(
        //                             image: AssetImage(
        //                                 onBoardImage1
        //                             ),
        //                             height: 110,
        //                           ),
        //                         )
        //                       ],
        //                     ),
        //                     Row(
        //                       children: [
        //                         ElevatedButton(
        //                           style: ElevatedButton.styleFrom(shape: const CircleBorder()),
        //                           onPressed: () {
        //
        //                           },
        //                           child: const Icon(Icons.play_arrow_rounded),
        //                         ),
        //                         const SizedBox(width: 8),
        //                         Column(
        //                           crossAxisAlignment: CrossAxisAlignment.start,
        //                           children: [
        //                             Text(
        //                               list[index].heading,
        //                               style: LightTextTheme.dashboardTxt,
        //                               overflow: TextOverflow.ellipsis,
        //                             ),
        //                             Text(
        //                               list[index].subHeading,
        //                               style: LightTextTheme.dashboardTxt,
        //                               overflow: TextOverflow.ellipsis,
        //                             ),
        //                           ],
        //                         )
        //                       ],
        //                     )
        //                   ],
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ),
        //   ),
        // ),
      ],
    );
  }
}
