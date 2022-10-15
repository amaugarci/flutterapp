import 'package:upaychat/Models/carddetaildata.dart';

import 'network_utils.dart';

class CardListApi {
  NetworkUtils _netUtil = new NetworkUtils();

  Future<CardListModel> search() {
    String baseTokenUrl = NetworkUtils.api_url + NetworkUtils.carddetails;

    return _netUtil
        .post(
      baseTokenUrl,
    )
        .then((dynamic res) {
      CardListModel result = new CardListModel.map(res);
      return result;
    });
  }
}
