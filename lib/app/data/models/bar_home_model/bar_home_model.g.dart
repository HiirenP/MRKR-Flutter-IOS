// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bar_home_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BarHomeModel _$BarHomeModelFromJson(Map<String, dynamic> json) => BarHomeModel(
      data: json['data'] == null
          ? null
          : BarHomeData.fromJson(json['data'] as Map<String, dynamic>),
      version: json['version'] as String,
      statusCode: json['statusCode'] as num,
      isSuccess: json['isSuccess'] as bool,
      message: json['message'] as String,
    );

Map<String, dynamic> _$BarHomeModelToJson(BarHomeModel instance) =>
    <String, dynamic>{
      'version': instance.version,
      'statusCode': instance.statusCode,
      'isSuccess': instance.isSuccess,
      'message': instance.message,
      'data': instance.data,
    };

BarHomeData _$BarHomeDataFromJson(Map<String, dynamic> json) => BarHomeData(
      sales: json['sales'] == null
          ? null
          : Sales.fromJson(json['sales'] as Map<String, dynamic>),
      tips: json['tips'] == null
          ? null
          : Sales.fromJson(json['tips'] as Map<String, dynamic>),
      tipsByStaff: json['tipsByStaff'] == null
          ? null
          : TipsByStaff.fromJson(json['tipsByStaff'] as Map<String, dynamic>),
      redemptionRate: json['redemptionRate'] == null
          ? null
          : RedemptionRate.fromJson(
              json['redemptionRate'] as Map<String, dynamic>),
      userActivity: json['userActivity'] == null
          ? null
          : UserActivity.fromJson(json['userActivity'] as Map<String, dynamic>),
    )..barAvailability = json['barAvailability'] as bool?;

Map<String, dynamic> _$BarHomeDataToJson(BarHomeData instance) =>
    <String, dynamic>{
      'sales': instance.sales,
      'tips': instance.tips,
      'tipsByStaff': instance.tipsByStaff,
      'redemptionRate': instance.redemptionRate,
      'userActivity': instance.userActivity,
      'barAvailability': instance.barAvailability,
    };

