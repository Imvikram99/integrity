import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:integrity/controllers/serviceController.dart';
import 'package:integrity/models/Order.dart';
import 'package:integrity/models/serviceModel.dart';


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
        title: Text(serviceModel.name,style: TextStyle(color: Colors.black),),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body:Container(
        padding: EdgeInsets.only(left: 10,right: 10),
        decoration: BoxDecoration(color: Colors.white),
        child:ListView(
          children: [
            Text(
              'Availability: '+serviceModel.availabilityStartDate+'-'+serviceModel.availabilityEndDate+', '+serviceModel.availabilityStartTime+'-'+serviceModel.availabilityEndTime,
              style: TextStyle(
                fontSize: Get.textTheme.bodyMedium!.fontSize,
              ),
            ),
            SizedBox(height: 5,),
            Divider(color: Colors.black12,thickness: 2,),
            SizedBox(height: 5,),
            Text('Description',style: TextStyle(fontSize: Get.textTheme.headline5!.fontSize,),
            ),
            SizedBox(height: 6,),
            Text(serviceModel.description),
            SizedBox(height: 6,),
            Text(serviceModel.country),
            SizedBox(height: 6,),
            Text(serviceModel.webAddress),
            SizedBox(height: 6,),
            TextButton(onPressed: (){
              final controller=Get.put(ServiceController());
              final order=Order(userId, serviceModel.name, DateTime.now().toString(), 'order placed', serviceModel.serviceId);
              controller.buyService(order,context);
            },
             style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            side: BorderSide(color: Colors.blue)
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