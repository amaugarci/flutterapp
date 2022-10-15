import 'package:upaychat/Models/commonmodel.dart';

import 'network_utils.dart';

class ForgotPasswordApi {
  NetworkUtils _netUtil = new NetworkUtils();

  Future<CommonModel> search(String mobileNo, String password) {
    String baseTokenUrl = NetworkUtils.api_url + NetworkUtils.forgotpassword;

    return _netUtil.post(
      baseTokenUrl,
      body: {
        "mobile_no": mobileNo,
        "password": password,
      },
    ).then((dynamic res) {
      CommonModel result = new CommonModel.map(res);
      return result;
    });
  }
}
