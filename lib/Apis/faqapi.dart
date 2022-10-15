import 'package:upaychat/Models/faqmodel.dart';

import 'network_utils.dart';

class FaqApi {
  NetworkUtils _netUtil = new NetworkUtils();

  Future<FaqModel> search() {
    String baseTokenUrl = NetworkUtils.api_url + NetworkUtils.faq;

    return _netUtil
        .post(
      baseTokenUrl,
    )
        .then((dynamic res) {
      FaqModel result = new FaqModel.map(res);
      return result;
    });
  }
}
