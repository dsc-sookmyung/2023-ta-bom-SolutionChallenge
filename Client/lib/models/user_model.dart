class UserModel {
  final String uid,
      email,
      displayName,
      photoUrl,
      lastSignInTime,
      creationTime,
      lastRefreshTime,
      tokensValidAfterTime;
  final bool emailVerified, disabled;

  UserModel.fromJson(Map<String, dynamic> json)
      : uid = json["uid"],
        emailVerified = json["emailVerified"],
        disabled = json["disabled"],
        email = json["email"],
        displayName = json["displayName"],
        photoUrl = json["photoURL"],
        lastSignInTime = json["metadata"]["lastSignInTime"],
        creationTime = json["metadata"]["creationTime"],
        lastRefreshTime = json["metadata"]["lastRefreshTime"],
        tokensValidAfterTime = json["tokensValidAfterTime"];
}
