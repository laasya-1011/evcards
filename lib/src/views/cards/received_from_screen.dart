import 'package:evcards/src/utils/firebase_constants.dart';
import 'package:evcards/src/views/cards/view_card.dart';
import 'package:flutter/material.dart';

class ReceivedFromScreen extends StatefulWidget {
  const ReceivedFromScreen({Key? key}) : super(key: key);

  @override
  State<ReceivedFromScreen> createState() => _ReceivedFromScreenState();
}

class _ReceivedFromScreenState extends State<ReceivedFromScreen> {
  List<String?> receivedFromUid = <String?>[];
  bool isLoading = false;
  Future getData() async {
    setState(() {
      isLoading = true;
    });
    await fireStoreSnapshotRef
        .collection("userCard")
        .doc(auth.currentUser?.uid)
        .get()
        .then((snap) {
      setState(() {
        List.from(snap['received_from']).forEach((element) {
          receivedFromUid.add(element);
        });
      });
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

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
              padding: EdgeInsets.all(5),
              width: width,
              height: height,
              child: ListView.builder(
                  itemCount: receivedFromUid.length,
                  itemBuilder: ((context, index) {
                    return StreamBuilder(
                        stream: fireStoreSnapshotRef
                            .collection('userCard')
                            .doc(receivedFromUid[index])
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: Container(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          } else if (snapshot.hasData) {
                            if (snapshot.data == null) {
                              return Container(child: Text('   '));
                            } else {
                              return miniViewCard();
                            }
                          } else {
                            return Center(
                              child: Container(
                                child: Text('Can\'t show the data'),
                              ),
                            );
                          }
                        });
                  }))),
    );
  }

  Widget miniViewCard() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ViewCard()));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.3,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.28,
                height: MediaQuery.of(context).size.height * 0.3,
                /*  */
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.blueGrey.withOpacity(0.1), blurRadius: 2)
                  ],
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                          'assets/images/1greg.jpg') /*NetworkImage(
                                  _profile['profile_picture'],
                                )*/
                      ),
                  border: Border.all(color: Colors.grey, width: 3),
                  // borderRadius: BorderRadius.circular(60)
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      cardDetail(
                          iconData: Icons.account_circle_sharp,
                          value: "George"),
                      cardDetail(
                          iconData: Icons.phone, value: "+91-9441811719"),
                      cardDetail(iconData: Icons.work, value: "Engineer"),
                      cardDetail(
                          iconData: Icons.email,
                          value: "laasyasri10@gmail.com"),
                      cardDetail(iconData: Icons.web, value: "www.google.com")
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget cardDetail({@required iconData, @required String? value}) {
    return Container(
      child: Row(
        children: [
          Icon(iconData),
          SizedBox(
            width: 10,
          ),
          Text(
            value!,
            style: TextStyle(color: Colors.blue[900]),
          )
        ],
      ),
    );
  }
}
