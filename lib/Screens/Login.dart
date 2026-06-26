import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:project/APIHandler/api.dart';
import 'package:project/Global/AdminGlobal.dart';
import 'package:project/Global/DirectorGlobal.dart';
import 'package:project/Global/GuardGlobal.dart';
import 'package:project/Global/MonitorGlobal.dart';
import 'package:project/Screens/Admin.dart';
import 'package:project/Screens/Guard.dart';
import 'package:project/Screens/Monitor.dart';
import 'package:http/http.dart' as http;
import 'package:project/Screens/MonitorDashBoard.dart';
import 'package:project/Tasks/DirectorDashBoard.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}
// 
class _LoginState extends State<Login> {
  TextEditingController controller_userName=TextEditingController();
  TextEditingController controller_password=TextEditingController();
  bool isObscure=true;
  int? duty_location;
  List<dynamic> dutyLocationCameraData=[];
  int? dutyLocationCameraId;
  String dutyLocationCameraName='';

  void getCameraByLocation(int locationId) async {
    // final String apiUrl = 'http://localhost:5000'; // Replace with your actual API endpoint

    try {
      final response = await http.get(Uri.parse('${APIHandler.ip}/GetCameraByLocation/$locationId'));

      if (response.statusCode == 200) {
        // If server returns an OK response, parse the JSON
        dutyLocationCameraData = json.decode(response.body);
        // Process the data as needed
        print(dutyLocationCameraData);
      } else {
        // If the server did not return a 200 OK response,
        // throw an exception.
        throw Exception('Failed to load data');
      }
    } catch (e) {
      // Handle errors
      print('Error: $e');
    }
  }

  Future<void> checkLogin() async {
    String username = controller_userName.text;
    String password = controller_password.text;

    if (username.isEmpty || password.isEmpty) {
      print('NO selected');
      return ;
    }
    try{
      print(username+password);
      var response=await APIHandler.checkLogin(username, password);
      print(response);
      if (response != null) {
        print('Data submitted successfully');
        print(response);
        if (response.isNotEmpty) {
          var responseData = response[0];
          String userRole = responseData['role'];
          String name=responseData['username'];
          int userId = responseData['id'];
          duty_location=responseData['duty_location'];
          getCameraByLocation(duty_location ?? 0);
          print(dutyLocationCameraData);
          
          if (userRole == 'Admin') {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Login Successful'),
                  content: Text('You are now logged in as ${responseData['username']} And Role of that person is ${responseData['role']}'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          AdminGlobal.adminGlobal = name;
                          AdminGlobal.adminGlobalId=userId;
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context){
                              return Admin();
                            })
                          );
                        });
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          } 
          else if(userRole == 'Guard'){
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Login Successful'),
                  content: Text('You are now logged in as ${responseData['username']} And Role of that person is ${responseData['role']}'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          if (dutyLocationCameraData.isNotEmpty) {
                            dutyLocationCameraId = dutyLocationCameraData[0]['camera_id'];
                            dutyLocationCameraName = dutyLocationCameraData[0]['camera_name'];
                            setState(() {
                              
                            });
                          }
                          print(dutyLocationCameraId);
                          print(dutyLocationCameraName);
                          GuardGlobal.guardGlobal = name;
                          GuardGlobal.guardGlobalId=userId;
                          GuardGlobal.guardGlobalDutyLocation=duty_location;
                          GuardGlobal.guardGlobalDutyLocationCameraId=dutyLocationCameraId;
                          GuardGlobal.guardGlobalDutyLocationCameraName=dutyLocationCameraName;
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context){
                              return GuardScreen();
                            })
                          );
                        });
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
          else if(userRole == 'Director'){
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Login Successful'),
                  content: Text('You are now logged in as ${responseData['username']} And Role of that person is ${responseData['role']}'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          DirectorGlobal.directorGlobal = name;
                          DirectorGlobal.directorGlobalId=userId;
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context){
                              return DirectorDashBoardScreen();
                            })
                          );
                        });
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
          else{
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Login Successful'),
                  content: Text('You are now logged in as ${responseData['username']} And Role of that person is ${responseData['role']}'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          // AdminGlobal(name);
                          MonitorGlobal.monitorGlobal = name;
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context){
                              return MonitorDashBoardScreen();
                            })
                          );
                          // Navigator.of(context).pushReplacement(
                          //   MaterialPageRoute(builder: (context){
                          //     return MonitorScreen();
                          //   })
                          // );
                        });
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        }
        else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Login Failed'),
                content: Text('Invalid username or password. Please try again.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      }
    }catch (e) {
      print('Error submitting form: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 30,),
                Container(
                  height: 130,
                  width: 130,
                  child: Image.asset('asset/images/logo.png',fit: BoxFit.fill,),
                ),
                SizedBox(height: 40,),
                Container(
                  height: 30,
                  width: double.infinity,
                  child: Text('Welcome',style: TextStyle(fontSize: 30,color: Colors.blue),)
                ),
                SizedBox(height: 5,),
                Container(
                  height: 30,
                  width: double.infinity,
                  child: Text('Back!',style: TextStyle(fontSize: 30,color: Colors.blue),)
                ),
                SizedBox(height: 30,),
                TextFormField(
                  controller: controller_userName,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    hintText: 'User Name',
                    labelText: 'User Name',
                    prefixIcon: Icon(Icons.person,size: 30,),
                  ),
                ),
                SizedBox(height: 20,),
                TextFormField(
                  controller: controller_password,
                  style: TextStyle(fontSize: 20),
                  obscureText: isObscure,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock,size: 30,),
                    suffixIcon: IconButton(
                      onPressed: (){
                        isObscure=!isObscure;
                        setState(() {
                          
                        });
                      }, 
                      icon: isObscure?Icon(Icons.visibility):Icon(Icons.visibility_off)
                    ),
                  ),
                ),
                SizedBox(height: 50,),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      checkLogin();
                    });
                  },
                  // onTap: (){
                  //   Navigator.of(context).pushReplacement(
                  //     MaterialPageRoute(builder: (context){
                  //       return ;
                  //     })
                  //   );
                  // },
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
                        child: Text('Login',style: TextStyle(fontSize: 20,color: Colors.white),),
                      ),
                    ),
                  )
                ),
                SizedBox(height: 30,),
                GestureDetector(
                  
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Text('Forgot your password?',style: TextStyle(fontSize: 20, color: Colors.blue),),
                  )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}