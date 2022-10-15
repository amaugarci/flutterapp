import 'package:flutter/cupertino.dart';
import 'package:upaychat/Apis/network_utils.dart';
import 'package:upaychat/CommonUtils/common_utils.dart';
import 'package:upaychat/Models/transactionmodel.dart';

class TransactionApi {
  NetworkUtils _netUtil = new NetworkUtils();

  Future<TransactionModel> search(BuildContext context) {
    String baseTokenUrl = NetworkUtils.api_url + NetworkUtils.transactionshistory;

    return _netUtil.post(baseTokenUrl).then((dynamic res) {
      if (res["message"] == "Unauthenticated.") {
        CommonUtils.logout(context);
        return null;
      } else {
        TransactionModel result = new TransactionModel.map(res);
        return result;
      }
    });
  }
}
