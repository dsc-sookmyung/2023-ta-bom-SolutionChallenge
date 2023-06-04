import 'dart:io';
import 'package:flutter/material.dart';
import 'package:good_to_go/components/app_bar.dart';
import 'package:good_to_go/components/base_scaffold.dart';
import 'package:good_to_go/provider/user_provider.dart';
import 'package:good_to_go/screens/store/screens/store_screen.dart';
import 'package:good_to_go/services/review_service.dart';
import 'package:good_to_go/utilities/colors.dart';
import 'package:good_to_go/utilities/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../components/base_filled_button.dart';

class WriteReviewScreen extends StatefulWidget {
  final String storeId;
  final String orderId;
  const WriteReviewScreen(
      {Key? key, required this.storeId, required this.orderId})
      : super(key: key);

  @override
  State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  final appBarTitle = "리뷰 작성";
  final TextEditingController _textController = TextEditingController();
  int? ratingValue;
  File? reviewImg;
  bool isBtnClicked = false;
  @override
  void initState() {
    super.initState();
  }

  bool isButtonDisable() {
    return ratingValue == null ||
        ratingValue == 0 ||
        reviewImg == null ||
        _textController.text == "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(appBarTitle),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15).w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 22.h,
                  ),
                  Text(
                    '사진',
                    style: FontStyle.captionStyle,
                  ),
                  const SpaceUnderCaption(),
                  GestureDetector(
                    onTap: () async {
                      ImagePicker picker = ImagePicker();
                      final image =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        reviewImg = File(image.path);
                        setState(() {});
                      }
                    },
                    child: reviewImg == null
                        ? Container(
                            decoration: BoxDecoration(
                              color: GrayScale.g100,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(6)).r,
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 106.h),
                              child: SvgPicture.asset(
                                  'assets/icons/add_a_photo.svg',
                                  height: 48.h),
                            ),
                          )
                        : ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(6)).r,
                            child: Container(
                              height: 260.h,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  alignment: FractionalOffset.center,
                                  image:
                                      Image.file(File(reviewImg!.path)).image,
                                ),
                              ),
                            ),
                          ),
                  ),
                  const SpaceUnderWidget(),
                  Text(
                    '별점',
                    style: FontStyle.captionStyle,
                  ),
                  const SpaceUnderCaption(),
                  Container(
                    alignment: Alignment.center,
                    height: 54.w,
                    decoration: BoxDecoration(
                      color: GrayScale.g100,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(6)).r,
                    ),
                    child: RatingBar(
                      initialRating: 0,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      glow: false,
                      itemSize: 28.w,
                      ratingWidget: RatingWidget(
                        full: SvgPicture.asset('assets/icons/star_filled.svg'),
                        half: SvgPicture.asset('assets/icons/star_half.svg'),
                        empty: SvgPicture.asset('assets/icons/star_line.svg'),
                      ),
                      itemPadding: const EdgeInsets.symmetric(horizontal: 10).w,
                      onRatingUpdate: (rating) {
                        ratingValue = rating.round();
                        setState(() {});
                      },
                    ),
                  ),
                  const SpaceUnderWidget(),
                  Text(
                    '리뷰',
                    style: FontStyle.captionStyle,
                  ),
                  const SpaceUnderCaption(),
                  TextField(
                    onChanged: (value) => setState(() {}),
                    controller: _textController,
                    style: FontStyle.textInTextFieldStyle,
                    maxLines: 7,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: '리뷰를 작성해 주세요.',
                      hintStyle: FontStyle.hintTextInTextFieldStyle,
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: textFieldDefaultBorderStyle,
                      enabledBorder: textFieldDefaultBorderStyle,
                      contentPadding: const EdgeInsets.all(18).w,
                    ),
                  ),
                  SizedBox(
                    height: 32.h,
                  ),
                  BaseFilledButton(isDisable: isButtonDisable(), '리뷰 작성하기',
                      () async {
                    if (!isBtnClicked) {
                      isBtnClicked = true;
                      final Map<String, dynamic> reviewData = {
                        "user_id": context.read<UserProvider>().user!.uid,
                        "review_text": _textController.text,
                        "star_rating": ratingValue.toString(),
                        "img": reviewImg!.path,
                        "restrt_id": widget.storeId,
                        "order_id": widget.orderId,
                        "emoji": ""
                      };

                      await ReviewService.postReview(reviewData);

                      if (context.mounted) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('리뷰 작성을 완료했습니다.'),
                          duration: Duration(seconds: 1),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: GrayScale.g800,
                        ));
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BaseScaffold()),
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  StoreScreen(storeId: widget.storeId)),
                        );
                      }
                    }
                  }),
                  SizedBox(
                    height: 32.h,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SpaceUnderWidget extends StatelessWidget {
  const SpaceUnderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28.h,
    );
  }
}

class SpaceUnderCaption extends StatelessWidget {
  const SpaceUnderCaption({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 6.h,
    );
  }
}
