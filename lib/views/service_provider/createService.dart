import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:integrity/constants.dart';
import 'package:integrity/controllers/category_controller.dart';
import 'package:integrity/controllers/serviceController.dart';
import 'package:integrity/models/category.dart';
import 'package:integrity/models/serviceModel.dart';
import 'package:integrity/views/paymentPage.dart';

class CreateService extends StatefulWidget {
  @override
  _CreateServiceState createState() => _CreateServiceState();
}

class _CreateServiceState extends State<CreateService> {
  final _formKey = GlobalKey<FormState>();
  final box=GetStorage();
  String? userId;
  late String dropdownValue;
  final optionItems=<String>[];
  late String selectedCategory;


  TextEditingController serviceNameController=TextEditingController();
  TextEditingController serviceCategoryController=TextEditingController();
  TextEditingController servicePriceController=TextEditingController();
  TextEditingController serviceDescriptionController=TextEditingController();
  TextEditingController pinCodeController=TextEditingController();
  TextEditingController webLinkController=TextEditingController();
  TextEditingController zoomLinkController=TextEditingController();
  TextEditingController watsAppController=TextEditingController();
  TextEditingController upiController=TextEditingController();
  TextEditingController telegramController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  TextEditingController startDayController=TextEditingController();
  TextEditingController endDayController=TextEditingController();
  TextEditingController startTimeController=TextEditingController();
  TextEditingController endTimeController=TextEditingController();

  TextEditingController cf1Controller=TextEditingController();
  TextEditingController cf2Controller=TextEditingController();
  TextEditingController cf3Controller=TextEditingController();
  String? cf1Title;
  String? cf2Title;
  String? cf3Title;
  List<CustomFields> customFileds=[];

  bool saving=false;
  double lat=0,long=0;
  double fromTime=0,toTime=0;
  late String countryValue;
  late String stateValue;
  late String cityValue;
  late String userPhone;
  List<String> days=['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'];

  List<String> searchSuggestion(String query)=>
      List.of(days).where((element) {
            final numberLower=element.toLowerCase();
            final queryLower=query.toLowerCase();
            return numberLower.contains(queryLower);
      }).toList();

