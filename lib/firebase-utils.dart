import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do/model/my-class.dart';
import 'package:to_do/model/task.dart';

class FirebaseUtils {
  static CollectionReference<Task> getTasksCollection(String uId) {
    return getUsersCollection()
        .doc(uId)
        .collection(Task.collectionName)
        .withConverter<Task>(
            fromFirestore: (snapshot, options) =>
                Task.fromFireStore(snapshot.data()!),
            toFirestore: (task, options) => task.toFireStore());
  }

  static Future<void> addTaskToFireStore(Task task, String uId) {
    var taskCollection = getTasksCollection(uId);
    DocumentReference<Task> docRef = taskCollection.doc();
    task.id = docRef.id;
    return docRef.set(task);
  }

  static Future<void> deleteTaskFromFireStore(Task task, String uId) {
    return getTasksCollection(uId).doc(task.id).delete();
  }

  static CollectionReference<MyUser> getUsersCollection() {
    return FirebaseFirestore.instance
        .collection(MyUser.collectionName)
        .withConverter<MyUser>(
            fromFirestore: (snapshot, options) =>
                MyUser.fromfirestore(snapshot.data()),
            toFirestore: (user, options) => user.toFirestore());
  }

  static Future<void> addUserToFireStore(MyUser myUser) {
    return getUsersCollection().doc(myUser.id).set(myUser);
  }

  static Future<MyUser?> readUserFromFireStore(String uId) async {
    var querysnapshot = await getUsersCollection().doc(uId).get();
    return querysnapshot.data();
  }
}
