import 'package:upaychat/Apis/network_utils.dart';
import 'package:upaychat/Models/commonmodel.dart';

class MyLikeDislikeApi {
  NetworkUtils _netUtil = new NetworkUtils();

  Future<CommonModel> search(String transactionid, String like) {
    String baseTokenUrl = NetworkUtils.api_url + NetworkUtils.addlike;

    return _netUtil.post(
      baseTokenUrl,
      body: {
        "post_id": transactionid,
      },
    ).then((dynamic res) {
      CommonModel result = new CommonModel.map(res);
      return result;
    });
  }
}
