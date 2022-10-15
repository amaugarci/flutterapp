class IDVerificationModel {
  String status;
  String message;
  VerificationData verificationData;

  IDVerificationModel.map(dynamic obj) {
    this.status = obj["status"].toString();
    this.message = obj["message"].toString();
    this.verificationData = obj['data'] == null ? null : VerificationData.fromJson(obj['data']);
  }
}

class VerificationData {
  int id;
  int status;
  String result;
  String street;
  String city;
  String state;
  String zipcode;
  String country;
  String created_at;
  String updated_at;
  List<Metadata> metadata;

  VerificationData.fromJson(dynamic jsonMap)
      : metadata = (jsonMap['metadata'] as List).map((i) => Metadata.fromJson(i)).toList(),
        id = int.parse(jsonMap['id'].toString()),
        status = int.parse(jsonMap['status'].toString()),
        result = jsonMap['result'].toString(),
        street = jsonMap['street'].toString(),
        city = jsonMap['city'].toString(),
        state = jsonMap['state'].toString(),
        zipcode = jsonMap['zipcode'].toString(),
        country = jsonMap['country'].toString(),
        created_at = jsonMap['created_at'].toString(),
        updated_at = jsonMap['updated_at'].toString();
}

class Metadata {
  int id;
  String path;
  int type;
  String created_at;
  String updated_at;

  Metadata.fromJson(dynamic jsonMap)
      : id = int.parse(jsonMap['id'].toString()),
        type = int.parse(jsonMap['type'].toString()),
        path = jsonMap['path'].toString(),
        created_at = jsonMap['created_at'].toString(),
        updated_at = jsonMap['updated_at'].toString();
}
