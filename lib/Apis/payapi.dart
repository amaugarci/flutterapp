import 'package:upaychat/Apis/network_utils.dart';
import 'package:upaychat/Models/commonmodel.dart';

class PayApiRequest {
  NetworkUtils _netUtil = new NetworkUtils();

  Future<CommonModel> search(String amount, String privacy, String caption,
      String toUserId, String user, String transactionType) {
    String baseTokenUrl = NetworkUtils.api_url + NetworkUtils.addtransaction;

    return _netUtil.post(
      baseTokenUrl,
      body: {
        "touser_id": toUserId,
        "user": user,
        "transaction_type": transactionType,
        "amount": amount,
        "caption": caption,
        "privacy": privacy,
      },
    ).then((dynamic res) {
      CommonModel result = new CommonModel.map(res);
      return result;
    });
  }
}
