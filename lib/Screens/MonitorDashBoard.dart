import 'package:flutter/material.dart';
import 'package:project/CommonUtils.dart/LogoutConfirmationDialog.dart';
import 'package:project/Global/MonitorGlobal.dart';
import 'package:project/Screens/AllAlerts.dart';
import 'package:project/Screens/Monitor.dart';

class MonitorDashBoardScreen extends StatefulWidget {
  const MonitorDashBoardScreen({super.key});

  @override
  State<MonitorDashBoardScreen> createState() => _MonitorDashBoardScreenState();
}

class _MonitorDashBoardScreenState extends State<MonitorDashBoardScreen> {

  String monitorName = MonitorGlobal.monitorGlobal;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20,),
            GestureDetector(
              onTap: () {
                setState(() {
                  showLogoutConfirmationDialog(context);
                  // Navigator.of(context).pushReplacement(
                  //   MaterialPageRoute(builder: (context){
                  //     return Login();
                  //   })
                  // );
                });
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Container(
                  height: 25,
                  width: double.infinity,
                  child: Text('Logout',style: TextStyle(fontSize: 20,color: Colors.blue),textAlign: TextAlign.right,)
                ),
              )
            ),
            SizedBox(height: 15,),
            Text('Welcome, ${monitorName}',style: TextStyle(fontSize: 30,color: Colors.blue),),
            SizedBox(height: 5,),
            Text('Monitor',style: TextStyle(fontSize: 20,color: Colors.blue),),
            SizedBox(height: 30,),
            Padding(
              padding: EdgeInsets.all(25.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: (){
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context){
                                return const MonitorScreen();
                              })
                            );
                          },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color.fromARGB(255, 126, 214, 255),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.notifications,size: 60,color: Colors.white,),
                                  SizedBox(height: 15,),
                                  Text('Alerts',style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),)
                                ]
                              ),
                            ),
                          )
                        ),
                        SizedBox(width: 20,),
                        GestureDetector(
                          onTap: () {
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(builder: (context){
                            //     return AddNewVisitScreen();
                            //   })
                            // );
                          },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color.fromARGB(255, 126, 214, 255),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.route,size: 60,color: Colors.white,),
                                  SizedBox(height: 15,),
                                  Text('Route',style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),)
                                ]
                              ),
                            ),
                          )
                        ),
                      ],
                    ),
                  ]
                )
              )
            )
          ]
        )
      )
    );
  }
}