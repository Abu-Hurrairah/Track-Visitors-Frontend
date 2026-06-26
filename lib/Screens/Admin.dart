import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:project/CommonUtils.dart/LogoutConfirmationDialog.dart';
import 'package:project/Global/AdminGlobal.dart';
import 'package:project/Screens/AddCamera.dart';
import 'package:project/Screens/AddDestination.dart';
import 'package:project/Screens/BlockVisitor.dart';
import 'package:project/Screens/CameraConnection.dart';
import 'package:project/Screens/CameraCost.dart';
import 'package:project/Screens/CurrentVisitors.dart';
import 'package:project/Screens/Floors.dart';
import 'package:project/Screens/GuardDuty.dart';
import 'package:project/Screens/Locations.dart';
import 'package:project/Screens/Login.dart';
import 'package:project/Screens/Paths.dart';
import 'package:project/Screens/Settings.dart';
import 'package:project/Screens/Users.dart';
import 'package:project/Screens/VisitorReport.dart';

import 'AddGuard.dart';

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  String adminName = AdminGlobal.adminGlobal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('')),
      body: SingleChildScrollView(
        // child: Column(
        //   children: [
        //     Container(
        //       decoration: BoxDecoration(
        //           color: Color(0xFF41A8C7),
        //           borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5),bottomRight: Radius.circular(5)),
        //       ),
        //       child: Column(
        //         // crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           SizedBox(height: 40,),
        //           Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             children: [
        //               Text('   Welcome, ${adminName}',style: TextStyle(fontSize: 30,color: Colors.white),),
        //               IconButton(
        //                 onPressed: (){
        //                   Navigator.of(context).pushReplacement(
        //                     MaterialPageRoute(builder: (context){
        //                       return SettingsScreen();
        //                     })
        //                   );
        //                 }, 
        //                 icon: Icon(Icons.settings,color: Colors.white,size: 30,)
        //               )
        //             ],
        //           ),
        //           // SizedBox(height: 5,),
        //           Align(
        //             alignment: Alignment.centerLeft, // Align text to the start
        //             child: Text('     Admin', style: TextStyle(fontSize: 20, color: Colors.white)),
        //           ),
        //           SizedBox(height: 30,),
        //         ],
        //       ),
        //     ),
        child:
            Padding(
              padding: EdgeInsets.all(25.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10,),
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
                    Text('Welcome, ${adminName}',style: TextStyle(fontSize: 30,color: Colors.blue),),
                    SizedBox(height: 5,),
                    Text('Admin',style: TextStyle(fontSize: 20,color: Colors.blue),),
                    SizedBox(height: 30,),
                    Row(
                      children: [
                        // GestureDetector(
                        //   onTap: (){
                        //     Navigator.of(context).push(
                        //       MaterialPageRoute(builder: (context){
                        //         return const AddGuard();
                        //       })
                        //     );
                        //   },
                        //   child: MouseRegion(
                        //     cursor: SystemMouseCursors.click,
                        //     child: Container(
                        //       height: 180,
                        //       width: 180,
                        //       decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(10),
                        //         color: Color.fromARGB(255, 126, 214, 255),
                        //       ),
                        //       child: Column(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           Icon(IconData(0xe050, fontFamily: 'MaterialIcons',),size: 60,color: Colors.white,),
                        //           SizedBox(height: 15,),
                        //           Text('Add Guard',style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),)
                        //         ]
                        //       ),
                        //     ),
                        //   )
                        // ),
                        GestureDetector(
                          onTap: (){
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context){
                                return const UsersScreen();
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
                                  Icon(Icons.person_outline,size: 60,color: Colors.white,),
                                  SizedBox(height: 15,),
                                  Text('Users',style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),)
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
                                return Floors();
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
                                  Text('Floors',style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),)
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
                        // GestureDetector(
                        //   onTap: (){
                        //     Navigator.of(context).push(
                        //       MaterialPageRoute(builder: (context){
                        //         return AddDestination();
                        //       })
                        //     );
                        //   },
                        //   child: MouseRegion(
                        //     cursor: SystemMouseCursors.click,
                        //     child: Container(
                        //       height: 180,
                        //       width: 180,
                        //       decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(10),
                        //         color: Color.fromARGB(255, 126, 214, 255),
                        //       ),
                        //       child: Column(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           Icon(IconData(0xe752, fontFamily: 'MaterialIcons'),size: 60,color: Colors.white,),
                        //           SizedBox(height: 15,),
                        //           Text('Add Destination',style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),)
                        //         ]
                        //       ),
                        //     ),
                        //   )
                        // ),
                        GestureDetector(
                          onTap: (){
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context){
                                return LocationScreen();
                              })
                            );
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(builder: (context){
                            //     return AddDestination();
                            //   })
                            // );
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
                                  Text('Locations',style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),)
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
                                return AddCamera();
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
                                  Icon(Icons.camera_alt_outlined,size: 60,color: Colors.white,),
                                  SizedBox(height: 15,),
                                  Text('Cameras',style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),)
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
                        // GestureDetector(
                        //   onTap: () {
                        //     Navigator.of(context).push(
                        //       MaterialPageRoute(builder: (context){
                        //         return AddCamera();
                        //       })
                        //     );
                        //   },
                        //   child: MouseRegion(
                        //     cursor: SystemMouseCursors.click,
                        //     child: Container(
                        //       height: 180,
                        //       width: 180,
                        //       decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(10),
                        //         color: Color.fromARGB(255, 126, 214, 255),
                        //       ),
                        //       child: Column(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           Icon(IconData(0xe048, fontFamily: 'MaterialIcons'),size: 60,color: Colors.white,),
                        //           SizedBox(height: 15,),
                        //           Text('Add Camera',style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),)
                        //         ]
                        //       ),
                        //     ),
                        //   )
                        // ),
                        
                        
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context){
                                return CameraConnectionScreen();
                              })
                            );
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(builder: (context){
                            //     return CameraCostScreen();
                            //   })
                            // );
                          },
                          child: MouseRegion(
                            cursor: MaterialStateMouseCursor.clickable,
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
                                    child: Image.asset('asset/images/cameracosticon.png',fit: BoxFit.fill,),
                                  ),
                                  SizedBox(height: 15,),
                                  Text('Camera Connections',style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),textAlign: TextAlign.center,)
                                ]
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20,),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context){
                                return CurrentVisitorsScreen(sourceScreen: 'Admin');
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
                      ],
                    ),
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        // GestureDetector(
                        //   onTap: (){
                        //     Navigator.of(context).push(
                        //       MaterialPageRoute(builder: (context){
                        //         return AddDestination();
                        //       })
                        //     );
                        //   },
                        //   child: MouseRegion(
                        //     cursor: SystemMouseCursors.click,
                        //     child: Container(
                        //       height: 180,
                        //       width: 180,
                        //       decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(10),
                        //         color: Color.fromARGB(255, 126, 214, 255),
                        //       ),
                        //       child: Column(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           Icon(IconData(0xe752, fontFamily: 'MaterialIcons'),size: 60,color: Colors.white,),
                        //           SizedBox(height: 15,),
                        //           Text('Add Destination',style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),)
                        //         ]
                        //       ),
                        //     ),
                        //   )
                        // ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context){
                                return GuardDutyScreen();
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
                                  Icon(Icons.groups_3,size: 60,color: Colors.white,),
                                  // Container(
                                  //   height: 60,
                                  //   width: 60,
                                  //   child: Image.asset('asset/images/reporticon.png',fit: BoxFit.fill,),
                                  // ),
                                  SizedBox(height: 15,),
                                  Text('Guards  Location',style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),textAlign: TextAlign.center,)
                                ]
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20,),
                        GestureDetector(
                          onTap: (){
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context){
                                return BlockVisitorScreen();
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
                                  Icon(Icons.error_outline,size: 60,color: Colors.white,),
                                  SizedBox(height: 15,),
                                  Text('Block Visitors',style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),)
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
                          onTap: (){
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context){
                                return VisitorReportScreen();
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
                                    child: Image.asset('asset/images/reporticon.png',fit: BoxFit.fill,),
                                  ),
                                  SizedBox(height: 15,),
                                  Text('Report',style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),)
                                ]
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20,),
                        GestureDetector(
                          onTap: (){
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context){
                                return PathsScreen();
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
                                  Icon(Icons.route,size: 60,color: Colors.white,),
                                  SizedBox(height: 15,),
                                  Text('Paths',style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),)
                                ]
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]
                ),
              ),
            ),
          // ],
        ),
      // ),
    );
  }
}