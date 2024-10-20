

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{

  Future addPersonalTask(Map<String,dynamic> userPersonalMap,String id,String uid)async{
    return await FirebaseFirestore.instance.collection("users").doc(uid).collection("Personal").doc(id).set(userPersonalMap);
  }
  Future addCollegeTask(Map<String,dynamic> userCollegeMap,String id,String uid)async{
    return await FirebaseFirestore.instance.collection("users").doc(uid).collection("College").doc(id).set(userCollegeMap);
  }
  Future addOfficeTask(Map<String,dynamic> userOfficeMap,String id,String uid)async{
    return await FirebaseFirestore.instance.collection("users").doc(uid).collection("Office").doc(id).set(userOfficeMap);
  }

  Future <Stream<QuerySnapshot>>getTask(String task,String uid)async{
    return await FirebaseFirestore.instance.collection("users")
        .doc(uid)
        .collection(task)
        .snapshots();
  }
  tickMethod(String id,String task,String uid, bool newValue)async{
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection(task)
        .doc(id)
        .update({"Yes":newValue});
  }
  Future<void> deleteTask(String taskId, String category, String uid)async{
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection(category)
        .doc(taskId)
        .delete();
  }
}