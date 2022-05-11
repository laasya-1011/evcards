import 'package:evcards/src/providers/profile_provider.dart';
import 'package:evcards/src/utils/firebase_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SharedToScreen extends StatefulWidget {
  const SharedToScreen({Key? key}) : super(key: key);

  @override
  State<SharedToScreen> createState() => _SharedToScreenState();
}

class _SharedToScreenState extends State<SharedToScreen> {
  List<String?> sharedToUid = <String?>[];
  Future getData() async {
    try {
      await fireStoreSnapshotRef
          .collection("userCard")
          .doc(auth.currentUser?.uid)
          .get()
          .then((snap) {
        setState(() {
          List.from(snap['shared_to']).forEach((element) {
            sharedToUid.add(element);
          });
        });
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final profileProvider = Provider.of<ProfileProvider>(context);
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
              child: sharedToUid.length == 0
                  ? Center(
                      child: Text("You haven't shared your card with anyone!"),
                    )
                  : ListView.builder(
                      itemCount: sharedToUid.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onLongPress: () {
                            showDialog(
                                context: this.context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color:
                                                Color.fromARGB(255, 3, 50, 121),
                                            width: 2),
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    title: Text(
                                      "Do you want block this user?",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 25),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () async {
                                          await profileProvider
                                              .removeSharedAndReceived(
                                                  rid: sharedToUid[index],
                                                  uid: auth.currentUser?.uid)
                                              .then((value) {});
                                        },
                                        child: Text(
                                          "YES",
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "NO",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          },
                          child: StreamBuilder(
                              stream: fireStoreSnapshotRef
                                  .collection('userCard')
                                  .doc(sharedToUid[index])
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: Container(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                } else if (snapshot.hasData) {
                                  //  int len = snapshot.data.docs.length;
                                  if (snapshot.data == null) {
                                    return Container(child: Text('   '));
                                  } else {
                                    return ListTile(
                                      leading: CircleAvatar(
                                          child: Container(
                                        //  width: MediaQuery.of(context).size.width * 0.35,
                                        // height: MediaQuery.of(context).size.height * 0.37,
                                        /*  */
                                        // padding: EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.blueGrey
                                                      .withOpacity(0.1),
                                                  blurRadius: 2)
                                            ],
                                            image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image: AssetImage(
                                                    'assets/images/1greg.jpg') /*NetworkImage(
                                                  snapshot
                                                      .data['profile_picture'],
                                                )*/
                                                ),
                                            border: Border.all(
                                                color: Colors.grey, width: 3),
                                            borderRadius:
                                                BorderRadius.circular(6)),
                                      )),
                                      title: Text(
                                        "  George", //snapshot.data('full_name'),
                                        style: TextStyle(
                                            color: Colors.blue[900],
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    );
                                  }
                                } else {
                                  return Center(
                                    child: Container(
                                      child: Text('Can\'t show the data'),
                                    ),
                                  );
                                }
                              }),
                        );
                      })),
    );
  }
}
