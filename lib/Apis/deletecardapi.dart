import 'network_utils.dart';

class DeleteCardApi {
  NetworkUtils _netUtil = new NetworkUtils();

  Future<bool> search(int cardid) {
    String baseTokenUrl = NetworkUtils.api_url + NetworkUtils.deletecard;

    return _netUtil.post(
      baseTokenUrl,
      body: {
        "cardid": cardid.toString(),
      },
    ).then((dynamic res) {
      Map.from(res);
      return res['status'] == "true";
    });
  }
}
