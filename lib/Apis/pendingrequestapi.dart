import 'package:upaychat/Models/pendingrequestmodel.dart';

import 'network_utils.dart';

class PendingRequestApi {
  NetworkUtils _netUtil = new NetworkUtils();

  Future<PendingRequestModel> search() {
    String baseTokenUrl = NetworkUtils.api_url + NetworkUtils.pendingrequest;

    return _netUtil
        .post(
      baseTokenUrl,
    )
        .then((dynamic res) {
      PendingRequestModel result = new PendingRequestModel.map(res);
      return result;
    });
  }
}
