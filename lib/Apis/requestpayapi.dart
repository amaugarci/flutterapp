import 'package:upaychat/Models/addmoneytowalletmodel.dart';

import 'network_utils.dart';

class RequestForPayApi {
  NetworkUtils _netUtil = new NetworkUtils();

  Future<AddMoneyToWalletModel> search(String transactionId, String privacy) {
    String baseTokenUrl = NetworkUtils.api_url + NetworkUtils.acceptrequest;

    return _netUtil.post(
      baseTokenUrl,
      body: {"transactionId": transactionId, "privacy": privacy},
    ).then((dynamic res) {
      AddMoneyToWalletModel result = new AddMoneyToWalletModel.map(res);
      return result;
    });
  }
}
