import 'package:upaychat/Models/commonmodel.dart';

import 'network_utils.dart';

class AddUpdateBankDetailApi {
  NetworkUtils _netUtil = new NetworkUtils();

  Future<CommonModel> search(String status, String bankId, String bankName,
      String bankholdername, String accountnumber) {
    String baseTokenUrl = NetworkUtils.api_url + status;

    Map body;
    if (status == "addbank") {
      body = {
        "bank_name": bankName.toString(),
        "account_holder_name": bankholdername.toString(),
        "account_no": accountnumber.toString(),
      };
    } else {
      body = {
        "bank_id": bankId.toString(),
        "bank_name": bankName.toString(),
        "account_holder_name": bankholdername.toString(),
        "account_no": accountnumber.toString(),
      };
    }

    return _netUtil
        .post(
      baseTokenUrl,
      body: body,
    )
        .then((dynamic res) {
      CommonModel result = new CommonModel.map(res);
      return result;
    });
  }
}
