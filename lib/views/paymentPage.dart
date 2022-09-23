import 'dart:convert';
import 'dart:developer';

import 'package:cashfree_pg/cashfree_pg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:integrity/constants.dart';
import 'package:http/http.dart' as http;
import 'package:integrity/models/serviceModel.dart';
import 'package:intl/intl.dart';

class PaymentPlan extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=>PaymentPlanState();

}

class PaymentPlanState extends State<PaymentPlan> {
  bool selected1=false,selected2=false;
  dynamic argumentData = Get.arguments;
  late ServiceModel serviceModel;
  late String userPhone;
  FirebaseFirestore firestore=FirebaseFirestore.instance;
  final remoteConfig = FirebaseRemoteConfig.instance;

  @override
  void initState() {
   serviceModel=argumentData[0]['s'];
   userPhone=argumentData[0]['ph'];
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
        title: Text('Choose Plan',style: TextStyle(color: Constants.appTextColor,fontSize: 26,fontWeight: FontWeight.bold),),
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
              margin: EdgeInsets.only(top: screenHeight/6,left: screenWidth/10),
              decoration: (BoxDecoration(
                  border: Border.all(color:selected1?Constants.appTextColor:Colors.transparent,width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.grey.shade200
              )),
              child: InkWell(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('\$23/Month',style: TextStyle(fontSize: 20,color: Constants.appTextColor),),
                    SizedBox(height: 6,),
                    Text('\$276 for 12 months',style: TextStyle(fontSize: 16,color: Colors.black87),),
                  ],
                ),
                onTap: (){
                  setState((){
                    selected1=true;
                    selected2=false;
                  });
                },
              ),
            ),
            Container(
              width: screenWidth/1.25,
              height: screenHeight/8,
              margin: EdgeInsets.only(top: screenHeight/15,left: screenWidth/10),
              decoration: (BoxDecoration(
                  border: Border.all(color:selected2?Constants.appTextColor:Colors.transparent,width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.grey.shade200
              )),
              child: InkWell(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('\$200/Yearly',style: TextStyle(fontSize: 20,color:Constants.appTextColor),),
                    SizedBox(height: 6,),
                    Text('save \$76',style: TextStyle(fontSize: 16,color: Colors.black87),),
                  ],
                ),
                onTap: (){
                  setState((){
                    selected2=true;
                    selected1=false;
                  });
                },
              ),
            ),
            Container(
              width: screenWidth/1.25,
              height: screenHeight/16,
              margin: EdgeInsets.only(top: screenHeight/3.5,left: screenWidth/10),
              child:TextButton(onPressed: ()async {
                final id = UniqueKey().hashCode;
                String token=await generateToken(id.toString());
                print(token);
                makePayment(token,id.toString());
              },
                child: Text('Pay',style: TextStyle(color: Colors.white,fontSize: 16),),
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
        "orderAmount":100.toString(),
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
      throw Exception('Failed to create album.');
    }
  }

  // WEB Intent
  makePayment(String token,String id) {
    //Replace with actual values

    String orderId = id;
    String stage = "TEST"; //PROD
    String orderAmount = 100.toString();
    String tokenData = token;
    String customerName = serviceModel.userId;
    String orderNote = serviceModel.name;
    String orderCurrency = "INR";
    String appId = remoteConfig.getString('client_id');
    String customerPhone = userPhone;
    String customerEmail = serviceModel.email;
    String notifyUrl = "https://test.gocashfree.com/notify";

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
            Get.back();
      print("key is $key : value is$value");
      //Do something with the result
    }));
  }

}