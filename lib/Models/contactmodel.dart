import 'package:contacts_service/contacts_service.dart';

class ContactModel {
  Contact contact;
  bool show = false;
  ContactModel(Contact c) {
    this.contact = c;
  }
}
