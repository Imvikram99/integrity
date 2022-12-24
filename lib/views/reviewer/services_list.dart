import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:integrity/constants.dart';
import 'package:integrity/views/reviewer/service_detail.dart';

import '../../controllers/serviceController.dart';

class ServicesList extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => ServiceListState();
}


class ServiceListState extends State<ServicesList> {

  late String title;
  @override
  void initState() {
    super.initState();
    title=Get.arguments;
  }
  @override
  Widget build(BuildContext context) {
     return Scaffold(
       appBar:AppBar(
         title: Text(title,),
         centerTitle: true,
         backgroundColor: Constants.appButtonColor,
       ),
       body:Container(
         margin: EdgeInsets.only(top: 10,left: 4,right: 4),
         child:GetX<ServiceController>(
           init: Get.put<ServiceController>(ServiceController()),
           builder: (ServiceController controller) {
             controller.getServiceByCategory(title);
             return controller.services.length>0?
             ListView.builder(
               itemCount: controller.services.length,
               itemBuilder: (BuildContext context, int index) {
                 final model = controller.services[index];
                 return InkWell(
                   onTap: ()
                   {
                     Get.to(()=>ServiceDetail(),arguments: controller.services[index]);
                   },
                   child:Container(
                     margin: const EdgeInsets.symmetric(
                       horizontal: 4,
                       vertical: 4,
                     ),
                     padding: EdgeInsets.only(left: 10,right: 15),
                     decoration: BoxDecoration(
                         color: Colors.grey.shade200,
                         borderRadius: BorderRadius.circular(10),
                         border:Border.all(color: Colors.black87)
                     ),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         SizedBox(height: 10,),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Text(
                               model.name,
                               style: TextStyle(
                                 fontSize: Get.textTheme.headline6!.fontSize,
                               ),
                             ),
                             Text(
                               model.averageRating.toString()+'/5',
                               style: TextStyle(
                                 fontSize: Get.textTheme.headline6!.fontSize,
                               ),
                             )
                           ],
                         ),
                         SizedBox(height: 10,),
                         Text(
                           model.availabilityStartDate+'-'+model.availabilityEndDate+', '+model.availabilityStartTime+'-'+model.availabilityEndTime,
                           style: TextStyle(
                             fontSize: Get.textTheme.bodyMedium!.fontSize,
                           ),
                         ),
                         SizedBox(height: 10,),
                         Text(
                           model.description,
                           style: TextStyle(
                             fontSize: Get.textTheme.bodySmall!.fontSize,
                           ),
                         ),
                         SizedBox(height: 10,),
                       ],
                     ),
                   ),
                 );
               },
             ):
             controller.services.length==0?
               Center(child: Text('No Service Avaiable in this Category',style: TextStyle(color: Colors.grey.shade600,fontStyle: FontStyle.italic),),)
               :Center(child: CircularProgressIndicator(),);
           },
         ) ,
       ),
     );
  }
}