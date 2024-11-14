import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatafirestoreService {
  static final data_firestore_account =
      FirebaseFirestore.instance.collection("account");
  static final data_firestore_account_active = FirebaseFirestore.instance
      .collection("account")
      .doc(FirebaseAuth.instance.currentUser!.uid);
  static final data_firestore_product =
      FirebaseFirestore.instance.collection("product");
}
