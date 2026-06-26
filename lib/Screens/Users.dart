import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:project/APIHandler/api.dart';
import 'package:project/CommonUtils.dart/LogoutConfirmationDialog.dart';
import 'package:project/Model/UserModel.dart';
import 'package:http/http.dart' as http;
import 'package:project/Screens/Admin.dart';
import 'package:project/Screens/Login.dart';
import '../CustomWidgets/Widgets.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  TextEditingController controller_fullName=TextEditingController();
  TextEditingController controller_userName=TextEditingController();
  TextEditingController controller_password=TextEditingController();
  TextEditingController controller_searchUser=TextEditingController();
  String? selectedValue;
  List<String> dropdownOptions = ['Admin', 'Guard', 'Monitor'];
  bool isObscure=true;
  String buttonState = 'Add';

  List<User> users = [];
  Future <void> getUsers() async{
    try{
      var request = http.MultipartRequest('GET',Uri.parse('${APIHandler.ip}/GetAllUsers'),);
      var response = await request.send();
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(await response.stream.bytesToString());
        setState(() {
          users = jsonResponse.map((json) => User.fromJson(json)).toList();
          // dropdownOptions = users.map((user) => user.name).toList();
          filteredUsers=users;
          print('');
        });
      }
    }catch (e) {
      print('Error submitting form: $e');
    }
  }

  Future<void> addUser() async {
    String fullname = controller_fullName.text;
    String username = controller_userName.text;
    String password = controller_password.text;

    if(fullname.isEmpty || username.isEmpty || password.isEmpty || selectedValue==null){
      print('NO selected');
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please fill in all fields.'),
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
      return ;
    }

    try {
      final newUser = User(
        name: controller_fullName.text,
        username: controller_userName.text,
        Password: controller_password.text,
        role: selectedValue!,
      );
      final response = await http.post(
        Uri.parse('${APIHandler.ip}/AddUser'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(newUser.toJson()),
      );

      if (response.statusCode == 201) {
        controller_fullName.clear();
        controller_userName.clear();
        controller_password.clear();
        selectedValue=null;
        final successMessage = json.decode(response.body)['message'];
        print('User added successfully: $successMessage');
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text(successMessage),
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
        setState(() {
          getUsers();
        });
      } else {
        final errorMessage = json.decode(response.body)['error'];
        print('Failed to add user: $errorMessage');
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to add user: $errorMessage'),
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
      // if (response.statusCode == 201) {
      //   print('User added successfully!');
      //   setState(() {
          
      //   });
      // } else {
      //   final errorMessage = json.decode(response.body)['error'];
      //   print('Failed to add user: $errorMessage');
      // }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Add a user ID variable to track the user being updated
  int? userIdForUpdate;
  Future<void> updateUser(int id, String name, String username, String password, String role) async {
    if(name.isEmpty || username.isEmpty || password.isEmpty || selectedValue==null){
      print('NO selected');
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please fill in all fields.'),
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
      return ;
    }
    
    try {
      final updatedUser = {
        'name': name,
        'username': username,
        'password': password,
        'role': role,
      };

      final response = await http.put(
        Uri.parse('${APIHandler.ip}/UpdateUser/$id'), 
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedUser),
      );

      if (response.statusCode == 200) {
        print('User updated successfully');
        final successMessage = json.decode(response.body)['message'];
        print('User updated successfully: $successMessage');
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text(successMessage),
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
        setState(() {
          // Clear the form fields and exit edit mode
          controller_fullName.clear();
          selectedValue = null;
          controller_userName.clear();
          controller_password.clear();
          buttonState = 'Add';
          userIdForUpdate = null;
          getUsers();
        });
      } else {
        final errorMessage = json.decode(response.body)['error'];
        print('Failed to update user: $errorMessage');
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to add user: $errorMessage'),
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
      print('Error: $e');
    }
  }

  // Function to display a confirmation dialog before deleting a user
  Future<void> deleteConfirmationDialog(int userId) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete User'),
          content: Text('Are you sure you want to delete this user?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirm delete
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel delete
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      // User confirmed the delete action
      deleteUser(userId);
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${APIHandler.ip}/DeleteUser/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final successMessage = json.decode(response.body)['message'];
        print('User deleted successfully: $successMessage');
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text(successMessage),
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
        setState(() {
          getUsers();
        });
      } else {
        final errorMessage = json.decode(response.body)['error'];
        print('Failed to delete user: $errorMessage');
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to delete user: $errorMessage'),
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
      print('Error: $e');
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
        filteredUsers = List.from(users);
      } else {
        // Filter the users based on the query
        filteredUsers = users.where((user) =>
          user.name.toLowerCase().contains(query.toLowerCase()) ||
          user.role.toLowerCase().contains(query.toLowerCase()) ||
          user.username.toLowerCase().contains(query.toLowerCase())
        ).toList();
      }
    });
  }


  @override
  void initState() {
    super.initState();
    getUsers();
    // filteredUsers = List.from(users);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text(''),),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: ListView(
            children:[ Column(
              children: [
                // SizedBox(height: 10,),
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
                Text('Users',style: TextStyle(fontSize: 30,color: Colors.blue,fontWeight: FontWeight.bold),),
                SizedBox(height: 20,),
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
                              controller_fullName.text = '';
                              selectedValue = null;
                              controller_userName.text = '';
                              controller_password.text = '';
                            });
                          },
                          child: Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: 20,),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controller_fullName,
                        decoration: InputDecoration(
                          hintText: 'Enter Full Name',
                          labelText: 'Full Name',
                          labelStyle: TextStyle(color: Colors.blue),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20,),
                    Expanded(
                      child: DropdownButton(
                        hint: Text('Select Roles',style: TextStyle(color: Colors.blue),),
                        icon: Icon(Icons.arrow_drop_down,color: Colors.blue,),
                        // icon: Icon(Icons.arrow_circle_down),
                        // underline: Text('__________'),
                        isExpanded: true,
                        // enableFeedback: true,
                        // dropdownColor: Colors.blue,
                        // borderRadius: BorderRadius.circular(10),
                        // menuMaxHeight: 60,
                        value: selectedValue,
                        items: dropdownOptions.map((e) => DropdownMenuItem(
                          child: Text(e),
                          value: e,
                        )).toList(), 
                        onChanged: (String? value){
                          setState(() {
                            selectedValue=value;
                          });
                        }
                      ),
                    ),
                    // Expanded(
                //       child: DropdownButtonFormField<String>(
                //         value: selectedValue,
                //         onChanged: (newValue) {
                //           setState(() {
                //             selectedValue = newValue;
                //           });
                //         },
                //         items: dropdownOptions.map((option) {
                //           return DropdownMenuItem(
                //       value: option,
                //       child: Text(option),
                //     );
                //   }).toList(),
                //   decoration: InputDecoration(
                //     labelText: 'Select an option',
                //     border: OutlineInputBorder(),
                //   ),
                // ),
                    // ),
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controller_userName,
                        decoration: InputDecoration(
                          hintText: 'Enter User Name',
                          labelText: 'User Name',
                          labelStyle: TextStyle(color: Colors.blue),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20,),
                    Expanded(
                      child: TextFormField(
                        controller: controller_password,
                        obscureText: isObscure,
                        decoration: InputDecoration(
                          hintText: 'Enter Password',
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.blue),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 1,
                            ),
                          ),
                          suffixIcon: IconButton( 
                            icon: Icon(isObscure 
                                ? Icons.visibility 
                                : Icons.visibility_off,color: Colors.blue,), 
                            onPressed: () { 
                              setState( 
                                () { 
                                  isObscure = !isObscure; 
                                }, 
                              ); 
                            }, 
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30,),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      // addUser();
                      if(buttonState=='Add'){
                        addUser();
                      }
                      else if (buttonState == 'Edit' && userIdForUpdate != null){
                        // Check if an update is in progress
                        final name = controller_fullName.text;
                        final username = controller_userName.text;
                        final password = controller_password.text;
                        final role = selectedValue;
                        updateUser(userIdForUpdate!, name, username, password, role!);
                      }
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
                        child: Text(buttonState=='Add'? 'Add User' : 'Update User',style: TextStyle(fontSize: 20,color: Colors.white),),
                      ),
                    ),
                  )
                ),
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
                      child: Text("Role",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)
                    )
                  ],
                ),
                Divider(thickness: 2),
                Container(
                  // height: double.maxFinite,
                  // height: (filteredUsers.length*70),
                  height: 430,
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
                                    buttonState = 'Edit';
                                    userIdForUpdate = user.id; // Store the user ID
                                    controller_fullName.text=user.name;
                                    controller_userName.text=user.username;
                                    controller_password.text=user.Password;
                                    selectedValue=user.role;
                                    setState(() {
                                      
                                    });
                                  },
                                  icon: Icons.edit_square,
                                  foregroundColor: Colors.blue,
                                ),
                                SlidableAction(
                                  onPressed: (context){
                                    setState(() {
                                      deleteConfirmationDialog(user.id ?? -1);
                                    });
                                  },
                                  icon: Icons.delete_forever,
                                  foregroundColor: Colors.red,
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
                                    child: Text(user.role)
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
                ),
                // DataTable(
                //   columnSpacing: 20,
                //   columns: [
                //     // DataColumn(label: Text('ID',style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)),
                //     DataColumn(label: Text("Name",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)),
                //     DataColumn(label: Text("Username",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)),
                //     DataColumn(label: Text("Role",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),))
                //   ], 
                //   rows: filteredUsers.map((user) {
                //     return DataRow(
                //       cells: [
                //         // DataCell(Text(user.id.toString())), // Assuming id is an int, modify as needed
                //         DataCell(Text(user.name)),
                //         DataCell(Text(user.username)),
                //         DataCell(
                //           Row(
                //             children: [
                //               Text(user.role),
                //               SizedBox(width: 5),
                //               IconButton(
                //                 onPressed: () {
                //                   // Add your delete logic here for the user
                //                   // You can use user.id to identify the user to delete
                //                   buttonState = 'Edit';
                //                   userIdForUpdate = user.id; // Store the user ID
                //                   controller_fullName.text=user.name;
                //                   controller_userName.text=user.username;
                //                   controller_password.text=user.Password;
                //                   selectedValue=user.role;
                //                   setState(() {
                                    
                //                   });
                //                 },
                //                 icon: Icon(Icons.edit_square, color: Colors.blue),
                //               ),
                //               IconButton(
                //                 onPressed: () {
                //                   // Add your delete logic here for the user
                //                   // You can use user.id to identify the user to delete
                //                   deleteConfirmationDialog(user.id ?? -1);
                //                 },
                //                 icon: Icon(Icons.delete_forever, color: Colors.red),
                //               ),
                //             ],
                //           ),
                //         ),
                        
                //       ],
                //     );
                //   }).toList(),
                //   // rows: [
                //   //   DataRow(
                //   //     cells: [
                //   //       DataCell(getText('',10)),
                //   //       DataCell(Text('')),
                //   //       DataCell(Text('')),
                //   //       DataCell(
                //   //         Row(
                //   //           children: [
                //   //             Text(''),
                //   //             SizedBox(width: 10,),
                //   //             IconButton(
                //   //               onPressed: (){
          
                //   //               }, 
                //   //               icon: Icon(Icons.delete_forever,color: Colors.blue,)
                //   //             ),
                //   //           ],
                //   //         )
                //   //       ),
                //   //     ]
                //   //   )
                //   // ],
                // ),
              ],
            ),
            ]
          ),
        ),
      ),
    );
  }
}