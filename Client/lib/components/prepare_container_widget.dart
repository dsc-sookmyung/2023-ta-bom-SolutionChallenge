import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:good_to_go/components/prepare_container_dialog.dart';
import 'package:good_to_go/models/food_container_model.dart';
import 'package:good_to_go/utilities/colors.dart';
import 'package:good_to_go/utilities/styles.dart';

import 'prepare_container.dart';

class PrepareContainerWdiget extends StatelessWidget {
  final List<FoodContainer> containerList;
  const PrepareContainerWdiget({required this.containerList, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              "준비할 용기",
              style: FontStyle.captionStyle,
            ),
            SizedBox(
              width: 6.w,
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const PrePareContainerDialog();
                    });
              },
              child: SvgPicture.asset(
                'assets/icons/help.svg',
                width: 16.w,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 6.h,
        ),
        Container(
          decoration: BoxDecoration(
            color: GrayScale.g100,
            borderRadius: const BorderRadius.all(Radius.circular(6)).r,
          ),
          child: GridView(
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: 27.w,
              vertical: 20.h,
            ),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 4.h,
            ),
            children: [
              for (var container in containerList)
                PrepareContainer(container.containerNum),
            ],
          ),
        ),
      ],
    );
  }
}
