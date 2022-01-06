import 'package:chatapp/model/profile_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ContactController extends GetxController{
  final String? _uid = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore?_firestore = FirebaseFirestore.instance;

  Future<List<ProfileData>> fetch() async {
    final CollectionReference _usersRef = _firestore!.collection('users');
    final QuerySnapshot _usersDoc =
    await _usersRef.where('uid', isNotEqualTo: _uid).get();
    return _usersDoc.docs.map((doc) {
      return ProfileData.fromJson({
        'uid': doc['uid'],
        'name': doc['name'],
        'imageUrl': doc['imageUrl'],
        'clId': null
      });
    }).toList();
  }

  Future<ProfileData> getProfile(String uid) async {
    final CollectionReference usersRef = _firestore!.collection('users');
    final QuerySnapshot users =
    await usersRef.where('uid', isEqualTo: uid).limit(1).get();
    var e = users.docs.first;
    return ProfileData.fromJson({
      'uid': e['uid'],
      'name': e['name'],
      'imageUrl': e['imageUrl'],
      'clId': null
    });
  }
}