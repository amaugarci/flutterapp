import 'package:upaychat/Models/addmoneytowalletmodel.dart';

import 'network_utils.dart';

class WithdrawAmountRequestApi {
  NetworkUtils _netUtil = new NetworkUtils();

  Future<AddMoneyToWalletModel> search(String amount) {
    String baseTokenUrl = NetworkUtils.api_url + NetworkUtils.withdrawrequest;

    return _netUtil.post(
      baseTokenUrl,
      body: {
        "amount": amount,
      },
    ).then((dynamic res) {
      AddMoneyToWalletModel result = new AddMoneyToWalletModel.map(res);
      return result;
    });
  }
}
