import 'package:marker/app/data/models/bar_get_update_details_model/bar_get_update_details_model.dart';
import 'package:marker/app/data/models/redeemed_upcoming_model/redeemed_upcoming_model.dart';

extension MarkerHolderDisplay on RedeemedUpcomingListData {
  Owner? get holder => redeemerId ?? ownerId;

  String? get holderDate {
    if (transferredAt != null && transferredAt!.isNotEmpty) {
      return transferredAt;
    }
    return createdAt;
  }
}
