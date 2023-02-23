import 'dart:async';
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
  Rx<List<ServiceModel>> myServiceList = Rx<List<ServiceModel>>([]);
  List<ServiceModel> get myServices => myServiceList.value;

  @override
  void onReady() {

  }
  @override
  void onInit() {
    super.onInit();
    allServiceList.bindStream(allServiceStream());
    
  }

  getMyServices(String id){
    myServiceList.bindStream(myServicesStream(id));
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

  updateServiceStatus(String name,id)
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
         .where('status',isEqualTo: 'published')
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
  Stream<List<ServiceModel>> myServicesStream(String id) {
    return firestore
        .collection('services').where('userId',isEqualTo: id)
        .snapshots()
        .map((QuerySnapshot query) {
      List<ServiceModel> services = [];
      for (var doc in query.docs) {
        final service =ServiceModel.fromDocumentSnapshot(documentSnapshot: doc);
        services.add(service);
      }
      services.sort((a, b) => b.status.compareTo(a.status));
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
    await firestore.collection('orders').add(order.toJson()).whenComplete(() =>
    {
      Loader.hide(),
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order placed successfully '),),),
      Get.back()
    }
    );
  }

  getServiceOrders(String id)
  {
    ordersList.bindStream(ordersStream(id));
  }
  Stream<List<Order>> ordersStream(String id) {
    return firestore
        .collection('orders').where('serviceId',isEqualTo: id)
        .snapshots()
        .map((QuerySnapshot query) {
      List<Order> services = [];
      for (var doc in query.docs) {
        final service =Order.fromDocumentSnapshot(documentSnapshot: doc);
        services.add(service);
      }
      services.sort((a,b)=>b.orderDate.compareTo(a.orderDate));
      return services;
    });
  }
  markOrderComplete(String orderId)
  {
    firestore.collection('orders').doc(orderId).update(
        {
          'orderStatus':'Completed'
        });
  }

  addReview(orderId,rating,review){
    firestore.collection('orders').doc(orderId).update(
        {
          'serviceRating':rating,
          'serviceReview':review,
         // 'orderStatus':status
        });
  }

  pauseService(String id){
    firestore.collection('services').doc(id).update({
      'status':'paused'
    });
  }
  reActivateService(String id){
    firestore.collection('services').doc(id).update({
      'status':'published'
    });
  }
  updateService(ServiceModel model,String id)
  {
    firestore.collection('services').doc(id).set(model.toJson()).onError((error, stackTrace) => print('error='+error.toString()));
  }

  giveUserCommission(String userId,String amount){
   firestore.collection('users').where('userid',isEqualTo: userId).get().then((value){
     for(var data in value.docs)
     {
       firestore.collection('users').doc(data.id).update({
         'walletAmount':amount
       });
     }
   });
  }
}