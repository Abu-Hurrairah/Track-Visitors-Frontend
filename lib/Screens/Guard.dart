import 'package:flutter/material.dart';
import 'package:project/Global/GuardGlobal.dart';
import 'package:project/Screens/AddNewVisit.dart';
import 'package:project/Screens/AddVisitor.dart';
import 'package:project/Screens/AllAlerts.dart';
import 'package:project/Screens/CurrentVisitors.dart';
import 'package:project/Screens/EndVisit.dart';
import 'package:project/Screens/ExitVisitor.dart';
import 'package:project/Screens/Login.dart';
import 'package:project/Screens/Settings.dart';
import 'package:project/Screens/VisitorReport.dart';
import 'package:project/Tasks/NewVisitorMode.dart';
import 'package:project/Tasks/VisitorMode.dart';

class GuardScreen extends StatefulWidget {
  const GuardScreen({super.key});

  @override
  State<GuardScreen> createState() => _GuardScreenState();
}

class _GuardScreenState extends State<GuardScreen> {
  String guardName = GuardGlobal.guardGlobal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Color(0xFF41A8C7),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5),bottomRight: Radius.circular(5)),
              ),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('   Welcome, ${guardName}',style: TextStyle(fontSize: 30,color: Colors.white),),
                      IconButton(
                        onPressed: (){
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context){
                              return SettingsScreen();
                            })
                          );
                        }, 
                        icon: Icon(Icons.settings,color: Colors.white,size: 30,)
                      )
                    ],
                  ),
                  // SizedBox(height: 5,),
                  Align(
                    alignment: Alignment.centerLeft, // Align text to the start
                    child: Text('     Guard', style: TextStyle(fontSize: 20, color: Colors.white)),
                  ),
                  SizedBox(height: 30,),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(25.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SizedBox(height: 20,),
                    // GestureDetector(
                    //   onTap: () {
                    //     setState(() {
                    //       Navigator.of(context).pushReplacement(
                    //         MaterialPageRoute(builder: (context){
                    //           return Login();
                    //         })
                    //       );
                    //     });
                    //   },
                    //   child: MouseRegion(
                    //     cursor: SystemMouseCursors.click,
                    //     child: Container(
                    //       height: 25,
                    //       width: double.infinity,
                    //       child: Text('Logout',style: TextStyle(fontSize: 20,color: Colors.blue),textAlign: TextAlign.right,)
                    //     ),
                    //   )
                    // ),
                    // SizedBox(height: 15,),
                    // Text('Welcome, ${guardName}',style: TextStyle(fontSize: 30,color: Colors.blue),),
                    // SizedBox(height: 5,),
                    // Text('Guard',style: TextStyle(fontSize: 20,color: Colors.blue),),
                    // // SizedBox(height: 30,),
                    // // Container(
                    // //   height: 150,
                    // //   // width: 150,
                    // //   child: Center(child: Text('No Alert Found')),
                    // // ),
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: (){
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context){
                                return const AddVisitorScreen();
                              })
                            );
                          },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Container(
                              height: 170,
                              width: 170,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color.fromARGB(255, 126, 214, 255),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_circle_outline,size: 60,color: Colors.white,),
                                  SizedBox(height: 15,),
                                  Text('Add Visitor',style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),)
                                ]
                              ),
                            ),
                          )
                        ),
                        SizedBox(width: 20,),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context){
                                return AddNewVisitScreen();
                              })
                            );
                          },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Container(
                              height: 170,
                              width: 170,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color.fromARGB(255, 126, 214, 255),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.location_pin,size: 60,color: Colors.white,),
                                  SizedBox(height: 15,),
                                  Text('New Visit',style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),)
                                ]
                              ),
                            ),
                          )
                        ),
                      ],
                    ),
                    //     GestureDetector(
                    //       onTap: () {
                    //         Navigator.of(context).push(
                    //           MaterialPageRoute(builder: (context){
                    //             return VisitorReportScreen();
                    //           })
                    //         );
                    //       },
                    //       child: MouseRegion(
                    //         cursor: SystemMouseCursors.click,
                    //         child: Container(
                    //           height: 150,
                    //           width: 150,
                    //           decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(10),
                    //             color: Color.fromARGB(255, 126, 214, 255),
                    //           ),
                    //           child: Column(
                    //             mainAxisAlignment: MainAxisAlignment.center,
                    //             children: [
                    //               Container(
                    //                 height: 60,
                    //                 width: 60,
                    //                 child: Image.asset('asset/images/searchlisticon.png',fit: BoxFit.fill,)
                    //               ),
                    //               SizedBox(height: 15,),
                    //               Text('Visitor Info',style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),)
                    //             ]
                    //           ),
                    //         ),
                    //       )
                    //     ),
                    //   ],
                    // ),
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: (){
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context){
                                return AllAlertsScreen();
                              })
                            );
                          },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Container(
                              height: 170,
                              width: 170,
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
                          onTap: (){
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context){
                                return EndVisitScreen();
                              })
                            );
                          },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Container(
                              height: 170,
                              width: 170,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color.fromARGB(255, 126, 214, 255),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.output_outlined,size: 60,color: Colors.white,),
                                  SizedBox(height: 15,),
                                  // Text('Exit Visitor',style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),)
                                  Text('End Visit',style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),)
                                ]
                              ),
                            ),
                          )
                        ),
                        
                      ],
                    ),
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context){
                                return CurrentVisitorsScreen(sourceScreen: 'Guard');
                              })
                            );
                          },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Container(
                              height: 170,
                              width: 170,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color.fromARGB(255, 126, 214, 255),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 60,
                                    width: 60,
                                    child: Image.asset('asset/images/searchlisticon.png',fit: BoxFit.fill,)
                                  ),
                                  SizedBox(height: 15,),
                                  Text('Current Visitors',style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),)
                                ]
                              ),
                            ),
                          )
                        ),
                        SizedBox(width: 20,),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context){
                                return NewVisitorModeScreen();
                              })
                            );
                          },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Container(
                              height: 170,
                              width: 170,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color.fromARGB(255, 126, 214, 255),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.person,size: 60,color: Colors.white,),
                                  SizedBox(height: 15,),
                                  Text('Visitors Mode',style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),)
                                ]
                              ),
                            ),
                          )
                        ),
                      ],
                    ),
                    // SizedBox(height: 10,),
                    // Text('${DateTime.now().toString().substring(0,10)}')
                    
                  ],
                )
              )
            ),
          ],
        ),
      )
    );
  }
}