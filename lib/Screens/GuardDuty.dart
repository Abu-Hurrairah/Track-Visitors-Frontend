// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:project/Model/LocationModel.dart';
// import 'package:project/Model/UserModel.dart';
// import 'package:project/Screens/Admin.dart';
// import 'package:project/Screens/Login.dart';
// import 'package:http/http.dart' as http;

// class GuardDutyScreen extends StatefulWidget {
//   const GuardDutyScreen({super.key});

//   @override
//   State<GuardDutyScreen> createState() => _GuardDutyScreenState();
// }

// class _GuardDutyScreenState extends State<GuardDutyScreen> {
//   TextEditingController controller_searchUser=TextEditingController();
//   Set<String> locationTypes= {}; // Use a Set instead of List
//   String? selectedLocation;
//   User? selectedUser; // Variable to store the selected user.
//   String buttonState='Add';
//   // Use a Map to store button states for each user based on their unique ID
//   Map<int, String> buttonStates = {};
//   int? selectedUserId;

//   List<User> users = [];
//   Future <void> getUsers() async{
//     try{
//       var request = http.MultipartRequest('GET',Uri.parse('http://localhost:5000/GetAllUsers'),);
//       var response = await request.send();
//       if (response.statusCode == 200) {
//         final List<dynamic> jsonResponse = json.decode(await response.stream.bytesToString());
//         setState(() {
//           users = jsonResponse.map((json) => User.fromJson(json)).toList();

//           // Initialize button states in the map
//           for (var user in users) {
//             buttonStates[user.id!] = 'Edit';
//           }

//           // dropdownOptions = users.map((user) => user.name).toList();
//           // Filter locations with type "gate"
//           List<User> userGuard = users.where((user) => user.role == 'Guard').toList();
//           filteredUsers=userGuard;
//           print(jsonResponse);
//           print(filteredUsers);
//         });
//       }
//     }catch (e) {
//       print('Error submitting form: $e');
//     }
//   }

//    List<Location> locations = [];
//   Future <void> getLocations() async{
//     try{
//       var request = http.MultipartRequest('GET',Uri.parse('http://localhost:5000/GetAllLocations'),);
//       var response = await request.send();
//       if (response.statusCode == 200) {
//         final List<dynamic> jsonResponse = json.decode(await response.stream.bytesToString());
//         setState(() {
//           locations = jsonResponse.map((json) => Location.fromJson(json)).toList();
//           // dropdownOptions = locations.map((location) => location.floorName).toList();
//           // Clear the dropdownOptions Set
//           locationTypes.clear();

//           // Add unique floor names to dropdownOptions
//           for (var location in locations) {
//             locationTypes.add(location.type);
//           }
//           print(jsonResponse);
//         });
//       }
//     }catch (e) {
//       print('Error submitting form: $e');
//     }
//   }

//   List<User> filteredUsers = [];
//   void filterUsers(String query) {
//     // setState(() {
//     //   filteredUsers = users.where((user) =>
//     //       user.name.toLowerCase().contains(query.toLowerCase())).toList();
//     // });
//     setState(() {
//       if (query.isEmpty) {
//         // If the query is empty, display all users
//         filteredUsers = users.where((user) => user.role == "Guard").toList();
//       } else {
//         // Filter the users based on the query
//         filteredUsers = users.where((user) =>
//           user.role == "Guard" && user.name.toLowerCase().contains(query.toLowerCase())
//         ).toList();
//       }
//     });
//   }

//   Future<void> allocateDutyLocation(int id, int locationId) async {
//     try {
//       final String apiUrl = 'http://localhost:5000/AllocateDutyLocation'; // your actual API URL
//       final Map<String, dynamic> requestData = {
//         'location_id': locationId,
//       };

//       final http.Response response = await http.post(
//         Uri.parse('$apiUrl/your_endpoint/$id'), // your actual endpoint
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode(requestData),
//       );