 Future<TimeOfDay> _selectTime(BuildContext context) async {
    TimeOfDay selectedTime = TimeOfDay.now();

    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if(timeOfDay != null && timeOfDay != selectedTime)
    {
      setState(() {
        selectedTime = timeOfDay;
      });
    }
     return selectedTime;
  }


  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(forceAndroidLocationManager: true)
        .then((Position position) {
      setState((){
        lat=position.latitude;
        long=position.longitude;} );

    }).catchError((e) {
      debugPrint(e);
    });
  }

 addService(ServiceModel model)
 {
   if (!_formKey.currentState!.validate()) {
     setState(() {
       saving = false;
     });
   }
   else
     {
       ServiceController controller=Get.put(ServiceController());
       controller.saveService(model);
       saving=false;
        Get.back();
        Get.to(()=>PaymentPlan(),arguments: [{'s':model,'ph':userPhone}]);
     }
 }

 addCustomField(){
   final _cformKey = GlobalKey<FormState>();
   TextEditingController controller1=TextEditingController();
   TextEditingController controller2=TextEditingController();
   Get.defaultDialog(
     title: 'Add filed',
     titleStyle: TextStyle(fontStyle: FontStyle.italic),
     content: Form(
         key: _cformKey,
         child: Column(
           children: [
             TextFormField(
               controller: controller1,
               decoration: InputDecoration(
                 border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                 hintText: 'field title',
               ),
               validator: (value){
                 if(value!.isEmpty)
                 {
                   return 'please enter a title';
                 }
                 return null;
               },
             ),
             SizedBox(height: 10,),
             TextFormField(
               controller: controller2,
               decoration: InputDecoration(
                 border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                 hintText: 'field value',
               ),
               validator: (value){
                 if(value!.isEmpty)
                 {
                   return 'please enter a value';
                 }
                 return null;
               },
             ),
             TextButton(
               onPressed: (){
                 if(_cformKey.currentState!.validate())
                   setState((){
                     if(cf1Controller.text.isEmpty)
                       {
                         cf1Title=controller1.text;
                         cf1Controller.text=controller2.text;
                         CustomFields fields=CustomFields(cf1Title,cf1Controller.text);
                         customFileds.add(fields);
                       }
                     else if(cf2Controller.text.isEmpty)
                       {
                         cf2Title=controller1.text;
                         cf2Controller.text=controller2.text;
                         CustomFields fields=CustomFields(cf2Title,cf2Controller.text);
                         customFileds.add(fields);
                       }
                     else
                       {
                         cf3Title=controller1.text;
                         cf3Controller.text=controller2.text;
                         CustomFields fields=CustomFields(cf3Title,cf3Controller.text);
                         customFileds.add(fields);
                       }
                   });
                 Get.back();
               },
               child: Text('Add',style: TextStyle(color: Colors.white),),
               style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue)),
             ),
           ],
         ))
   );
 }

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(box!=null)
      {
        userId=box.read('id');
        FirebaseFirestore.instance.collection('users').where('userid',isEqualTo:userId).get().then((value) =>
        {
          for(var data in value.docs)
            {
              userPhone=data.data()['phone'],
            }
        });
      }
    _getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
        onClosing: () {},
        builder: (context) =>
        StatefulBuilder(
        builder: (BuildContext context, StateSetter sheetState /*You can rename this!*/) {
         return Form(
          key: _formKey,
          child: Container(
              margin: EdgeInsets.only(left: 20,right: 20),
              height:MediaQuery.of(context).size.height/1.5,
              child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 10,),
                          Expanded(flex: 4,
                            child: Text('Create Service',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Constants.appTextColor),),
                          ),
                          Expanded(flex: 1,
                            child: IconButton(icon: Icon(Icons.clear),
                              onPressed: (){
                                Navigator.pop(context);
                              },
                            ),
                          )
                        ],
                      ),
                      TextFormField(
                        controller: serviceNameController,
                        style:  TextStyle(color: Colors.black87, fontSize: 16),
                        decoration: InputDecoration(
                            enabledBorder: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(15.0),
                              borderSide:  BorderSide(color:  Colors.grey.shade200 ),

                            ),
                            focusedBorder: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(15.0),
                              borderSide:  BorderSide(color:  Colors.cyan.shade700 ),

                            ),
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey.shade500,fontSize: 14),
                            hintText: "Type Service name",
                            fillColor: Colors.grey.shade200),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter service name';
                          }
                          return null;
                        },
                        onTap: (){

                        },
                      ),
                      SizedBox(height: 20,),
                      Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: Colors.grey.shade200),
                        child: Column(
                          children: [
                            SizedBox(height: 10,),
                            Text('Availability Time'),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(width: 10,),
                                Expanded(
                                  flex: 1,
                                  child:Container(
                                    height: 50,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: Colors.white),
                                    child:Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                            child: TextFormField(
                                              controller: startTimeController,
                                              readOnly: true,
                                              style:  TextStyle(color: Colors.black87, fontSize: 16),
                                              decoration: InputDecoration(
                                                  enabledBorder: new OutlineInputBorder(
                                                    borderRadius: new BorderRadius.circular(15.0),
                                                    borderSide:  BorderSide(color:  Colors.white ),
                                                  ),
                                                  focusedBorder: new OutlineInputBorder(
                                                    borderRadius: new BorderRadius.circular(15.0),
                                                    borderSide:  BorderSide(color:  Colors.white ),
                                                  ),
                                                  filled: true,
                                                  hintStyle: TextStyle(color: Colors.grey.shade500,fontSize: 14),
                                                  hintText: "From",
                                                  fillColor: Colors.white),
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return 'Please select a Time';
                                                }
                                                return null;
                                              },
                                              onTap: (){

                                              },
                                            )),
                                        IconButton(icon: Icon(Icons.access_time,color: Colors.blue,),
                                          onPressed: () async{
                                            TimeOfDay t=await _selectTime(this.context);
                                            setState((){
                                              fromTime=t.hour.toDouble()+(t.minute.toDouble() / 60);
                                              startTimeController.text=t.format(this.context);
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Expanded(
                                  flex: 1,
                                  child:Container(
                                    height: 50,
                                    //  padding: EdgeInsets.only(left: 8,right: 8),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: Colors.white),
                                    child:Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                            child: TextFormField(
                                              controller: endTimeController,
                                              readOnly: true,
                                              style:  TextStyle(
                                                  color: Colors.black87, fontSize: 16),
                                              decoration: InputDecoration(
                                                  enabledBorder: new OutlineInputBorder(
                                                    borderRadius: new BorderRadius.circular(15.0),
                                                    borderSide:  BorderSide(color:  Colors.white ),
                                                  ),
                                                  focusedBorder: new OutlineInputBorder(
                                                    borderRadius: new BorderRadius.circular(15.0),
                                                    borderSide:  BorderSide(color:  Colors.white ),
                                                  ),
                                                  filled: true,
                                                  hintStyle: TextStyle(color: Colors.grey.shade500,fontSize: 14),
                                                  hintText: "To",
                                                  fillColor: Colors.white),
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return 'Please select a Time';
                                                }
                                                else if(fromTime>=toTime)
                                                {
                                                  return 'Please change the end time';
                                                }
                                                return null;
                                              },
                                              onTap: (){

                                              },
                                            )),
                                        IconButton(icon: Icon(Icons.access_time,color: Colors.blue,),
                                          onPressed: () async{
                                            TimeOfDay t=await _selectTime(this.context);
                                            setState((){
                                              toTime=t.hour.toDouble()+(t.minute.toDouble() / 60);
                                              endTimeController.text=t.format(context);
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10,),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(width: 10,),
                                Expanded(
                                    flex: 1,
                                    child:TypeAheadField(
                                      suggestionsCallback :(pattern) async {
                                        return await searchSuggestion(pattern);
                                      },
                                      onSuggestionSelected: (String day){
                                        setState((){
                                          startDayController.text=day;
                                        });
                                      },
                                      textFieldConfiguration: TextFieldConfiguration(
                                        controller: startDayController,
                                        style:  TextStyle(color: Colors.black87, fontSize: 14),
                                        decoration: InputDecoration(
                                            focusedBorder: new OutlineInputBorder(
                                              borderRadius: new BorderRadius.circular(15.0),
                                              borderSide:  BorderSide(color:  Colors.white ),
                                            ),
                                            enabledBorder: new OutlineInputBorder(
                                              borderRadius: new BorderRadius.circular(15.0),
                                              borderSide:  BorderSide(color:  Colors.white ),
                                            ),
                                            hintText: 'From (day)',
                                            hintStyle: TextStyle(color: Colors.grey.shade500),
                                            filled: true,
                                            fillColor: Colors.white
                                        ),

                                      ),
                                      itemBuilder: (context,String day){
                                        return ListTile(title: Text(day),);
                                      },
                                    ) ),
                                SizedBox(width: 10,),
                                Expanded(
                                    flex: 1,
                                    child:TypeAheadField(
                                      suggestionsCallback :(pattern) async {
                                        return await searchSuggestion(pattern);
                                      },
                                      onSuggestionSelected: (String day){
                                        setState((){
                                          endDayController.text=day;
                                        });
                                      },
                                      textFieldConfiguration: TextFieldConfiguration(
                                          controller: endDayController,
                                          style:  TextStyle(
                                              color: Colors.black87, fontSize: 14),
                                          decoration: InputDecoration(
                                              focusedBorder: new OutlineInputBorder(
                                                borderRadius: new BorderRadius.circular(15.0),
                                                borderSide:  BorderSide(color:  Colors.white ),
                                              ),
                                              enabledBorder: new OutlineInputBorder(
                                                borderRadius: new BorderRadius.circular(15.0),
                                                borderSide:  BorderSide(color:  Colors.white ),
                                              ),
                                              hintText: 'To (day)',
                                              hintStyle: TextStyle(color: Colors.grey.shade500),
                                              filled: true,
                                              fillColor: Colors.white
                                          )
                                      ),
                                      itemBuilder: (context,String day){
                                        return ListTile(title: Text(day),);
                                      },
                                    ) ),
                                SizedBox(width: 10,),
                              ],
                            ),
                            SizedBox(height: 10,),
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                      SelectState(
                        onCountryChanged: (value) {
                          setState(() {
                            countryValue= value;
                          });
                        },
                        onStateChanged:(value) {
                          setState(() {
                            stateValue = value;
                          });
                        },
                        onCityChanged:(value) {
                          setState(() {
                            cityValue = value;
                          });
                        },

                      ),
                      SizedBox(height: 20,),
                      GetX<CategoryController>(
                        init: Get.put(CategoryController()),
                        builder: (controller){
                          optionItems.clear();
                          controller.categories.forEach((element) {
                            optionItems.add(element.name);
                          });
                            dropdownValue=optionItems[0];
                            print(dropdownValue);
                          return DropdownButtonFormField(
                            decoration: InputDecoration(
                                enabledBorder: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(15.0),
                                  borderSide:  BorderSide(color:  Colors.grey.shade200 ),

                                ),
                                focusedBorder: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(15.0),
                                  borderSide:  BorderSide(color:  Colors.cyan.shade700 ),

                                ),
                                filled: true,
                                fillColor: Colors.grey.shade200),
                            dropdownColor: Colors.grey.shade200,
                            value: dropdownValue,
                            onChanged: (String? newValue) {
                              dropdownValue = newValue!;
                              selectedCategory=newValue;
                            },
                            items: optionItems.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(fontSize: 14),
                                ),
                              );
                            }).toList(),
                          );

                        },
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        controller: servicePriceController,
                        style:  TextStyle(color: Colors.black87, fontSize: 16),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            enabledBorder: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(15.0),
                              borderSide:  BorderSide(color:  Colors.grey.shade200 ),

                            ),
                            focusedBorder: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(15.0),
                              borderSide:  BorderSide(color:  Colors.cyan.shade700 ),

                            ),
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey.shade500,fontSize: 14),
                            hintText: "Service Price",
                            fillColor: Colors.grey.shade200),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter service price';
                          }
                          return null;
                        },
                        onTap: (){

                        },
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        controller: serviceDescriptionController,
                        style:  TextStyle(color: Colors.black87, fontSize: 16),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter service description';
                          }
                          else if(value.length>500)
                          {
                            return 'description should be short';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            enabledBorder: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(15.0),
                              borderSide:  BorderSide(color:  Colors.grey.shade200 ),
                            ),
                            focusedBorder: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(15.0),
                              borderSide:  BorderSide(color:  Colors.cyan.shade700 ),
                            ),
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey.shade500,fontSize: 14),
                            hintText: "Type short Description",
                            fillColor: Colors.grey.shade200),
                        maxLines: 5,
                        onTap: (){

                        },
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        controller:pinCodeController ,
                        style:  TextStyle(
                            color: Colors.black87, fontSize: 16),
                        decoration: InputDecoration(
                            enabledBorder: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(15.0),
                              borderSide:  BorderSide(color:  Colors.grey.shade200 ),

                            ),
                            focusedBorder: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(15.0),
                              borderSide:  BorderSide(color:  Colors.cyan.shade700 ),

                            ),
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey.shade500,fontSize: 14),
                            hintText: "Type Pin code",
                            fillColor: Colors.grey.shade200),
                        onTap: (){

                        },
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        controller:watsAppController ,
                        style:  TextStyle(
                            color: Colors.black87, fontSize: 16),
                        decoration: InputDecoration(
                            enabledBorder: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(15.0),
                              borderSide:  BorderSide(color:  Colors.grey.shade200 ),

                            ),
                            focusedBorder: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(15.0),
                              borderSide:  BorderSide(color:  Colors.cyan.shade700 ),

                            ),
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey.shade500,fontSize: 14),
                            hintText: "Type Your business Watsapp",
                            fillColor: Colors.grey.shade200),
                        onTap: (){

                        },
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        controller:emailController ,
                        style:  TextStyle(
                            color: Colors.black87, fontSize: 16),
                        decoration: InputDecoration(
                            enabledBorder: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(15.0),
                              borderSide:  BorderSide(color:  Colors.grey.shade200 ),

                            ),
                            focusedBorder: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(15.0),
                              borderSide:  BorderSide(color:  Colors.cyan.shade700 ),

                            ),
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey.shade500,fontSize: 14),
                            hintText: "Type email",
                            fillColor: Colors.grey.shade200),
                        validator: (val) {
                          bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val.toString());

                          if (val == null || val.isEmpty) {
                            return 'Please write an email address';
                          }
                          else if(!emailValid)
                          {
                            return 'not a valid email address';
                          }
                          return null;
                        },
                        onTap: (){

                        },
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        controller:upiController,
                        style:  TextStyle(
                            color: Colors.black87, fontSize: 16),
                        decoration: InputDecoration(
                            enabledBorder: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(15.0),
                              borderSide:  BorderSide(color:  Colors.grey.shade200 ),

                            ),
                            focusedBorder: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(15.0),
                              borderSide:  BorderSide(color:  Colors.cyan.shade700 ),

                            ),
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey.shade500,fontSize: 14),
                            hintText: "Upi link",
                            fillColor: Colors.grey.shade200),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter UPI link';
                          }
                          return null;
                        },
                        onTap: (){

                        },
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        controller:telegramController,
                        style:  TextStyle(
                            color: Colors.black87, fontSize: 16),
                        decoration: InputDecoration(
                            enabledBorder: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(15.0),
                              borderSide:  BorderSide(color:  Colors.grey.shade200 ),

                            ),
                            focusedBorder: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(15.0),
                              borderSide:  BorderSide(color:  Colors.cyan.shade700 ),

                            ),
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey.shade500,fontSize: 14),
                            hintText: "Type telegram",
                            fillColor: Colors.grey.shade200),
                        onTap: (){

                        },
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        controller:zoomLinkController,
                        style:  TextStyle(
                            color: Colors.black87, fontSize: 16),
                        decoration: InputDecoration(
                            enabledBorder: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(15.0),
                              borderSide:  BorderSide(color:  Colors.grey.shade200 ),

                            ),
                            focusedBorder: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(15.0),
                              borderSide:  BorderSide(color:  Colors.cyan.shade700 ),

                            ),
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey.shade500,fontSize: 14),
                            hintText: "Type Zoom Link",
                            fillColor: Colors.grey.shade200),
                        onTap: (){

                        },
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        controller:webLinkController ,
                        style:  TextStyle(
                            color: Colors.black87, fontSize: 16),
                        decoration: InputDecoration(
                            enabledBorder: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(15.0),
                              borderSide:  BorderSide(color:  Colors.grey.shade200 ),

                            ),
                            focusedBorder: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(15.0),
                              borderSide:  BorderSide(color:  Colors.cyan.shade700 ),

                            ),
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey.shade500,fontSize: 14),
                            hintText: "Type your web address",
                            fillColor: Colors.grey.shade200),
                        onTap: (){

                        },
                      ),
                      SizedBox(height: 20,),
                      cf1Controller.text.isNotEmpty?
                      Container(
                        child: Column(
                          children: [
                            TextFormField(
                              controller:cf1Controller ,
                              style:  TextStyle(
                                  color: Colors.black87, fontSize: 16),
                              decoration: InputDecoration(
                                  enabledBorder: new OutlineInputBorder(
                                    borderRadius: new BorderRadius.circular(15.0),
                                    borderSide:  BorderSide(color:  Colors.grey.shade200 ),

                                  ),
                                  focusedBorder: new OutlineInputBorder(
                                    borderRadius: new BorderRadius.circular(15.0),
                                    borderSide:  BorderSide(color:  Colors.cyan.shade700 ),

                                  ),
                                  filled: true,
                                  hintStyle: TextStyle(color: Colors.grey.shade500,fontSize: 14),
                                  hintText: "Type your web address",
                                  fillColor: Colors.grey.shade200),
                              readOnly: true,
                            ),
                            SizedBox(height: 15,)
                          ],
                        ),
                      ) :Container(),
                      cf2Controller.text.isNotEmpty?
                      Container(
                        child: Column(
                          children: [
                            TextFormField(
                              controller:cf2Controller ,
                              style:  TextStyle(
                                  color: Colors.black87, fontSize: 16),
                              decoration: InputDecoration(
                                  enabledBorder: new OutlineInputBorder(
                                    borderRadius: new BorderRadius.circular(15.0),
                                    borderSide:  BorderSide(color:  Colors.grey.shade200 ),

                                  ),
                                  focusedBorder: new OutlineInputBorder(
                                    borderRadius: new BorderRadius.circular(15.0),
                                    borderSide:  BorderSide(color:  Colors.cyan.shade700 ),

                                  ),
                                  filled: true,
                                  hintStyle: TextStyle(color: Colors.grey.shade500,fontSize: 14),
                                  hintText: "Type your web address",
                                  fillColor: Colors.grey.shade200),
                              readOnly: true,
                            ),
                            SizedBox(height: 15,)
                          ],
                        ),
                      ) :Container(),
                      cf3Controller.text.isNotEmpty?
                      Container(
                        child: Column(
                          children: [
                            TextFormField(
                              controller:cf3Controller ,
                              style:  TextStyle(
                                  color: Colors.black87, fontSize: 16),
                              decoration: InputDecoration(
                                  enabledBorder: new OutlineInputBorder(
                                    borderRadius: new BorderRadius.circular(15.0),
                                    borderSide:  BorderSide(color:  Colors.grey.shade200 ),

                                  ),
                                  focusedBorder: new OutlineInputBorder(
                                    borderRadius: new BorderRadius.circular(15.0),
                                    borderSide:  BorderSide(color:  Colors.cyan.shade700 ),

                                  ),
                                  filled: true,
                                  hintStyle: TextStyle(color: Colors.grey.shade500,fontSize: 14),
                                  hintText: "Type your web address",
                                  fillColor: Colors.grey.shade200),
                              readOnly: true,
                            ),
                            SizedBox(height: 15,)
                          ],
                        ),
                      ) :Container(),
                      cf3Controller.text.isEmpty?
                      TextButton(onPressed: (){
                        setState((){
                          addCustomField();
                        });
                      },
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Constants.appButtonColor),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      side: BorderSide(color:Constants.appButtonColor)
                                  )
                              ),
                              padding: MaterialStateProperty.all(EdgeInsets.only(top: 15,bottom: 15,left: 20,right: 20))
                          ),
                          child: Text('Add Custom Fields',style: TextStyle(color: Colors.white),)
                      ):Container(),
                      SizedBox(height: 20,),
                      saving?Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                          child:Center(child: CircularProgressIndicator(),)):
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                            child:TextButton(onPressed: (){
                              sheetState((){
                                saving=true;
                              });
                              ServiceModel model=ServiceModel(userId!,serviceNameController.text,selectedCategory,'draft', serviceDescriptionController.text,servicePriceController.text,
                                  startTimeController.text, endTimeController.text, startDayController.text, endDayController.text,
                                  countryValue,stateValue,cityValue,pinCodeController.text,lat.toString(),long.toString(),emailController.text,
                                  upiController.text,watsAppController.text
                                  ,telegramController.text,zoomLinkController.text,webLinkController.text,0,0,customFileds);
                              addService(model);
                            },
                                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Constants.appButtonColor),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15.0),
                                            side: BorderSide(color: Constants.appButtonColor)
                                        )
                                    ),
                                    padding: MaterialStateProperty.all(EdgeInsets.only(top: 20,bottom: 20))
                                ),
                                child: Text('CREATE NOW',style: TextStyle(color: Colors.white),)
                            )),
                      ),
                      SizedBox(height: 20,)
                    ],
                  )
              )));
      })
    );
  }

}