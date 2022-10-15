import 'package:upaychat/Models/commonmodel.dart';

import 'network_utils.dart';

class AddUpdateCardDetailApi {
  NetworkUtils _netUtil = new NetworkUtils();

  Future<CommonModel> search(String status, String cardId, String cardNumber,
      String cardHolder, String cardExp, String cardCvv) {
    String baseTokenUrl = NetworkUtils.api_url + status;

    Map body;
    if (status == "addcard") {
      body = {
        "card_number": cardNumber,
        "expire_date": cardExp,
        "cvv": cardCvv,
        "card_holder": cardHolder,
      };
    } else {
      body = {
        "card_id": cardId,
        "card_number": cardNumber,
        "expire_date": cardExp,
        "cvv": cardCvv,
        "card_holder": cardHolder,
      };
    }

    return _netUtil.post(baseTokenUrl, body: body).then((dynamic res) {
      CommonModel result = new CommonModel.map(res);
      return result;
    });
  }
}
