import 'package:evcards/src/providers/profile_provider.dart';
import 'package:evcards/src/utils/firebase_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

DateTime? currentBackPressTime;

class ViewCard extends StatefulWidget {
  final String? uid;
  const ViewCard({Key? key, @required String? this.uid}) : super(key: key);

  @override
  State<ViewCard> createState() => _ViewCardState();
}

class _ViewCardState extends State<ViewCard> {
  DocumentSnapshot? _profile;
  bool isLoading = false;
  Future initData() async {
    setState(() {
      isLoading = true;
    });
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    final snapshot = await fireStoreSnapshotRef
        .collection('userCard')
        .where('uid', isEqualTo: widget.uid)
        .get();
    _profile = snapshot.docs[0];
    print(_profile?['uid']);
    await profileProvider
        .addSharedAndReceived(uid: auth.currentUser?.uid, rid: widget.uid)
        .then((value) {});
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    initData();
    super.initState();
  }

  /* int i = 0;

  Future<bool?> _onWillPop(BuildContext context) async {
    DateTime now = DateTime.now();
    if (i != 0) {
      setState(() {
        i = 0;
      });
    } else if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
          "Press back again to exit",
          style: TextStyle(color: Colors.black),
        ),
      ));
      // Fluttertoast.showToast(msg: "Press back again to exit");
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }*/

  @override
  Widget build(BuildContext context) {
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
              child: ListView(children: [
                Container(
                  child: Stack(
                    fit: StackFit.loose,
                    children: [
                      ClipPath(
                        clipper: WaveClipperOne(reverse: false, flip: true),
                        child: Container(
                          width: width,
                          height: height * 0.42,
                          color: Color.fromARGB(255, 209, 33, 240),
                        ),
                      ),
                      ClipPath(
                        clipper: WaveClipperTwo(reverse: false, flip: false),
                        child: Container(
                          width: width,
                          height: height * 0.4,
                          /*  */
                          padding: EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 4)
                            ],
                            color: Colors.white,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  _profile?['profile_picture'],
                                )),
                            // border: Border.all(color: Colors.purple, width: 3),
                            // borderRadius: BorderRadius.circular(20)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.account_circle_sharp,
                        size: 38,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        _profile?['full_name'],
                        style: TextStyle(
                            color: Colors.blue[900],
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: Divider(
                    thickness: 1,
                    color: Colors.grey[300],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.phone,
                        size: 38,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        _profile?['phone_number'],
                        style: TextStyle(
                            color: Colors.blue[900],
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: Divider(
                    thickness: 1,
                    color: Colors.grey[300],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.work,
                        size: 38,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        _profile?['job_title'],
                        style: TextStyle(
                            color: Colors.blue[900],
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: Divider(
                    thickness: 1,
                    color: Colors.grey[300],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.email,
                        size: 38,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        _profile?['email'],
                        style: TextStyle(
                            color: Colors.blue[900],
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: Divider(
                    thickness: 1,
                    color: Colors.grey[300],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.location_city,
                        size: 38,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        _profile?['company_name'],
                        style: TextStyle(
                            color: Colors.blue[900],
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: Divider(
                    thickness: 1,
                    color: Colors.grey[300],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.location_on,
                        size: 38,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        _profile?['address'],
                        style: TextStyle(
                            color: Colors.blue[900],
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: Divider(
                    thickness: 1,
                    color: Colors.grey[300],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.web,
                        size: 38,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        _profile?['website'],
                        style: TextStyle(
                            color: Colors.blue[900],
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: Divider(
                    thickness: 1,
                    color: Colors.grey[300],
                  ),
                ),
              ]),
            ),
    );
  }
}
