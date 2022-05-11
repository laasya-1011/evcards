import 'package:evcards/src/providers/auth_provider.dart';
import 'package:evcards/src/providers/profile_provider.dart';
import 'package:evcards/src/utils/firebase_constants.dart';
import 'package:evcards/src/views/auth/login.dart';
import 'package:evcards/src/views/cards/qr_scan_page.dart';
import 'package:evcards/src/views/cards/received_from_screen.dart';
import 'package:evcards/src/views/cards/shared_to_screen.dart';
import 'package:evcards/src/views/cards/view_card.dart';
import 'package:flutter/material.dart';
import 'package:evcards/src/views/cards/create_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evcards/src/providers/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget drawer() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Container(
        width: MediaQuery.of(context).size.width * 0.77,
        color: Colors.white,
        child: ListView(children: [
          Container(
            //width: MediaQuery.of(context).size.width * 0.77,
            height: MediaQuery.of(context).size.height * 0.49,
            margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            decoration: BoxDecoration(
              color: Colors.transparent,
              //  border: Border.all(color: Colors.black45, width: 1),
              //  borderRadius: BorderRadius.circular(60)
            ),
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: MediaQuery.of(context).size.height * 0.37,
                  /*  */
                  // padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.blueGrey.withOpacity(0.1),
                          blurRadius: 2)
                    ],
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: /* _profile?['profile_picture'] == null
                            ? AssetImage('assets/images/1greg.jpg')
                            : */
                            NetworkImage(
                          _profile?['profile_picture'],
                        )),
                    border: Border.all(color: Colors.grey, width: 3),
                    // borderRadius: BorderRadius.circular(60)
                  ),
                ),
                Positioned(
                  top: 150,
                  left: 10,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        //  border: Border.all(color: Colors.black45, width: 1),
                        borderRadius: BorderRadius.circular(20)),
                    child: Container(
                      width: MediaQuery.of(context).size.height * 0.25,
                      height: MediaQuery.of(context).size.height * 0.25,
                      /*  */
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 4)
                          ],
                          color: Colors.white,
                          /* image: const DecorationImage(
                              fit: BoxFit.cover,
                              image:/* AssetImage(
                                  'assets/images/qrcode.png')*/ /*NetworkImage(
                                  _profile['profile_picture'],
                                )*/
                              ),*/
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(20)),
                      child: QrImage(
                        data: _profile?['uid'],
                        size: 50,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          detailCard(
              iconData: Icons.account_circle_sharp,
              name: _profile?['full_name']),
          Divider(
            color: Colors.grey[300],
            thickness: 1,
          ),
          detailCard(iconData: Icons.phone, name: _profile?['phone_number']),
          Divider(
            color: Colors.grey[300],
            thickness: 1,
          ),
          detailCard(iconData: Icons.email, name: _profile?['email']),
          Divider(
            color: Colors.grey[300],
            thickness: 1,
          ),
          detailCard(iconData: Icons.work, name: _profile?['job_title']),
          Divider(
            color: Colors.grey[300],
            thickness: 1,
          ),
          detailCard(
              iconData: Icons.location_city, name: _profile?['company_name']),
          Divider(
            color: Colors.grey[300],
            thickness: 1,
          ),
          detailCard(iconData: Icons.location_on, name: _profile?['address']),
          Divider(
            color: Colors.grey[300],
            thickness: 1,
          ),
          detailCard(iconData: Icons.web, name: _profile?['website']),
          Divider(
            color: Colors.grey[300],
            thickness: 1,
          ),
          ListTile(
            onTap: () async {
              await authProvider.logout().then((value) async {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              });
            },
            horizontalTitleGap: 1,
            leading: Icon(Icons.logout),
            title: Text(
              'LogOut',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 15),
            ),
          ),
        ]));
  }

  DocumentSnapshot? _profile;
  bool isLoading = false;
  Future initData() async {
    setState(() {
      isLoading = true;
    });
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    if (profileProvider.getProfileData() == null) {
      await profileProvider
          .getProfile(uid: auth.currentUser?.uid)
          .then((value) {
        _profile = profileProvider.getProfileData();
        print(_profile?['uid']);
        setState(() {
          isLoading = false;
        });
      });
    } else {
      _profile = profileProvider.getProfileData();
      setState(() {
        isLoading = false;
      });
    }
  }

  int i = 0;
  @override
  void initState() {
    initData();
    if (i != 0) {
      setState(() {
        i = 0;
      });
    }
    super.initState();
  }

  var pages = [SharedToScreen(), ReceivedFromScreen()];
  Widget detailCard({@required IconData? iconData, @required String? name}) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.07,
      margin: EdgeInsets.only(left: 15),
      child: Row(
        children: [
          Icon(
            iconData,
            size: 38,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            name!,
            style: TextStyle(color: Colors.blue[900], fontSize: 17),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    final profileProvider = Provider.of<ProfileProvider>(context);
    return isLoading
        ? Scaffold(
            body: Center(
            child: CircularProgressIndicator(
              color: Colors.redAccent,
            ),
          ))
        : Scaffold(
            drawerEdgeDragWidth: width * 0.7,
            drawerScrimColor: Colors.black38,
            drawer: drawer(),
            appBar: AppBar(
              backgroundColor: Colors.blue[100],
              leading: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                  child: CircleAvatar(
                      backgroundImage: NetworkImage(
                    _profile?['profile_picture'],
                  ))),
              titleSpacing: 2,
              title: Container(
                  alignment: Alignment.topLeft,
                  child: Column(children: [
                    Text("Hello, ${_profile?['full_name']}",
                        style: TextStyle(
                            color: Colors.blue[900],
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                    const Padding(
                        padding: EdgeInsets.fromLTRB(7, 3, 0, 0),
                        child: Text("Welcome to eVCards!",
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                                fontWeight: FontWeight.normal)))
                  ])),
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => QRScanPage()));
                    },
                    icon: Icon(Icons.qr_code_2, color: Colors.blue[900]))
              ],
            ),
            body: pages[i],
            bottomNavigationBar: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.share), label: "Shared to"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.arrow_downward), label: "Received from")
              ],
              currentIndex: i,
              type: BottomNavigationBarType.fixed,
              onTap: (index) {
                setState(() {
                  // _pState = i;
                  i = index;
                });
              },
            ),
          );
  }
}
