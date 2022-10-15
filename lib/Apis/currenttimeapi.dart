import 'package:upaychat/Apis/network_utils.dart';
import 'package:upaychat/Models/commonmodel.dart';

class CurrentTimeApiRequest {
  NetworkUtils _netUtil = new NetworkUtils();

  Future<CommonModel> search() {
    String baseTokenUrl = NetworkUtils.api_url + NetworkUtils.currenttime;

    return _netUtil
        .post(
      baseTokenUrl,
    )
        .then((dynamic res) {
      CommonModel result = new CommonModel.map(res);
      return result;
    });
  }
}
