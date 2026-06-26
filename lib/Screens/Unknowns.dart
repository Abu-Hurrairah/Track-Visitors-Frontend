import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:project/APIHandler/api.dart';
import 'package:project/CommonUtils.dart/LogoutConfirmationDialog.dart';
import 'package:project/Model/CameraModel.dart';
import 'package:project/Screens/Guard.dart';
import 'package:http/http.dart' as http;

class UnknownsScreen extends StatefulWidget {
  const UnknownsScreen({super.key});

  @override
  State<UnknownsScreen> createState() => _UnknownsScreenState();
}

class _UnknownsScreenState extends State<UnknownsScreen> {
  String? selectedCamera;
  int? selectedCameraId;
  List<String> dropdownCameras=[];
  // String? startDate;
  // String? endDate;
  DateTimeRange? selectedDateRange;
  DateTime? startDate;
  DateTime? endDate;

  List<Map<String, dynamic>> images=[];
  List<String> imageUrls = []; // List to store fetched image URLs
  List<Uint8List> imageBytesList = [];

  List<Camera> cameras = [];
  Future <void> getCameras() async{
    try{
      var request = http.MultipartRequest('GET',Uri.parse('${APIHandler.ip}/GetAllCameras'),);
      var response = await request.send();
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(await response.stream.bytesToString());
        setState(() {
          print(jsonResponse);
          cameras = jsonResponse.map((json) => Camera.fromJson(json)).toList();
          dropdownCameras = cameras.map((camera) => camera.name).toList();
          print(dropdownCameras);
        });
      }
    }catch (e) {
      print('Error submitting form: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    
    getCameras();
    
  }

  int getCameraIdByName(String cameraName) {
    final camera = cameras.firstWhere((camera) => camera.name == cameraName, orElse: () => Camera(id: 0, name: ''));
    return camera.id;
  }

  // Future<void> _selectDate(BuildContext context, {required bool isStartDate}) async {
  //   DateTime? pickedDate = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2101),
  //   );

  //   if (pickedDate != null) {
  //     setState(() {
  //       if (isStartDate) {
  //         startDate = pickedDate.toLocal().toString();
  //       } else {
  //         endDate = pickedDate.toLocal().toString();
  //       }
  //     });
  //   }
  // }

  Future<void> _selectDateRange(BuildContext context) async {
    DateTimeRange? pickedDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDateRange != null) {
      setState(() {
        // selectedDateRange = pickedDateRange;
        // Store only the date part
        startDate = DateTime(pickedDateRange.start.year, pickedDateRange.start.month, pickedDateRange.start.day);
        endDate = DateTime(pickedDateRange.end.year, pickedDateRange.end.month, pickedDateRange.end.day);
      });
    }
  }

