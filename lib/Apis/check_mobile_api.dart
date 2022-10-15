import 'package:upaychat/Models/commonmodel.dart';

import 'network_utils.dart';

class CheckMobileApi {
  NetworkUtils _netUtil = new NetworkUtils();

  Future<CommonModel> search(String mobile, String exist, String twilioService) {
    // true: twilio, false: multitexter
    String baseTokenUrl = NetworkUtils.api_url + NetworkUtils.checkmobile;

    return _netUtil.post(
      baseTokenUrl,
      body: {
        "mobile": mobile,
        "exist": exist,
        "twilio": twilioService,
      },
    ).then((dynamic res) {
      CommonModel result = new CommonModel.map(res);
      return result;
    });
  }
}
