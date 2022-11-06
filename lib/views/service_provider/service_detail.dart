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
        child: ListView(
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
            Text('Description',style: TextStyle(fontSize: Get.textTheme.headline5!.fontSize,),),
            SizedBox(height: 6,),
            Text(serviceModel.description),
            SizedBox(height: 6,),
            Text(serviceModel.categoryName),
            SizedBox(height: 6,),
            //Text(serviceModel.status),
            SizedBox(height: 6,),
            Text(serviceModel.upiLink),
            SizedBox(height: 6,),
            Text(serviceModel.country),
            SizedBox(height: 6,),
            Text(serviceModel.webAddress),
            SizedBox(height: 6,),
            Text('Orders:',style: TextStyle(fontSize: Get.textTheme.headline5!.fontSize,),),
            GetX<ServiceController>(
              init: Get.put<ServiceController>(ServiceController()),
              builder: (ServiceController controller) {
                controller.getServiceOrders(serviceModel.serviceId);
                return controller.orders.length>0?
                ListView.builder(
                  itemCount: controller.orders.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    final model = controller.orders[index];
                    return Container(
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
                            Text(model.name,
                              style: TextStyle(
                                fontSize: Get.textTheme.headline6!.fontSize,
                              ),
                            ),
                            SizedBox(height: 10,),
                            Text(
                              model.date,
                              style: TextStyle(
                                fontSize: Get.textTheme.bodySmall!.fontSize,
                              ),
                            ),
                            SizedBox(height: 10,),
                            Text(
                              model.userPhone,
                              style: TextStyle(
                                fontSize: Get.textTheme.bodySmall!.fontSize,
                              ),
                            ),
                            SizedBox(height: 10,),
                            Text(
                              'order status: '+model.status,
                              style: TextStyle(
                                fontSize: Get.textTheme.bodySmall!.fontSize,
                              ),
                            ),
                            SizedBox(height: 10,),
                            /*model.status=='order placed'?
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                TextButton(onPressed: (){
                                  controller.updateOrderStatus(serviceModel.serviceId, model.orderId,'Rejected');
                                },
                                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15.0),

                                          )
                                      ),
                                      padding: MaterialStateProperty.all(EdgeInsets.only(top: 8,bottom: 8,left: 30,right: 30)),
                                    ),
                                    child: Text('Reject',style: TextStyle(color: Colors.white),)
                                ),
                                TextButton(onPressed: (){
                                  controller.updateOrderStatus(serviceModel.serviceId, model.orderId,'Accepted');
                                },
                                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15.0),
                                          )
                                      ),
                                      padding: MaterialStateProperty.all(EdgeInsets.only(top: 8,bottom: 8,left: 30,right: 30)),
                                    ),
                                    child: Text('Accept',style: TextStyle(color: Colors.white),)
                                ),
                              ],
                            ):
                            Container()*/
                          ],
                        ),
                      );
                  },
                )
                    :Container();
              },
            )
          ],
        )
      )
    );
  }

}