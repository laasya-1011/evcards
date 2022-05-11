import 'dart:io';
import 'package:evcards/src/providers/profile_provider.dart';
import 'package:evcards/src/providers/storage.dart';
import 'package:evcards/src/utils/firebase_constants.dart';
import 'package:evcards/src/views/home_page.dart';
import 'package:evcards/src/views/widgets/text_input_deco.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CreateCard extends StatefulWidget {
  const CreateCard({Key? key}) : super(key: key);

  @override
  State<CreateCard> createState() => _CreateCardState();
}

class _CreateCardState extends State<CreateCard> {
  TextEditingController emailController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController phController = TextEditingController();
  TextEditingController jobTitleController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  File? _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.redAccent,
              ),
            )
          : Container(
              width: width,
              height: height,
              alignment: Alignment.center,
              child: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: ListView(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      'Create Your Card',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                          fontSize: 28),
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      child: Stack(
                        children: <Widget>[
                          Card(
                            elevation: 2,
                            shape: CircleBorder(),
                            child: ClipOval(
                                child: _image == null
                                    ? Image.asset(
                                        'assets/images/avatar.png',
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        _image!,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        fit: BoxFit.cover,
                                      )),
                          ),
                          Positioned(
                            top: 80,
                            left: 70,
                            child: InkWell(
                              onTap: getImage,
                              child: const Card(
                                  color: Colors.white,
                                  elevation: 10,
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.pink,
                                    size: 30,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(maxHeight: height * 0.105),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      height: height * 0.105,
                      margin: EdgeInsets.symmetric(horizontal: 13, vertical: 2),
                      child: TextFormField(
                        controller: fullNameController,
                        style: TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.none),
                        decoration: textFieldInputDeco('Full Name'),
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(maxHeight: height * 0.105),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      height: height * 0.105,
                      margin: EdgeInsets.symmetric(horizontal: 13, vertical: 2),
                      child: TextFormField(
                        controller: companyNameController,
                        style: TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.none),
                        decoration: textFieldInputDeco('Company Name'),
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(maxHeight: height * 0.105),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      height: height * 0.105,
                      margin: EdgeInsets.symmetric(horizontal: 13, vertical: 2),
                      child: TextFormField(
                        controller: jobTitleController,
                        style: TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.none),
                        decoration: textFieldInputDeco('JobTitle'),
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(maxHeight: height * 0.105),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      height: height * 0.105,
                      margin: EdgeInsets.symmetric(horizontal: 13, vertical: 2),
                      child: TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.none),
                        decoration: textFieldInputDeco('Email'),
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(maxHeight: height * 0.105),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      height: height * 0.105,
                      margin: EdgeInsets.symmetric(horizontal: 13, vertical: 2),
                      child: TextFormField(
                        controller: phController,
                        style: TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.none),
                        decoration: textFieldInputDeco('Mobile number'),
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(maxHeight: height * 0.105),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      height: height * 0.105,
                      margin: EdgeInsets.symmetric(horizontal: 13, vertical: 2),
                      child: TextFormField(
                        controller: addressController,
                        style: TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.none),
                        decoration: textFieldInputDeco('Address'),
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(maxHeight: height * 0.105),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      height: height * 0.105,
                      margin: EdgeInsets.symmetric(horizontal: 13, vertical: 2),
                      child: TextFormField(
                        controller: websiteController,
                        style: TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.none),
                        decoration: textFieldInputDeco('Website Link'),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          isLoading = true;
                        });
                        if (formKey.currentState?.validate() == true) {
                          await addFileToFirebase(
                                  filePath: _image?.path,
                                  firebasePath: "profilePic")
                              .then((profilePicUrl) async {
                            await profileProvider
                                .createProfile(
                                    uid: auth.currentUser?.uid,
                                    email: emailController.text,
                                    fullName: fullNameController.text,
                                    companyName: companyNameController.text,
                                    phoneNumber: phController.text,
                                    profilepicUrl: profilePicUrl,
                                    website: websiteController.text,
                                    address: addressController.text,
                                    jobTitle: jobTitleController.text)
                                .then((value) async {
                              await profileProvider
                                  .checkProfile(uid: auth.currentUser?.uid)
                                  .then((hasProfile) {
                                print("uid 2 ${auth.currentUser?.uid}");
                                if (hasProfile == true) {
                                  //
                                  profileProvider
                                      .saveProfileStatus(
                                          // saving status
                                          hasProfile: true)
                                      .then((value) {
                                    setState(() {
                                      isLoading = false;
                                    });

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomePage()),
                                    );
                                  });
                                  print("uid 3 has profile"); //
                                } else {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  print("something went wrong.. try again");
                                }
                              });
                            });
                          });
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(
                            vertical: 5, horizontal: width * 0.3),
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.redAccent,
                        ),
                        child: const Text(
                          'Submit',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
