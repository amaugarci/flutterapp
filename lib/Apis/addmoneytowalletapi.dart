import 'package:upaychat/Models/addmoneytowalletmodel.dart';

import 'network_utils.dart';

class AddMoneyWalletApi {
  NetworkUtils _netUtil = new NetworkUtils();

  Future<AddMoneyToWalletModel> search(
      double totalamount, double amount, String gatewayname, String senderID, String receiverID) {
    String baseTokenUrl = NetworkUtils.api_url + NetworkUtils.addmoneytowallet;

    return _netUtil.post(
      baseTokenUrl,
      body: {
        "amount": amount.toString(),
        "totalamount": totalamount.toString(),
        "gatewayName": gatewayname.toString(),
        "senderID": "",
        "receiverID": "",
      },
    ).then((dynamic res) {
      AddMoneyToWalletModel result = new AddMoneyToWalletModel.map(res);
      return result;
    });
  }
}
