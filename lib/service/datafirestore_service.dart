import 'package:Expoplace/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatafirestoreService {
  static final data_firestore_account =
      FirebaseFirestore.instance.collection("account");
  static final data_firestore_account_active =
      FirebaseFirestore.instance.collection("account").doc(globalUid);
  static final data_firestore_product =
      FirebaseFirestore.instance.collection("product");
}
