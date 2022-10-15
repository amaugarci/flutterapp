class LoginModel {
  String status;

  String message;
  String token;

  int id;
  String firstname;
  String lastname;
  String username;
  String email;
  String mobile;
  String roll;
  String birthday;
  String profile_image;

  LoginModel.map(dynamic obj) {
    if (obj != null) {
      this.status = obj["status"].toString();
      this.message = obj["message"].toString();
      this.token = obj["token"].toString();
      if (status == "true") {
        this.id = int.parse(obj['data']["id"].toString());
        this.firstname = obj['data']["firstname"].toString();
        this.lastname = obj['data']["lastname"].toString();
        this.username = obj['data']["username"].toString();
        this.email = obj['data']["email"].toString();
        this.birthday = obj['data']["birthday"].toString();
        this.mobile = obj['data']["mobile"].toString();
        this.roll = obj['data']["roll"].toString();
        this.profile_image = obj['data']['profile_image'].toString();
      }
    }
  }
}
