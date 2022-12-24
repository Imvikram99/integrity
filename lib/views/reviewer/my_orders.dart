import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:integrity/constants.dart';
import 'package:integrity/controllers/reviewer_controller.dart';
import 'package:integrity/views/reviewer/service_detail.dart';

import '../../controllers/serviceController.dart';

class Myorders extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => MyordersState();
}


class MyordersState extends State<Myorders> {

  final box = GetStorage();
  late String userId;
  late double rating;

  TextEditingController reviewController=TextEditingController();

  @override
  void initState() {
    super.initState();
    if(box!=null)
    {
      userId= box.read('id');
    }
    print('user is= '+userId);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text('My Orders',),
        centerTitle: true,
        backgroundColor: Constants.appButtonColor,
        elevation: 0,
      ),
      body:Container(
        margin: EdgeInsets.only(top: 10,right: 4,left: 4),
        child:GetX<ReviewerController>(
          init: Get.put<ReviewerController>(ReviewerController()),
          builder: (ReviewerController controller) {
            controller.getMyOrders(userId);
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
                        Text(model.serviceName, style: TextStyle(fontSize: Get.textTheme.headline6!.fontSize,),),
                        SizedBox(height: 10,),
                        Text(model.orderStatus, style: TextStyle(fontSize: Get.textTheme.bodyMedium!.fontSize,),),
                        SizedBox(height: 10,),
                        Text(model.orderDate, style: TextStyle(fontSize: Get.textTheme.bodySmall!.fontSize,),),
                        SizedBox(height: 10,),
                        model.orderStatus=='Completed'&& model.buyerRating>0?
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                RatingBar.builder(
                                  initialRating: model.serviceRating,
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
                                    rating=rat;
                                  },
                                ),
                                SizedBox(width: 8,),
                                Text(model.serviceRating.toString(),style: TextStyle(fontSize: 20),),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Text('" ${model.serviceReview} "',style: TextStyle(fontSize: 18),),
                            SizedBox(height: 10,),
                          ],
                        ):
                        model.orderStatus=='Completed'&& model.buyerRating==0?
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
                                      controller.updateOrderStatus(model.orderId,rating,reviewController.text,model.serviceId);
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
                        ):
                        model.orderStatus=='in Progress'?
                        Column(
                          children: [
                            RatingBar.builder(
                              initialRating: 1,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              ignoreGestures: true,
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
                              readOnly: true,
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
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('You can not post a review while order is in progress.')));
                              },
                            ),
                            SizedBox(height: 10,),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.only(left: 25,right: 25),
                              child:  TextButton(
                                  onPressed: (){
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('You can not post a review while order is in progress.')));
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
                        ):
                        Container(),
                        SizedBox(height: 10,),
                      ],
                    ),
                  ),
                );
              },
            )
                :Center(child: Text('No service available in this category',),);
          },
        ) ,
      ),
    );
  }

}