Sales _$SalesFromJson(Map<String, dynamic> json) => Sales(
      thisToday: (json['thisToday'] as List<dynamic>?)
          ?.map((e) => SalesThisToday.fromJson(e as Map<String, dynamic>))
          .toList(),
      thisWeek: (json['thisWeek'] as List<dynamic>?)
          ?.map((e) => SalesThisWeek.fromJson(e as Map<String, dynamic>))
          .toList(),
      thisMonth: (json['thisMonth'] as List<dynamic>?)
          ?.map((e) => SalesThisMonth.fromJson(e as Map<String, dynamic>))
          .toList(),
      thisYear: (json['thisYear'] as List<dynamic>?)
          ?.map((e) => SalesThisYear.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SalesToJson(Sales instance) => <String, dynamic>{
      'thisToday': instance.thisToday,
      'thisWeek': instance.thisWeek,
      'thisMonth': instance.thisMonth,
      'thisYear': instance.thisYear,
    };

TipsByStaff _$TipsByStaffFromJson(Map<String, dynamic> json) => TipsByStaff(
      thisToday: (json['thisToday'] as List<dynamic>?)
          ?.map((e) => TipsByStaffItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      thisWeek: (json['thisWeek'] as List<dynamic>?)
          ?.map((e) => TipsByStaffItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      thisMonth: (json['thisMonth'] as List<dynamic>?)
          ?.map((e) => TipsByStaffItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      thisYear: (json['thisYear'] as List<dynamic>?)
          ?.map((e) => TipsByStaffItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TipsByStaffToJson(TipsByStaff instance) =>
    <String, dynamic>{
      'thisToday': instance.thisToday,
      'thisWeek': instance.thisWeek,
      'thisMonth': instance.thisMonth,
      'thisYear': instance.thisYear,
    };

TipsByStaffItem _$TipsByStaffItemFromJson(Map<String, dynamic> json) =>
    TipsByStaffItem(
      staffId: json['staffId'] as String?,
      name: json['name'] as String?,
      value: json['value'] as num?,
    );

Map<String, dynamic> _$TipsByStaffItemToJson(TipsByStaffItem instance) =>
    <String, dynamic>{
      'staffId': instance.staffId,
      'name': instance.name,
      'value': instance.value,
    };

RedemptionRate _$RedemptionRateFromJson(Map<String, dynamic> json) =>
    RedemptionRate(
      thisWeek: (json['thisWeek'] as List<dynamic>?)
          ?.map(
              (e) => RedemptionRateThisWeek.fromJson(e as Map<String, dynamic>))
          .toList(),
      thisMonth: (json['thisMonth'] as List<dynamic>?)
          ?.map((e) =>
              RedemptionRateThisMonth.fromJson(e as Map<String, dynamic>))
          .toList(),
      thisYear: (json['thisYear'] as List<dynamic>?)
          ?.map(
              (e) => RedemptionRateThisYear.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RedemptionRateToJson(RedemptionRate instance) =>
    <String, dynamic>{
      'thisWeek': instance.thisWeek,
      'thisMonth': instance.thisMonth,
      'thisYear': instance.thisYear,
    };

UserActivity _$UserActivityFromJson(Map<String, dynamic> json) => UserActivity(
      thisWeek: (json['thisWeek'] as List<dynamic>?)
          ?.map((e) => UserActivityThisWeek.fromJson(e as Map<String, dynamic>))
          .toList(),
      thisMonth: (json['thisMonth'] as List<dynamic>?)
          ?.map(
              (e) => UserActivityThisMonth.fromJson(e as Map<String, dynamic>))
          .toList(),
      thisYear: (json['thisYear'] as List<dynamic>?)
          ?.map((e) => UserActivityThisYear.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserActivityToJson(UserActivity instance) =>
    <String, dynamic>{
      'thisWeek': instance.thisWeek,
      'thisMonth': instance.thisMonth,
      'thisYear': instance.thisYear,
    };

SalesThisToday _$SalesThisTodayFromJson(Map<String, dynamic> json) =>
    SalesThisToday(
      hour: json['hour'] as String?,
      value: json['value'] as num?,
    );

Map<String, dynamic> _$SalesThisTodayToJson(SalesThisToday instance) =>
    <String, dynamic>{
      'hour': instance.hour,
      'value': instance.value,
    };

SalesThisWeek _$SalesThisWeekFromJson(Map<String, dynamic> json) =>
    SalesThisWeek(
      day: json['day'] as String?,
      value: json['value'] as num?,
    );

Map<String, dynamic> _$SalesThisWeekToJson(SalesThisWeek instance) =>
    <String, dynamic>{
      'day': instance.day,
      'value': instance.value,
    };

SalesThisMonth _$SalesThisMonthFromJson(Map<String, dynamic> json) =>
    SalesThisMonth(
      date: json['date'] as String?,
      value: json['value'] as num?,
    );

Map<String, dynamic> _$SalesThisMonthToJson(SalesThisMonth instance) =>
    <String, dynamic>{
      'date': instance.date,
      'value': instance.value,
    };

SalesThisYear _$SalesThisYearFromJson(Map<String, dynamic> json) =>
    SalesThisYear(
      month: json['month'] as String?,
      value: json['value'] as num?,
    );

Map<String, dynamic> _$SalesThisYearToJson(SalesThisYear instance) =>
    <String, dynamic>{
      'month': instance.month,
      'value': instance.value,
    };

RedemptionRateThisWeek _$RedemptionRateThisWeekFromJson(
        Map<String, dynamic> json) =>
    RedemptionRateThisWeek(
      total: (json['total'] as num?)?.toInt(),
      redeemed: (json['redeemed'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RedemptionRateThisWeekToJson(
        RedemptionRateThisWeek instance) =>
    <String, dynamic>{
      'total': instance.total,
      'redeemed': instance.redeemed,
    };

RedemptionRateThisMonth _$RedemptionRateThisMonthFromJson(
        Map<String, dynamic> json) =>
    RedemptionRateThisMonth(
      total: (json['total'] as num?)?.toInt(),
      redeemed: (json['redeemed'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RedemptionRateThisMonthToJson(
        RedemptionRateThisMonth instance) =>
    <String, dynamic>{
      'total': instance.total,
      'redeemed': instance.redeemed,
    };

RedemptionRateThisYear _$RedemptionRateThisYearFromJson(
        Map<String, dynamic> json) =>
    RedemptionRateThisYear(
      total: (json['total'] as num?)?.toInt(),
      redeemed: (json['redeemed'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RedemptionRateThisYearToJson(
        RedemptionRateThisYear instance) =>
    <String, dynamic>{
      'total': instance.total,
      'redeemed': instance.redeemed,
    };

UserActivityThisWeek _$UserActivityThisWeekFromJson(
        Map<String, dynamic> json) =>
    UserActivityThisWeek(
      day: json['day'] as String?,
      total: (json['total'] as num?)?.toInt(),
      redeemed: (json['redeemed'] as num?)?.toInt(),
      active: (json['active'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UserActivityThisWeekToJson(
        UserActivityThisWeek instance) =>
    <String, dynamic>{
      'day': instance.day,
      'total': instance.total,
      'redeemed': instance.redeemed,
      'active': instance.active,
    };

UserActivityThisMonth _$UserActivityThisMonthFromJson(
        Map<String, dynamic> json) =>
    UserActivityThisMonth(
      date: json['date'] as String?,
      total: (json['total'] as num?)?.toInt(),
      redeemed: (json['redeemed'] as num?)?.toInt(),
      active: (json['active'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UserActivityThisMonthToJson(
        UserActivityThisMonth instance) =>
    <String, dynamic>{
      'date': instance.date,
      'total': instance.total,
      'redeemed': instance.redeemed,
      'active': instance.active,
    };

UserActivityThisYear _$UserActivityThisYearFromJson(
        Map<String, dynamic> json) =>
    UserActivityThisYear(
      month: json['month'] as String?,
      total: (json['total'] as num?)?.toInt(),
      redeemed: (json['redeemed'] as num?)?.toInt(),
      active: (json['active'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UserActivityThisYearToJson(
        UserActivityThisYear instance) =>
    <String, dynamic>{
      'month': instance.month,
      'total': instance.total,
      'redeemed': instance.redeemed,
      'active': instance.active,
    };
