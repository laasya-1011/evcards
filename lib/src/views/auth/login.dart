import 'package:evcards/src/providers/auth_provider.dart';
import 'package:evcards/src/providers/profile_provider.dart';
import 'package:evcards/src/utils/firebase_constants.dart';
import 'package:evcards/src/views/auth/forgot_password.dart';
import 'package:evcards/src/views/auth/signup.dart';
import 'package:evcards/src/views/cards/create_card.dart';
import 'package:evcards/src/views/home_page.dart';
import 'package:evcards/src/views/widgets/text_input_deco.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  final Function? toggle;

  const LoginPage({Key? key, this.toggle}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailID = TextEditingController();
  TextEditingController password = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final authProvider = Provider.of<AuthProvider>(context);
    final profileProvider = Provider.of<ProfileProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.redAccent,
                ),
              )
            : Container(
                width: width,
                height: height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    const Text(
                      'Digital Visiting Cards',
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                    ),
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          alignment: Alignment.topCenter,
                          width: width,
                          height: height * 0.37,
                          margin: EdgeInsets.symmetric(
                              horizontal: 35, vertical: 30),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(color: Colors.grey, blurRadius: 2)
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 17,
                              ),
                              const Text(
                                'Login Here',
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17),
                              ),
                              Form(
                                key: formKey,
                                child: Column(
                                  children: [
                                    Container(
                                      // padding: EdgeInsets.symmetric(horizontal: 10),
                                      height: height * 0.055,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 13, vertical: 20),
                                      child: TextFormField(
                                        validator: (val) {
                                          return RegExp(
                                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                  .hasMatch(val!)
                                              ? null
                                              : 'Please provide a valid emailID';
                                        },
                                        controller: emailID,
                                        style: TextStyle(
                                            color: Colors.black,
                                            decoration: TextDecoration.none),
                                        decoration: textFieldInputDeco(
                                            'Enter your Email ID'),
                                      ),
                                    ),
                                    Container(
                                      // padding: EdgeInsets.symmetric(horizontal: 10),
                                      height: height * 0.055,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 13, vertical: 8),
                                      child: TextFormField(
                                        validator: (val) {
                                          return (val != null && val.length > 7)
                                              ? null
                                              : 'minimum 8 characters required ';
                                        }, // craete aprofile
                                        controller: password,
                                        obscureText: true,
                                        style: TextStyle(color: Colors.black),
                                        decoration: textFieldInputDeco(
                                            'Enter Password'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                            top: height * 0.385,
                            child: GestureDetector(
                              onTap: () async {
                                if (emailID.text.isEmpty ||
                                    password.text.isEmpty) {
                                  Fluttertoast.showToast(
                                      msg: "Please enter the credentails");
                                } else {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  await authProvider
                                      .emailSignIn(
                                          email: emailID.text,
                                          pass: password.text)
                                      .then((user) {
                                    if (user == null) {
                                      // print("no user registered");
                                      setState(() {
                                        isLoading = false;
                                      });
                                      Fluttertoast.showToast(
                                          msg: "Something went wrong");
                                      // Navigator.pushReplacement(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) => SignUp()));
                                      print("something went wrong"); // wait
                                    } else {
                                      //   print("entered wrong place");
                                      profileProvider
                                          .checkProfile(
                                              uid: auth.currentUser?.uid)
                                          .then((hasProfile) {
                                        if (hasProfile == true) {
                                          profileProvider
                                              .saveProfileStatus(
                                                  hasProfile: true)
                                              .then((value) {
                                            print(" home");
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        HomePage()));
                                          });
                                          setState(() {
                                            isLoading = false; // test it
                                          });
                                        } else {
                                          print("signup");
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SignUp()));
                                          setState(() {
                                            isLoading = false;
                                          });
                                        }
                                      });
                                    }
                                  }).catchError((err) {
                                    setState(() {
                                      isLoading = false;
                                      setState(() {
                                        emailID.clear();
                                        password.clear();
                                      });
                                    });
                                    // password wrong or account doest exist

                                    Fluttertoast.showToast(
                                      msg: "${err.message}",
                                    );

                                    print('Error:: $err');
                                  });
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.redAccent,
                                ),
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13),
                                ),
                              ),
                            ))
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 10),
                      margin: EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgotPassword()),
                            );
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                                color: Colors.redAccent, fontSize: 12),
                          )),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      height: height * 0.005,
                      color: Colors.grey[300],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 30),
                      child: const Text(
                        'Don\'t Have An Account?',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.black54), // sign up
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        //  Get.to(SignUp());
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SignUp()));
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.redAccent,
                        ),
                        child: const Text(
                          'SignUp',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  @override
  void dispose() {
    setState(() {
      emailID.clear();
      password.clear();
    });
    super.dispose();
  }
}
