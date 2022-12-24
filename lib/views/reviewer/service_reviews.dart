import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:integrity/constants.dart';
import 'package:integrity/controllers/reviewer_controller.dart';
import 'package:integrity/controllers/serviceController.dart';
import 'package:integrity/models/Order.dart';
import 'package:integrity/models/serviceModel.dart';


class ServiceReviews extends StatefulWidget{
  ServiceReviews({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => ServiceReviewsState();
}


class ServiceReviewsState extends State<ServiceReviews> {

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
            child:GetX<ReviewerController>(
                  init: Get.put<ReviewerController>(ReviewerController()),
                  builder: (ReviewerController controller) {
                    controller.getServiceOrders(serviceModel.serviceId);
                    return controller.serviceOrders.length>0?
                    ListView.builder(
                      itemCount: controller.serviceOrders.length,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        final model = controller.serviceOrders[index];
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
                                  Text('" ${model.buyerReview} "',style: TextStyle(fontSize: 18,fontStyle: FontStyle.italic),),
                                  SizedBox(height: 10,),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    )
                    :controller.serviceOrders.length==0?
                        Center(child: Text('No Reviews'),)
                        :Container();
                  },
                )
        )
    );
  }

}