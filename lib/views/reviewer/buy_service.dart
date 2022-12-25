import 'dart:convert';
import 'package:cashfree_pg/cashfree_pg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:integrity/constants.dart';
import 'package:http/http.dart' as http;
import 'package:integrity/controllers/serviceController.dart';
import 'package:integrity/models/Order.dart';
import 'package:integrity/models/serviceModel.dart';
import 'package:integrity/views/reviewer/my_orders.dart';

class BuyService extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=>BuyServiceState();

}

class BuyServiceState extends State<BuyService> {
  FirebaseFirestore firestore=FirebaseFirestore.instance;
  final remoteConfig = FirebaseRemoteConfig.instance;

  final box = GetStorage();
  late String userId;
  late ServiceModel serviceModel;
  late String userPhone;

  @override
  void initState() {
    serviceModel=Get.arguments;
    if(box!=null)
    {
      userId= box.read('id');
      FirebaseFirestore.instance.collection('users').where('userid',isEqualTo:userId).get().then((value) =>
      {
        for(var data in value.docs)
          {
            userPhone=data.data()['phone'],
          }
      });
    }

    getRemoteConfig();
    super.initState();
  }
  getRemoteConfig() async
  {
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(minutes: 1),
    ));
    await remoteConfig.fetchAndActivate();
  }
  @override
  Widget build(BuildContext context) {
    double screenHeight=MediaQuery.of(context).size.height;
    double screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        title: Text('Buy Service',style: TextStyle(color: Constants.appTextColor,fontSize: 26,fontWeight: FontWeight.bold),),
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body:SafeArea(
        child:Column(
          children: [
            Container(
              width: screenWidth/1.25,
              height: screenHeight/8,
              margin: EdgeInsets.only(top: screenHeight/15,left: screenWidth/10),
              child:Center(child:Text('Pay the service charges',style: TextStyle(fontSize: 18,fontStyle: FontStyle.italic),) ,)
            ),
            Container(
              width: screenWidth/1.25,
              height: screenHeight/15,
              margin: EdgeInsets.only(top: screenHeight/4,left: screenWidth/10),
              child:TextButton(onPressed: ()async {
                final id = UniqueKey().hashCode;
                String token=await generateToken(id.toString());
                print(token);
                makeUpiPayment(token,id.toString());
              },
                child:Align(
                  alignment: Alignment.center,
                  child:Text('Pay \$'+serviceModel.price+' to ${serviceModel.upiLink} \n Through UPI',style: TextStyle(color: Colors.white,fontSize: 16,fontStyle: FontStyle.italic),),
                ),
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue.shade400)),
              ) ,
            ),
            Container(
              width: screenWidth/1.25,
              height: screenHeight/15,
              margin: EdgeInsets.only(top: screenHeight/15,left: screenWidth/10),
              child:TextButton(onPressed: ()async {
                final id = UniqueKey().hashCode;
                String token=await generateToken(id.toString());
                print(token);
                makeCardPayment(token,id.toString());
              },
                child: Text('Pay \$'+serviceModel.price+' to ${serviceModel.upiLink} \n Through Bank',style: TextStyle(color: Colors.white,fontSize: 16,fontStyle: FontStyle.italic),),
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue.shade400)),
              ) ,
            )
          ],
        ),
      ),
    );
  }


  Future<String> generateToken(String id) async
  {
    final response = await http.post(
      Uri.parse('https://test.cashfree.com/api/v2/cftoken/order'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-client-id':remoteConfig.getString('client_id'),
        'x-client-secret':remoteConfig.getString('client_secret')
      },
      body: jsonEncode(<String, String>{
        "orderId": id,
        "orderAmount":serviceModel.price.toString(),
        "orderCurrency":"INR"
      }),
    );

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse['cftoken'];
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to generate token.');
    }
  }


  makeUpiPayment(String token,String id) {
    //Replace with actual values

    String orderId = id;
    String stage = Constants.cashFreeOrderStage;
    String orderAmount = serviceModel.price.toString();
    String tokenData = token;
    String customerName = userId;
    String orderNote = serviceModel.name;
    String orderCurrency = "INR";
    String appId = remoteConfig.getString('client_id');
    String customerPhone = userPhone;
    String customerEmail = serviceModel.email;
    String notifyUrl = Constants.cashFreeNotifyUrl;

    Map<String, dynamic> inputParams = {
      "orderId": orderId,
      "orderAmount": orderAmount,
      "customerName": customerName,
      "orderNote": orderNote,
      "orderCurrency": orderCurrency,
      "appId": appId,
      "customerPhone": customerPhone,
      "customerEmail": customerEmail,
      "stage": stage,
      "tokenData": tokenData,
      "notifyUrl": notifyUrl
    };

    CashfreePGSDK.doUPIPayment(inputParams)
        .then((value) => value?.forEach((key, value) {
      if(value=='SUCCESS')
      {
         final controller=Get.put(ServiceController());
         final order=Order(userId,serviceModel.userId,serviceModel.serviceId,userPhone,serviceModel.email,serviceModel.name,DateTime.now().toString(),'in Progress'
             ,0,'',0,'');
         controller.buyService(order,context);
         Get.close(3);
         Get.to(()=>Myorders());
      }
      print("key is $key : value is$value");
      //Do something with the result
    }));
  }

  makeCardPayment(String token,String id) {
    //Replace with actual values

    String orderId = id;
    String stage = Constants.cashFreeOrderStage;
    String orderAmount = serviceModel.price.toString();
    String tokenData = token;
    String customerName = userId;
    String orderNote = serviceModel.name;
    String orderCurrency = "INR";
    String appId = remoteConfig.getString('client_id');
    String customerPhone = userPhone;
    String customerEmail = serviceModel.email;
    String notifyUrl = Constants.cashFreeNotifyUrl;

    Map<String, dynamic> inputParams = {
      "orderId": orderId,
      "orderAmount": orderAmount,
      "customerName": customerName,
      "orderNote": orderNote,
      "orderCurrency": orderCurrency,
      "appId": appId,
      "customerPhone": customerPhone,
      "customerEmail": customerEmail,
      "stage": stage,
      "tokenData": tokenData,
      "notifyUrl": notifyUrl
    };

    CashfreePGSDK.doPayment(inputParams)
        .then((value) => value?.forEach((key, value) {
      if(value=='SUCCESS')
      {
        final controller=Get.put(ServiceController());
        final order=Order(userId,serviceModel.userId,serviceModel.serviceId,userPhone,serviceModel.email,serviceModel.name,DateTime.now().toString(),'in Progress'
            ,0,'',0,'');
        controller.buyService(order,context);
        Get.close(3);
        Get.to(()=>Myorders());
      }
      print("key is $key : value is$value");
      //Do something with the result
    }));
  }

}