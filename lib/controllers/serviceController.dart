import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';
import 'package:integrity/models/Order.dart';
import 'package:integrity/models/serviceModel.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';


class ServiceController extends GetxController{
  FirebaseFirestore firestore=FirebaseFirestore.instance;
  Rx<List<ServiceModel>> serviceList = Rx<List<ServiceModel>>([]);
  List<ServiceModel> get services => serviceList.value;
  Rx<List<ServiceModel>> allServiceList = Rx<List<ServiceModel>>([]);
  List<ServiceModel> get allServices => allServiceList.value;
  var s=<ServiceModel>[].obs;
  Rx<List<Order>> ordersList = Rx<List<Order>>([]);
  List<Order> get orders => ordersList.value;

  @override
  void onReady() {

  }
  @override
  void onInit() {
    super.onInit();
    allServiceList.bindStream(allServiceStream());
  }

  saveService(ServiceModel service)
  {
    print('inside service');

    firestore.collection('services').add(service.toJson()).
    then((value) => {
      print(value.id),

     // Get.snackbar('','Service Saved Successfully',snackPosition: SnackPosition.BOTTOM,backgroundColor: Colors.black,colorText: Colors.white),
    }).
    catchError((error) => {

      Get.snackbar('Error',error.toString(),snackPosition: SnackPosition.BOTTOM)
    });

  }

  getServiceByCategory(String category)
  {
    serviceList.bindStream(serviceStream(category));
  }

  updateService(String name,id)
  {
    firestore.collection('services').where('name',isEqualTo: name).where('userId',isEqualTo: id).get().then((value) =>
    {
      value.docs.forEach((element) {
        firestore.collection('services').doc(element.id).update({
          'status':'published',
        });
      })
    });
  }
  Stream<List<ServiceModel>> serviceStream(String c) {
    return firestore
        .collection('services')
        .where('category',isEqualTo: c)
        .snapshots()
        .map((QuerySnapshot query) {
      List<ServiceModel> services = [];
      for (var doc in query.docs) {
        final service =ServiceModel.fromDocumentSnapshot(documentSnapshot: doc);
      //  TodoModel.fromDocumentSnapshot(documentSnapshot: todo);
        services.add(service);
      }
      return services;
    });
  }

  Stream<List<ServiceModel>> allServiceStream() {
    return firestore
        .collection('services')
        .snapshots()
        .map((QuerySnapshot query) {
      List<ServiceModel> services = [];
      for (var doc in query.docs) {
        final service =ServiceModel.fromDocumentSnapshot(documentSnapshot: doc);
        services.add(service);
      }
      return services;
    });
  }

  buyService(Order order,BuildContext context) async{
    Loader.show(context,
        isSafeAreaOverlay: false,
        isAppbarOverlay: true,
        isBottomBarOverlay: true,
        progressIndicator: CircularProgressIndicator(),
        overlayColor: Colors.transparent);
   await firestore.collection('services').doc(order.serviceId).collection('orders').add(order.toJson()).then((ordr) => {
          firestore.collection('users').where('userid',isEqualTo: order.userId).get().then((value) =>
          {
           // print(value.docs.first.id)
            firestore.collection('users').doc(value.docs.first.id).collection('orders').doc(ordr.id).set(order.toJson()).then((value) => {
                //  print(value.id),
                  Loader.hide(),
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order placed successfully '),),),
                  Get.back()
            })
          }),
       })
   .catchError((error) => {
      Loader.hide(),
     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error),),),
    });

  }

  getServiceOrders(String id)
  {
    ordersList.bindStream(ordersStream(id));
  }
  Stream<List<Order>> ordersStream(String id) {
    return firestore
        .collection('services').doc(id).collection('orders')
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