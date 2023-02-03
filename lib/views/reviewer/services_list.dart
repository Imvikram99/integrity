import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:integrity/constants.dart';
import 'package:integrity/models/category.dart';
import 'package:integrity/views/reviewer/service_detail.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/serviceController.dart';

class ServicesList extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => ServiceListState();
}


class ServiceListState extends State<ServicesList> {

  late Category category;
  final box = GetStorage();
  late String userId;
  FirebaseDynamicLinks dynamicLinks=FirebaseDynamicLinks.instance;
  String? _linkMessage;
  bool _isCreatingLink = false;
  @override
  void initState() {
    super.initState();
    category=Get.arguments;
    if(box!=null)
    {
      userId= box.read('id');
    }
  }
  @override
  Widget build(BuildContext context) {
     return Scaffold(
       appBar:AppBar(
         title: Text(category.name,),
         centerTitle: true,
         backgroundColor: Constants.appButtonColor,
       ),
       body:Container(
         margin: EdgeInsets.only(top: 10,left: 4,right: 4),
         child: GetX<ServiceController>(
           init: Get.put<ServiceController>(ServiceController()),
           builder: (ServiceController controller) {
             controller.getServiceByCategory(category.name);
             return controller.services.length>0?
             ListView.builder(
               itemCount: controller.services.length,
               itemBuilder: (BuildContext context, int index) {
                 final model = controller.services[index];
                 return InkWell(
                   onTap: ()
                   {
                     Get.to(()=>ServiceDetail(),arguments: [controller.services[index],category]);
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
                         SizedBox(height: 6,),
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
                         Row(
                           mainAxisAlignment: MainAxisAlignment.end,
                           children: [
                             InkWell(
                               onTap: (){
                                 _createDynamicLink(model.serviceId,userId);
                               },
                               child: Icon(Icons.share),
                             )
                           ],
                         ),
                         SizedBox(height: 6,),
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
         )
       ),
     );
  }

  Future<void> _createDynamicLink(String serviceId,String userId) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: Constants.kUriPrefix,
      link: Uri.parse(Constants.kUriPrefix +Constants.kServicePageLink+'serviceid=$serviceId&userid=$userId'),
      androidParameters: const AndroidParameters(
        packageName: 'com.example.integrity',
        minimumVersion: 0,
      ),
    );
    Uri url= await dynamicLinks.buildLink(parameters);

    await FlutterShare.share(
       title: 'link to share',
        text: 'Integrity Service Link',
        linkUrl: url.toString(),
    );
  }
}