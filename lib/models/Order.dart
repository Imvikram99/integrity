import 'package:cloud_firestore/cloud_firestore.dart';

class Order{
  late String orderId;
  late String buyerId;
  late String serviceProviderId;
  late String serviceId;
  late String buyerPhone;
  late String servicePhone;
  late String serviceName;
  late String orderDate;
  late String orderStatus;
  late double buyerRating;
  late String buyerReview;
  late double serviceRating;
  late String serviceReview;

  Order(this.buyerId,this.serviceProviderId,this.serviceId,this.buyerPhone,this.servicePhone,this.serviceName,this.orderDate,this.orderStatus,this.buyerRating,this.buyerReview
      ,this.serviceRating,this.serviceReview);




  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['buyerId']=this.buyerId;
    data['providerId']=this.serviceProviderId;
    data['serviceId'] = this.serviceId;
    data['buyerPhone'] = this.buyerPhone;
    data['servicePhone'] = this.servicePhone;
    data['serviceName'] = this.serviceName;
    data['orderDate'] = this.orderDate;
    data['orderStatus'] = this.orderStatus;
    data['buyerRating'] = this.buyerRating;
    data['buyerReview'] = this.buyerReview;
    data['serviceRating'] = this.serviceRating;
    data['serviceReview'] = this.serviceReview;
    return data;
  }

  Order.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) {
    orderId=documentSnapshot.id;
    buyerId = documentSnapshot['buyerId'].toString();
    serviceProviderId = documentSnapshot['providerId'].toString();
    serviceId=documentSnapshot['serviceId'].toString();
    buyerPhone=documentSnapshot['buyerPhone'].toString();
    servicePhone=documentSnapshot['servicePhone'].toString();
    serviceName=documentSnapshot['serviceName'].toString();
    orderDate=documentSnapshot['orderDate'].toString();
    orderStatus=documentSnapshot['orderStatus'].toString();
    buyerRating=documentSnapshot['buyerRating'].toDouble();
    buyerReview=documentSnapshot['buyerReview'].toString();
    serviceRating=documentSnapshot['serviceRating'];
    serviceReview=documentSnapshot['serviceReview'].toString();
  }
}