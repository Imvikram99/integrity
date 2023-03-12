import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:integrity/constants.dart';
import 'package:integrity/models/serviceModel.dart';
import 'package:integrity/views/reviewer/buy_service.dart';
import 'package:integrity/views/reviewer/service_reviews.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:telegram/telegram.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/category.dart';


class ServiceDetail extends StatefulWidget{
  final String? serviceId;
  final String? userId;
  ServiceDetail({Key? key,this.serviceId,this.userId}) : super(key: key);
  @override
  State<StatefulWidget> createState() => ServiceDetailState();
}


class ServiceDetailState extends State<ServiceDetail> {

  bool deeplink=false;
  late ServiceModel serviceModel;
  late Category category;
  final box = GetStorage();
  late String userId;
  late String deepLinkUserId;
  late double currentLat;
  late double currentLang;
  late double roundDistanceInKM=0;


  @override
  void initState() {
    super.initState();
    if(Get.arguments!=null)
      {
        serviceModel=Get.arguments[0];
        category=Get.arguments[1];
      }
    else
      {
        deeplink=true;
      //  box.write('deepLinkId', widget.userId);
        deepLinkUserId=widget.userId!;
      }
    if(!deeplink)
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await this.getCurrentLoc();
      setState(() { });
    });
  }
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }
  Future<void> getCurrentLoc() async{
    _handleLocationPermission();
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    double dista=Geolocator.distanceBetween(position.latitude, position.longitude,double.parse(serviceModel.latitude),double.parse(serviceModel.longitude));
    double distanceInKiloMeters = dista/ 1000;
    roundDistanceInKM= double.parse((distanceInKiloMeters).toStringAsFixed(0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:Text(''),
        centerTitle: true,
        backgroundColor: Constants.appButtonColor,
      ),
      body:Container(
        padding: EdgeInsets.only(left: 10,right: 10,top: 10),
        decoration: BoxDecoration(color: Colors.white),
        child:deeplink?
        FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('services').doc(widget.serviceId).get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child:CircularProgressIndicator());
              }
              serviceModel =ServiceModel.fromDocumentSnapshot(documentSnapshot: snapshot.data!) ;
              return ListView(
                children: [
                  SizedBox(height:10),
                  Text(
                    'Availability',
                    style: TextStyle(
                        fontSize: Get.textTheme.bodyMedium!.fontSize,fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 4,),
                  Text(serviceModel.availabilityStartDate+' - '+serviceModel.availabilityEndDate+', '+serviceModel.availabilityStartTime+' - '+serviceModel.availabilityEndTime,
                    style: TextStyle(
                      fontSize: Get.textTheme.bodyMedium!.fontSize,
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text('Price',style: TextStyle(fontSize: Get.textTheme.bodyMedium!.fontSize,fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4,),
                  Text(serviceModel.price),
                  SizedBox(height: 10,),
                  Text('Status',style: TextStyle(fontSize: Get.textTheme.bodyMedium!.fontSize,fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4,),
                  Text(serviceModel.status),
                  SizedBox(height: 10,),
                  Text('Description',style: TextStyle(fontSize: Get.textTheme.bodyMedium!.fontSize,fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4,),
                  Text(serviceModel.description),
                  SizedBox(height: 10,),
                  Text('Address',style: TextStyle(fontSize: Get.textTheme.bodyMedium!.fontSize,fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4,),
                  Text(serviceModel.city+' , '+serviceModel.state+' , '+serviceModel.country),
                  SizedBox(height: 10,),
                  serviceModel.email.isNotEmpty?Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email Address',style: TextStyle(fontSize: Get.textTheme.bodyMedium!.fontSize,fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4,),
                      InkWell(
                        child: Row(
                          children: [
                            Icon(Icons.email_outlined,size: 30,color: Colors.red.shade300,),
                            SizedBox(width: 6,),
                            Text(serviceModel.email)
                          ],
                        ),
                        onTap: (){
                          _sendMail(serviceModel.email);
                        },
                      ),
                      SizedBox(height: 10,),
                    ],
                  ):Container(),
                  serviceModel.watsApp.isNotEmpty?Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('WhatsApp',style: TextStyle(fontSize: Get.textTheme.bodyMedium!.fontSize,fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4,),
                      InkWell(
                        child: Row(
                          children: [
                            Icon(Icons.whatsapp,color: Colors.green,size: 30,),
                            SizedBox(width: 6,),
                            Text(serviceModel.watsApp)
                          ],
                        ),
                        onTap: (){
                          _launchWhatsapp(serviceModel.watsApp);
                        },
                      ),
                      SizedBox(height: 10,),
                    ],
                  ):Container(),
                 serviceModel.telegram.isNotEmpty?Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Telegram',style: TextStyle(fontSize: Get.textTheme.bodyMedium!.fontSize,fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4,),
                      InkWell(
                        child: Row(
                          children: [
                            Icon(Icons.telegram,size: 30,color: Colors.blue,),
                            SizedBox(width: 6,),
                            Text(serviceModel.telegram)
                          ],
                        ),
                        onTap: (){
                          _launchTelegram(serviceModel.telegram);
                        },
                      ),
                      SizedBox(height: 10,),
                    ],
                  ):Container(),
                  serviceModel.webAddress.isNotEmpty?Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Web Address',style: TextStyle(fontSize: Get.textTheme.bodyMedium!.fontSize,fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4,),
                      InkWell(
                        child: Row(
                          children: [
                            Icon(Icons.web,size: 25,color: Colors.blue,),
                            SizedBox(width: 6,),
                            Text(serviceModel.webAddress)
                          ],
                        ),
                        onTap: () async {
                          _launchWebAddress(serviceModel.webAddress);
                        },
                      ),
                      SizedBox(height: 10,),
                    ],
                  ):Container(),
                  Text('Upi',style: TextStyle(fontSize: Get.textTheme.bodyMedium!.fontSize,fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4,),
                  Text(serviceModel.upiLink),
                  SizedBox(height: 10,),
                  Text('Zoom',style: TextStyle(fontSize: Get.textTheme.bodyMedium!.fontSize,fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4,),
                  Text(serviceModel.zoom),
                  SizedBox(height: 10,),
                  Text('Ratings',style: TextStyle(fontSize: Get.textTheme.bodyMedium!.fontSize,fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4,),
                  Text(serviceModel.averageRating.toString()+'/5'),
                  SizedBox(height: 10,),
                  serviceModel.customFileds!.length>0?
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(serviceModel.customFileds![0].title??'',style: TextStyle(fontSize: Get.textTheme.bodyMedium!.fontSize,fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4,),
                      Text(serviceModel.customFileds![0].value??''),
                    ],
                  ): SizedBox(height: 1,),
                  serviceModel.customFileds!.length>0?
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(serviceModel.customFileds![1].title??'',style: TextStyle(fontSize: Get.textTheme.bodyMedium!.fontSize,fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4,),
                      Text(serviceModel.customFileds![1].value??''),
                    ],
                  ): SizedBox(height: 1,),
                  serviceModel.customFileds!.length>0?
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(serviceModel.customFileds![2].title??'',style: TextStyle(fontSize: Get.textTheme.bodyMedium!.fontSize,fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4,),
                      Text(serviceModel.customFileds![2].value??''),
                    ],
                  ):
                  SizedBox(height: 1,),
                  SizedBox(height: 10,),
                  TextButton(onPressed: (){
                    Get.to(()=>ServiceReviews(),arguments: serviceModel);
                  },
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Constants.appButtonColor),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            )
                        ),
                        padding: MaterialStateProperty.all(EdgeInsets.only(top: 12,bottom: 12)),
                      ),
                      child: Text('Service Reviews',style: TextStyle(color: Colors.white),)
                  ),
                  SizedBox(height: 15,),
                  TextButton(onPressed: (){
                    Get.to(()=>BuyService(),arguments:[serviceModel,deepLinkUserId]);
                  },
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Constants.appButtonColor),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            )
                        ),
                        padding: MaterialStateProperty.all(EdgeInsets.only(top: 12,bottom: 12)),
                      ),
                      child: Text('Buy Service',style: TextStyle(color: Colors.white),)
                  )
                ],
              );
            }
        )
        :ListView(
          children: [
            SizedBox(height:10),
            Text(
              'Availability',
              style: TextStyle(
                fontSize: Get.textTheme.bodyMedium!.fontSize,fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 4,),
            Text(serviceModel.availabilityStartDate+' - '+serviceModel.availabilityEndDate+', '+serviceModel.availabilityStartTime+' - '+serviceModel.availabilityEndTime,
              style: TextStyle(
                fontSize: Get.textTheme.bodyMedium!.fontSize,
              ),
            ),
            SizedBox(height: 10,),
            Text('Price',style: TextStyle(fontSize: Get.textTheme.bodyMedium!.fontSize,fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4,),
            Text(serviceModel.price),
            SizedBox(height: 10,),
            Text('Status',style: TextStyle(fontSize: Get.textTheme.bodyMedium!.fontSize,fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4,),
            Text(serviceModel.status),
            SizedBox(height: 10,),
            Text('Description',style: TextStyle(fontSize: Get.textTheme.bodyMedium!.fontSize,fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4,),
            Text(serviceModel.description),
            SizedBox(height: 10,),
            Text('Address',style: TextStyle(fontSize: Get.textTheme.bodyMedium!.fontSize,fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4,),
            Text(serviceModel.city+' , '+serviceModel.state+' , '+serviceModel.country),
            SizedBox(height: 10,),
            category.emailStatus && serviceModel.email.isNotEmpty?Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Email Address',style: TextStyle(fontSize: Get.textTheme.bodyMedium!.fontSize,fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4,),
                InkWell(
                  child: Row(
                    children: [
                      Icon(Icons.email_outlined,size: 30,color: Colors.red.shade300,),
                      SizedBox(width: 6,),
                      Text(serviceModel.email)
                    ],
                  ),
                  onTap: (){
                    _sendMail(serviceModel.email);
                  },
                ),
                SizedBox(height: 10,),
              ],
            ):Container(),
            category.whatsAppStatus && serviceModel.watsApp.isNotEmpty?Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('WhatsApp',style: TextStyle(fontSize: Get.textTheme.bodyMedium!.fontSize,fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4,),
                InkWell(
                  child: Row(
                    children: [
                      Icon(Icons.whatsapp,color: Colors.green,size: 30,),
                      SizedBox(width: 6,),
                      Text(serviceModel.watsApp)
                    ],
                  ),
                  onTap: (){
                    _launchWhatsapp(serviceModel.watsApp);
                  },
                ),
                SizedBox(height: 10,),
              ],
            ):Container(),
            category.telegramStatus && serviceModel.telegram.isNotEmpty?Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Telegram',style: TextStyle(fontSize: Get.textTheme.bodyMedium!.fontSize,fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4,),
                InkWell(
                  child: Row(
                    children: [
                      Icon(Icons.telegram,size: 30,color: Colors.blue,),
                      SizedBox(width: 6,),
                      Text(serviceModel.telegram)
                    ],
                  ),
                  onTap: (){
                    _launchTelegram(serviceModel.telegram);
                  },
                ),
                SizedBox(height: 10,),
              ],
            ):Container(),
            serviceModel.webAddress.isNotEmpty?Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Web Address',style: TextStyle(fontSize: Get.textTheme.bodyMedium!.fontSize,fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4,),
                InkWell(
                  child: Row(
                    children: [
                      Icon(Icons.web,size: 25,color: Colors.blue,),
                      SizedBox(width: 6,),
                      Text(serviceModel.webAddress)
                    ],
                  ),
                  onTap: () async {
                    _launchWebAddress(serviceModel.webAddress);
                  },
                ),
                SizedBox(height: 10,),
              ],
            ):Container(),
            Text('Upi',style: TextStyle(fontSize: Get.textTheme.bodyMedium!.fontSize,fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4,),
            Text(serviceModel.upiLink),
            SizedBox(height: 4,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Location',style: TextStyle(fontSize: Get.textTheme.bodyMedium!.fontSize,fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4,),
                InkWell(
                  child: Row(
                    children: [
                      Icon(Icons.map,size: 30,color: Colors.blue,),
                      SizedBox(width: 6,),
                      Text(roundDistanceInKM.toString()+' Km away')
                    ],
                  ),
                  onTap: (){
                    MapsLauncher.launchCoordinates(double.parse(serviceModel.latitude), double.parse(serviceModel.longitude));
                  },
                ),
                SizedBox(height: 10,),
              ],
            ),
            SizedBox(height: 10,),
            Text('Zoom',style: TextStyle(fontSize: Get.textTheme.bodyMedium!.fontSize,fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4,),
            Text(serviceModel.zoom),
            SizedBox(height: 10,),
            Text('Ratings',style: TextStyle(fontSize: Get.textTheme.bodyMedium!.fontSize,fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4,),
            Text(serviceModel.averageRating.toString()+'/5'),
            SizedBox(height: 10,),
            serviceModel.customFileds!.length>0?
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(serviceModel.customFileds![0].title??'',style: TextStyle(fontSize: Get.textTheme.bodyMedium!.fontSize,fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4,),
                Text(serviceModel.customFileds![0].value??''),
              ],
            ): SizedBox(height: 1,),
            serviceModel.customFileds!.length>0?
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(serviceModel.customFileds![1].title??'',style: TextStyle(fontSize: Get.textTheme.bodyMedium!.fontSize,fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4,),
                Text(serviceModel.customFileds![1].value??''),
              ],
            ): SizedBox(height: 1,),
            serviceModel.customFileds!.length>0?
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(serviceModel.customFileds![2].title??'',style: TextStyle(fontSize: Get.textTheme.bodyMedium!.fontSize,fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4,),
                Text(serviceModel.customFileds![2].value??''),
              ],
            ):
            SizedBox(height: 1,),
            SizedBox(height: 10,),
            TextButton(onPressed: (){
              Get.to(()=>ServiceReviews(),arguments: serviceModel);
            },
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Constants.appButtonColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      )
                  ),
                  padding: MaterialStateProperty.all(EdgeInsets.only(top: 12,bottom: 12)),
                ),
                child: Text('Service Reviews',style: TextStyle(color: Colors.white),)
            ),
            SizedBox(height: 15,),
            TextButton(onPressed: (){
              Get.to(()=>BuyService(),arguments:[serviceModel,null]);
            },
             style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Constants.appButtonColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                        )
                    ),
                    padding: MaterialStateProperty.all(EdgeInsets.only(top: 12,bottom: 12)),
                ),
                child: Text('Buy Service',style: TextStyle(color: Colors.white),)
            )
          ],
        ),
      )
    );
  }

  _launchWhatsapp(String number) async {
    var whatsapp =Uri.parse("whatsapp://send?phone=$number&text=hello");
    if (await canLaunchUrl(whatsapp)) {
      await launchUrl(whatsapp);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("WhatsApp is not installed on the device"),
        ),
      );
    }
  }

  _launchTelegram(String name) async {
    /// Send message via Telegram
    Telegram.send(
        username:name,
        message:' '
    );
  }

  _sendMail(String emailId) async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: emailId,
      query: 'subject= &body= ', //add subject and body here
    );

    var url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchWebAddress(String link) async {
    final uri = Uri.parse('https://'+link);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Web Address is not available"),
        ),
      );
    }
  }
}