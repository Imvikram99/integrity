import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:integrity/models/Order.dart';

class ReviewerController extends GetxController{
  FirebaseFirestore firestore=FirebaseFirestore.instance;
  Rx<List<Order>> ordersList = Rx<List<Order>>([]);
  List<Order> get orders => ordersList.value;
  Rx<List<Order>> serviceOrdersList = Rx<List<Order>>([]);
  List<Order> get serviceOrders => serviceOrdersList.value;
  
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  getMyOrders(String id){
    ordersList.bindStream(ordersStream(id));
  }

  getServiceOrders(String serviceId){
    serviceOrdersList.bindStream(serviceOrdersStream(serviceId));
  }
  
  Stream<List<Order>> ordersStream(String id) {
    return firestore
        .collection('orders').where('buyerId',isEqualTo: id)
        .snapshots()
        .map((QuerySnapshot query) {
      List<Order> orders = [];
      for (var doc in query.docs) {
        final order =Order.fromDocumentSnapshot(documentSnapshot: doc);
        orders.add(order);
      }
      orders.sort((a, b) => b.orderDate.compareTo(a.orderDate));
      return orders;
    });
  }

  Stream<List<Order>> serviceOrdersStream(String id) {
    return firestore
        .collection('orders').where('serviceId',isEqualTo: id)
        .snapshots()
        .map((QuerySnapshot query) {
      List<Order> orders = [];
      for (var doc in query.docs) {
        final order =Order.fromDocumentSnapshot(documentSnapshot: doc);
        orders.add(order);
      }
      return orders;
    });
  }

  updateOrderStatus(orderId,rating,review,serviceId) async{
   await firestore.collection('orders').doc(orderId).update(
        {
          'buyerRating':rating,
          'buyerReview':review,
        }).whenComplete(() async {
        await  firestore.collection('services').doc(serviceId).get().then((value) async{
            double or=value.data()!['totalOrders'].toDouble();
            double ra=value.data()!['averageRating'].toDouble();
            double tr=ra*or;
            double to=or+1;
            double t=tr+rating;
            double ave=t/to;
          await  firestore.collection('services').doc(serviceId).update({
              'totalOrders':to,
              'averageRating':double.parse(ave.toStringAsFixed(2))
            });

          });
    });
  }
}