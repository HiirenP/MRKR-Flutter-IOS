import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:marker/app/data/models/bank_details_model/bank_details_model.dart';
import 'package:marker/app/data/models/get_terminal_token/get_terminal_token_model.dart';
import 'package:marker/app/data/models/transaction_history_model/transaction_history_model.dart';
import 'package:marker/app/data/models/withdraw_money_model/withdraw_money_model.dart';
import 'package:marker/app/global/app_config.dart';
import 'package:retrofit/retrofit.dart';

part 'payment_service.g.dart';

// ignore: public_member_api_docs
Map<String, dynamic> deserializedynamic(Map<String, dynamic> json) => json;
GetTerminalTokenModel deserializeGetTerminalTokenModel(Map<String, dynamic> json) => GetTerminalTokenModel.fromJson(json);

/// Add base Url here..
@RestApi(parser: Parser.FlutterCompute, baseUrl: AppConfig.restApiBaseUrl)
@lazySingleton
abstract class PaymentService {
  @factoryMethod
  factory PaymentService(Dio dio) = _PaymentService;

  @POST(EndPoints.addBankDetail)
  @MultiPart()
  Future<BankDetailsModel> addBankDetail({
    @Part() required String email,
    @Part() required String phone,
    @Part() required String iso,
    @Part() required String country,
    @Part() required String countryFlag,
    @Part() required String identityNumber,
    @Part() required String city,
    @Part() required String address,
    @Part() required String state,
    @Part() required String bankAccountNumber,
    @Part() required String bdate,
    @Part() required String bmonth,
    @Part() required String byear,
    @Part() required String pincode,
    @Part() required String routing_number,
    @Part() required String fname,
    @Part() required String lname,
    @Part(name: 'frontImage') File? frontImage,
    @Part(name: 'backImage') File? backImage,
  });

  @GET(EndPoints.getBankDetail)
  Future<BankDetailsModel> getBankDetail();

  @PATCH(EndPoints.updateBankDetail)
  Future<BankDetailsModel> updateBankDetail({
    @Part() String? email,
    @Part() String? phone,
    @Part() String? iso,
    @Part() String? country,
    @Part() String? countryFlag,
    @Part() String? city,
    @Part() String? address,
    @Part() String? state,
    @Part() String? bankAccountNumber,
    @Part() String? pincode,
    @Part() String? routing_number,
  });

  //Raw data passing
  @POST(EndPoints.withdrawalMoney)
  Future<WithdrawMoneyModel> withdrawalMoney(
    @Body() Map<String, dynamic> data,
  );

  @POST(EndPoints.transactionHistory)
  Future<TransactionHistoryWithdrawalModel> transactionHistory(
    @Body() Map<String, dynamic> data,
  );

  @POST(EndPoints.wallet)
  Future<TransactionHistoryWithdrawalModel> wallet(
    @Body() Map<String, dynamic> data,
  );

  @POST(EndPoints.withdrawalHistory)
  Future<TransactionHistoryWithdrawalModel> withdrawalHistory(
    @Body() Map<String, dynamic> data,
  );
  @POST(EndPoints.terminalToken)
  Future<GetTerminalTokenModel> terminalToken();

  @GET(EndPoints.memberPlatformFeePreview)
  Future<Map<String, dynamic>> memberPlatformFeePreview(
    @Query('basePrice') String basePrice,
  );
}
