import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:upaychat/CustomWidgets/my_colors.dart';
import 'package:upaychat/Models/contactmodel.dart';

class PickContactFile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PickContactFileState();
  }
}

class PickContactFileState extends State<PickContactFile> {
  Function(String) onContactPicked;
  List<ContactModel> _contacts;

  @override
  void initState() {
    super.initState();
    refreshContacts();
  }

  Future<void> refreshContacts() async {
    var contacts = (await ContactsService.getContacts(withThumbnails: false, iOSLocalizedLabels: false)).toList();
    setState(() {
      _contacts = contacts.map((e) => ContactModel(e)).toList();
    });
    for (final contact in _contacts) {
      ContactsService.getAvatar(contact.contact).then((avatar) {
        if (avatar == null) return; // Don't redraw if no change.
        setState(() => contact.contact.avatar = avatar);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    onContactPicked = (ModalRoute.of(context).settings.arguments as Map)['onContactPicked'];
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: MyColors.base_green_color,
        centerTitle: true,
        title: new Text(
          'Contacts',
          style: TextStyle(
            fontFamily: 'Doomsday',
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: Container(
        color: MyColors.base_green_color_20,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: _body(context),
      ),
    );
  }

  _body(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: _contacts != null
          ? ListView.builder(
              itemCount: _contacts?.length ?? 0,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                ContactModel _contactItem = _contacts?.elementAt(index);
                Contact _contact = _contactItem.contact;
                return Card(
                  elevation: 4,
                  child: InkWell(
                    splashColor: MyColors.base_green_color.withAlpha(200),
                    onTap: () {
                      setState(() {
                        if (_contacts[index].show == false) {
                          _contacts[index].show = true;
                        } else {
                          _contacts[index].show = false;
                        }
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(top: 5),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              children: [
                                (_contact.avatar != null && _contact.avatar.length > 0)
                                    ? CircleAvatar(
                                        radius: 22,
                                        backgroundImage: MemoryImage(_contact.avatar),
                                      )
                                    : CircleAvatar(
                                        radius: 22,
                                        child: Text(_contact.initials()),
                                      ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 15),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _contact.displayName,
                                          style: TextStyle(
                                            fontFamily: 'Doomsday',
                                            color: Colors.black,
                                            fontSize: 20,
                                          ),
                                        ),
                                        if (_contact.emails.length > 0)
                                          Text(
                                            _contact.emails.first?.value,
                                            style: TextStyle(
                                              fontFamily: 'Doomsday',
                                              fontSize: 16,
                                            ),
                                          )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          if (_contactItem.show)
                            ListView.builder(
                              itemCount: _contact.phones.length,
                              shrinkWrap: true,
                              itemBuilder: (context, id) {
                                return InkWell(
                                  splashColor: MyColors.base_green_color.withAlpha(200),
                                  onTap: () {
                                    onContactPicked(_contact.phones.elementAt(id).value.replaceAll(new RegExp(r'[^+0-9]'), ''));
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                      margin: EdgeInsets.all(8),
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        children: [
                                          Text(
                                            _contact.phones.elementAt(id).label + ": ",
                                            style: TextStyle(color: MyColors.grey_color, fontSize: 18, fontWeight: FontWeight.bold),
                                          ),
                                          Expanded(
                                            child: Text(
                                              _contact.phones.elementAt(id).value.replaceAll(new RegExp(r'[^+0-9]'), ''),
                                              style: TextStyle(
                                                color: MyColors.grey_color,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                          Icon(
                                            MaterialIcons.keyboard_arrow_right,
                                            color: MyColors.grey_color,
                                            size: 30,
                                          ),
                                        ],
                                      )),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              })
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