  String _formatDate(DateTime date) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    return '${date.year}-${twoDigits(date.month)}-${twoDigits(date.day)}';
  }


  Future<void> fetchDumpImagesList({
    String? camera,
    String? startDate,
    String? endDate,
  }) async {
    final baseUrl = '${APIHandler.ip}'; // Replace with your actual API base URL

    // Construct the endpoint URL with query parameters
    final endpoint = Uri.parse('$baseUrl/GetDumpImagesList?camera=$camera&start_date=$startDate&end_date=$endDate');

    try {
      // Make the HTTP GET request
      final response = await http.get(endpoint);

      if (response.statusCode == 200) {
        // Parse the JSON response
        final Map<String, dynamic> responseData = json.decode(response.body);
        print(responseData);
        images = List<Map<String, dynamic>>.from(responseData['images']);

        setState(() {
          imageUrls = images.map((image) {
            final relativePath = image['full_path'].toString();
            downloadImage(relativePath);
            return '$relativePath';
          }).toList();
          print('sssss');
          print('Constructed Image URLs: $imageUrls');
        });
        // Process and use the fetched data as needed
        print(images);
      } else {
        // Handle error response
        print('Error: ${response.statusCode}');
        print(response.body);
      }
    } catch (e) {
      // Handle network or other errors
      print('Error: $e');
    }
  }

  Future<void> downloadImage(String imagePath) async {
    final baseUrl = '${APIHandler.ip}'; // Replace with your actual server base URL
    final downloadUrl = '$baseUrl/GetDumpImage?path=$imagePath';

    try {
      final response = await http.get(Uri.parse(downloadUrl));

      if (response.statusCode == 200) {
        // Assuming you want to save the image to the device's local storage
        // You can change this part based on your requirements
        final Uint8List bytes = response.bodyBytes;
        // final String fileName = 'downloaded_image.jpg'; // Change the file name as needed

        // final File file = File(fileName);
        // await file.writeAsBytes(bytes);

        // Add the image bytes to the list
        setState(() {
          imageBytesList.add(bytes);
        });

        // Handle the downloaded image file as needed
        print('Image downloaded successfully: $bytes');
      } else {
        // Handle error response
        print('Error downloading image: ${response.statusCode}');
        print(response.body);
      }
    } catch (e) {
      // Handle network or other errors
      print('Error: $e');
    }
  }


  Widget buildImageRows() {
    List<Widget> rows = [];
    for (int i = 0; i < imageUrls.length; i += 3) {
      List<Widget> rowChildren = [];
      for (int j = i; j < i + 3 && j < imageUrls.length; j++) {
        rowChildren.add(
          Image.network(
            imageUrls[j],
            height: 150,
            width: 150,
          ),
        );
      }
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: rowChildren,
        ),
      );
    }
    return Column(children: rows);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
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
                          return GuardScreen();
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
              Text('Unknowns',style: TextStyle(fontSize: 30,color: Colors.blue),),
              SizedBox(height: 30,),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue, // Set the border color
                    width: 1.0, // Set the border width
                  ),
                  borderRadius: BorderRadius.circular(8.0), // Adjust border radius
                ),
                child: DropdownButton<String>(
                  hint: Text('    Select Camera', style: TextStyle(color: Colors.blue),),
                  icon: Icon(Icons.arrow_drop_down, color: Colors.blue),
                  isExpanded: true,
                  value: selectedCamera,
                  items: [
                    if (selectedCamera != null)
                      DropdownMenuItem(
                        child: Text('    ---Select Camera---'),
                        value: null,
                      ),
                    ...dropdownCameras.map((cameraName) {
                      return DropdownMenuItem(
                        child: Text('    $cameraName'),
                        value: cameraName,
                      );
                    }).toList(),
                  ],
                  onChanged: (String? value) {
                    setState(() {
                      selectedCamera = value;
                      print(selectedCamera);
                      if (value != null) {
                        selectedCameraId=getCameraIdByName(value);
                        print(selectedCameraId);
                      }
                    });
                  },
                  underline: SizedBox.shrink(),
                ),
              ),
              SizedBox(height: 10,),
              // Button to select start and end dates
              ElevatedButton(
                onPressed: () async {
                  // await _selectDate(context, isStartDate: true);
                  // await _selectDate(context, isStartDate: false);
                  // print(startDate);
                  // print(endDate);

                  // DateTimeRange? pickedDateRange = await showDateRangePicker(
                  //   context: context,
                  //   firstDate: DateTime(2000),
                  //   lastDate: DateTime(2101),
                  // );

                  // if (pickedDateRange != null) {
                  //   setState(() {
                  //     startDate = pickedDateRange.start;
                  //     endDate = pickedDateRange.end;
                  //   });
                  // }

                  // Show the date range picker
                  await _selectDateRange(context);
                },
                child: Text('Select Dates'),
              ),
              // Display selected start and end dates
              if (startDate != null && endDate != null)
                Text(
                  'Selected Dates: Start - ${_formatDate(startDate!)}, End - ${_formatDate(endDate!)}',
                  style: TextStyle(fontSize: 16),
                ),
              SizedBox(height: 10,),
              ElevatedButton(
                onPressed: () async {
                  if (selectedCameraId != null && startDate != null && endDate != null) {
                    await fetchDumpImagesList(
                      camera: selectedCameraId.toString(),
                      startDate: _formatDate(startDate!),
                      endDate: _formatDate(endDate!),
                    );
                  } else {
                    // Show an error message or handle the case where not all required fields are selected
                    print('Please select a camera and date range.');
                  }
                },
                child: Text('Fetch'),
              ),
              SizedBox(height: 10,),
              ElevatedButton.icon(
                onPressed: (){

                }, 
                icon: Icon(Icons.change_circle), 
                label: Text('Fetch')
              ),
              SizedBox(height: 20),
              Text(
                'Fetched Images:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10,),
              // buildImageRows(),
              // Display fetched images in a GridView
              Container(
                height: 450,
                child: SingleChildScrollView(
                  child: Column(
                    children: List<Widget>.generate(
                      (imageBytesList.length / 3).ceil(), // Calculate the number of rows needed
                      (rowIndex) {
                        final start = rowIndex * 3;
                        final end = (rowIndex + 1) * 3;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List<Widget>.generate(
                            min(3, imageBytesList.length - start),
                            (colIndex) {
                              final index = start + colIndex;
                              return Column(
                                children: [
                                  if (images[index]['date'] != null && images[index]['time'] != null)
                                    Text(
                                      'Date: ${images[index]['date']}',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  if (images[index]['date'] != null && images[index]['time'] != null)
                                    Text(
                                      'Time: ${images[index]['time']}',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  SizedBox(height: 5),
                                  Container(
                                    height: 250,
                                    width: 110,
                                    child: Image.memory(
                                      imageBytesList[index],
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  SizedBox(height: 10,)
                                ],
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // child: GridView.builder(
                //   shrinkWrap: true,
                //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //     crossAxisCount: 3, // 3 images per row
                //     crossAxisSpacing: 8.0,
                //     mainAxisSpacing: 8.0,
                //   ),
                //   itemCount: imageUrls.length,
                //   itemBuilder: (BuildContext context, int index) {
                //     if (index < imageBytesList.length) {
                //       return Image.memory(
                //         imageBytesList[index],
                //         height: 150,
                //         width: 150,
                //         fit: BoxFit.fill, // Use BoxFit to adjust how the image should be fitted
                //       );
                //     } else {
                //       return Container(); // or any placeholder widget when the list is empty
                //     }
                //     // You might need to adjust the key based on the actual structure of your data
                //   },
                // ),
              ),
            ]
          )
        )
      )
    );
  }
}