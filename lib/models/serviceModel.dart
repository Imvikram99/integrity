import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceModel{
  late String serviceId;
  late String userId;
  late String name;
  late String categoryName;
  late String status;
  late String description;
  late String availabilityStartTime;
  late String availabilityEndTime;
  late String availabilityStartDate;
  late String availabilityEndDate;
  late String country;
  late String state;
  late String city;
  late String pinCode;
  late String latitude;
  late String longitude;
  late String email;
  late String upiLink;
  late String watsApp;
  late String telegram;
  late String zoom;
  late String webAddress;
  List<CustomFields>? customFileds;

  ServiceModel(this.userId,this.name,this.categoryName,this.status,this.description,
      this.availabilityStartTime,this.availabilityEndTime,
      this.availabilityStartDate,this.availabilityEndDate,this.country,this.state,this.city,this.pinCode,this.latitude,this.longitude,
      this.email,this.upiLink,this.watsApp,this.telegram,this.zoom,this.webAddress,this.customFileds);

  ServiceModel.fromJson(Map<String,dynamic> json){
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId']=this.userId;
    data['name'] = this.name;
    data['category'] = this.categoryName;
    data['status'] = this.status;
    data['desc'] = this.description;
    data['startTime'] = this.availabilityStartTime;
    data['endTime'] = this.availabilityEndTime;
    data['startDate'] = this.availabilityStartDate;
    data['endDate'] = this.availabilityEndDate;
    data['country'] = this.country;
    data['state'] = this.state;
    data['city'] = this.city;
    data['pinCode'] = this.pinCode;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['email'] = this.email;
    data['upiLink']=this.upiLink;
    data['watsApp'] = this.watsApp;
    data['telegram'] = this.telegram;
    data['zoom'] = this.zoom;
    data['webLink'] = this.webAddress;
    data['customData']=_valuesList(customFileds);

    return data;
  }

  ServiceModel.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) {
    serviceId = documentSnapshot.id;
    userId=documentSnapshot['userId'].toString();
    name=documentSnapshot['name'].toString();
    categoryName=documentSnapshot['category'].toString();
   // status=documentSnapshot['status'].toString();
    description=documentSnapshot['desc'].toString();
    availabilityStartTime=documentSnapshot['startTime'].toString();
    availabilityEndTime=documentSnapshot['endTime'].toString();
    availabilityStartDate=documentSnapshot['startDate'].toString();
    availabilityEndDate=documentSnapshot['endDate'].toString();
    country=documentSnapshot['country'].toString();
    country=documentSnapshot['state'].toString();
    city=documentSnapshot['city'].toString();
    pinCode=documentSnapshot['pinCode'].toString();
    latitude=documentSnapshot['latitude'].toString();
    longitude=documentSnapshot['longitude'].toString();
    email=documentSnapshot['email'].toString();
    upiLink=documentSnapshot['upiLink'].toString();
    watsApp=documentSnapshot['watsApp'].toString();
    telegram=documentSnapshot['telegram'].toString();
    zoom=documentSnapshot['zoom'].toString();
    webAddress=documentSnapshot['webLink'].toString();
    customFileds=_convertValues(documentSnapshot['customData']);
  }

}

class CustomFields{
  String? title;
  String? value;

  CustomFields(this.title,this.value);

  CustomFields.fromJson(Map<String,dynamic> json){
    title=json['title'].toString();
    value=json['value'].toString();
  }

  Map<String,dynamic> toJson(){
    Map<String,dynamic> data=Map<String,dynamic>();
    data['title']=title;
    data['value']=value;
    return data;
  }

}
_convertValues(List<dynamic> json) {
  final c = <CustomFields>[];

  for (final challenge in json) {
    c.add(CustomFields.fromJson(challenge as Map<String, dynamic>));
  }
  return c;
}

List<Map<String, dynamic>>? _valuesList(List<CustomFields>? challenges) {
  if (challenges == null) {
    return null;
  }
  final challengesMap = <Map<String, dynamic>>[];
  challenges.forEach((challenge) {
    challengesMap.add(challenge.toJson());
  });
  return challengesMap;
}