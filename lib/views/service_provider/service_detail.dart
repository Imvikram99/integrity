import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:integrity/constants.dart';
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
  String orderstatus='';
  late double rating;

  TextEditingController reviewController=TextEditingController();

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
        child: ListView(
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
                        padding: EdgeInsets.only(left: 10,right: 10),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10),
                            border:Border.all(color: Colors.black87)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10,),
                            Text(model.serviceName,
                              style: TextStyle(
                                fontSize: Get.textTheme.headline6!.fontSize,
                              ),
                            ),
                            SizedBox(height: 10,),
                            Text(
                              model.orderDate,
                              style: TextStyle(
                                fontSize: Get.textTheme.bodySmall!.fontSize,
                              ),
                            ),
                            SizedBox(height: 10,),
                            Text(
                              model.buyerPhone,
                              style: TextStyle(
                                fontSize: Get.textTheme.bodySmall!.fontSize,
                              ),
                            ),
                            SizedBox(height: 10,),
                            Text(
                              'order status: '+model.orderStatus,
                              style: TextStyle(
                                fontSize: Get.textTheme.bodySmall!.fontSize,
                              ),
                            ),
                            SizedBox(height: 10,),
                            model.orderStatus=='Completed'?
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    RatingBar.builder(
                                      initialRating: model.buyerRating,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      ignoreGestures: true,
                                      itemCount: 5,
                                      itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (rat) {
                                        print(rat);
                                       // rating=rat;
                                      },
                                    ),
                                    SizedBox(width: 8,),
                                    Text(model.buyerRating.toString(),style: TextStyle(fontSize: 20),),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Text('" ${model.buyerReview} "',style: TextStyle(fontSize: 18),),
                                SizedBox(height: 10,),
                              ],
                            ):
                            orderstatus=='Completed'?
                            Column(
                              children: [
                                RatingBar.builder(
                                  initialRating: 1,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rat) {
                                    print(rat);
                                    rating=rat;
                                  },
                                ),
                                SizedBox(height: 15,),
                                TextFormField(
                                  controller: reviewController,
                                  style:  TextStyle(color: Colors.black87, fontSize: 16),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Write down a review';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      enabledBorder: new OutlineInputBorder(
                                        borderRadius: new BorderRadius.circular(15.0),
                                        borderSide:  BorderSide(color:  Colors.cyan.shade700 ),
                                      ),
                                      focusedBorder: new OutlineInputBorder(
                                        borderRadius: new BorderRadius.circular(15.0),
                                        borderSide:  BorderSide(color:  Colors.cyan.shade700 ),
                                      ),
                                      filled: true,
                                      hintStyle: TextStyle(color: Colors.grey.shade500,fontSize: 14),
                                      hintText: "Write a review",
                                      fillColor: Colors.grey.shade200),
                                  maxLines: 3,
                                  onTap: (){

                                  },
                                ),
                                SizedBox(height: 10,),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.only(left: 25,right: 25),
                                  child:  TextButton(
                                      onPressed: (){
                                        if(reviewController.text.isNotEmpty)
                                          {
                                            controller.updateOrderStatus(model.orderId,rating,reviewController.text,'Completed');
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('Review Submitted Successfully')));
                                          }
                                        else
                                          {
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('Please Write a review first')));
                                          }
                                      },
                                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15.0),
                                            )
                                        ),
                                        padding: MaterialStateProperty.all(EdgeInsets.only(top: 8,bottom: 8,left: 30,right: 30)),
                                      ),
                                      child: Text('Submit',style: TextStyle(color: Colors.white),)
                                  ) ,
                                )
                              ],
                            )
                            :Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.only(left: 25,right: 25),
                              child:  TextButton(
                                  onPressed: (){
                                    setState(() {
                                      orderstatus='Completed';
                                    });
                                  },
                                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15.0),
                                        )
                                    ),
                                    padding: MaterialStateProperty.all(EdgeInsets.only(top: 8,bottom: 8,left: 30,right: 30)),
                                  ),
                                  child: Text('Mark Complete',style: TextStyle(color: Colors.white),)
                              ) ,
                            ),
                            SizedBox(height: 10,),
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