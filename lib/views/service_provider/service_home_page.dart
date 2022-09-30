import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:integrity/controllers/category_controller.dart';
import 'package:integrity/controllers/serviceController.dart';
import 'package:integrity/models/serviceModel.dart';
import 'package:integrity/views/createService.dart';
import 'package:integrity/views/service_provider/services_list.dart';

class Provider_Home_Page extends StatefulWidget {
  Provider_Home_Page({Key? key}) : super(key: key);

  @override
  State<Provider_Home_Page> createState() => Provider__Home_PageState();
}

class Provider__Home_PageState extends State<Provider_Home_Page> {
  ServiceController serviceController=Get.put(ServiceController());
  var duplicateItems =<ServiceModel>[];
  var items = <ServiceModel>[];
  String q='';

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    duplicateItems.addAll(serviceController.allServices);
  return Scaffold(
      body:SafeArea(
        child:Container(
          margin: EdgeInsets.only(left: 15,right: 10,top: 20),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded( flex: 6, child: Text('Categories',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.blueGrey.shade700),)),
                  Expanded( flex: 1, child: Icon(Icons.person_outline)),
                  Expanded( flex: 1,child: Icon(Icons.add_alert_outlined))
                ],
              ),
              SizedBox(height: 30,),
              TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey[800]),
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
            Expanded(flex:1,child:
            IconButton(onPressed:(){createService(controller.categories[index].name);}, icon: Icon(Icons.add,color: Colors.grey.shade400,))
            )
          ],
        ),
        Divider(color: Colors.grey.shade500,),
        SizedBox(height: 10,)
      ],
    );

  }

  createService(String categoryName) async
  {

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) =>CreateService(categoryName)
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