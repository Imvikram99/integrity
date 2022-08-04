import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:integrity/screens/reviewer/auth.dart';


class First_page extends StatefulWidget {
  First_page({Key? key}) : super(key: key);

  @override
  State<First_page> createState() => _First_pageState();
}

class _First_pageState extends State<First_page> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        
        body: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height*0.3,
                    width: MediaQuery.of(context).size.width*0.6,
                    child: Image.asset("assets/images/logo.png")),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30,horizontal: 30),
                child: Container(
                  
                  child: Column(
                    children:  [
                     Text("I am a...",style: TextStyle(
                      fontSize: 30,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w700
                     ),),
                     SizedBox(
                      height: 30,
                     ),
                     Container(
                 
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.all(Radius.circular(10)),
                           color: Colors.blueAccent,
                     ),
                     width: MediaQuery.of(context).size.width*0.7,
                     height: 60,
                       child: TextButton(
                        
                        onPressed: (){
                           Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Register()),
                            );
                        }, child: Text("REVIEWER",style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white
                        ),)),
                     ),
                     SizedBox(
                      height: 20,
                     ),
                     Container(
                      decoration: BoxDecoration(
                       borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.green[900],
                     ),
                     
                      width: MediaQuery.of(context).size.width*0.7,
                      height: 60,
                      child: TextButton(onPressed: (){}, child: Text("SERVICE PROVIDER",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white
                      ),
                      )))   
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}