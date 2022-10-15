import 'package:flutter/material.dart';
import 'package:upaychat/Apis/faqapi.dart';
import 'package:upaychat/CommonUtils/common_utils.dart';
import 'package:upaychat/CommonUtils/string_files.dart';
import 'package:upaychat/CustomWidgets/my_colors.dart';
import 'package:upaychat/Models/faqmodel.dart';
import 'package:upaychat/globals.dart';

class FaqFile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FaqFileState();
  }
}

class FaqFileState extends State<FaqFile> {
  bool isLoaded = false;
  bool isData = false;
  String msg;
  List<FaqData> faqlist = [];

  @override
  void initState() {
    _callApiListForFaq();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: MyColors.base_green_color,
        centerTitle: true,
        title: new Text(
          'Faqs',
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
        child: isLoaded
            ? Container(
                padding: EdgeInsets.only(top: 3, bottom: 3, left: 2, right: 2),
                child: isLoaded && isData
                    ? ListView.builder(
                        itemCount: faqlist.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(4.0))),
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(top: 5),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (faqlist[index].show == false) {
                                        faqlist[index].show = true;
                                      } else {
                                        faqlist[index].show = false;
                                      }
                                    });
                                  },
                                  child: Text(
                                    "${faqlist[index].id.toString()}." + faqlist[index].question,
                                    style: TextStyle(
                                      fontFamily: 'Doomsday',
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                faqlist[index].show
                                    ? Container(
                                        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          "Ans: " + faqlist[index].answer,
                                          style: TextStyle(
                                            color: MyColors.grey_color,
                                            fontSize: 18,
                                          ),
                                        ),
                                      )
                                    : Container()
                              ],
                            ),
                          );
                        })
                    : Text(
                        msg,
                        style: TextStyle(
                          fontFamily: 'Doomsday',
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
              )
            : CommonUtils.progressDialogBox());
  }

  void _callApiListForFaq() async {
    if (Globals.isOnline) {
      try {
        FaqApi _requestApi = new FaqApi();
        FaqModel result = await _requestApi.search();
        if (result.status == "true") {
          if (result.faqlist.isNotEmpty) {
            faqlist = result.faqlist;
            setState(() {
              isLoaded = true;
              isData = true;
            });
          } else {
            setState(() {
              isLoaded = true;
              isData = false;
            });
          }
        } else {
          CommonUtils.errorToast(context, result.message);
          Navigator.pop(context);
        }
      } catch (e) {
        print(e);
        Navigator.pop(context);
        CommonUtils.errorToast(context, e.toString());
      }
    } else {
      CommonUtils.errorToast(context, StringMessage.network_Error);
    }
  }
}
