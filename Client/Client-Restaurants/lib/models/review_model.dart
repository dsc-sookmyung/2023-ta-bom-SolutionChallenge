import 'package:good_to_go_restaurant/models/user_model.dart';

class ReviewModel {
  final String id, reviewText, imgUrl, restrtId, orderId;
  String userId, userImgUrl, userName;
  late String? emoji;
  final num starRating;
  final int createdAt;

  ReviewModel.fromJsonWithUser(Map<String, dynamic> json, UserModel user)
      : id = json['id'],
        reviewText = json['review_text'],
        imgUrl = json['img'],
        restrtId = json['restrt_id'],
        orderId = json['order_id'],
        starRating = json['star_rating'],
        createdAt = json['created_at']['_seconds'] * 1000 +
            (json['created_at']['_nanoseconds'] / 1000000).round(),
        userId = user.uid,
        userName = user.displayName,
        userImgUrl = user.photoUrl,
        emoji = json['emoji'];
}
