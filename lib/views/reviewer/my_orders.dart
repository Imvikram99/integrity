import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:integrity/controllers/reviewer_controller.dart';
import 'package:integrity/views/reviewer/service_detail.dart';

import '../../controllers/serviceController.dart';

class Myorders extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => MyordersState();
}


class MyordersState extends State<Myorders> {

//  late String title;
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text('My Orders',style: TextStyle(color: Colors.black),),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: GetX<ReviewerController>(
        init: Get.put<ReviewerController>(ReviewerController()),
        builder: (ReviewerController controller) {
          return controller.orders.length>0?
          ListView.builder(
            itemCount: controller.orders.length,
            itemBuilder: (BuildContext context, int index) {
              final model = controller.orders[index];
              return InkWell(
                onTap: ()
                {
               //   Get.to(()=>ServiceDetail(),arguments: controller.services[index]);
                },
                child:Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 4,
                  ),
                  padding: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                      border:Border.all(color: Colors.black87)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10,),
                      Text(model.name, style: TextStyle(fontSize: Get.textTheme.headline6!.fontSize,),),
                      SizedBox(height: 10,),
                      Text(model.status, style: TextStyle(fontSize: Get.textTheme.bodyMedium!.fontSize,),),
                      SizedBox(height: 10,),
                      Text(model.date, style: TextStyle(fontSize: Get.textTheme.bodySmall!.fontSize,),),
                      SizedBox(height: 10,),
                    ],
                  ),
                ),
              );
            },
          )
              :Center(child: Text('No service available in this category',),);
        },
      ),
    );
  }

}