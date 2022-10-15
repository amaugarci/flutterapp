import 'network_utils.dart';

class DeleteBankApi {
  NetworkUtils _netUtil = new NetworkUtils();

  Future<bool> search(int bankid) {
    String baseTokenUrl = NetworkUtils.api_url + NetworkUtils.deletebank;

    return _netUtil.post(
      baseTokenUrl,
      body: {
        "bankid": bankid.toString(),
      },
    ).then((dynamic res) {
      Map.from(res);
      return res['status'] == "true";
    });
  }
}
