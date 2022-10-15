import 'package:flutter/material.dart';
import 'package:upaychat/CommonUtils/common_utils.dart';
import 'package:upaychat/CommonUtils/firebase_utils.dart';
import 'package:upaychat/CustomWidgets/my_colors.dart';
import 'package:upaychat/Models/MessageModel.dart';
import 'package:upaychat/Pages/chat_file.dart';
import 'package:badges/badges.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:upaychat/globals.dart';

class ChatListItem extends StatefulWidget {
  final data;
  final bool isCustomer;

  const ChatListItem({Key key, this.data, this.isCustomer}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ChatList();
  }
}

class ChatList extends State<ChatListItem> {
  String userid;
  bool _loadImageError = false;
  MessageModel lastMessage;
  var updateListener;

  @override
  void initState() {
    userid = CommonUtils.getStrUserid();
    String tmpChild1 = widget.isCustomer ? userid : widget?.data?.user_id?.toString();
    String tmpChild2 = !widget.isCustomer ? userid : widget?.data?.user_id?.toString();
    try {
      if (updateListener) updateListener.cancel();
    } catch (e) {}

    updateListener = FirebaseUtils.onValueListener(tmpChild1, tmpChild2).listen((event) {
      updateValue(event);
    });
    super.initState();
  }

  void updateValue(event) {
    int unread = 0;
    String text = "";
    String id = "";
    bool read = false;
    bool sent = false;
    int sender = widget.data.user_id;
    if (event.snapshot.exists) {
      var snapshots = event.snapshot.value;

      checkRead(Map tmpMap) {
        return tmpMap.containsKey('sender') && tmpMap['sender'] != userid && !tmpMap['read'];
      }

      unread = snapshots.values.where((e) => checkRead(e)).length;
      var msgData = snapshots.values.last;
      id = snapshots.keys.last;
      if (msgData != null) {
        text = (msgData.containsKey("text") && msgData['text'] != null) ? msgData['text'] : "";
        read = (msgData.containsKey("read") && msgData['read'] != null) && msgData['read'];
        sent = read || (msgData.containsKey("sent") && msgData['sent'] != null && msgData['sent']);
      }
    }
    MessageModel tmpLast = new MessageModel(id, text, read, sent, unread, sender);
    setState(() {
      lastMessage = tmpLast;
    });
  }

  void closeChat(dynamic param) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          'Do you want to close this chat?',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 18,
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: MyColors.base_green_color,
            ),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text(
              'No',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: MyColors.base_green_color,
            ),
            onPressed: () {
              String selUsrId = param.user_id.toString();
              FirebaseUtils.deleteMessage(widget.isCustomer ? userid : selUsrId, widget.isCustomer ? selUsrId : userid);
              Navigator.of(context).pop(false);
            },
            child: Text(
              'Yes',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getName(String first, String last) {
    String tmp = "";
    if (first != null && first.length > 0) {
      tmp += first[0];
    }
    if (last != null && last.length > 0) {
      tmp += last[0];
    }
    return tmp;
  }

  @override
  Widget build(BuildContext context) {
    var item = widget.data;
    bool isNotEmptyMsg = lastMessage != null && lastMessage.id != null && lastMessage.id.isNotEmpty;
    return Slidable(
      key: Key(item.user_id.toString()),
      actionPane: SlidableBehindActionPane(),
      actionExtentRatio: 0.25,
      fastThreshold: 1,
      closeOnScroll: true,
      // Display item's title, price...
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatFile(
                            avatarTxt: getName(item.firstname, item.lastname),
                            avatar: Globals.base_url + item.profile_image,
                            receiverid: item.user_id.toString(),
                            receiver: item.username,
                          )),
                );
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(5, 8, 3, 8),
                child: Row(
                  children: [
                    Container(
                        margin: const EdgeInsets.only(left: 0, right: 12, top: 0, bottom: 0),
                        height: 60.0,
                        width: 60.0,
                        child: CircleAvatar(
                          radius: 100,
                          backgroundImage: this._loadImageError ? null : NetworkImage(Globals.base_url + item.profile_image),
                          onBackgroundImageError: this._loadImageError
                              ? null
                              : (dynamic exception, StackTrace stackTrace) {
                                  print("Error loading image! " + exception.toString());
                                  WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
                                        this._loadImageError = true;
                                      }));
                                },
                          child: this._loadImageError
                              ? Text(
                                  getName(item.firstname, item.lastname),
                                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                                )
                              : null,
                        )),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.firstname + " " + item.lastname,
                            maxLines: 1,
                            style: TextStyle(
                              fontFamily: 'Doomsday',
                              color: MyColors.grey_color,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            isNotEmptyMsg && lastMessage.text != null ? lastMessage.text : "",
                            style: TextStyle(
                              fontFamily: 'Doomsday',
                              color: MyColors.grey_color,
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              isNotEmptyMsg
                                  ? Icon(
                                      Icons.check,
                                      color: lastMessage.isSent ? MyColors.base_green_color : MyColors.grey_color,
                                      size: 24,
                                    )
                                  : Container(),
                              isNotEmptyMsg
                                  ? Icon(
                                      Icons.check,
                                      color: lastMessage.isRead ? MyColors.base_green_color : MyColors.grey_color,
                                      size: 24,
                                    )
                                  : Container(),
                              Container(
                                child: Text(isNotEmptyMsg ? CommonUtils.timesAgoFeature(lastMessage.id) : ""),
                              ),
                            ],
                          ),
                          isNotEmptyMsg && lastMessage.unreadMsgCount > 0
                              ? Badge(
                                  badgeContent: Text(
                                    lastMessage.unreadMsgCount.toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  animationType: BadgeAnimationType.fade,
                                )
                              : Container()
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            color: MyColors.light_grey_divider_color,
            height: 1,
          ),
        ],
      ),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => closeChat(item),
        ),
      ],
    );
  }
}
