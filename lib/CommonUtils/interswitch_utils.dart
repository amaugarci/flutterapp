import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:upaychat/globals.dart';

class InterswitchUtils {
  String nonce;
  String timeStamp;

  static InterswitchUtils instance;
  static InterswitchUtils getInstance() {
    if (instance == null) instance = new InterswitchUtils();
    return instance;
  }

  String computeTimeStamp() {
    return (DateTime.now().millisecondsSinceEpoch / 1000 ?? 0).toInt().toString();
  }

  String computeNonce({int length = 32}) {
    String _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    return String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

  String computeAuthorizationString() {
    String encoded = base64.encode(utf8.encode(Globals.clientId));
    return 'InterswitchAuth $encoded';
  }

  String computeSignature(endpoint, method) {
    method = method.toUpperCase();
    var signature = method + '&' + Uri.encodeComponent(endpoint) + '&' + timeStamp + '&' + nonce + '&' + Globals.clientId + '&' + Globals.secretKey;
    return base64.encode(sha1.convert(utf8.encode(signature)).bytes);
  }

  Future _get(path) {
    return curl(path, "GET", null);
  }

  Future _post(path, data) {
    return curl(path, "POST", data);
  }

  Future curl(path, method, data) {
    method = method.toUpperCase();
    timeStamp = computeTimeStamp();
    nonce = computeNonce();
    String authorizationString = computeAuthorizationString();
    var fullPath = 'https://' + Globals.hostname + path;
    var headers = {
      'Content-Type': 'application/json',
      "Authorization": authorizationString,
      'Signature': computeSignature(fullPath, method),
      'Timestamp': timeStamp,
      'Nonce': nonce,
      'TerminalID': Globals.terminalId,
      'SignatureMethod': Globals.signatureMethod,
    };
    print(Uri.parse(fullPath));
    var request = method == "GET" ? http.get(Uri.parse(fullPath), headers: headers) : http.post(Uri.parse(fullPath), headers: headers, body: json.encode(data));

    return request.then((http.Response response) {
      var res = json.decode(response.body) as Map;
      return res;
    }).timeout(const Duration(seconds: 300));
  }

  Future getBillers() {
    return _get('/api/v2/quickteller/billers');
  }

  Future getCategories() {
    return _get('/api/v2/quickteller/categorys');
  }

  Future getBillersByCategory(String category) {
    return _get('/api/v2/quickteller/categorys/$category/billers');
  }

  Future getBillerDetail(String billerid) {
    return _get('/api/v2/quickteller/billers/$billerid/paymentitems');
  }

  Future customerValidation(var data) {
    return _post('/api/v2/quickteller/customers/validations', data);
  }

  Future billPayment(var data) {
    int _rnd = Random().nextInt(999999999) + 1000000000;
    data["TerminalId"] = Globals.terminalId;
    data["requestReference"] = _rnd.toString();
//  {TerminalId:<YOUR_TERMINAL_ID>,paymentCode:10403,customerId:0000000001,customerMobile:2348056731576,customerEmail:johndoe@gmail.com,amount:360000,requestReference:1194000023}'
    return _post('/api/v2/quickteller/payments/advices', data);
  }
}
