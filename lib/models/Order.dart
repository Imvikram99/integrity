import 'package:cloud_firestore/cloud_firestore.dart';

class Order{
  late String orderId;
  late String userId;
  late String serviceId;
  late String name;
  late String date;
  late String status;

  Order(this.userId,this.name,this.date,this.status,this.serviceId);


/*  ServiceModel.fromJson(Map<String,dynamic> json){
    userId=json['userId'].toString();
    name=json['name'].toString();
    categoryName=json['category'].toString();
    status=json['status'].toString();
    description=json['desc'].toString();
    availabilityStartTime=json['startTime'].toString();
    availabilityEndTime=json['endTime'].toString();
    availabilityStartDate=json['startDate'].toString();
    availabilityEndDate=json['endDate'].toString();
    country=json['country'].toString();
    country=json['state'].toString();
    city=json['city'].toString();
    pinCode=json['pinCode'].toString();
    latitude=json['latitude'].toString();
    longitude=json['longitude'].toString();
    email=json['email'].toString();
    upiLink=json['upiLink'].toString();
    watsApp=json['watsApp'].toString();
    telegram=json['telegram'].toString();
    zoom=json['zoom'].toString();
    webAddress=json['webLink'].toString();
    customFileds=_convertValues(json['customData']);
  }*/

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId']=this.userId;
    data['name'] = this.name;
    data['serviceId'] = this.serviceId;
    data['status'] = this.status;
    data['date'] = this.date;
    return data;
  }

  Order.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) {
    orderId=documentSnapshot.id;
    serviceId = documentSnapshot['serviceId'].toString();
    userId=documentSnapshot['userId'].toString();
    name=documentSnapshot['name'].toString();
    status=documentSnapshot['status'].toString();
    date=documentSnapshot['date'].toString();
  }
}