import 'package:upaychat/Apis/network_utils.dart';
import 'package:upaychat/Models/commonmodel.dart';

class ChangePasswordApi {
  NetworkUtils _netUtil = new NetworkUtils();

  Future<CommonModel> search(String newpassword, String oldpassword) {
    String baseTokenUrl = NetworkUtils.api_url + NetworkUtils.changepassword;

    return _netUtil.post(
      baseTokenUrl,
      body: {
        "new_password": newpassword,
        "password": oldpassword,
      },
    ).then((dynamic res) {
      CommonModel result = new CommonModel.map(res);
      return result;
    });
  }
}
