import 'package:upaychat/Models/banklistmodel.dart';

import 'network_utils.dart';

class BankListApi {
  NetworkUtils _netUtil = new NetworkUtils();

  Future<BankListModel> search() {
    String baseTokenUrl = NetworkUtils.api_url + NetworkUtils.bankdetails;

    return _netUtil
        .post(
      baseTokenUrl,
    )
        .then((dynamic res) {
      BankListModel result = new BankListModel.map(res);
      return result;
    });
  }
}
