import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String first_name;
  final String last_name;
  final String dob; // MM/DD

  UserModel({
    required this.first_name,
    required this.last_name,
    required this.dob,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      first_name: data['first_name'] ?? '',
      last_name: data['last_name'] ?? '',
      dob: data['dob'] ?? '',
    );
  }
}

class UserService {
  static final _auth = fb_auth.FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;

  static Future<UserModel?> getCurrentUser() async {
    final fbUser = _auth.currentUser;
    if (fbUser == null) return null;

    // Supomos que os dados extras estão em uma coleção 'users', documento com o uid
    final doc = await _firestore.collection('users').doc(fbUser.uid).get();

    if (!doc.exists) return null;

    return UserModel.fromMap(doc.data()!);
  }
}
