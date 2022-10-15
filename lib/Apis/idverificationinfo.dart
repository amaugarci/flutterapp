import 'package:upaychat/Models/idverificationmodel.dart';

import 'network_utils.dart';

class IDVerificationInfo {
  NetworkUtils _netUtil = new NetworkUtils();

  Future<IDVerificationModel> search() {
    String baseTokenUrl = NetworkUtils.api_url + NetworkUtils.idverify;

    return _netUtil.get(baseTokenUrl).then((dynamic res) {
      IDVerificationModel result = new IDVerificationModel.map(res);
      return result;
    });
  }
}
