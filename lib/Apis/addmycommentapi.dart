import 'package:upaychat/Apis/network_utils.dart';
import 'package:upaychat/Models/commonmodel.dart';

class AddCommentModelApi {
  NetworkUtils _netUtil = new NetworkUtils();

  Future<CommonModel> search(String transactionid, String comment) {
    String baseTokenUrl = NetworkUtils.api_url + NetworkUtils.addcomment;

    return _netUtil.post(
      baseTokenUrl,
      body: {
        "transactionid": transactionid,
        "comment": comment,
      },
    ).then((dynamic res) {
      CommonModel result = new CommonModel.map(res);
      return result;
    });
  }
}
