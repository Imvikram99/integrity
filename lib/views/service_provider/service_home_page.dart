import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:integrity/constants.dart';
import 'package:integrity/controllers/category_controller.dart';
import 'package:integrity/controllers/serviceController.dart';
import 'package:integrity/models/serviceModel.dart';
import 'package:integrity/views/service_provider/createService.dart';
import 'package:integrity/views/reviewer/services_list.dart';
import 'package:integrity/views/service_provider/edit_service.dart';
import 'package:integrity/views/service_provider/profile.dart';
import 'package:integrity/views/service_provider/service_detail.dart';

import '../../screens/login_page.dart';

class Provider_Home_Page extends StatefulWidget {
  Provider_Home_Page({Key? key}) : super(key: key);

  @override
  State<Provider_Home_Page> createState() => Provider__Home_PageState();
}

class Provider__Home_PageState extends State<Provider_Home_Page> {
  ServiceController serviceController=Get.put(ServiceController());
  final box = GetStorage();
  late String userId;

  @override
  void initState() {
    super.initState();
    if(box!=null)
    {
      userId= box.read('id');
    }
  }
  @override
  Widget build(BuildContext context) {
  return Scaffold(
      appBar: AppBar(
        title: Text('My Services'),
        backgroundColor: Constants.appButtonColor,
        actions: [
          GestureDetector(
           child: Icon(Icons.add),
          onTapDown: (TapDownDetails details){
            createService();
          },
        ),
          SizedBox(width: 15,),
          GestureDetector(
            child: Icon(Icons.person_outline),
            onTapDown: (TapDownDetails details){
                _showPopupMenu(context, details.globalPosition);
            },
          ),
          SizedBox(width: 15,),
          Icon(Icons.add_alert_outlined),
          SizedBox(width: 15,)
        ],
      ),
      body:Container(
          margin: EdgeInsets.only(left: 15,right: 10,top: 10,),
          child: Column(
            children: [
              Flexible(
                  child:GetX<ServiceController>(
                    init: Get.put(ServiceController()),
                    builder: (controller){
                      controller.getMyServices(userId);
                      return controller.myServices.length>0?
                      ListView.builder(
                        padding: EdgeInsets.only(bottom: 20),
                        shrinkWrap: true,
                        itemCount: controller.myServices.length,
                        itemBuilder: (context, index) {
                          final model = controller.myServices[index];
                          return InkWell(
                            child:Column(
                              children: [
                                SizedBox(height: 10,),
                                Container(
                                  padding: EdgeInsets.only(left: 10),
                                  width:MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(10),
                                      border:Border.all(color: Constants.appTextColor)
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10,),
                                      Row(
                                        children: [
                                          Expanded(
                                              flex:5,
                                              child: Text(
                                            model.name,
                                            style: TextStyle(
                                              fontSize: Get.textTheme.headline6!.fontSize,
                                            ),
                                          )),
                                          Expanded(
                                            flex: 1,
                                            child:GestureDetector(
                                              onTapDown: (TapDownDetails details){
                                                 _serviceOptions(context,details.globalPosition,controller.myServices[index],controller);
                                              },
                                              child: Icon(Icons.keyboard_control_sharp,color: Constants.appTextColor,size: 25,),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                      Text(
                                        model.status,
                                        style: TextStyle(
                                          fontSize: Get.textTheme.bodyMedium!.fontSize,
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      Text(
                                        model.categoryName,
                                        style: TextStyle(
                                          fontSize: Get.textTheme.bodyMedium!.fontSize,
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      Text(
                                        model.city+' '+model.country,
                                        style: TextStyle(
                                          fontSize: Get.textTheme.bodyMedium!.fontSize,
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      Text(
                                        model.availabilityStartDate+'-'+model.availabilityEndDate+', '+model.availabilityStartTime+'-'+model.availabilityEndTime,
                                        style: TextStyle(
                                          fontSize: Get.textTheme.bodyMedium!.fontSize,
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            onTap: (){
                              Get.to(()=>ServiceDetail(),arguments: model);
                            },
                          );
                        },
                      ):
                      controller.myServices.length==0?
                      Center(child: Text('You have not created any service yet',style: TextStyle(color: Colors.grey,fontStyle: FontStyle.italic),),):
                      Center(child: CircularProgressIndicator(),);
                    },
                  )
               ),
            ],
          ),
        ) ,
      );
  }



  createService() async
  {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) =>CreateService()
    );
  }


  _showPopupMenu(BuildContext context, Offset offset) async{
    double left = offset.dx;
    double top = offset.dy+15;
    await showMenu(
        context: context,
        position: RelativeRect.fromLTRB(left, top, 50, 0),
        useRootNavigator: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0))),
        items: [
          PopupMenuItem<String>(
            child: const Text('LogOut'),
            onTap: () async{
              box.erase();
              await Future.delayed(const Duration(milliseconds: 10));
              Get.offAll(()=>LogIn_page());
            },),
          PopupMenuItem<String>(
            child: const Text('My Profile'),
            onTap: () async{
              await Future.delayed(const Duration(milliseconds: 10));
              Get.to(()=>ProviderProfile(),arguments: userId);
            },),
        ]
    );
  }

  _serviceOptions(BuildContext context, Offset offset,ServiceModel serviceModel,ServiceController controller ) async{
    double left = offset.dx;
    double top = offset.dy+15;
    await showMenu(context: context, position: RelativeRect.fromLTRB(left, top, 4, 0),
        useRootNavigator: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0))),
        items: [
          PopupMenuItem<String>(
              child: const Text('Edit Service'),
              onTap: () => Future(
                    () => Get.to(EditService(),arguments: serviceModel)
              )
          ),
          PopupMenuItem<String>(
              child: serviceModel.status=='published'?Text('Pause Service'):Text('ReActivate'),
              onTap: () => Future(
                    () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) =>
                        serviceModel.status=='published'? AlertDialog(
                        title: const Text('Warning!',style: TextStyle(color: Colors.red),),
                        content: const Text('Do you really want to Pause this Service?',style: TextStyle(fontSize: 18)),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('No',style: TextStyle(color: Colors.green)),
                          ),
                          TextButton(
                            onPressed: () =>{
                              controller.pauseService(serviceModel.serviceId),
                              Navigator.pop(context, 'OK'),
                            },
                            child: const Text('Yes',style: TextStyle(color: Colors.green)),
                          ),
                        ],
                  ):AlertDialog(
                          title: const Text('Warning!',style: TextStyle(color: Colors.red),),
                          content: const Text('Your are going to Re activate this service',style: TextStyle(fontSize: 18)),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('Cancel',style: TextStyle(color: Colors.green)),
                            ),
                            TextButton(
                              onPressed: () =>{
                                controller.reActivateService(serviceModel.serviceId),
                                Navigator.pop(context, 'OK'),
                              },
                              child: const Text('oK',style: TextStyle(color: Colors.green)),
                            ),
                          ],
                        ),
                ),
              )
          ),
        ]
    );
  }
}