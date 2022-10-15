import 'package:upaychat/Apis/network_utils.dart';
import 'package:upaychat/Models/commonmodel.dart';

class UserCheckApi {
  NetworkUtils _netUtil = new NetworkUtils();

  Future<CommonModel> search({String roll = ''}) {
    String baseTokenUrl = NetworkUtils.api_url + NetworkUtils.usercheck;

    return _netUtil.post(
      baseTokenUrl,
      body: {
        'roll': roll,
      },
    ).then((dynamic res) {
      CommonModel result = new CommonModel.map(res);
      return result;
    });
  }
}
