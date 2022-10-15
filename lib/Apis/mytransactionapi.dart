import 'package:upaychat/Apis/network_utils.dart';
import 'package:upaychat/Models/mytransactionmodel.dart';

class MyTransactionApi {
  NetworkUtils _netUtil = new NetworkUtils();

  Future<MyTransactionModel> search() {
    String baseTokenUrl =
        NetworkUtils.api_url + NetworkUtils.mytransactionshistory;

    return _netUtil
        .post(
      baseTokenUrl,
    )
        .then((dynamic res) {
      MyTransactionModel result = new MyTransactionModel.map(res);
      return result;
    });
  }
}
