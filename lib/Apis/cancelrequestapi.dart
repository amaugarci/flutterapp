import 'package:upaychat/Models/addmoneytowalletmodel.dart';

import 'network_utils.dart';

class CancelRequestApi {
  NetworkUtils _netUtil = new NetworkUtils();

  Future<AddMoneyToWalletModel> search(String requestId) {
    String baseTokenUrl = NetworkUtils.api_url + NetworkUtils.cancelrequest;

    return _netUtil.post(
      baseTokenUrl,
      body: {
        "requestId": requestId,
      },
    ).then((dynamic res) {
      AddMoneyToWalletModel result = new AddMoneyToWalletModel.map(res);
      return result;
    });
  }
}
