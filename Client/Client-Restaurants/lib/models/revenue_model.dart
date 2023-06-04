class RevenueModel {
  final int todayRevenue;
  final int monthRevenue;
  final List<dynamic> lastSixRevenueList;

  RevenueModel.fromJson(Map<String, dynamic> json)
      : todayRevenue = json['todayRevenue'],
        monthRevenue = json['monthRevenue'],
        lastSixRevenueList = json["lastSixRevenueList"];
}
