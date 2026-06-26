import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project/Model/CameraModel.dart';
import 'package:project/Screens/Admin.dart';
import 'package:project/Screens/Login.dart';
import 'package:http/http.dart' as http;

class CameraCostScreen extends StatefulWidget {
  const CameraCostScreen({super.key});

  @override
  State<CameraCostScreen> createState() => _CameraCostScreenState();
}

class _CameraCostScreenState extends State<CameraCostScreen> {
  List<String> camera = []; // List to hold camera names
  List<String> rowNames = [];
  List<String> columnNames = [];
  List<List<int>> adjacencyMatrix = [];
  bool isLoading = true;

  TextEditingController costController = TextEditingController();
  String location = '';
  int selectedRowIndex = -1;
  int selectedColIndex = -1;
  String buttonState = 'Add';


  @override
  void initState() {
    super.initState();
    // Fetch the adjacency matrix data when the screen is loaded.
    fetchAdjacencyMatrixData();
    getCameras();
  }

  // Function to fetch the adjacency matrix data from your Python server.
  Future<void> fetchAdjacencyMatrixData() async {
    final Uri url = Uri.parse('http://localhost:5000/GetCameraMatrix'); // Convert the string to a Uri.

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        rowNames = List<String>.from(data['rowNames']);
        columnNames = List<String>.from(data['columnNames']);
        adjacencyMatrix = List<List<int>>.from(data['matrix'].map((e) => List<int>.from(e)));
        print(adjacencyMatrix);
        isLoading = false; // Data is available, no longer loading.
      });
    } else {
      throw Exception('Failed to load adjacency matrix data');
    }
  }

  List<Camera> cameras = [];
  Future <void> getCameras() async{
    try{
      var request = http.MultipartRequest('GET',Uri.parse('http://localhost:5000/GetAllCameras'),);
      var response = await request.send();
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(await response.stream.bytesToString());
        setState(() {
          cameras = jsonResponse.map((json) => Camera.fromJson(json)).toList();
          camera = cameras.map((camera) => camera.name).toList();
          print(camera);
        });
      }
    }catch (e) {
      print('Error submitting form: $e');
    }
  }


  ElevatedButton buildTopLeftCell() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        elevation: 4, 
        backgroundColor: Colors.grey[300], // Set the cell color for headers
      ),
      child: Container(
        alignment: Alignment.center,
        child: Text(
          '', // You can leave this cell empty
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
      ),
    );
  }

  GestureDetector buildEditableCell(int rowIndex, int colIndex) {
  return GestureDetector(
    onTap: () {
      if(buttonState=='Edit'){
        setState(() {
          selectedRowIndex = rowIndex;
          selectedColIndex = colIndex;
          location = '${camera[rowIndex]} - ${camera[colIndex]}';
          costController.text = adjacencyMatrix[rowIndex][colIndex].toString();
        });

        showDialog(
          context: context,
          barrierDismissible: false, // Prevent dismissal by clicking outside
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('$location', style: TextStyle(color: Colors.blue),),
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
              actions: <Widget>[
                GestureDetector(
                  onTap: () {
                    // Update the adjacencyMatrix with the new cost
                    final newCost = int.tryParse(costController.text) ?? 0;
                    // Update the cost in both directions
                    adjacencyMatrix[rowIndex][colIndex] = newCost;
                    adjacencyMatrix[colIndex][rowIndex] = newCost;
                    // adjacencyMatrix[selectedRowIndex][selectedColIndex] = newCost;
                    setState(() {
                      selectedRowIndex = -1;
                      selectedColIndex = -1;
                    });
                    Navigator.of(context).pop();
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.blue,
                      ),
                      child: Center(
                        child: Text('Save', style: TextStyle(fontSize: 20, color: Colors.white),),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }
      else{
        return;
      }
    },
    child: Container(
      width: calculateCellSize(camera.length),
      height: calculateCellSize(camera.length),
      // width: 120, // Fixed width
      // height: 50,  // Fixed height
      color: Colors.white, // Set the cell color for editable cells
      alignment: Alignment.center,
      child: Text(
        adjacencyMatrix[rowIndex][colIndex].toString(),
        style: TextStyle(fontSize: 12, color: Colors.black),
      ),
    ),
  );
}


  // ElevatedButton buildEditableCell(int rowIndex, colIndex) {
  //   return ElevatedButton(
  //     onPressed: () {
  //       setState(() {
  //         selectedRowIndex = rowIndex;
  //         selectedColIndex = colIndex;
  //         location = '${camera[rowIndex]} - ${camera[colIndex]}';
  //         costController.text = adjacencyMatrix[rowIndex][colIndex].toString();
  //       });

  //       showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             title: Text('$location',style: TextStyle(color: Colors.blue),),
  //             content: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: <Widget>[
  //                 Text('Edit Cost',style: TextStyle(color: Colors.blue),),
  //                 TextField(
  //                   controller: costController,
  //                   // decoration: InputDecoration(labelText: 'Cost'),
  //                   decoration: InputDecoration(
  //                     enabledBorder: UnderlineInputBorder(
  //                     borderSide: BorderSide(
  //                       color: Colors.blue,
  //                       width: 1,
  //                     ),
  //                   ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             actions: <Widget>[
  //               // TextButton(
  //               //   child: Text('Cancel'),
  //               //   onPressed: () {
  //               //     Navigator.of(context).pop();
  //               //   },
  //               // ),
  //               GestureDetector(
  //                 onTap: (){
  //                   // Update the adjacencyMatrix with the new cost
  //                   final newCost = int.tryParse(costController.text) ?? 0;
  //                   adjacencyMatrix[selectedRowIndex][selectedColIndex] = newCost;
  //                   setState(() {
  //                     selectedRowIndex = -1;
  //                     selectedColIndex = -1;
  //                   });
  //                   Navigator.of(context).pop();
  //                 },
  //                 child: MouseRegion(
  //                   cursor: SystemMouseCursors.click,
  //                   child: Container(
  //                     height: 50,
  //                     width: 250,
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(40),
  //                       color: Colors.blue,
  //                     ),
  //                     child: Center(
  //                       child: Text('Save',style: TextStyle(fontSize: 20,color: Colors.white),),
  //                     ),
  //                   ),
  //                 )
  //               ),
  //               // TextButton(
  //               //   child: Text('Save'),
  //               //   onPressed: () {
  //               //     // Update the adjacencyMatrix with the new cost
  //               //     final newCost = int.tryParse(costController.text) ?? 0;
  //               //     adjacencyMatrix[selectedRowIndex][selectedColIndex] = newCost;
  //               //     setState(() {
  //               //       selectedRowIndex = -1;
  //               //       selectedColIndex = -1;
  //               //     });
  //               //     Navigator.of(context).pop();
  //               //   },
  //               // ),
  //             ],
  //           );
  //         },
  //       );
  //     },
  //     style: ElevatedButton.styleFrom(
  //       elevation: 4,
  //       primary: Colors.white, // Set the cell color for editable cells
  //     ),
  //     child: Container(
  //       alignment: Alignment.center,
  //       child: Text(
  //         adjacencyMatrix[rowIndex][colIndex].toString(),
  //         style: TextStyle(fontSize: 12, color: Colors.black),
  //       ),
  //     ),
  //   );
  // }

  Future<String> updateAdjacencyMatrix(List<List<int>> matrix, List<String> rowNames, List<String> columnNames) async {
    final String url = 'http://localhost:5000/UpdateMatrix'; // Replace with your actual server URL and endpoint

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

  double calculateCellSize(int cameraCount) {
    const double minCellSize = 80.0;
    const double maxCellSize = 120.0;

    double cellSize = maxCellSize;

    if (cameraCount > 0) {
      cellSize = (400.0 - (cameraCount + 1) * 8.0) / cameraCount;
      cellSize = cellSize.clamp(minCellSize, maxCellSize);
    }

    return cellSize;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
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
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context){
                            return Login();
                          })
                        );
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
                Text('Camera Connections',style: TextStyle(fontSize: 30,color: Colors.blue),),
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
                            });
                          },
                          child: Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: 20,),
                isLoading
                    ? CircularProgressIndicator() // Show a loading indicator
                    :Container(
                      // height: 300,
                      child: GridView.builder(
                                      shrinkWrap: true,
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: camera.length + 1, // Adjust the column count
                      crossAxisSpacing: 8.0, // Adjust spacing between columns
                      mainAxisSpacing: 8.0, // Adjust spacing between rows
                      // childAspectRatio: calculateCellSize(camera.length),
                      // childAspectRatio: .8, // Adjust this value to control the button size
                                      ),
                                      itemCount: (camera.length + 1) * (camera.length + 1), // Include one more row for the headings
                                      itemBuilder: (context, index) {
                      int rowIndex = index ~/ (camera.length + 1);
                      int colIndex = index % (camera.length + 1);
                                        
                      if (rowIndex == 0 && colIndex == 0) {
                        // For the top-left cell
                        return buildTopLeftCell();
                      }
                              
                      // Define the colors for the first row and column
                      Color cellColor = Colors.white;
                      if (rowIndex == 0 || colIndex == 0) {
                        cellColor = Colors.grey[300]!; // Light grey for the first row and column
                      }
                                        
                      if (colIndex == 0) {
                        return GestureDetector(
                          onTap: () {
                            // Handle the tap event for the first column (camera names)
                            // You can add your logic here
                          },
                          child: Container(
                            width: calculateCellSize(camera.length),
                            height: calculateCellSize(camera.length),
                            // width: 120, // Fixed width
                            // height: 50,  // Fixed height
                            color: cellColor, // Set the cell color
                            alignment: Alignment.center,
                            child: Text(
                              camera[rowIndex - 1], // Adjust the index to start one step below
                              style: TextStyle(fontSize: 15, color: Colors.blue),
                            ),
                          ),
                        );
                      }else if (rowIndex == 0) {
                        return GestureDetector(
                          onTap: () {
                            // Handle the tap event for the first row (camera names)
                            // You can add your logic here
                          },
                          child: Container(
                            width: calculateCellSize(camera.length),
                            height: calculateCellSize(camera.length),
                            // width: 120, // Fixed width
                            // height: 50,  // Fixed height
                            color: cellColor, // Set the cell color
                            alignment: Alignment.center,
                            child: Text(
                              camera[colIndex - 1],
                              style: TextStyle(fontSize: 15, color: Colors.blue),
                            ),
                          ),
                        );
                      }
                              
                      // if (colIndex == 0) {
                      //   // Render camera names in the first column
                      //   return ElevatedButton(
                      //     onPressed: () {},
                      //     style: ElevatedButton.styleFrom(
                      //       elevation: 4, // Add elevation
                      //       primary: cellColor, // Set the cell color
                      //     ),
                      //     child: Container(
                      //       alignment: Alignment.center,
                      //       child: Text(
                      //         camera[rowIndex - 1], // Adjust the index to start one step below
                      //         style: TextStyle(fontSize: 15, color: Colors.blue),
                      //       ),
                      //     ),
                      //   );
                      // } else if (rowIndex == 0) {
                      //   // Render camera names in the first row
                      //   return ElevatedButton(
                      //     onPressed: () {},
                      //     style: ElevatedButton.styleFrom(
                      //       elevation: 4, // Add elevation
                      //       primary: cellColor, // Set the cell color
                      //     ),
                      //     child: Container(
                      //       alignment: Alignment.center,
                      //       child: Text(
                      //         camera[colIndex - 1],
                      //         style: TextStyle(fontSize: 15, color: Colors.blue),
                      //       ),
                      //     ),
                      //   );
                      // } 
                      else {
                        return buildEditableCell(rowIndex - 1, colIndex - 1);
                        // // Render adjacency matrix values
                        // return ElevatedButton(
                        //   onPressed: () {},
                        //   style: ElevatedButton.styleFrom(
                        //     elevation: 4, // Add elevation
                        //     primary: cellColor, // Set the cell color
                        //   ),
                        //   child: Container(
                        //     alignment: Alignment.center,
                        //     child: Text(
                        //       adjacencyMatrix[rowIndex - 1][colIndex - 1].toString(),
                        //       style: TextStyle(fontSize: 18, color: Colors.black),
                        //     ),
                        //   ),
                        // );
                      }
                                      },
                                    ),
                    ),
                //  // Your adjacency matrix
                // Table(
                //   defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                //   // border: TableBorder.all(color: Colors.grey), // Add border
                //   children: [
                //     // Additional row with camera names
                //     TableRow(
                //       children: [
                //         TableCell(
                //           child: Container(),
                //         ),
                //         for (var i = 0; i < camera.length; i++)
                //           TableCell(
                //             child: Container(
                //               width: 40,
                //               height: 40,
                //               alignment: Alignment.center,
                //               decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.grey),
                //               ),
                //               child: Text(
                //                 camera[i],
                //                 style: TextStyle(fontSize: 18),
                //               ),
                //             ),
                //           ),
                //       ],
                //     ),
                //     for (var i = 0; i < adjacencyMatrix.length; i++)
                //       TableRow(
                //         children: [
                //           // Additional column with camera names
                //           TableCell(
                //             child: Container(
                //               width: 40,
                //               height: 40,
                //               alignment: Alignment.center,
                //               decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.grey),
                //               ),
                //               child: Text(
                //                 camera[i],
                //                 style: TextStyle(fontSize: 18),
                //               ),
                //             ),
                //           ),
                //           for (var j = 0; j < adjacencyMatrix[i].length; j++)
                //             TableCell(
                //               child: Container(
                //                 width: 40,
                //                 height: 40,
                //                 alignment: Alignment.center,
                //                 decoration: BoxDecoration(
                //                   border: Border.all(color: Colors.grey),
                //                 ),
                //                 child: Text(
                //                   adjacencyMatrix[i][j].toString(),
                //                   style: TextStyle(fontSize: 18),
                //                 ),
                //               ),
                //             ),
                //         ],
                //       ),
                //   ],
                // ),
                
                SizedBox(height: 30,),
                if(buttonState=='Edit')
                GestureDetector(
                  onTap: ()async{
                    // setState(() {
                      if(buttonState=='Add'){
                        // addCameraCost();
                      }
                      else if (buttonState == 'Edit'){
                        // Check if an update is in progress
                        final response = await updateAdjacencyMatrix(adjacencyMatrix, rowNames, columnNames);
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
                SizedBox(height: 20,),
                if(buttonState=='Add')
                  GestureDetector(
                    onTap: (){
                      buttonState='Edit';
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
                          border: Border.all(
                            width: 2, //                   <--- border width here
                            color: Colors.blue,
                          ),
                          // color: Colors.blue,
                        ),
                        child: Center(
                          child: Text(buttonState=='Add'? 'Edit Costs Enable' : 'Edit Costs Disable',style: TextStyle(fontSize: 20,color: Colors.blue),),
                        ),
                      ),
                    )
                  ),
              ]
            ),
          )
        )
      )
    );
  }
}
