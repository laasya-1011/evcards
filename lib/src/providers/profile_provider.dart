import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evcards/src/utils/firebase_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider with ChangeNotifier {
  Future createProfile(
      {@required String? uid,
      @required String? email,
      @required String? fullName,
      @required String? companyName,
      @required String? phoneNumber,
      @required String? profilepicUrl,
      @required String? website,
      @required String? address,
      @required String? jobTitle}) async {
    try {
      var profile = <String, dynamic>{
        'uid': uid,
        'full_name': fullName,
        'company_name': companyName,
        'email': email,
        'phone_number': phoneNumber,
        'profile_picture': profilepicUrl,
        'website': website,
        'address': address,
        'job_title': jobTitle,
        'created_date': DateTime.now().toLocal(),
        'shared_to': [],
        'received_from': []
      };

      await db.collection('userCard').doc(uid).set(profile).then((value) {});
    } catch (err) {
      print(err);
    }
  }

  Future updateProfile(
      {@required String? docId,
      @required String? uid,
      @required String? email,
      @required String? fullName,
      @required String? companyName,
      @required String? phoneNumber,
      @required String? profilepicUrl,
      @required String? address,
      @required String? jobTitle,
      @required String? website}) async {
    try {
      var profile = <String, dynamic>{
        'uid': uid,
        'full_name': fullName,
        'company_name': companyName,
        'email': email,
        'phone_number': phoneNumber,
        'profile_picture': profilepicUrl,
        'address': address,
        'job_title': jobTitle,
        'website': website,
        'created_date': DateTime.now().toLocal(),
      };

      await db
          .collection('userCard')
          .doc(docId)
          .update(profile)
          .then((value) {});
    } catch (e) {
      print(e);
    }
  } // open up the ui pic

  Future<bool> checkProfile({@required String? uid}) async {
    final snapshot = await fireStoreSnapshotRef
        .collection("userCard")
        .where('uid', isEqualTo: auth.currentUser?.uid)
        .get();
    //

    if (snapshot.docs.length == 0) {
      return false;
    } else {
      return true;
    }
  }

  DocumentSnapshot? _profile;
  DocumentSnapshot? getProfileData() => _profile;
  Future setProfileEmpty() async {
    _profile = null;
    notifyListeners();
  }

  Future<void> getProfile({@required String? uid}) async {
    final snapshot = await fireStoreSnapshotRef
        .collection("userCard")
        .where('uid', isEqualTo: auth.currentUser?.uid)
        .limit(1)
        .get();

    _profile = snapshot.docs[0];
    notifyListeners(); // this is setState // now our profile and auth providers are ready//sir, one doubt // yes
  }

  Future saveProfileStatus({@required bool? hasProfile}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('profile', hasProfile!);
  }

  Future<bool?> profileStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getBool('profile') != null) {
      prefs.getBool('profile');

      return prefs.getBool('profile');
    } else {
      return false;
    }
  }

  Future<void> addSharedAndReceived(
      {@required String? rid, @required String? uid}) async {
    await fireStoreSnapshotRef.collection('userCard').doc(uid).update({
      'received_from': FieldValue.arrayUnion([rid])
    }).then((value) async {
      await fireStoreSnapshotRef.collection('userCard').doc(rid).update({
        'shared_to': FieldValue.arrayUnion([uid])
      });
    });
  }

  Future<void> removeSharedAndReceived(
      {@required String? rid, @required String? uid}) async {
    await fireStoreSnapshotRef.collection('userCard').doc(rid).update({
      'received_from': FieldValue.arrayRemove([rid])
    }).then((value) async {
      await fireStoreSnapshotRef.collection('userCard').doc(uid).update({
        'shared_to': FieldValue.arrayUnion([uid])
      });
    });
  }
}
