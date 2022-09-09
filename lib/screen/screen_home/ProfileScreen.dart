
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:testapp/screen/screen_home/user.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_database/firebase_database.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  double screenHeight = 0;
  double screenWidth  = 0;
  Color primary = const Color(0xffeef444c);
  TextEditingController NameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController bodController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Firebase.apps.length == "") {
      Firebase.initializeApp();
    }
  }
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    String birth = "Date of birth";
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top:80, bottom: 24),
                height: 120,
                width: 120,
                alignment:  Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: primary
            ) ,
                // child: Center(
                //   child: Icon(
                //     Icons.person,
                //     color: Colors.white,
                //     size: 80,
                //   ),
                // ),
        ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Employee ${User.usercode}",
                  style: TextStyle(
                    fontFamily: "NexaBold",
                    fontSize: 18,

                  ),
                ),
    ),
              const SizedBox(height: 24),
              textField("Full Name", "Full Name", NameController),
              textField("Birth of Date", "Birth of Date", bodController),
              Container(
                height: kToolbarHeight,
                width: screenWidth,
                margin: EdgeInsets.only(bottom:12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: Colors.black54,
                  ),
                ),
              ),
               textField("Address", "Address", addressController),             
              GestureDetector(
                onTap: () async {
                  String fullName=NameController.text;
                     String birthDate=bodController.text;
                     String address = addressController.text;

                  if(User.canEdit){
                     if(fullName.isEmpty){
                       showSnackBar("Please enter your name!");
                     }else if(birthDate.isEmpty){
                       showSnackBar("Please enter your birth data");
                     }else if(address.isEmpty){
                       showSnackBar("Please enter your address!");
                     }else{
                       showSnackBar("You can't edit anymore, please contact support team.");
                       var setDate = await FirebaseDatabase.instance.ref().child('information/' + User.usercode);
                      setDate.update({
                        'name':fullName,
                        'bod':birthDate,
                        'addr':address
                      });}
                  }
                  showDatePicker(context:context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1950),
                  lastDate: DateTime.now(),
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
                  ).then((value) {
                    setState(() {
                      birth=DateFormat("MM/dd/yyyy").format(value!);
                    });
                  }
                  
                  );
                } ,
                child: Container(
                  height: kToolbarHeight,
                  width: screenWidth,
                  margin: EdgeInsets.only(bottom: 12),

                  padding: const EdgeInsets.only(left: 11),

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                      color: primary
                    ),
                      child: const Center(
                      child: Text(
                        "SAVE",
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: "NexaBold",
                          fontSize: 16,
                        ),
                      ),
                    )
    ),
              ),
        ]), //Center
      ), //SingleChildScrollView
    );//Scaffold
  }
  Widget textField(String title, String hint, TextEditingController controller){
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft ,
          child: Text(
            title,
            style: const TextStyle(
              fontFamily: "NexaBold",
              color: Colors.black87,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 12),
          child: TextFormField(
          cursorColor: Colors.black54,
          maxLines: 1,
          decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
          color: Colors.black54,
          fontFamily: "NexaBold"
          ),
          enabledBorder : const OutlineInputBorder(
          borderSide: BorderSide(
          color: Colors.black54,
          ),
          ),
          focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
          color: Colors.black54,
        ),
      ),
    ),
    ),
    ),
    ],
    );
    }
    void showSnackBar(String text){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(
          text,
        ),)
      );
    }
}