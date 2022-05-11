import 'dart:async';

import 'package:evcards/src/utils/firebase_constants.dart';
import 'package:evcards/src/views/auth/login.dart';
import 'package:evcards/src/views/auth/signup.dart';
import 'package:evcards/src/views/cards/create_card.dart';
import 'package:evcards/src/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/providers/profile_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    Timer(Duration(seconds: 3), () async {
      if (auth.currentUser == null) {
        // go to login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        profileProvider.profileStatus().then((value) {
          if (value == true) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          } else {
            profileProvider
                .checkProfile(uid: auth.currentUser?.uid)
                .then((hasProfile) async {
              if (hasProfile == true) {
                // save profile status and move to home page
                profileProvider
                    .saveProfileStatus(hasProfile: true)
                    .then((value) {
                  // navigate to home screen
                  //
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                });
              } else {
                // create profile
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => CreateCard()),
                );
              }
            });
          }
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Center(
          child: Container(
              width: width,
              height: height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: height * 0.15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: 5),
                              Text("Digital Visiting Cards".toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.blue[900],
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                          Center(
                            child: Image.asset("assets/images/card.png",
                                height: height * 0.35,
                                width: width,
                                fit: BoxFit.cover),
                          )
                        ],
                      )),
                  Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Welcome !',
                            style: TextStyle(
                                color: Colors.blue[900],
                                fontSize: 32,
                                fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, top: 4, bottom: 32),
                            child: Text(
                              'Connecting people by electronic visiting cards!',
                              style: TextStyle(
                                  color: Colors.red[300],
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ))
                ],
              )),
        ),
      ),
    );
  }
}
