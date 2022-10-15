import 'package:flutter/cupertino.dart';
import 'package:upaychat/CommonUtils/common_utils.dart';
import 'package:upaychat/Models/walletmodel.dart';

import 'network_utils.dart';

class WalletApi {
  NetworkUtils _netUtil = new NetworkUtils();

  Future<WalletModel> search(BuildContext context) {
    String baseTokenUrl = NetworkUtils.api_url + NetworkUtils.wallet;

    return _netUtil.post(baseTokenUrl).then((dynamic res) {
      if (res["message"] == "Unauthenticated.") {
        CommonUtils.logout(context);
        return null;
      } else {
        WalletModel result = new WalletModel.map(res);
        return result;
      }
    });
  }
}
