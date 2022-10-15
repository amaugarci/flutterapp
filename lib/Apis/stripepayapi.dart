import 'package:upaychat/Apis/network_utils.dart';
import 'package:upaychat/Models/commonmodel.dart';

class StripePayApiRequest {
  NetworkUtils _netUtil = new NetworkUtils();

  Future<CommonModel> search(double amount, String email, String cardNumber,
      String expDate, String cvc) {
    List<String> date = expDate.split('/');
    String baseTokenUrl = NetworkUtils.api_url + NetworkUtils.stripepay;

    return _netUtil.post(
      baseTokenUrl,
      body: {
        "amount": amount.toString(),
        "email": email,
        "card_number": cardNumber.replaceAll(' ', ''),
        "exp_month": date[0],
        "exp_year": date[1],
        "cvc": cvc,
      },
    ).then((dynamic res) {
      CommonModel result = new CommonModel.map(res);
      return result;
    });
  }
}