//       if (response.statusCode == 200) {
//         print('Guard duty location updated successfully!');
//       } else {
//         print('Failed to update guard duty location. Status code: ${response.statusCode}');
//         print('Response body: ${response.body}');
//       }
//     } catch (e) {
//       print('Exception: $e');
//       // Handle exception as needed
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     getUsers();
//     getLocations();
//     // filteredUsers = List.from(users);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: EdgeInsets.all(20),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               SizedBox(height: 20,),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.of(context).pushReplacement(
//                         MaterialPageRoute(builder: (context){
//                           return Admin();
//                         })
//                       );
//                     },
//                     child: MouseRegion(
//                       cursor: SystemMouseCursors.click,
//                       child: Container(
//                         height: 30,
//                         width: 30,
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.blue,width: 2),
//                           shape: BoxShape.circle,
//                         ),
//                         child: Center(
//                           child: Icon(Icons.arrow_back,color: Colors.blue,)
//                         ),
//                       ),
//                     )
//                   ),
//                   // SizedBox(width: 800),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.of(context).pushReplacement(
//                         MaterialPageRoute(builder: (context){
//                           return Login();
//                         })
//                       );
//                     },
//                     child: MouseRegion(
//                       cursor: SystemMouseCursors.click,
//                       child: Container(
//                         height: 25,
//                         // width: 200,
//                         // width: double.infinity,
//                         child: Text('Logout',style: TextStyle(fontSize: 20,color: Colors.blue),textAlign: TextAlign.right,)
//                       ),
//                     )
//                   ),
//                 ],
//               ),
//               SizedBox(height: 10,),
//               Text('Guards Location',style: TextStyle(fontSize: 25,color: Colors.blue),),
//               SizedBox(height: 25,),
//               if (selectedUser != null) ...[
//                 Container(
//                   child: Column(
//                     // mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text('${selectedUser!.name}'),
//                           GestureDetector(
//                             onTap: () {
//                               User? selectedUserCopy = selectedUser;
//                               if (selectedUserCopy != null) {
//                                 // Set the button state to 'Edit' for the selected user
//                                 buttonStates[selectedUserCopy.id!] = 'Edit';
//                                 selectedUser = null;
//                                 setState(() {});
//                               }
//                               // setState(() {
//                               //   buttonState = 'Add';
//                               //   // Set the button state to 'Edit' when the close button is tapped
//                               //   buttonStates[user.id!] = 'Edit';
//                               //   selectedUser = null;
//                               // });
//                             },
//                             child: Icon(Icons.close),
//                           ),
//                         ],
//                       ),
//                       Text('${selectedUser!.username}'),
//                       SizedBox(height: 15,),
//                       Text('Duty Location: ${selectedUser!.role.isEmpty?selectedUser!.role:'Not Assigned'}'),
//                       SizedBox(height: 15,),
//                       // Dropdown for location selection
//                       DropdownButton<String>(
//                         hint: Text('Select Location',style: TextStyle(color: Colors.blue),),
//                         icon: Icon(Icons.arrow_drop_down,color: Colors.blue,),
//                         // icon: Icon(Icons.arrow_circle_down),
//                         // underline: Text('__________'),
//                         isExpanded: true,
//                         // enableFeedback: true,
//                         // dropdownColor: Colors.blue,
//                         // borderRadius: BorderRadius.circular(10),
//                         // menuMaxHeight: 60,
//                         value: selectedLocation,
//                         items: locationTypes.map((e) => DropdownMenuItem(
//                           child: Text(e),
//                           value: e,
//                         )).toList(), 
//                         onChanged: (String? value){
//                           setState(() {
//                             selectedLocation=value;
//                           });
//                         }
//                       ),
//                       SizedBox(height: 15,),
//                       // Save button
//                       GestureDetector(
//                         onTap: (){
//                           // allocateDutyLocation(selectedUserId!,);
//                           setState(() {
                            
