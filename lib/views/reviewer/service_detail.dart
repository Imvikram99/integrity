import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:integrity/constants.dart';
import 'package:integrity/controllers/serviceController.dart';
import 'package:integrity/models/Order.dart';
import 'package:integrity/models/serviceModel.dart';
import 'package:integrity/views/reviewer/buy_service.dart';
import 'package:integrity/views/reviewer/service_reviews.dart';


class ServiceDetail extends StatefulWidget{
  ServiceDetail({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => ServiceDetailState();
}


class ServiceDetailState extends State<ServiceDetail> {

  late ServiceModel serviceModel;
  final box = GetStorage();
  late String userId;

  @override
  void initState() {
    super.initState();
    serviceModel=Get.arguments;
    if(box!=null)
    {
      userId= box.read('id');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text(serviceModel.name),
        centerTitle: true,
        backgroundColor: Constants.appButtonColor,
      ),
      body:Container(
        padding: EdgeInsets.only(left: 10,right: 10,top: 10),
        decoration: BoxDecoration(color: Colors.white),
        child:ListView(
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
            Text('Email Address',style: TextStyle(fontSize: Get.textTheme.bodyMedium!.fontSize,fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4,),
            Text(serviceModel.email),
            SizedBox(height: 10,),
            Text('WhatsApp',style: TextStyle(fontSize: Get.textTheme.bodyMedium!.fontSize,fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4,),
            Text(serviceModel.watsApp),
            SizedBox(height: 10,),
            Text('Telegram',style: TextStyle(fontSize: Get.textTheme.bodyMedium!.fontSize,fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4,),
            Text(serviceModel.telegram),
            SizedBox(height: 10,),
            Text('Web Address',style: TextStyle(fontSize: Get.textTheme.bodyMedium!.fontSize,fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4,),
            Text(serviceModel.webAddress),
            SizedBox(height: 10,),
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
              Get.to(()=>BuyService(),arguments: serviceModel);
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

}