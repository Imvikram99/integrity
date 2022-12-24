import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:integrity/constants.dart';
import 'package:integrity/views/reviewer/reviewer_home_page.dart';
import 'package:integrity/views/service_provider/service_home_page.dart';


class ProviderEditProfile extends StatefulWidget {
  ProviderEditProfile({Key? key}) : super(key: key);

  @override
  State<ProviderEditProfile> createState() => ProviderEditProfileState();
}

class ProviderEditProfileState extends State<ProviderEditProfile> {
  late String userId;
  FirebaseFirestore firestore=FirebaseFirestore.instance;
  TextEditingController nameController=TextEditingController();
  TextEditingController ageController=TextEditingController();

  late String dropdownvalue;

  var items = ['select Gender','Male', 'Female',];

  @override
  void initState() {
    super.initState();
    userId=Get.arguments[0];
    nameController.text=Get.arguments[1];
    ageController.text=Get.arguments[2];
    dropdownvalue=Get.arguments[3];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Profile'),
          centerTitle: true,
          backgroundColor: Constants.appButtonColor,
        ),
        body: Container(
                margin: EdgeInsets.only(left: 15,right: 15,top: 20),
                height: MediaQuery.of(context).size.height,
                child:Column(
                  children: [
                    TextFormField(
                      controller:nameController ,
                      style:  TextStyle(color: Colors.black87, fontSize: 16),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'name can not be empty';
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
                          hintStyle: TextStyle(color: Colors.grey.shade500,fontSize: 14,fontStyle: FontStyle.italic),
                          hintText: "Name",
                          fillColor: Colors.grey.shade200),
                      onTap: (){

                      },
                    ),
                    SizedBox(height: 10,),
                    TextFormField(
                      controller: ageController,
                      style:  TextStyle(color: Colors.black87, fontSize: 16),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter age';
                        }
                        return null;
                      },
                      keyboardType:TextInputType.number ,
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
                          hintStyle: TextStyle(color: Colors.grey.shade500,fontSize: 14,fontStyle: FontStyle.italic),
                          hintText: "age",
                          fillColor: Colors.grey.shade200),
                      onTap: (){

                      },
                    ),
                    SizedBox(height: 10,),
                    DropdownButtonFormField(
                      value: dropdownvalue,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: items.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownvalue = newValue!;
                        });
                      },
                      decoration:InputDecoration(
                          enabledBorder: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(15.0),
                            borderSide:  BorderSide(color:  Colors.grey.shade200 ),
                          ),
                          focusedBorder: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(15.0),
                            borderSide:  BorderSide(color:  Colors.cyan.shade700 ),
                          ),
                          filled: true,
                          hintStyle: TextStyle(color: Colors.grey.shade500,fontSize: 14,fontStyle: FontStyle.italic),
                          hintText: "age",
                          fillColor: Colors.grey.shade200) ,
                    ),
                    SizedBox(height: 15,),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                          padding: EdgeInsets.only(bottom:20),
                          child:TextButton(
                              onPressed: (){
                                firestore.collection('users').doc(userId).update(
                                    {
                                      'userName':nameController.text,
                                      'userAge':ageController.text,
                                      'userGender':dropdownvalue
                                    }).whenComplete(() => {
                                  Fluttertoast.showToast(
                                    msg: 'profile data updated',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                  ),
                                  Get.offAll(Provider_Home_Page())
                                });
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
                              child: Text('Update',style: TextStyle(color: Colors.white),)
                          )),
                    ),
                  ],
                ) ,
              )
    );
  }
}