
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:testapp/components/rounder_btn.dart';
import 'package:testapp/constants.dart';
import 'package:testapp/screen/screen_home/user.dart';

class TodayScreen extends StatefulWidget {

  const TodayScreen({ Key? key }) : super(key: key);

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {

  var _checkInOut = true;
  var day= (DateTime.now().weekday > 5)? true : false;
  var checkin = '--/--';
  var checkout ="--/--";
  var OT = "--";
  var _checkOT = false;
  String location = "";

  double scr_h = 0;
  double scr_w = 0;
  Color primary = const Color(0xffeef444c);
  @override
  void initState() {

    Check();
  }


  void Check() async {
    var setDate = await FirebaseDatabase.instance.ref().child('attendance/' + User.usercode)
        .child(DateFormat("yyyy/MMMM/").format(DateTime.now()) + DateTime.now().day.toString());
    var _checkout = await setDate.child("checkout").get();
    var _checkin = await setDate.child("checkin").get();
    var _ot = await setDate.child("ot").get();
    setState(() {
      if (_checkin.exists) {
        checkin = _checkin.value.toString();
        _checkInOut = false;
      }
      if (_checkout.exists) {
        checkout = _checkout.value.toString();
      }
      if (_ot.exists) {
        OT = _ot.value.toString();
        _checkOT = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    scr_h=MediaQuery.of(context).size.height;
    scr_w=MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(top: 32),
            child:Text(
              "Wellcome",
              style: TextStyle(
                color: Colors.black54,
                fontFamily: "NexaRegular",
                fontSize: scr_w/20,
              ),
            ) ,
          ),
          Container(

            alignment: Alignment.centerLeft,
            child:Text(
              User.username,
              style: TextStyle(
                color: Colors.black54,
                fontFamily: "NexaBold",
                fontSize: scr_w/18,
              ),
            ) ,
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(top: 32),
            child:Text(
              "Today's Status",
              style: TextStyle(
                fontFamily: "NexaBold",
                fontSize: scr_w/18,
              ),
            ) ,
          ),
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 32),
            height: 150,
            decoration: const BoxDecoration(
              color: kSubColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(2,2),
                )
              ],
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Check in",
                          style: TextStyle(
                            fontFamily: "Nexaregular",
                            fontSize: scr_w/20,
                            color: Colors.black54,
                          ),),
                        Text(
                          checkin,
                          style: TextStyle(
                            fontFamily: "NexaBold",
                            fontSize: scr_w/18,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Check out",
                          style: TextStyle(
                            fontFamily: "Nexaregular",
                            fontSize: scr_w/20,
                            color: Colors.black54,
                          ),
                        ),
                        Text(checkout,
                          style: TextStyle(
                            fontFamily: "NexaBold",
                            fontSize: scr_w/18,
                            color: Colors.black54,),),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: _checkOT,
                  child: Expanded(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("OverTime",
                            style: TextStyle(
                              fontFamily: "Nexaregular",
                              fontSize: scr_w/20,
                              color: Colors.black54,
                            ),
                          ),
                          Text(OT,
                            style: TextStyle(
                              fontFamily: "NexaBold",
                              fontSize: scr_w/18,
                              color: Colors.black54,),),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if(checkin != "--/--" && !_checkInOut )
            RounderBtn(
              text: "Over Time",
              press: () {
                OverTime();
              },
              color: kSubColor,
              textColor: Colors.black,
            ),
          Container(
            alignment: Alignment.centerLeft,
            child: RichText(
              text: TextSpan(
                text: DateTime.now().day.toString(),
                style: TextStyle(
                  color: primary,
                  fontSize: scr_w/18,
                  fontFamily: "NexaBold",
                ),
                children: [
                  TextSpan(
                      text: DateFormat("  MMMM  yyyy").format(DateTime.now()),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: scr_w/20,
                      )
                  ),
                ],
              ),
            ),
          ),
          StreamBuilder(
              stream: Stream.periodic(const Duration(seconds: 1)),
              builder: (context, snapshot) {
                return Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    DateFormat("HH:mm:ss").format(DateTime.now()),
                    style: TextStyle(
                      fontFamily: "NexaBold",
                      fontSize: scr_w/18,
                      color: Colors.black54,),
                  ),
                );
              }
          ),
          ((checkout == "--/--"))?
          Container(
            margin: const EdgeInsets.only(top: 24),
            child: Builder(builder: (context) {
              final GlobalKey<SlideActionState> key = GlobalKey();
              return SlideAction(
                text: checkAttendance(),
                textStyle: TextStyle(
                  color: Colors.black54,
                  fontFamily: "NexaRegular",
                  fontSize: scr_w / 20,
                ),
                outerColor: Colors.white,
                innerColor: primary,
                key: key,
                onSubmit: () async {
                    await Future.delayed(
                        const Duration(seconds: 1),
                            () {}
                    );
                    key.currentState!.reset();
                    await Future.delayed(
                        const Duration(milliseconds: 1300),
                            () {}
                    );
                    var setDate = await FirebaseDatabase.instance.ref().child('attendance/' + User.usercode)
                        .child(DateFormat("yyyy/MMMM/").format(DateTime.now()) + DateTime.now().day.toString());
                    var checkAttendance = await setDate.child("checkout").get();
                    setState(() {
                      if (!checkAttendance.exists) {
                        if (_checkInOut) {
                          setDate.update(
                              {
                                'checkin': DateFormat("HH:mm").format(
                                    DateTime.now())
                              }
                          );
                          _checkInOut = !_checkInOut;
                          checkin = DateFormat("HH:mm").format(DateTime.now());
                        } else {
                          var hour = DateTime.now().hour - 17;
                          var minute = DateTime.now().minute;
                          hour = (minute > 30) ? (hour + 1) : hour;
                          setDate.update(
                              {
                                'checkout': DateFormat("HH:mm").format(
                                    DateTime.now())
                              }
                          );
                          checkout = DateFormat("HH:mm").format(DateTime.now());
                          if (_checkOT) {
                            setDate.update(
                                {
                                  'ot' : hour.toString()
                                }
                            );
                          }
                          _checkInOut = true;
                        }
                      }
                    }
                    );
                    var _checkin = await setDate.child("checkin").get();
                    var _checkout = await setDate.child("checkout").get();
                    var _ot = await setDate.child("ot").get();
                    setState(() {
                      if(_checkin.exists)
                        checkin = DateFormat("HH:mm").format(DateTime.now());
                      if (_checkout.exists)
                        checkout = DateFormat("HH:mm").format(DateTime.now());
                      if (_ot.exists)
                        OT = _ot.value.toString();
                    });

                },
              );
            }
            ),
          ): Container(
            padding: EdgeInsets.all(30),
            child: const Text(
              "Thanks",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          location != "" ? Text(
            "Location: " + location,
          ) : const SizedBox(),
        ],
        ),
      ),
    );
  }
  String checkAttendance(){
    return (!_checkInOut)? "Slide to Check out" : "Slide to Check in";
  }


  Future<void> OverTime() async {
    var setDate = await FirebaseDatabase.instance.ref().child('attendance/' + User.usercode)
        .child(DateFormat("yyyy/MMMM/").format(DateTime.now()) + DateTime.now().day.toString());
    var ot = await setDate.child("ot").get();
    setState(() {
      if(!ot.exists) {
        setDate.update(
            {
              'ot': '--'
            }
        );
      }
      _checkOT = true;
    });
  }

}