//                           });
//                         },
//                         child: MouseRegion(
//                           cursor: SystemMouseCursors.click,
//                           child: Container(
//                             height: 50,
//                             width: 400,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(40),
//                               color: Colors.blue,
//                             ),
//                             child: Center(
//                               child: Text('Save',style: TextStyle(fontSize: 20,color: Colors.white),),
//                             ),
//                           ),
//                         )
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Text('Selected User Information', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                 // Text('Name: ${selectedUser!.name}'),
//                 // Text('Username: ${selectedUser!.username}'),
//                 // Text('Duty Location: ${selectedUser!.role}'),

//                 // // Dropdown for location selection
//                 // DropdownButton<String>(
//                 //   hint: Text('Location Floor',style: TextStyle(color: Colors.blue),),
//                 //   icon: Icon(Icons.arrow_drop_down,color: Colors.blue,),
//                 //   // icon: Icon(Icons.arrow_circle_down),
//                 //   // underline: Text('__________'),
//                 //   isExpanded: true,
//                 //   // enableFeedback: true,
//                 //   // dropdownColor: Colors.blue,
//                 //   // borderRadius: BorderRadius.circular(10),
//                 //   // menuMaxHeight: 60,
//                 //   value: selectedLocation,
//                 //   items: locationTypes.map((e) => DropdownMenuItem(
//                 //     child: Text(e),
//                 //     value: e,
//                 //   )).toList(), 
//                 //   onChanged: (String? value){
//                 //     setState(() {
//                 //       selectedLocation=value;
//                 //     });
//                 //   }
//                 // ),

//                 // // Save button
//                 // ElevatedButton(
//                 //   onPressed: () {
//                 //     // Implement save logic here to save changes to the selected user.
//                 //     // You can access selectedUser to get the updated information.
//                 //   },
//                 //   child: Text('Save'),
//                 // ),
//               ],
//               SizedBox(height: 30,),
//               Container(
//                 height: 50,
//                 width: 400,
//                 child: TextField(
//                   controller: controller_searchUser,
//                   decoration: InputDecoration(
//                     hintText: 'Search',
//                     hintStyle: TextStyle(color: Colors.blue),
//                     // Add a clear button to the search bar
//                     suffixIcon: IconButton(
//                       icon: Icon(Icons.clear,color: Colors.blue,),
//                       onPressed: () {
//                         controller_searchUser.clear();
//                         getUsers();
//                         setState(() {
                          
//                         });
//                       },
//                     ),
//                     // Add a search icon or button to the search bar
//                     prefixIcon: IconButton(
//                       icon: Icon(Icons.search,color: Colors.blue,),
//                       onPressed: () {
//                         // Perform the search here
//                         // searchUser(); // Call the searchUser method
//                       },
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderSide:
//                         BorderSide(width: 1, color: Colors.blue), //<-- SEE HERE
//                       borderRadius: BorderRadius.circular(30.0)
//                     ),
//                   ),
//                   onChanged: (query) {
//                     filterUsers(query);
//                   },
//                 ),
//               ),
//               SizedBox(height: 30,),
//               DataTable(
//                 columnSpacing: 20,
//                 columns: [
//                   // DataColumn(label: Text('ID',style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)),
//                   DataColumn(label: Text("Name",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)),
//                   DataColumn(label: Text("Username",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)),
//                   DataColumn(label: Text("Role",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),))
//                 ], 
//                 rows: filteredUsers.map((user) {
//                   return DataRow(
//                     cells: [
//                       // DataCell(Text(user.id.toString())), // Assuming id is an int, modify as needed
//                       DataCell(Text(user.name)),
//                       DataCell(Text(user.username)),
//                       DataCell(
//                         Row(
//                           children: [
//                             Text(user.role),
//                             SizedBox(width: 10),
//                             GestureDetector(
//                               onTap: (){
//                                 if (buttonStates[user.id] == 'Edit') {
//                                     buttonStates[user.id!] = 'Allot';
//                                     selectedUser = user;
//                                     // Store the selected user ID in a variable
//                                     selectedUserId = user.id;
//                                   } else {
//                                     buttonStates[user.id!] = 'Edit';
//                                     selectedUser = null;
//                                     // Reset the selected user ID
//                                     selectedUserId = null;
//                                   }
//                                 setState(() {
                                  
//                                 });
//                               },
//                               child: Container(
//                                 height: 38,
//                                 width: 50,
//                                 decoration: BoxDecoration(
//                                   color: buttonStates[user.id] == 'Edit' ? Color(0xFFFC5F70) : Colors.blue,
//                                   borderRadius: BorderRadius.circular(5)
//                                 ),
//                                 child: Center(
//                                   child: Text(buttonStates[user.id]!, style: TextStyle(color: Colors.white)),
//                                 ),
//                               ),
//                             ),
//                             // IconButton(
//                             //   onPressed: () {
//                             //     // // Add your delete logic here for the user
//                             //     // // You can use user.id to identify the user to delete
//                             //     // buttonState = 'Edit';
//                             //     // userIdForUpdate = user.id; // Store the user ID
//                             //     // controller_fullName.text=user.name;
//                             //     // controller_userName.text=user.username;
//                             //     // controller_password.text=user.Password;
//                             //     // selectedValue=user.role;
//                             //     // setState(() {
                                  
//                             //     // });
//                             //   },
//                             //   icon: Icon(Icons.edit_square, color: Colors.blue),
//                             // ),
//                             // IconButton(
//                             //   onPressed: () {
//                             //     // // Add your delete logic here for the user
//                             //     // // You can use user.id to identify the user to delete
//                             //     // deleteConfirmationDialog(user.id ?? -1);
//                             //   },
//                             //   icon: Icon(Icons.delete_forever, color: Colors.red),
//                             // ),
//                           ],
//                         ),
//                       ),
                      
//                     ],
//                   );
//                 }).toList(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:project/APIHandler/api.dart';
import 'package:project/CommonUtils.dart/LogoutConfirmationDialog.dart';
import 'package:project/CustomWidgets/Widgets.dart';
import 'package:project/Global/GuardGlobal.dart';
import 'package:project/Model/LocationModel.dart';
import 'package:project/Model/UserModel.dart';
import 'package:project/Screens/Admin.dart';
import 'package:project/Screens/Login.dart';
import 'package:http/http.dart' as http;

class GuardDutyScreen extends StatefulWidget {
  const GuardDutyScreen({super.key});

  @override
  State<GuardDutyScreen> createState() => _GuardDutyScreenState();
}

class _GuardDutyScreenState extends State<GuardDutyScreen> {
  TextEditingController controller_searchUser=TextEditingController();
  Set<String> locationTypes= {}; // Use a Set instead of List
  Set<String> locationNames={};
  String? selectedLocation;
  int? selectedLocationId;
  // User? selectedUser; // Variable to store the selected user.
  String buttonState='Add';
  // Use a Map to store button states for each user based on their unique ID
  // Map<int, String> buttonStates = {};
  // int? selectedUserId;
  int? userIdForUpdate;
  String? guardName;
  String? guardUserName;
  String? guardDutyLocation;
  String? guardDutyLocationId;

  List<User> users = [];
  Future <void> getUsers() async{
    try{
      var request = http.MultipartRequest('GET',Uri.parse('${APIHandler.ip}/GetAllUsers'),);
      var response = await request.send();
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(await response.stream.bytesToString());
        setState(() {
          users = jsonResponse.map((json) => User.fromJson(json)).toList();

          // // Initialize button states in the map
          // for (var user in users) {
          //   buttonStates[user.id!] = 'Edit';
          // }

          // dropdownOptions = users.map((user) => user.name).toList();
          // Filter locations with type "gate"
          List<User> userGuard = users.where((user) => user.role == 'Guard').toList();
          filteredUsers=userGuard;
          print(jsonResponse);
          print(filteredUsers);
        });
      }
    }catch (e) {
      print('Error submitting form: $e');
    }
  }

   List<Location> locations = [];
  Future <void> getLocations() async{
    try{
      var request = http.MultipartRequest('GET',Uri.parse('${APIHandler.ip}/GetAllLocations'),);
      var response = await request.send();
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(await response.stream.bytesToString());
        setState(() {
          locations = jsonResponse.map((json) => Location.fromJson(json)).toList();
          // dropdownOptions = locations.map((location) => location.floorName).toList();
          // Clear the dropdownOptions Set
          locationTypes.clear();

          // Add unique location names to dropdownOptions
          for (var location in locations) {
            locationTypes.add(location.type);
          }

          // Add unique location names to dropdownOptions
          for (var location in locations) {
            if(location.type=='Gate')
              locationNames.add(location.name);
          }

          print(jsonResponse);
        });
      }
    }catch (e) {
      print('Error submitting form: $e');
    }
  }

  List<User> filteredUsers = [];
  void filterUsers(String query) {
    // setState(() {
    //   filteredUsers = users.where((user) =>
    //       user.name.toLowerCase().contains(query.toLowerCase())).toList();
    // });
    setState(() {
      if (query.isEmpty) {
        // If the query is empty, display all users
        filteredUsers = users.where((user) => user.role == "Guard").toList();
      } else {
        // Filter the users based on the query
        filteredUsers = users.where((user) {
          final lowerCaseQuery = query.toLowerCase();
          final lowerCaseName = user.name.toLowerCase();
          final lowerCaseUsername = user.username.toLowerCase();
          final lowerCaseDutyLocation = getLocationName(user.dutyLocation).toLowerCase();

          // Check if any field contains the query
          return user.role == "Guard" &&
              (lowerCaseName.contains(lowerCaseQuery) ||
                  lowerCaseUsername.contains(lowerCaseQuery) ||
                  lowerCaseDutyLocation.contains(lowerCaseQuery));
        }).toList();
        // // Filter the users based on the query
        // filteredUsers = users.where((user) =>
        //   user.role == "Guard" && user.name.toLowerCase().contains(query.toLowerCase())
        // ).toList();
      }
    });
  }

  Future<void> allocateDutyLocation(int id, int locationId) async {
    try {
      final response = await http.put(
        Uri.parse('${APIHandler.ip}/AllocateDutyLocation/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'location_id': locationId}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        GuardGlobal.guardGlobalDutyLocation=locationId;
        selectedLocationId=locationId;
        print(jsonResponse);
        print('Guard duty location updated successfully!');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Guard duty location updated successfully!'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    buttonState='Add';
                    guardName='';
                    guardUserName='';
                    guardDutyLocation='';
                    guardDutyLocationId='';
                    getUsers();
                    setState(() {
                      
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        print('Failed to update guard duty location. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to update guard duty location. Status code: ${response.statusCode}\nResponse body: ${response.body}'),
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
    } catch (e) {
      print('Exception: $e');
      // Handle exception as needed
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Exception'),
            content: Text('An exception occurred: $e'),
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

  @override
  void initState() {
    super.initState();
    getUsers();
    getLocations();
    // filteredUsers = List.from(users);
  }

  String getLocationName(int? locationId) {
    // Method to get location name based on location ID
    if (locationId != null) {
      Location? location = locations.firstWhere((location) => location.id == locationId);
      return location.name;
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context){
                          return Admin();
                        })
                      );
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue,width: 2),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(Icons.arrow_back,color: Colors.blue,)
                        ),
                      ),
                    )
                  ),
                  // SizedBox(width: 800),
                  GestureDetector(
                    onTap: () {
                      showLogoutConfirmationDialog(context);
                      // Navigator.of(context).pushReplacement(
                      //   MaterialPageRoute(builder: (context){
                      //     return Login();
                      //   })
                      // );
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        height: 25,
                        // width: 200,
                        // width: double.infinity,
                        child: Text('Logout',style: TextStyle(fontSize: 20,color: Colors.blue),textAlign: TextAlign.right,)
                      ),
                    )
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Text('Guards Location',style: TextStyle(fontSize: 25,color: Colors.blue),),
              SizedBox(height: 25,),
              if (buttonState == 'Edit') ...[
                Container(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (buttonState == 'Edit')
                    Container(
                      padding: EdgeInsets.all(10.0),
                      color: Colors.yellow,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Edit Mode Enabled',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                buttonState = 'Add';
                                selectedLocation=null;
                                selectedLocationId=null;
                              });
                            },
                            child: Icon(Icons.close),
                          ),
                        ],
                      ),
                    ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Guard Name: ${guardName ?? ''}', style: TextStyle(fontSize: 20, color: Colors.blue)),
                          // GestureDetector(
                          //   onTap: () {
                          //     buttonState='Add';
                          //     selectedLocation=null;
                          //     selectedLocationId=null;
                          //     // User? selectedUserCopy = selectedUser;
                          //     // if (selectedUserCopy != null) {
                          //     //   // Set the button state to 'Edit' for the selected user
                          //     //   // buttonStates[selectedUserCopy.id!] = 'Edit';
                          //     //   // selectedUser = null;
                          //     //   setState(() {});
                          //     // }
                          //     // setState(() {
                          //     //   buttonState = 'Add';
                          //     //   // Set the button state to 'Edit' when the close button is tapped
                          //     //   buttonStates[user.id!] = 'Edit';
                          //     //   selectedUser = null;
                          //     // });
                          //     setState(() {
                                
                          //     });
                          //   },
                          //   child: Icon(Icons.close,color: Colors.blue,),
                          // ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Text('Guard User Name: ${guardUserName ?? ''}', style: TextStyle(fontSize: 20, color: Colors.blue)),
                      SizedBox(height: 10,),
                      Text('Duty Location: ${guardDutyLocation?.isNotEmpty ?? false ? guardDutyLocation! : 'Not Assigned'}',style: TextStyle(fontSize: 20, color: Colors.blue)),
                      SizedBox(height: 20,),
                      Text('Locations',style: TextStyle(fontSize: 18,color: Colors.blue),),
                      // Dropdown for location selection
                      DropdownButton<String>(
                        hint: Text('Select Location',style: TextStyle(color: Colors.blue),),
                        icon: Icon(Icons.arrow_drop_down,color: Colors.blue,),
                        // icon: Icon(Icons.arrow_circle_down),
                        // underline: Text('__________'),
                        isExpanded: true,
                        // enableFeedback: true,
                        // dropdownColor: Colors.blue,
                        // borderRadius: BorderRadius.circular(10),
                        // menuMaxHeight: 60,
                        value: selectedLocation,
                        items: locationNames.map((e) => DropdownMenuItem(
                          child: Text(e),
                          value: e,
                        )).toList(), 
                        onChanged: (String? value){
                          setState(() {
                            selectedLocation=value;
                            selectedLocationId = locations.firstWhere((location) => location.name == value).id;
                            print(selectedLocation);
                            print(selectedLocationId);
                          });
                        }
                      ),
                      SizedBox(height: 15,),
                      // Save button
                      if(buttonState=='Edit')
                      GestureDetector(
                        onTap: (){
                          allocateDutyLocation(userIdForUpdate!,selectedLocationId!);
                          setState(() {
                            
                          });
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
                              child: Text(buttonState=='Add'? 'Add' : 'Save',style: TextStyle(fontSize: 20,color: Colors.white),),
                            ),
                          ),
                        )
                      ),
                    ],
                  ),
                ),
                // Text('Selected User Information', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                // Text('Name: ${selectedUser!.name}'),
                // Text('Username: ${selectedUser!.username}'),
                // Text('Duty Location: ${selectedUser!.role}'),

                // // Dropdown for location selection
                // DropdownButton<String>(
                //   hint: Text('Location Floor',style: TextStyle(color: Colors.blue),),
                //   icon: Icon(Icons.arrow_drop_down,color: Colors.blue,),
                //   // icon: Icon(Icons.arrow_circle_down),
                //   // underline: Text('__________'),
                //   isExpanded: true,
                //   // enableFeedback: true,
                //   // dropdownColor: Colors.blue,
                //   // borderRadius: BorderRadius.circular(10),
                //   // menuMaxHeight: 60,
                //   value: selectedLocation,
                //   items: locationTypes.map((e) => DropdownMenuItem(
                //     child: Text(e),
                //     value: e,
                //   )).toList(), 
                //   onChanged: (String? value){
                //     setState(() {
                //       selectedLocation=value;
                //     });
                //   }
                // ),

                // // Save button
                // ElevatedButton(
                //   onPressed: () {
                //     // Implement save logic here to save changes to the selected user.
                //     // You can access selectedUser to get the updated information.
                //   },
                //   child: Text('Save'),
                // ),
              ],
              SizedBox(height: 30,),
              Container(
                height: 50,
                width: 400,
                child: TextField(
                  controller: controller_searchUser,
                  decoration: InputDecoration(
                    hintText: 'Search User',
                    hintStyle: TextStyle(color: Colors.blue),
                    // Add a clear button to the search bar
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear,color: Colors.blue,),
                      onPressed: () {
                        controller_searchUser.clear();
                        getUsers();
                        setState(() {
                          
                        });
                      },
                    ),
                    // Add a search icon or button to the search bar
                    prefixIcon: IconButton(
                      icon: Icon(Icons.search,color: Colors.blue,),
                      onPressed: () {
                        // Perform the search here
                        // searchUser(); // Call the searchUser method
                      },
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                        BorderSide(width: 1, color: Colors.blue), //<-- SEE HERE
                      borderRadius: BorderRadius.circular(30.0)
                    ),
                  ),
                  onChanged: (query) {
                    filterUsers(query);
                  },
                ),
              ),
              SizedBox(height: 30,),
              Row(
                children: [
                  Expanded(
                    child: Text('Name',style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)
                  ),
                  Expanded(
                    child: Text("Username",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)
                  ),
                  Expanded(
                    child: Text("Duty Location",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)
                  )
                ],
              ),
              Divider(thickness: 2),
              Container(
                // height: double.maxFinite,
                // height: (filteredUsers.length*70),
                height: 450,
                child: ListView.builder(
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index){
                    User user=filteredUsers[index];
                    return Column(
                      children: [
                        Slidable(
                          endActionPane: ActionPane(
                            motion: StretchMotion(), 
                            children: [
                              SlidableAction(
                                onPressed: (context){
                                  print('User: $user');
                                  if (user != null) {
                                    // Add your delete logic here for the user
                                    // You can use user.id to identify the user to delete
                                    buttonState = 'Edit';
                                    userIdForUpdate = user.id; // Store the user ID
                                    print(userIdForUpdate);
                                    guardName=user.name;
                                    guardUserName=user.username;
                                    guardDutyLocationId = user.dutyLocation?.toString() ?? '-1';
                                    guardDutyLocation = guardDutyLocationId != '-1' ? getLocationName(int.parse(guardDutyLocationId!)) : 'Not Assigned';
              
                                    // guardDutyLocationId=user.dutyLocation.toString();
                                    // guardDutyLocation=getLocationName(int.parse(guardDutyLocationId!));
                                    print(guardDutyLocation);
                                    // print();
                                    // controller_floorName.text=floor.name;
                                    setState(() {
                                      
                                    });
                                  }
                                },
                                icon: Icons.edit_square,
                                foregroundColor: Colors.blue,
                              ),
                            ]
                          ),
                          child: Container(
                            height: 40,
                            child: Row(
                              children: [
                                Expanded(
                                  child: getText(user.name.toString(),15)
                                ),
                                Expanded(
                                  child: getText(user.username,15)
                                ),
                                Expanded(
                                  child: Text(getLocationName(user.dutyLocation).isEmpty?'Not Assigned':getLocationName(user.dutyLocation))
                                )
                              ],
                            ),
                          )
                        ),
                        Divider(thickness: 1.5),
                      ],
                    );
                  }
              
                ),
              )
              // SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child: DataTable(
              //     columnSpacing: 20,
              //     columns: [
              //       // DataColumn(label: Text('ID',style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)),
              //       DataColumn(label: Text("Name",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)),
              //       DataColumn(label: Text("Username",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)),
              //       DataColumn(label: Text("Duty Location",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),))
              //     ], 
              //     rows: filteredUsers.map((user) {
              //       return DataRow(
              //         cells: [
              //           // DataCell(Text(user.id.toString())), // Assuming id is an int, modify as needed
              //           DataCell(Text(user.name,style: TextStyle(fontSize: 15),)),
              //           DataCell(Text(user.username,style: TextStyle(fontSize: 15),)),
              //           DataCell(
              //             Row(
              //               children: [
              //                 Text(getLocationName(user.dutyLocation).isEmpty?'Null':getLocationName(user.dutyLocation),style: TextStyle(fontSize: 15),),
              //                 SizedBox(width: 10),
              //                 IconButton(
              //                   onPressed: () {
              //                     print('User: $user');
              //                     if (user != null) {
              //                       // Add your delete logic here for the user
              //                       // You can use user.id to identify the user to delete
              //                       buttonState = 'Edit';
              //                       userIdForUpdate = user.id; // Store the user ID
              //                       print(userIdForUpdate);
              //                       guardName=user.name;
              //                       guardUserName=user.username;
              //                       guardDutyLocationId = user.dutyLocation?.toString() ?? '-1';
              //                       guardDutyLocation = guardDutyLocationId != '-1' ? getLocationName(int.parse(guardDutyLocationId!)) : 'Not Assigned';
              
              //                       // guardDutyLocationId=user.dutyLocation.toString();
              //                       // guardDutyLocation=getLocationName(int.parse(guardDutyLocationId!));
              //                       print(guardDutyLocation);
              //                       // print();
              //                       // controller_floorName.text=floor.name;
              //                       setState(() {
                                      
              //                       });
              //                     }
              //                   },
              //                   icon: Icon(Icons.edit_square, color: Colors.blue),
              //                 ),
              //                 // IconButton(
              //                 //   onPressed: () {
              //                 //     // // Add your delete logic here for the user
              //                 //     // // You can use user.id to identify the user to delete
              //                 //     // buttonState = 'Edit';
              //                 //     // userIdForUpdate = user.id; // Store the user ID
              //                 //     // controller_fullName.text=user.name;
              //                 //     // controller_userName.text=user.username;
              //                 //     // controller_password.text=user.Password;
              //                 //     // selectedValue=user.role;
              //                 //     // setState(() {
                                    
              //                 //     // });
              //                 //   },
              //                 //   icon: Icon(Icons.edit_square, color: Colors.blue),
              //                 // ),
              //                 // IconButton(
              //                 //   onPressed: () {
              //                 //     // // Add your delete logic here for the user
              //                 //     // // You can use user.id to identify the user to delete
              //                 //     // deleteConfirmationDialog(user.id ?? -1);
              //                 //   },
              //                 //   icon: Icon(Icons.delete_forever, color: Colors.red),
              //                 // ),
              //               ],
              //             ),
              //           ),
                        
              //         ],
              //       );
              //     }).toList(),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}