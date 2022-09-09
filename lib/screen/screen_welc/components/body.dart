import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:testapp/components/rounder_btn.dart';
import 'package:testapp/constants.dart';
import 'package:testapp/screen/screen_login/login.dart';
import 'package:testapp/screen/screen_welc/components/background.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Death COMPANY",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            SizedBox(height: size.height*0.03),
            SvgPicture.asset(
              "assets/icons/chat.svg",
              height: size.height*0.5,
            ),
            SizedBox(height: size.height*0.06),
            RounderBtn(
              text: "LOG IN",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context){
                      return LoginScreen();
                      },
                  ),
                );
              },
            ),
            RounderBtn(
              text: "Forget Password",
              press: ()
                async {
                await FlutterPhoneDirectCaller.callNumber("0338029736");
              },
              color: kSubColor,
              textColor: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}



