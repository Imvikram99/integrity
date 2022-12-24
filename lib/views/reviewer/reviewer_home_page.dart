import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:integrity/constants.dart';
import 'package:integrity/screens/login_page.dart';
import 'package:integrity/views/reviewer/profile.dart';
import 'package:integrity/views/service_provider/profile.dart';
import 'package:integrity/views/reviewer/my_orders.dart';
import 'package:integrity/views/reviewer/service_detail.dart';

import '../../controllers/category_controller.dart';
import '../../controllers/serviceController.dart';
import '../../models/serviceModel.dart';
import 'services_list.dart';


class Reviewer_Home_Page extends StatefulWidget {
  Reviewer_Home_Page({Key? key}) : super(key: key);

  @override
  State<Reviewer_Home_Page> createState() => Reviewer__Home_PageState();
}

class Reviewer__Home_PageState extends State<Reviewer_Home_Page> {

  ServiceController serviceController=Get.put(ServiceController());
  var duplicateItems =<ServiceModel>[];
  var items = <ServiceModel>[];
  String q='';
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
    duplicateItems.addAll(serviceController.allServices);
    return Scaffold(
        appBar: AppBar(
          title: Text(Constants.appName),
          centerTitle: true,
          backgroundColor: Constants.appButtonColor,
          actions: [
            GestureDetector(
              child: Icon(Icons.person_outline),
              onTapDown: (TapDownDetails details){
                _showPopupMenu(
                    context, details.globalPosition);
              },
            ),
            SizedBox(width: 20,),
            Icon(Icons.add_alert_outlined),
            SizedBox(width: 20,)
          ],
        ),
        body:SafeArea(
          child:Container(
            margin: EdgeInsets.only(left: 15,right: 10,top: 20),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      filled: true,
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      hintText: "Search Service",
                      fillColor: Colors.grey.shade100),
                  onChanged: (value) {
                    filterSearchResults(value);
                  },
                ),
                SizedBox(height: 15,),
                Flexible(
                  child:q==''?categoriesList()
                      : ListView.builder(
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final model = items[index];
                      return Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.hotel,color: Colors.blue,size: 30,),
                              SizedBox(width: 10,),
                              Text(model.categoryName,style: Get.textTheme.headline6)
                            ],
                          ),
                          SizedBox(height: 10,),
                          Container(
                            padding: EdgeInsets.only(left: 10),
                            width:MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10),
                                border:Border.all(color: Colors.black87)
                            ),
                            child:InkWell(
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
                                    model.availabilityStartDate+'-'+model.availabilityEndDate+', '+model.availabilityStartTime+'-'+model.availabilityEndTime,
                                    style: TextStyle(
                                      fontSize: Get.textTheme.bodyMedium!.fontSize,
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                ],
                              ),
                              onTap: (){
                                Get.to(()=>ServiceDetail(),arguments: items[index]);
                              },
                            )

                          )
                        ],
                      );
                    },
                  ),

                )
              ],
            ),
          ) ,
        )
    );
  }

  Widget categoriesList()
  {
    return GetX<CategoryController>(
      init: Get.put(CategoryController()),
      builder: (cController){
        return cController.categories.length>0?
        ListView.builder(
            itemCount: cController.categories.length,
            itemBuilder: (BuildContext context, int index){
              return categoryItem(cController,index);
            })
            :Center(child: CircularProgressIndicator(),);
      },
    );
  }
  Widget categoryItem(CategoryController controller,int index)
  {
    return Column(
      children: [
        Row(
          children: [
            Expanded(flex:1,child: Icon(Icons.home_outlined,color: Colors.blue,)),
            Expanded(flex:5,child: InkWell(child:Text(controller.categories[index].name),
              onTap: (){
                Get.to(()=>ServicesList(),arguments: controller.categories[index].name);
              },)),
          ],
        ),
        Divider(color: Colors.grey.shade500,),
        SizedBox(height: 10,)
      ],
    );

  }

  //show menu
  _showPopupMenu(BuildContext context, Offset offset) async{
    FirebaseAuth auth=FirebaseAuth.instance;
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
            child: const Text('My Profile'),
            onTap: () async{
              await Future.delayed(const Duration(milliseconds: 10));
              Get.to(()=>ReviewerProfile(),arguments: userId);
            },),
          PopupMenuItem<String>(
            child: const Text('My Orders'),
            onTap: () async{
              await Future.delayed(const Duration(milliseconds: 10));
              Get.to(()=>Myorders());
            },
          ),
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


  void filterSearchResults(String query) {
    if(query.isNotEmpty) {
      List<ServiceModel> dummyListData = [];
      duplicateItems.forEach((item) {
        if(item.name.contains(query)) {
          if(!dummyListData.contains(item))
          {
            dummyListData.add(item);
          }
        }
      });
      setState(() {
        q=query;
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        q='';
        items.clear();

        //  items.addAll(duplicateItems);
      });
    }
  }
}






class expandable extends StatelessWidget {
  var service;
  var icon;
  var name;
  var star;
  var reveiwNumber;
  var isExpired;
  var description;
  
   expandable({
    Key? key,
    this.service,
    this.icon,
    this.name,
    this.star,
    this.reveiwNumber,
    this.isExpired,
    this.description
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
  //  decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(5.0),
              //   // color: Colors.white,
              //   boxShadow: [
              //     BoxShadow(
              //       color: Colors.grey,
              //       offset: Offset(0.0, 1.0), //(x,y)
              //       blurRadius: 6.0,
              //     ),
              //   ],
              // ),
      child: ExpandablePanel(
        
        header: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
                  textBaseline: TextBaseline.alphabetic,
            children: [
              Icon(icon,size: 40,color: Colors.blueAccent,),
              const SizedBox(
                width: 10,
              ),
              Text(service,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500
                ),)
            ]
        ),
        collapsed: const Text('', softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis,),
        expanded: Container(
          margin: EdgeInsets.only(top: 20),
          child: Center(
            child: Container(
              // height: MediaQuery.of(context).size.height*0.12,
              // width: MediaQuery.of(context).size.width*0.85,
               decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Color.fromARGB(255, 149, 153, 161).withOpacity(0.32),
            ),
             color: Colors.grey[100],
          ),
             
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:[
      Text(name,style: const TextStyle(
        color: Colors.black,
        fontSize: 15
      ),
      
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(star),
            const SizedBox(
            width: 5,
          ), 
          Icon(Icons.star,color: Colors.yellow,),
           const SizedBox(
            width: 5,
          ),  
          Text('|',style: TextStyle(fontWeight: FontWeight.bold),),
          const SizedBox(
            width: 5,
          ),
          Text('${reveiwNumber} Reviews')
        ],
      )
                      ]
                    ) ,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 25,horizontal: 0),
        child: Text(isExpired,style: TextStyle(
          color: Colors.grey[400]
        ),),
      ),
                      ],
                    ),
                    Container(
                       decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white,
            ),
             color: Colors.white,
          ),
                       child: Padding(
       padding: const EdgeInsets.all(13.0),
       child: Text(
        
        description, 
        style: TextStyle(
          color: Colors.grey[800],
          
        ),
        ),
                       ),     
                    )
                  ],
                ),
              ),
            ),
          ),
        )
       
      ),
    );
  }
}