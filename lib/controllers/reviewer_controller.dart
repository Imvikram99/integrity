import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:integrity/models/Order.dart';

class ReviewerController extends GetxController{
  FirebaseFirestore firestore=FirebaseFirestore.instance;
  Rx<List<Order>> ordersList = Rx<List<Order>>([]);
  List<Order> get orders => ordersList.value;
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    ordersList.bindStream(ordersStream());
  }

  Stream<List<Order>> ordersStream() {
    var id;
    var doc=firestore.collection('users').where('userid',isEqualTo: 'fgJRY072MdbCu4izBqPtIThDXU73').get();
   doc.then((value) =>
    {
      id=value.docs.first.id,
      print(id)
    });
    return firestore
        .collection('users').doc('C4KrvY3rvvCoFpKvkX6C').collection('orders')
        .snapshots()
        .map((QuerySnapshot query) {
      List<Order> services = [];
      for (var doc in query.docs) {
        final service =Order.fromDocumentSnapshot(documentSnapshot: doc);
        services.add(service);
      }
      return services;
    });
  }
}