import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:testapp/screen/screen_home/user.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({ Key? key }) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}
  double scr_h = 0;
  double scr_w = 0;
  var _checkin = '--/--';
  var _checkout ="--/--";
  Color primary = const Color(0xffeef444c);
  String _day = (int.parse(DateFormat('dd').format(DateTime.now()))-1).toString();
class _CalendarScreenState extends State<CalendarScreen> {
  @override
  void initState() {
    // TODO: implement initState
    Check();
    if (Firebase.apps.length == "") {
      Firebase.initializeApp();
    }
  }
void Check() async {
    var setDate = await FirebaseDatabase.instance.ref().child('attendance/' + User.usercode)
        .child(DateFormat("yyyy/MMMM/").format(DateTime.now()) + _day);
    var __checkout = await setDate.child("checkout").get();
    var __checkin = await setDate.child("checkin").get();
    setState(() {
      if (__checkin.exists) {
        _checkin = __checkin.value.toString();
      }
      if (__checkout.exists) {
        _checkout = __checkout.value.toString();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    scr_h=MediaQuery.of(context).size.height;
    scr_w=MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(top: 32),
            child:Text(
              "My Attendence",
              style: TextStyle(
                fontFamily: "NexaBold",
                fontSize: scr_w/18,
              ),
            ) ,
          ),
          Stack(
            children: [
              Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(top: 32),
            child:Text(
              _day+DateFormat(" / MMMM / yyyy").format(DateTime.now()),
              style: TextStyle(
                fontFamily: "NexaBold",
                fontSize: scr_w/18,
              ),
            ) ,
          ),
          Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(top: 32),
            child: GestureDetector(
              onTap: () async{
                final day = await showDatePicker(
                  context: context, 
                  initialDate: DateTime.now(), 
                  firstDate: DateTime(2000), 
                  lastDate: DateTime(2100),
                  builder: (context, child){
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.light(
                          primary: primary,
                          secondary: primary,
                          onSecondary: Colors.white,
                        ),
                        textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(
                            primary: primary,
                          ),
                        ),
                  textTheme: const TextTheme(
                    headline4: TextStyle(
                      fontFamily: "NexaBold",
                    ),
                    overline: TextStyle(
                      fontFamily: "NexaBold",
                    ),
                      button: TextStyle(
                        fontFamily: "NexaBold",
                      ),
 )                     ),
                        child: child!,
                      );
                  }
                );
                if(day!=null){
                  setState(() {
                    _day=DateFormat('dd').format(day);
                    Check();
                  });
                }
                
              },
            child:Text(
              "Pick a Day",
              style: TextStyle(
                fontFamily: "NexaBold",
                fontSize: scr_w/18,
              ),
            ), ),
          ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 12, left: 6, right: 6),
            height: 150,
            decoration: const BoxDecoration(
              color: Colors.white,
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
                        _checkin,
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
                      Text(
                        _checkout,
                      style: TextStyle(
                        fontFamily: "NexaBold",
                        fontSize: scr_w/18,
                        color: Colors.black54,),),
                    ],
                  ),
                ),
                ),
              ],
            ),
          ),
          ]),
      ),
      );
  }
}