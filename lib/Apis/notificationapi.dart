import 'package:upaychat/Models/notificationmodel.dart';

import 'network_utils.dart';

class NotificationApi {
  NetworkUtils _netUtil = new NetworkUtils();

  Future<NotificationModel> search() {
    String baseTokenUrl = NetworkUtils.api_url + NetworkUtils.mynotification;

    return _netUtil
        .post(
      baseTokenUrl,
    )
        .then((dynamic res) {
      NotificationModel result = new NotificationModel.map(res);
      return result;
    });
  }
}
