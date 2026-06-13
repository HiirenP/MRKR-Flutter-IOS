import 'package:json_annotation/json_annotation.dart';
import 'package:marker/app/data/models/common/common.dart';

part 'bar_home_model.g.dart';

BarHomeModel deserializeBarHomeModel(Map<String, dynamic> json) => BarHomeModel.fromJson(json);

Map<String, dynamic> serializeBarHomeModel(BarHomeModel model) => model.toJson();

@JsonSerializable()
class BarHomeModel extends ApiResponse {
  BarHomeModel({
    required this.data,
    required super.version,
    required super.statusCode,
    required super.isSuccess,
    required super.message,
  });

  factory BarHomeModel.fromJson(Map<String, dynamic> json) {
    return _$BarHomeModelFromJson(json.isNotEmpty ? json : <String, dynamic>{});
  }

  BarHomeData? data;

  Map<String, dynamic> toJson() => _$BarHomeModelToJson(this);
}

@JsonSerializable()
class BarHomeData {
  BarHomeData({this.sales, this.tips, this.tipsByStaff, this.redemptionRate, this.userActivity});

  factory BarHomeData.fromJson(Map<String, dynamic> json) {
    // Check if the json is not empty and return a default empty AuthData if it is
    return _$BarHomeDataFromJson(json.isNotEmpty ? json : <String, dynamic>{});
  }

  Sales? sales;
  Sales? tips;
  TipsByStaff? tipsByStaff;
  RedemptionRate? redemptionRate;
  UserActivity? userActivity;
  bool? barAvailability;

  Map<String, dynamic> toJson() => _$BarHomeDataToJson(this);
}

@JsonSerializable()
class Sales {
  Sales({this.thisToday, this.thisWeek, this.thisMonth, this.thisYear});

  factory Sales.fromJson(Map<String, dynamic> json) => _$SalesFromJson(json);
  List<SalesThisToday>? thisToday;
  List<SalesThisWeek>? thisWeek;
  List<SalesThisMonth>? thisMonth;
  List<SalesThisYear>? thisYear;

  Map<String, dynamic> toJson() => _$SalesToJson(this);
}

@JsonSerializable()
class TipsByStaff {
  TipsByStaff({this.thisToday, this.thisWeek, this.thisMonth, this.thisYear});

  factory TipsByStaff.fromJson(Map<String, dynamic> json) => _$TipsByStaffFromJson(json);
  List<TipsByStaffItem>? thisToday;
  List<TipsByStaffItem>? thisWeek;
  List<TipsByStaffItem>? thisMonth;
  List<TipsByStaffItem>? thisYear;

  Map<String, dynamic> toJson() => _$TipsByStaffToJson(this);
}

@JsonSerializable()
class TipsByStaffItem {
  TipsByStaffItem({this.staffId, this.name, this.value});

  factory TipsByStaffItem.fromJson(Map<String, dynamic> json) => _$TipsByStaffItemFromJson(json);
  String? staffId;
  String? name;
  num? value;

  Map<String, dynamic> toJson() => _$TipsByStaffItemToJson(this);
}

@JsonSerializable()
class RedemptionRate {
  RedemptionRate({this.thisWeek, this.thisMonth, this.thisYear});

  factory RedemptionRate.fromJson(Map<String, dynamic> json) => _$RedemptionRateFromJson(json);
  List<RedemptionRateThisWeek>? thisWeek;
  List<RedemptionRateThisMonth>? thisMonth;
  List<RedemptionRateThisYear>? thisYear;

  Map<String, dynamic> toJson() => _$RedemptionRateToJson(this);
}

@JsonSerializable()
class UserActivity {
  UserActivity({this.thisWeek, this.thisMonth, this.thisYear});

  factory UserActivity.fromJson(Map<String, dynamic> json) => _$UserActivityFromJson(json);
  List<UserActivityThisWeek>? thisWeek;
  List<UserActivityThisMonth>? thisMonth;
  List<UserActivityThisYear>? thisYear;

