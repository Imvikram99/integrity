import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:integrity/controllers/category_controller.dart';
import 'package:integrity/controllers/serviceController.dart';
import 'package:integrity/models/serviceModel.dart';
import 'package:integrity/views/createService.dart';
import 'package:integrity/views/reviewer/services_list.dart';
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
      body:SafeArea(
        child:Container(
          margin: EdgeInsets.only(left: 15,right: 10,top: 20),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded( flex: 6, child: Text('My Services',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.blueGrey.shade700),)),
                  Expanded( flex: 1,child:GestureDetector(
                    child: Icon(Icons.add),
                    onTapDown: (TapDownDetails details){
                      createService();
                    },
                  )),
                  Expanded( flex: 1,child:GestureDetector(
                    child: Icon(Icons.person_outline),
                    onTapDown: (TapDownDetails details){
                      _showPopupMenu(
                          context, details.globalPosition);
                    },
                  )),
                  Expanded( flex: 1,child: Icon(Icons.add_alert_outlined))
                ],
              ),
              SizedBox(height: 30,),
              SizedBox(height: 15,),
              Flexible(
                  child:GetX<ServiceController>(
                    init: Get.put(ServiceController()),
                    builder: (controller){
                      controller.getMyServices(userId);
                      return controller.myServices.length>0?
                      ListView.builder(
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
                                      border:Border.all(color: Colors.black87)
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10,),
                                      Text(
                                        model.name,
                                        style: TextStyle(
                                          fontSize: Get.textTheme.headline6!.fontSize,
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
                      )
                          :Center(child: CircularProgressIndicator(),);
                    },
                  )
               )
            ],
          ),
        ) ,
      )
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
        ]
    );
  }
}