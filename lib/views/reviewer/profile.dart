import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:integrity/constants.dart';
import 'package:integrity/views/reviewer/edit_profile.dart';
import 'package:integrity/views/service_provider/edit_profile.dart';


class ReviewerProfile extends StatefulWidget {
  ReviewerProfile({Key? key}) : super(key: key);

  @override
  State<ReviewerProfile> createState() => ReviewerProfileState();
}

class ReviewerProfileState extends State<ReviewerProfile> {
  late String userId;
  FirebaseFirestore firestore=FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    userId=Get.arguments;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My Profile'),
          centerTitle: true,
          backgroundColor: Constants.appButtonColor,
        ),
        body:StreamBuilder(
            stream: firestore.collection('users').where('userid', isEqualTo: userId).snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Container(
                margin: EdgeInsets.only(left: 15,right: 15,top: 20),
                child:Column(
                  children: [
                    TextFormField(
                      initialValue: snapshot.data!.docs.first['phone'],
                      readOnly: true,
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
                          hintText: "",
                          fillColor: Colors.grey.shade200),
                      onTap: (){

                      },
                    ),
                    SizedBox(height: 10,),
                    TextFormField(
                      initialValue: snapshot.data!.docs.first['userName'] ,
                      readOnly: true,
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
                          hintStyle: TextStyle(color: Colors.grey.shade500,fontSize: 14,fontStyle: FontStyle.italic),
                          hintText: "Name",
                          fillColor: Colors.grey.shade200),
                      onTap: (){

                      },
                    ),
                    SizedBox(height: 10,),
                    TextFormField(
                      initialValue: snapshot.data!.docs.first['userAge'],
                      readOnly: true,
                      style:  TextStyle(color: Colors.black87, fontSize: 16),
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
                    TextFormField(
                      initialValue: snapshot.data!.docs.first['userGender'],
                      readOnly: true,
                      style:  TextStyle(color: Colors.black87, fontSize: 16),
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
                    SizedBox(height: 15,),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                          child:TextButton(
                              onPressed: (){
                                Get.to(()=>ReviewerEditProfile(),arguments: [snapshot.data!.docs.first.id,snapshot.data!.docs.first['userName'],snapshot.data!.docs.first['userAge'],
                                  snapshot.data!.docs.first['userGender'] ]);
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
                              child: Text('Edit Profile',style: TextStyle(color: Colors.white),)
                          )),
                    ),
                  ],
                ) ,
              );
            })
    );
  }

}