  Map<String, dynamic> toJson() => _$UserActivityToJson(this);
}

@JsonSerializable()
class SalesThisToday {
  SalesThisToday({this.hour, this.value});

  factory SalesThisToday.fromJson(Map<String, dynamic> json) => _$SalesThisTodayFromJson(json);
  String? hour;
  num? value;

  Map<String, dynamic> toJson() => _$SalesThisTodayToJson(this);
}

@JsonSerializable()
class SalesThisWeek {
  SalesThisWeek({this.day, this.value});

  factory SalesThisWeek.fromJson(Map<String, dynamic> json) => _$SalesThisWeekFromJson(json);
  String? day;
  num? value;

  Map<String, dynamic> toJson() => _$SalesThisWeekToJson(this);
}

@JsonSerializable()
class SalesThisMonth {
  SalesThisMonth({this.date, this.value});

  factory SalesThisMonth.fromJson(Map<String, dynamic> json) => _$SalesThisMonthFromJson(json);
  String? date;
  num? value;

  Map<String, dynamic> toJson() => _$SalesThisMonthToJson(this);
}

@JsonSerializable()
class SalesThisYear {
  SalesThisYear({this.month, this.value});

  factory SalesThisYear.fromJson(Map<String, dynamic> json) => _$SalesThisYearFromJson(json);
  String? month;
  num? value;

  Map<String, dynamic> toJson() => _$SalesThisYearToJson(this);
}

@JsonSerializable()
class RedemptionRateThisWeek {
  RedemptionRateThisWeek({this.total, this.redeemed});

  factory RedemptionRateThisWeek.fromJson(Map<String, dynamic> json) => _$RedemptionRateThisWeekFromJson(json);
  int? total;
  int? redeemed;

  Map<String, dynamic> toJson() => _$RedemptionRateThisWeekToJson(this);
}

@JsonSerializable()
class RedemptionRateThisMonth {
  RedemptionRateThisMonth({this.total, this.redeemed});

  factory RedemptionRateThisMonth.fromJson(Map<String, dynamic> json) => _$RedemptionRateThisMonthFromJson(json);
  int? total;
  int? redeemed;

  Map<String, dynamic> toJson() => _$RedemptionRateThisMonthToJson(this);
}

@JsonSerializable()
class RedemptionRateThisYear {
  RedemptionRateThisYear({this.total, this.redeemed});

  factory RedemptionRateThisYear.fromJson(Map<String, dynamic> json) => _$RedemptionRateThisYearFromJson(json);
  int? total;
  int? redeemed;

  Map<String, dynamic> toJson() => _$RedemptionRateThisYearToJson(this);
}

@JsonSerializable()
class UserActivityThisWeek {
  UserActivityThisWeek({this.day, this.total, this.redeemed, this.active});

  factory UserActivityThisWeek.fromJson(Map<String, dynamic> json) => _$UserActivityThisWeekFromJson(json);
  String? day;
  int? total;
  int? redeemed;
  int? active;

  Map<String, dynamic> toJson() => _$UserActivityThisWeekToJson(this);
}

@JsonSerializable()
class UserActivityThisMonth {
  UserActivityThisMonth({this.date, this.total, this.redeemed, this.active});

  factory UserActivityThisMonth.fromJson(Map<String, dynamic> json) => _$UserActivityThisMonthFromJson(json);
  String? date;
  int? total;
  int? redeemed;
  int? active;

  Map<String, dynamic> toJson() => _$UserActivityThisMonthToJson(this);
}

@JsonSerializable()
class UserActivityThisYear {
  UserActivityThisYear({this.month, this.total, this.redeemed, this.active});

  factory UserActivityThisYear.fromJson(Map<String, dynamic> json) => _$UserActivityThisYearFromJson(json);
  String? month;
  int? total;
  int? redeemed;
  int? active;

  Map<String, dynamic> toJson() => _$UserActivityThisYearToJson(this);
}
