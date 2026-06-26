import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project/APIHandler/api.dart';
import 'package:project/CommonUtils.dart/LogoutConfirmationDialog.dart';
import 'package:project/Screens/Admin.dart';
import 'package:project/Screens/Login.dart';

class CameraConnectionScreen extends StatefulWidget {
  const CameraConnectionScreen({super.key});

  @override
  State<CameraConnectionScreen> createState() => _CameraConnectionScreenState();
}

class _CameraConnectionScreenState extends State<CameraConnectionScreen> {

  // // Define a 5x5 adjacency matrix
  // List<List<int>> matrix = [
  //   [0, 1, 0, 1, 0],
  //   [1, 0, 1, 0, 1],
  //   [0, 1, 0, 1, 0],
  //   [1, 0, 1, 0, 1],
  //   [0, 1, 0, 1, 0],
  // ];

  TextEditingController costController=TextEditingController();
  List<List<int>> matrix = [];
  List<String> rowNames = [];
  List<String> columnNames = [];
  double cellSize = 60.0;
  String buttonState='Add';
  

  Future<void> getAdjacencyMatrix() async {
    final url = '${APIHandler.ip}/GetCameraMatrix';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        setState(() {
          // Update the matrix and rebuild the UI
          matrix = (data['matrix'] as List)
              .map((row) => (row as List).cast<int>())
              .toList();
          rowNames = List<String>.from(data['rowNames']);
          columnNames = List<String>.from(data['columnNames']);
          print(matrix);
        });
      } else {
        // Handle error: Show an alert, log, or provide feedback to the user
        print('Failed to load adjacency matrix: ${response.statusCode}');
      }
    } catch (e) {
      // Handle other exceptions
      print('Error: $e');
    }
  }

  void _showDialog(int rowIndex, int colIndex, String rowName, String colName) {
    costController.text = matrix[rowIndex - 1][colIndex - 1].toString();
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissal by clicking outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$rowName - $colName', style: TextStyle(color: Colors.blue),),  //Text('Cell Clicked'),
          // title: Text('C$rowIndex - C$colIndex', style: TextStyle(color: Colors.blue),),  //Text('Cell Clicked'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Edit Cost', style: TextStyle(color: Colors.blue),),
              TextField(
                controller: costController,
                keyboardType: TextInputType.number,
                // inputFormatters: <TextInputFormatter>[
                //   FilteringTextInputFormatter.digitsOnly, // Accept only digits
                // ],
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // content: Text('C$rowIndex - C$colIndex'),  //Text('Clicked on cell at row: $rowIndex, column: $colIndex'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Update the matrix with the new value
                int newValue = int.parse(costController.text);
                setState(() {
                  matrix[rowIndex - 1][colIndex - 1] = newValue;
                  matrix[colIndex - 1][rowIndex - 1] = newValue; // Update the symmetric cell
                });
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<String> updateAdjacencyMatrix(List<List<int>> matrix, List<String> rowNames, List<String> columnNames) async {
    final String url = '${APIHandler.ip}/UpdateMatrix'; // Replace with your actual server URL and endpoint

    // Prepare the request body
    final Map<String, dynamic> requestBody = {
      'matrix': matrix,
      'rowNames': rowNames,
      'columnNames': columnNames,
    };

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      return 'Connections updated successfully';
    } else {
      throw Exception('Failed to update connections');
    }
  }

  Future<void> showResponseDialog(String response) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Status'),
          content: Text(response),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                buttonState = 'Add';
                getAdjacencyMatrix();
                setState(() {
                  
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // // Function to generate abbreviated names from a full name
  // String generateAbbreviatedName(String fullName) {
  //   List<String> words = fullName.split(' ');
  //   return words.map((word) => word[0]).join('');
  // }

  String generateAbbreviatedName(String name) {
    List<String> words = name.split(' ');

    if (words.length == 2) {
      String firstWord = words[0];
      String secondWord = words[1];

      if (firstWord.length == 2) {
        // Include both letters of the 2-letter first word and the first letter of the second word
        return firstWord + secondWord.substring(0, 1);
      } else {
        // Include only the first letter of each word
        return words.map((word) => word.isNotEmpty ? word[0] : '').join();
      }
    } else if (words.length >= 3) {
      String firstWord = words[0];
      String secondWord = words[1];
      String thirdWord = words[2];

      if (firstWord.length == 2) {
        // Include both letters of the 2-letter first word and the first letter of the second word
        return firstWord + secondWord.substring(0, 1)+thirdWord.substring(0, 1);
      } else {
        // Include only the first letter of each word
        return words.map((word) => word.isNotEmpty ? word[0] : '').join();
      }
    }
    else {
      // Only one word, include its first two letters
      return name.length >= 2 ? name.substring(0, 2) : name;
    }
  }



  @override
  void initState() {
    super.initState();
    // Call the function in the initState to fetch data when the widget is created
    getAdjacencyMatrix();
    // String name = "GF Sitting Area";
    // String abbreviatedName = generateAbbreviatedName(name);
    // print(abbreviatedName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Camera Connection'),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: GestureDetector(
      //     onTap: () {
      //       buttonState = 'Edit';
      //       setState(() {});
      //     },
      //     child: MouseRegion(
      //       cursor: SystemMouseCursors.click,
      //       child: Container(
      //         height: 50,
      //         width: 400,
      //         decoration: BoxDecoration(
      //           borderRadius: BorderRadius.circular(40),
      //           border: Border.all(
      //             width: 2,
      //             color: Colors.blue,
      //           ),
      //         ),
      //         child: Center(
      //           child: Text(
      //             buttonState == 'Add' ? 'Edit Costs Enable' : 'Edit Costs Disable',
      //             style: TextStyle(fontSize: 20, color: Colors.blue),
      //           ),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      bottomNavigationBar: BottomAppBar(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if(buttonState=='Add')
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  buttonState = 'Edit';
                  setState(() {});
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    height: 50,
                    width: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                        width: 2,
                        color: Colors.blue,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        buttonState == 'Add' ? 'Edit Costs Enable' : 'Edit Costs Disable',
                        style: TextStyle(fontSize: 20, color: Colors.blue),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if(buttonState=='Edit')
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: ()async{
                    // setState(() {
                      if(buttonState=='Add'){
                        // addCameraCost();
                      }
                      else if (buttonState == 'Edit'){
                        // Check if an update is in progress
                        final response = await updateAdjacencyMatrix(matrix, rowNames, columnNames);
                        print(response); // You can handle the response as needed.
                        showResponseDialog(response);
                      }
                      setState(() {
                        
                      });
                    // });
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
                        child: Text(buttonState=='Add'? 'Save Costs' : 'Update Costs',style: TextStyle(fontSize: 20,color: Colors.white),),
                      ),
                    ),
                  )
                ),
              ),
          ]
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            SizedBox(height: 10,),
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
                // SizedBox(width: 180),
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
            Align(alignment: Alignment.topCenter,child: Text('Camera Connections',style: TextStyle(fontSize: 30,color: Colors.blue),)),
            SizedBox(height: 20,),
            if (buttonState == 'Edit')
              Container(
                padding: EdgeInsets.all(10.0),
                color: Colors.yellow,
                // width: (50*rowNames.length.toDouble()),
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
                        });
                      },
                      child: Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: [
                      // Header Row
                      Row(
                        children: [
                          Container(
                            color: Colors.grey[300]!,
                            margin: EdgeInsets.all(8.0),
                            height: 35,
                            width: 140,
                            child: Center(
                              child: Text(
                                '',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          for (int colIndex = 0;
                              colIndex < columnNames.length;
                              colIndex++)
                            Container(
                              // color: Colors.grey[300]!,
                              color: Color(0xFF0CC0A7),
                              margin: EdgeInsets.all(8.0),
                              height: 35,
                              width: 50,
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Center(
                                  child: Text(
                                    generateAbbreviatedName(columnNames[colIndex]),
                                    style: TextStyle(
                                      fontSize: 19.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),

                      // Data Rows
                      ...List.generate(
                        matrix.length,
                        (rowIndex) => Row(
                          children: [
                            Container(
                              // color: Colors.grey[300]!,
                              color: Color(0xFF0CC0A7),
                              margin: EdgeInsets.all(8.0),
                              height: 35,
                              width: 140,
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Center(
                                  child: Text(
                                    rowNames[rowIndex],
                                    style: TextStyle(
                                      fontSize: 19.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            for (int colIndex = 0;
                                colIndex < matrix[rowIndex].length;
                                colIndex++)
                              GestureDetector(
                                onTap: buttonState == 'Edit'
                                    ? () {
                                        _showDialog(
                                            rowIndex + 1, colIndex + 1, rowNames[rowIndex], columnNames[colIndex]);
                                      }
                                    : null,
                                child: Container(
                                  height: 35,
                                  margin: EdgeInsets.all(8.0),
                                  // color: Colors.white,
                                  color: Colors.grey[300]!,
                                  width: 50,
                                  child: Center(
                                    child: Text(
                                      matrix[rowIndex][colIndex].toString(),
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),


            // Padding(
            //   padding: EdgeInsets.all(8.0),
            //   child: SingleChildScrollView(
            //     scrollDirection: Axis.vertical,
            //     child: SingleChildScrollView(
            //       scrollDirection: Axis.horizontal,
            //       child: Column(
            //         children: [
            //           SizedBox(height: 10,),
            //           Table(
            //             defaultColumnWidth: FixedColumnWidth(100),
            //             // defaultColumnWidth: FixedColumnWidth(cellSize),
            //             children: [
            //               TableRow(
            //                 children: [
            //                   Material(
            //                     elevation: 4.0,
            //                     child: GestureDetector(
            //                       onTap: () {
            //                         // Ignore heading cell
            //                         // _showDialog(0, 0);
            //                       },
            //                       child: Container(
            //                         margin: EdgeInsets.all(8.0),
            //                         color: Colors.grey[300]!,
            //                         padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
            //                         width: 150,
            //                         // width: cellSize,
            //                         // height: cellSize,
            //                         child: Center(
            //                           child: Text(
            //                             '',
            //                             style: TextStyle(
            //                               fontSize: 18.0,
            //                               fontWeight: FontWeight.bold,
            //                               color: Colors.white,
            //                             ),
            //                           ),
            //                         ),
            //                       ),
            //                     ),
            //                   ),
            //                   for (int colIndex = 0;
            //                       colIndex < columnNames.length;
            //                       colIndex++)
            //                     Material(
            //                       elevation: 4.0,
            //                       child: GestureDetector(
            //                         onTap: () {
            //                           // Ignore heading cells
            //                           // _showDialog(0, colIndex + 1);
            //                         },
            //                         child: Container(
            //                           color: Colors.grey[300]!,
            //                           padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
            //                           margin: EdgeInsets.all(8.0),
            //                           width: 150,
            //                           // width: cellSize,
            //                           // height: cellSize,
            //                           child: Align(
            //                             alignment: Alignment.topCenter,
            //                             child: Text(
            //                               generateAbbreviatedName(columnNames[colIndex]),
            //                               // columnNames[colIndex],
            //                               style: TextStyle(
            //                                 fontSize: 17.0,
            //                                 fontWeight: FontWeight.bold,
            //                                 color: Colors.blue,
            //                               ),
            //                             ),
            //                           ),
            //                         ),
            //                       ),
            //                     ),
            //                 ],
            //               ),
            //               ...List.generate(
            //                 matrix.length,
            //                 (rowIndex) => TableRow(
            //                   children: [
            //                     GestureDetector(
            //                       onTap: () {
            //                         // Ignore heading cells
            //                         // _showDialog(rowIndex + 1, 0);
            //                       },
            //                       child: Material(
            //                         elevation: 4.0,
            //                         child: Container(
            //                           color: Colors.grey[300]!,
            //                           padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
            //                           margin: EdgeInsets.all(8.0),
            //                           width: 150,
            //                           // width: cellSize,
            //                           // height: cellSize,
            //                           child: Align(
            //                             alignment: Alignment.topCenter,
            //                             child: Text(
            //                               rowNames[rowIndex],
            //                               style: TextStyle(
            //                                 fontSize: 17.0,
            //                                 fontWeight: FontWeight.bold,
            //                                 color: Colors.blue,
            //                               ),
            //                             ),
            //                           ),
            //                         ),
            //                       ),
            //                     ),
            //                     for (int colIndex = 0;
            //                         colIndex < matrix[rowIndex].length;
            //                         colIndex++)
            //                       GestureDetector(
            //                         onTap: buttonState == 'Edit'
            //                             ? () {
            //                                 _showDialog(
            //                                     rowIndex + 1, colIndex + 1);
            //                               }
            //                             : null,
            //                         // onTap: () {
            //                         //   // Ignore heading cells
            //                         //   _showDialog(rowIndex + 1, colIndex + 1);
            //                         // },
            //                         child: Material(
            //                           elevation: 4.0,
            //                           child: Container(
            //                             margin: EdgeInsets.all(8.0),
            //                             color: Colors.white,
            //                             padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
            //                             width: 150,
            //                             // width: cellSize,
            //                             // height: cellSize,
            //                             child: Center(
            //                               child: Text(
            //                                 matrix[rowIndex][colIndex].toString(),
            //                                 style: TextStyle(
            //                                   fontSize: 15.0,
            //                                   // fontWeight: FontWeight.bold,
            //                                   color: Colors.black,
            //                                 ),
            //                               ),
            //                             ),
            //                           ),
            //                         ),
            //                       ),
            //                   ],
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
          ]
        ),
      ),
    );
  }
}