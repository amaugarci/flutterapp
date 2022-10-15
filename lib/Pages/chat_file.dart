import 'dart:async';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:upaychat/Apis/currenttimeapi.dart';
import 'package:upaychat/CommonUtils/common_utils.dart';
import 'package:upaychat/CommonUtils/firebase_utils.dart';
import 'package:upaychat/CommonUtils/preferences_manager.dart';
import 'package:upaychat/CommonUtils/string_files.dart';
import 'package:upaychat/CustomWidgets/my_colors.dart';
import 'package:upaychat/Models/commonmodel.dart';
import 'package:upaychat/globals.dart';
import 'package:intl/intl.dart';

class ChatFile extends StatefulWidget {
  final String receiverid;
  final String receiver;
  final String avatar;
  final String avatarTxt;

  const ChatFile({Key key, this.receiverid, this.receiver, this.avatar, this.avatarTxt}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ChatFileState();
  }
}

class ChatFileState extends State<ChatFile> {
  String userid;
  bool isCustomer;
  bool connecting = true;
  bool isUserOnline = false;
  bool isTyping = false;
  Timer checkOnlineTimer;
  Timer draftTimer;

  String messageText;
  TextEditingController messageTextController = TextEditingController();
  FocusNode _focus = new FocusNode();
  List<MessageBubble> messageBubbles = [];

  @override
  void initState() {
    userid = CommonUtils.getStrUserid();
    isCustomer = PreferencesManager.getString(StringMessage.roll) == "customer";
    getMessages();
    checkOnline();
    checkDraftMessages();
    _focus.addListener(_onFocusChange);
    super.initState();
  }

