import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'Admin.dart';
import 'Login.dart';

class StartingScreen extends StatelessWidget {
  const StartingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 170,
                width: 170,
                child: Image.asset('asset/images/logo.png',fit: BoxFit.fill,),
              ),
              SizedBox(height: 50,),
              Container(
                height: 50,
                width: 430,
                child: Text('Visitor Tracking System',style: TextStyle(fontSize: 30,color: Colors.blue,fontWeight: FontWeight.w900),textAlign: TextAlign.center),
              ),
              SizedBox(height: 20,),
              Container(
                height: 60,
                width: 400,
                child: Text('Smart tracking for safer and efficient university visits',style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.w400),textAlign: TextAlign.center,),
              ),
              SizedBox(height: 70,),
              GestureDetector(
                onTap: (){
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context){
                      // return Login();
                      return const Login();
                    })
                  );
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    height: 50,
                    width: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.blue,
                    ),
                    child: Center(
                      child: Text('Get Started',style: TextStyle(fontSize: 20,color: Colors.white),),
                    ),
                  ),
                )
              )
            ]
          ),
        ),
      ),
    );
  }
}