  void closeChat() {
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
              String selUsrId = widget.receiverid.toString();
              FirebaseUtils.deleteMessage(isCustomer ? userid : selUsrId, isCustomer ? selUsrId : userid);
              Navigator.of(context).pop(false);
              Navigator.pop(context);
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

  bool isSending = false;
  void reSendDraftMessage() async {
    if (isSending) return;
    if (messageBubbles == null || messageBubbles.length <= 0) return;
    var draftMessages = messageBubbles.where((element) => element.isSending).toList();
    if (draftMessages.length <= 0) return;
    draftMessages = draftMessages.reversed.toList();
    isSending = true;

    if (Globals.isOnline) {
      CurrentTimeApiRequest _currentTimeApi = new CurrentTimeApiRequest();
      CommonModel result = await _currentTimeApi.search();
      if (result.status == "true") {
        DateTime tmpTime = DateTime.parse(result.message);
        draftMessages.forEach((element) {
          tmpTime = tmpTime.add(Duration(seconds: 1));
          String formattedDate = DateFormat('yyyy-MM-dd kk:mm:ss').format(tmpTime);
          var sentMessage = {'text': element.messageText, 'sender': element.messageSender, 'read': false, 'sent': isUserOnline};
          FirebaseUtils.sendMessage(isCustomer ? userid : widget.receiverid, isCustomer ? widget.receiverid : userid, formattedDate, sentMessage);
          deleteMessage(element.id);
        });
      }
    } else {
      CommonUtils.errorToast(context, StringMessage.network_Error);
    }

    isSending = false;
  }

  void checkDraftMessages() {
    if (draftTimer != null && draftTimer.isActive) draftTimer.cancel();
    draftTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      print("running timer => " + Globals.isInForeground.toString());
      if (!Globals.isInForeground) return;
      reSendDraftMessage();
    });
  }

  void getMessages() {
    var _messageRef = FirebaseUtils.getMessageRef(isCustomer ? userid : widget.receiverid, isCustomer ? widget.receiverid : userid);
    _messageRef.onChildAdded.listen((event) {
      var snapshot = event.snapshot;
      if (snapshot.exists) {
        Map message = snapshot.value;
        try {
          final id = snapshot.key;
          final messageText = message['text'];
          final messageSender = message['sender'];
          final read = message.containsKey('read') && message['read'];
          final sent = message.containsKey('sent') && message['sent'];

          final messageBubble = MessageBubble(
            id: id,
            messageText: messageText,
            messageSender: messageSender,
            messageTime: id,
            isMe: userid == messageSender,
            read: read,
            sent: sent,
            isSending: false,
          );
          appendMessage(messageBubble);
        } catch (e) {}
      }
    });
    _messageRef.onChildRemoved.listen((event) {
      var snapshot = event.snapshot;
      if (snapshot.exists) {
        deleteMessage(snapshot.key);
      }
    });
    _messageRef.onChildChanged.listen((event) {
      var snapshot = event.snapshot;
      if (snapshot.exists) {
        Map message = snapshot.value;
        try {
          final id = snapshot.key;
          final messageText = message['text'];
          final messageSender = message['sender'];
          final read = message.containsKey('read') && message['read'];
          final sent = message.containsKey('sent') && message['sent'];

          final messageBubble = MessageBubble(
            id: id,
            messageText: messageText,
            messageSender: messageSender,
            messageTime: id,
            isMe: userid == messageSender,
            read: read,
            sent: sent,
            isSending: false,
          );
          updateMessage(snapshot.key, messageBubble);
        } catch (e) {}
      }
    });
  }

  void appendMessage(var messageBubble) {
    messageBubbles.insert(0, messageBubble);
    setState(() {
      messageBubbles = List.from(messageBubbles);
    });
  }

  void updateMessage(String key, MessageBubble messageBubble) {
    int index = messageBubbles.indexWhere((element) => element.id == key);
    messageBubbles[index] = messageBubble;
    setState(() {
      messageBubbles = List.from(messageBubbles);
    });
  }

  void deleteMessage(var key) {
    messageBubbles.removeWhere((element) => element.id == key);
    setState(() {
      messageBubbles = List.from(messageBubbles);
    });
  }

  void checkOnline() {
    if (checkOnlineTimer != null && checkOnlineTimer.isActive) checkOnlineTimer.cancel();
    checkOnlineTimer = Timer.periodic(Duration(seconds: CommonUtils.CHECK_ONLINE_SECONDS), (timer) {
      print("running timer => " + Globals.isInForeground.toString());
      if (!Globals.isInForeground) return;
      checkOnlineStatus();
      readMessage();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
    setTyping(false);
  }

  void _onFocusChange() {
    setTyping(_focus.hasFocus);
  }

  var typingTimer;
  void setTyping(bool isFocus) {
    Globals.typingDate = isFocus ? DateTime.now() : null;
    FirebaseUtils.updateState();
  }

  bool _loadImageError = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        checkOnlineTimer.cancel();
        Navigator.of(context).pop();
        return;
      },
      child: GestureDetector(
        onTap: () => _focus?.unfocus(),
        child: Scaffold(
          appBar: new AppBar(
            backgroundColor: MyColors.base_green_color,
            centerTitle: true,
            title: Text(
              widget.receiver,
              style: TextStyle(
                fontFamily: 'Doomsday',
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            actions: [
              Container(
                  padding: EdgeInsets.all(10),
                  child: SizedBox(
                      width: 40,
                      child: Stack(
                        clipBehavior: Clip.none,
                        fit: StackFit.expand,
                        children: [
                          CircleAvatar(
                            radius: 100,
                            backgroundImage: this._loadImageError ? null : NetworkImage(widget.avatar),
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
                                    widget.avatarTxt,
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  )
                                : null,
                          ),
                          Positioned(
                              bottom: 0,
                              left: 0,
                              child: Badge(
                                toAnimate: false,
                                shape: BadgeShape.square,
                                badgeColor: isUserOnline ? MyColors.online_bg_color : MyColors.grey_color,
                                borderRadius: BorderRadius.circular(999),
                                badgeContent: SizedBox(
                                  width: 5,
                                  height: 5,
                                ),
                              )),
                        ],
                      )))

              // IconButton(
              //     icon: Icon(Icons.close),
              //     tooltip: 'Close Chat',
              //     onPressed: () {
              //       closeChat();
              //     }),
            ],
          ),
          body: Container(
            color: MyColors.base_green_color_20,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(10),
            child: _body(context),
          ),
        ),
      ),
    );
  }

  void checkOnlineStatus() {
    try {
      if (!CommonUtils.checkStringId(widget.receiverid)) {
        return;
      }
      FirebaseUtils.checkOnline(widget.receiverid).then((value) {
        bool isOn = false;
        bool typing = false;
        if (value.exists) {
          Map data = Map.from(value.value);
          int status = data.containsKey("status") ? data['status'] : CommonUtils.OFFLINE_STATUS;
          String date = data.containsKey("date") ? data['date'] : null;
          if (status == CommonUtils.OFFLINE_STATUS || date == null) {
            return;
          }
          var now = DateTime.now();
          var later = DateTime.parse(date).add(const Duration(seconds: CommonUtils.CHECK_ONLINE_SECONDS + 10));
          bool checkDate = later.isAfter(now);
          if (!checkDate) return;
          isOn = true;
          typing = status == CommonUtils.TYPING_STATUS;
        }
        setState(() {
          isUserOnline = isOn;
          isTyping = typing;
        });
      });
    } catch (e) {
      print("check on: " + e.toString());
    }
  }

  void readMessage() async {
    if (!CommonUtils.checkStringId(userid) || !CommonUtils.checkStringId(widget.receiverid)) {
      return;
    }
    String c1 = isCustomer ? userid : widget.receiverid;
    String c2 = isCustomer ? widget.receiverid : userid;
    FirebaseUtils.readMessages(c1, c2);
  }

  _body(BuildContext context) {
    readMessage();
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              children: messageBubbles,
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(left: 15, bottom: 5),
            child: Text(
              isTyping ? "Typing ..." : "",
              style: TextStyle(fontSize: 14),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: MyColors.light_grey_divider_color,
              boxShadow: [
                BoxShadow(color: Colors.grey, spreadRadius: 1),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageTextController,
                    focusNode: _focus,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Doomsday',
                    ),
                    onChanged: (value) {
                      setTyping(true);
                      setState(() {
                        messageText = value;
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                      hintText: 'Type your message here...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                (messageText != null && messageText.length > 0)
                    ? IconButton(
                        onPressed: () {
                          messageTextController.clear();
                          var tmpMessage = new MessageBubble(
                            id: CommonUtils.getRandomString(length: 10),
                            messageText: messageText,
                            messageSender: userid,
                            messageTime: null,
                            isMe: true,
                            read: false,
                            sent: false,
                            isSending: true,
                          );

                          appendMessage(tmpMessage);
                          reSendDraftMessage();
                        },
                        icon: Icon(
                          Icons.send,
                          color: Colors.lightBlueAccent,
                          size: 22,
                        ),
                      )
                    : Container()
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String id;
  final String messageText;
  final String messageSender;
  final String messageTime;
  final bool isMe;
  final bool read;
  final bool sent;
  final bool isSending;

  MessageBubble({this.id, this.messageText, this.messageSender, this.messageTime, this.isMe, this.read, this.sent, this.isSending});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Column(
        children: [
          Container(
              child: Row(
            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              (isMe && isSending)
                  ? Container(
                      margin: EdgeInsets.only(right: 12),
                      child: SizedBox(
                        child: CircularProgressIndicator(strokeWidth: 3),
                        height: 15.0,
                        width: 15.0,
                      ),
                    )
                  : Container(),
              Material(
                elevation: 5,
                color: isMe ? Colors.lightBlueAccent : Colors.white,
                borderRadius: isMe
                    ? BorderRadius.only(
                        topLeft: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      )
                    : BorderRadius.only(
                        topRight: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                      ),
                child: Container(
                    constraints: BoxConstraints(minWidth: 100, maxWidth: MediaQuery.of(context).size.width * 0.7),
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$messageText',
                          style: TextStyle(fontSize: 20, color: isMe ? Colors.white : Colors.black87),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check,
                              color: (!isMe || this.sent) ? MyColors.base_green_color : MyColors.grey_color,
                              size: 20,
                            ),
                            Icon(
                              Icons.check,
                              color: (!isMe || this.read) ? MyColors.base_green_color : MyColors.grey_color,
                              size: 20,
                            ),
                            Container(
                              child: Text(
                                messageTime == null ? "Just now" : CommonUtils.timesAgoFeature(messageTime),
                                style: TextStyle(
                                  color: isMe ? Colors.white : Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
              ),
            ],
          )),
        ],
      ),
    );
  }
}
