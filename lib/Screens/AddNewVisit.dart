import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:project/APIHandler/api.dart';
import 'package:project/Global/GuardGlobal.dart';
// import 'package:project/Global/VisitorVisitData.dart';
import 'package:project/Model/LocationModel.dart';
import 'package:project/Model/PictureModel.dart';
import 'package:project/Model/VisitorModel.dart';
import 'package:project/Screens/DestinationPaths.dart';
import 'package:project/Screens/DetectedCameras.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:provider/provider.dart';

class AddNewVisitScreen extends StatefulWidget {
  const AddNewVisitScreen({super.key});

  @override
  State<AddNewVisitScreen> createState() => _AddNewVisitScreenState();
}

class _AddNewVisitScreenState extends State<AddNewVisitScreen> {
//   TextEditingController _searchController = TextEditingController();
//   TextEditingController time_Controller = TextEditingController();
//   bool _showDropdown = false;
//   // List<String> _dropdownValues = ['Option 1', 'Option 2', 'Option 3'];
//   late List<String> _dropdownValues;
//   List<String> _filteredValues = [];
//   String? selectedDestination;
//   // List<String> dropdownOptions = ['Admin', 'Datacell', 'Conference Room','Lab-1','Lab-2'];
//   List<String> dropdownOptions=[];
//   List<String> sourceList=['Main Gate','Back Gate'];
//   String? selectedSource;
//   bool isSending = false;
//   @override
//   void initState() {
//     super.initState();
//     getVisitors();
//     // getVisitorPicture();
//     getLocations();
//     _searchController.addListener(() {
//       setState(() {
//         _showDropdown = _searchController.text.isNotEmpty;
//         if(_dropdownValues!=null){
//           _filteredValues = _dropdownValues
//             .where((value) =>
//                 value.toLowerCase().contains(_searchController.text.toLowerCase()))
//             .toList();
//         }
//         else{
//           print('object');
//         }
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   Future<void> tracking() async {
//     String visitor = _searchController.text;
//     String entry_time = time_Controller.text;
//     String destination=selectedDestination!;

//     if (visitor.isEmpty || entry_time.isEmpty || destination.isEmpty) {
//       print('NO selected');
//       return ;
//     }
//     try{
//       var response=await APIHandler.addVisit(visitor, entry_time, destination);
//       if (response.statusCode == 200) {
//         // Success! Handle accordingly
//         // Navigator.of(context).push(
//         //   MaterialPageRoute(builder: (context){
//         //     return DetectedCamerasScreen(response);
//         //   })
//         // );
//         print('Data submitted successfully');
//       } else {
//         // Error occurred, handle accordingly
//         print('Data submission error: ${response.reasonPhrase}');
//       }
//     }catch (e) {
//       print('Error submitting form: $e');
//     }
//   }
// // void fetchData() async {
// //   var url = Uri.parse('http://localhost:5000/StartVisit'); // Replace with your API URL
// //   var headers = {'Content-Type': 'application/json'}; // Set the headers

// //   var data = {
// //     'id': '123',
// //     'starttime': '9:03 AM',
// //     'destination': 'Admin',
// //   }; // Replace with your JSON data

// //   // Send the POST request
// //   var response = await http.post(
// //     url,
// //     headers: headers,
// //     body: jsonEncode(data),
// //   );

// //   if (response.statusCode == 200) {
// //     // If the server returns a 200 OK response
// //     Map<String, dynamic> jsonData = json.decode(response.body);
// //     print(jsonData);
// //     // Now you can process and use the data in jsonData
// //     List<List<String>> paths = [];
// //     if (jsonData.containsKey('paths')) {
// //       paths = (jsonData['paths'] as List)
// //           .map((path) => List<String>.from(path))
// //           .toList();
// //     }
// //     String source = jsonData['source'] ?? '';
// //     // Use the extracted data as needed
// //     print('Paths: $paths');
// //     print('Source: $source');
// //   } else {
// //     // If the server returns an error response
// //     print('Request failed with status: ${response.statusCode}');
// //   }
// // }
//   void _tracking() async {
//   if (_searchController.text.isEmpty ||time_Controller.text.isEmpty) {
//     // Display form validation error
//     // ...
//     return;
//   } 
//   else {
//     setState(() {
//       isSending = true; // Start sending, disable the button
//     });
//       try {
//         // var request = http.MultipartRequest('POST',Uri.parse('http://localhost:5000/StartVisit'),);
//         // request.fields['id'] = _searchController.text;
//         // request.fields['starttime'] = time_Controller.text;
//         // request.fields['destination'] = selectedDestination!;
//         var data = {
//           'id': _searchController.text,
//           'starttime': time_Controller.text,
//           'destination': selectedDestination,
//         };

//         var headers = {
//           'Content-Type': 'application/json', // Set the content type header
//         };
//         var response = await http.post(
//           Uri.parse('http://localhost:5000/StartVisit'),
//           headers: headers, // Set the headers in the request
//           body: jsonEncode(data), // Encode the data to JSON format
//         );
//         // var response = await request.send();
//         // print(headers);
//         // print(data);
//         // print(json.encode(data));

//         if (response.statusCode == 200) {
//           print(response.body); // Print the response body for debugging
          
//           // Parse the JSON response body
//           Map<String, dynamic> jsonData = jsonDecode(response.body);
          
//           // Extract the 'paths' list from the JSON data
//           List<List<String>> paths = [];
//           if (jsonData.containsKey('paths')) {
//             paths = (jsonData['paths'] as List)
//                 .map((path) => List<String>.from(path))
//                 .toList();
//           }
//           String source = jsonData['source'] ?? '';
//           // Use the extracted data as needed
//           print('Paths: $paths');
//           print('Source: $source');
//           // Navigate to the next screen with the extracted data

//           showDialog(
//             context: context,
//             builder: (context) {
//               return AlertDialog(
//                 title: Text('Success'),
//                 content: Text('Visit is added successfully'), // Your custom success message
//                 actions: <Widget>[
//                   TextButton(
//                     onPressed: () {
//                       // Navigate to the AddNewVisitScreen or perform other actions as needed
//                       setState(() {
//                         Navigator.of(context).pop();
//                       });
                      
//                       // Navigator.of(context).push(
//                       //   MaterialPageRoute(builder: (context) {
//                       //     return DetectedCamerasScreen(paths,int.parse(_searchController.text),time_Controller.text); // Pass the extracted data to the next screen
//                       //   }),
//                       // );
                      
//                     },
//                     child: Text('OK'),
//                   ),
//                 ],
//               );
//             },
//           );

//           // Navigator.of(context).push(
//           //   MaterialPageRoute(builder: (context) {
//           //     return DetectedCamerasScreen(paths,int.parse(_searchController.text),time_Controller.text); // Pass the extracted data to the next screen
//           //   }),
//           // );
//           } else {
//             print('API request failed with status code: ${response.statusCode}');
//             showDialog(
//               context: context,
//               builder: (context) {
//                 return AlertDialog(
//                   title: Text('Error'),
//                   content: Text('API request failed with status code: ${response.statusCode}'), // Your custom success message
//                   actions: <Widget>[
//                     TextButton(
//                       onPressed: () {
//                         // Navigate to the AddNewVisitScreen or perform other actions as needed
//                         Navigator.of(context).pop();
//                       },
//                       child: Text('OK'),
//                     ),
//                   ],
//                 );
//               },
//             );
//           }
//         // if (response.statusCode == 200) {
//         //   print(response.body);
//         //   Navigator.of(context).push(
//         //     MaterialPageRoute(builder: (context){
//         //       return DetectedCamerasScreen(response.body);
//         //     })
//         //   );
//           // Success! Display success dialog and reset fields
//           // ...
        
//       } catch (error) {
//         // Handle network or API call error
//         // ...
//       }finally{
//         setState(() {
//           isSending = false; // Response received, enable the button
//         });
//       }
//     }
//   }

//   List<Visitor> visitors = [];
//   Future <void> getVisitors() async{
//     try{
//       var request = http.MultipartRequest('GET',Uri.parse('http://localhost:5000/GetAllVisitors'),);
//       var response = await request.send();
//       if (response.statusCode == 200) {
//         final List<dynamic> jsonResponse = json.decode(await response.stream.bytesToString());
//         setState(() {
//           visitors = jsonResponse.map((json) => Visitor.fromJson(json)).toList();
//           _dropdownValues = visitors.map((visitor) => visitor.name).toList();
//           print('');
//         });
//       }
//     }catch (e) {
//       print('Error submitting form: $e');
//     }
//   }

//   late List<dynamic> pictures;
//   Future <void> getVisitorPicture() async{
//     try{
//       var request = http.MultipartRequest('GET',Uri.parse('http://localhost:5000/get_all_pictures'),);
//       var response = await request.send();
//       if (response.statusCode == 200) {
//         final List<dynamic> jsonResponse = json.decode(await response.stream.bytesToString());
//         setState(() {
//           pictures = jsonResponse.map((json) => Picture.fromJson(json)).toList().reversed.toList();//.sort((a , b
//         });
//       }
//     }catch (e) {
//       print('Error submitting form: $e');
//     }
//   }

//   var displayedImage;
//   Uint8List? visitorImageBytes;
//   Future<void> fetchImage(int visitorId) async {
//     final response = await http.get(Uri.parse('http://localhost:5000/get_image/$visitorId'));

//     if (response.statusCode == 200) {
      
//       print(visitorImageBytes.runtimeType);
//       setState(() {
//         visitorImageBytes = response.bodyBytes;
//       });
//       // Display the image using Image.memory or Image.file
//       // setState(() {
//       //   displayedImage = Image.memory(imageBytes);
//       //   print(displayedImage.runtimeType);
//       // });
//     } else {
//       // Handle errors or show a placeholder image
//     }
//   }


//   List<Location> locations = [];
//   Future <void> getLocations() async{
//     print('loc running');
//     try{
//       // var response = await http.get(Uri.parse('http://localhost:5000/GetAllLocations'));
//       // print(response.statusCode);
//       // if (response.statusCode == 200) {
//       //   final List<dynamic> jsonResponse = json.decode(response.body);
//       //   setState(() {
//       //     locations = jsonResponse.map((json) => Location.fromJson(json)).toList();
//       //     print(locations);
//       //     dropdownOptions = locations.map((location) => location.name).toList();
//       //     print(dropdownOptions);
//       //   });
//       // }
//       var request = http.MultipartRequest('GET',Uri.parse('http://localhost:5000/GetAllLocations'),);
//       var response = await request.send();
//       print(response.statusCode);
//       if (response.statusCode == 200) {
//         final List<dynamic> jsonResponse = json.decode(await response.stream.bytesToString());
//         print(jsonResponse);
//         setState(() {
//           locations = jsonResponse.map((json) => Location.fromJson(json)).toList();
//           print(locations);
//           dropdownOptions = locations.map((location) => location.name).toList();
//           print(dropdownOptions);
//         });
//       }
//     }catch (e) {
//       print('Error submitting form: $e');
//     }
//   }


TextEditingController _searchController = TextEditingController();
  TextEditingController time_Controller = TextEditingController();
  bool _showDropdown = false;
  late List<String> _dropdownValues;
  List<String> _filteredValues = [];
  String? selectedDestination;
  List<String> selectedDestinations = [];
  Set<String> selectDestinations={};
  List<String> dropdownOptions=[];
  List<String> sourceList=[];
  String? selectedSource;
  bool isSending = false;
  int user_id=GuardGlobal.guardGlobalId!;
  Timer? _timeUpdateTimer;
  FocusNode _searchFocusNode = FocusNode();
  int? visitorId;
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    getVisitors();
    getLocations();  // This Function Has CircularProgressIndicator()
    // getAllCamerasAndLocations();
    print(GuardGlobal.guardGlobalId);
    _searchController.addListener(() {
      setState(() {
        _showDropdown = _searchController.text.isNotEmpty;
        if(_dropdownValues!=null){
          _filteredValues = _dropdownValues
            .where((value) =>
                value.toLowerCase().contains(_searchController.text.toLowerCase()))
            .toList();
        }
        else{
          print('object');
        }
      });
    });
    // Create a timer that updates the time every second.
    _timeUpdateTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!time_Controller.text.isEmpty) {
        // Calculate the next time value
        TimeOfDay currentTime = TimeOfDay.now();
        setState(() {
          time_Controller.text = currentTime.format(context);
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _timeUpdateTimer?.cancel();
    super.dispose();
  }

  int getLocationIdByName(String name) {
    print('g');
    final location = locations.firstWhere((loc) => loc.name == name);
    print(location);
    return location != null ? location.id : -1; // Return -1 if not found (handle error)
  }

  List<int> getLocationIdsByNames(List<String> names) {
    print('s');
    List<int> ids = [];
    selectDestinations=names.toSet();
    print(selectDestinations);
    for (String name in selectDestinations) {
      final location = locations.firstWhere((loc) => loc.name == name);
      if (location != null) {
        ids.add(location.id);
        print('starting');
      } else {
        // Handle the case where a location name is not found
        ids.add(-1); // Or any other error handling logic
      }
    }

    return ids;
  }

  Future<bool> checkVisitorBlocked(String visitorId) async {

    try {
      final Uri uri = Uri.parse('${APIHandler.ip}/CheckVisitorBlocked/$visitorId'); // Include visitorId in the URL

      // Send a GET request
      final http.Response response = await http.get(uri);

      if (response.statusCode == 200) {
        // Parse the JSON response
        final dynamic responseData = json.decode(response.body);
        print(responseData);

        // Check if the visitor is blocked
        bool isBlocked = responseData['blocked'] ?? false;

        if (isBlocked) {
          // Show dialog based on the visitor status
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Visitor Status'),
                content: Text('Visitor is Blocked'),
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
        else{
          print('Visitor Is Not Block');
        }

        return isBlocked;
      } else {
        // Handle the case where the request fails
        print('Failed to check visitor status: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print('Error: $error');
      // Handle the error as needed

      // Show an error dialog for network or other errors
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to check visitor status.$error'),
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

      return false;
    }
  }



  void _tracking() async {
    print('start');
    print(_searchController.text);
    print(time_Controller.text);
    if (_searchController.text.isEmpty ||time_Controller.text.isEmpty) {
      print('end');
      return;
    } 
    else {
      print('Starting');
      bool block=await checkVisitorBlocked(visitorId.toString());
      if(block){
        print('Visitor Is Block');
        _searchController.clear();
        time_Controller.clear();
        selectedDestinations=[];
        visitorImageBytes=null;
        time_Controller.text='';
        _filteredValues=[];
        selectedDestination=null;
      }
      else{
        setState(() {
          isSending = true;
        });
          try {
            print('a');
            // final sourceId = getLocationIdByName(selectedSource!);
            final sourceId=GuardGlobal.guardGlobalDutyLocation!;
            // final destinationId = getLocationIdByName(selectedDestination!);
            print('sourceId');
            print(sourceId);
            // print(destinationId);
            print('q');
            // Get the IDs for selected destinations
            List<int> selectedDestinationIds = getLocationIdsByNames(selectedDestinations);
            print(selectedDestinationIds);

            var data = {
              // 'id': int.parse(_searchController.text),
              'id': visitorId,
              'starttime': time_Controller.text,
              'destinations': selectedDestinationIds,
              'source': sourceId,
              'user_id': user_id,
            };
            print(data);

            // var data = {
            //   'id': _searchController.text,
            //   'starttime': time_Controller.text,
            //   'destination': destinationId,
            //   'source':sourceId,
            //   'user_id':user_id,
            // };
            // var data = {
            //   'id': _searchController.text,
            //   'starttime': time_Controller.text,
            //   'destination': selectedDestination,
            //   'source':selectedSource,
            //   'user_id':user_id,
            // };
            // print(data);
            print(jsonEncode(data));
            var headers = {
              'Content-Type': 'application/json',
            };
            var response = await http.post(
              Uri.parse('${APIHandler.ip}/StartVisitWithThreads'),
              headers: headers,
              body: jsonEncode(data),
            );

            if (response.statusCode == 200) {
              print(response.body);
              String jsonResponse=response.body;
              Map<String, dynamic> jsonData = jsonDecode(response.body);
              List<List<String>> paths = [];
              if (jsonData.containsKey('paths')) {
                paths = (jsonData['paths'] as List)
                    .map((path) => List<String>.from(path))
                    .toList();
              }
              List<List<String>> locationPaths = [];
              if (jsonData.containsKey('locationPaths')) {
                locationPaths = (jsonData['locationPaths'] as List)
                    .map((locationPath) => List<String>.from(locationPath))
                    .toList();
                }
                String source = jsonData['source'] ?? '';
                print('Paths: $paths');
                print('Source: $source');
                print('Location Paths: $locationPaths');
                print('Visitor Id: $visitorId');

                // Save data in shared preferences with a visitor-specific key
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String visitorKey = 'visitor_$visitorId';
                prefs.setString('$visitorKey.jsonResponse', jsonResponse);
                prefs.setInt('$visitorKey.visitorId', visitorId!);
                prefs.setString('$visitorKey.visitTime', time_Controller.text);
                print(prefs);

                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Success'),
                      content: Text('Visit is added successfully'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            setState(() {
                              Navigator.of(context).pop();
                            });
                            
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) {
                                return DestinationPathsScreen(locationPaths,paths,visitorId!,time_Controller.text);
                              }),
                            );
                            
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(builder: (context) {
                            //     return DetectedCamerasScreen(paths,visitorId!,time_Controller.text);
                            //     // return DetectedCamerasScreen(paths,int.parse(_searchController.text),time_Controller.text);
                            //   }),
                            // );

                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              } else {
                print('API request failed with status code: ${response.statusCode}');
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Error'),
                      content: Text('API request failed with status code: ${response.statusCode}'),
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
          catch (error) {
            
          }finally{
            setState(() {
              isSending = false;
            });
          }
        }
      }
    }

  List<Visitor> visitors = [];
  Future <void> getVisitors() async{
    try{
      var request = http.MultipartRequest('GET',Uri.parse('${APIHandler.ip}/GetAllVisitors'),);
      var response = await request.send();
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(await response.stream.bytesToString());
        setState(() {
          visitors = jsonResponse.map((json) => Visitor.fromJson(json)).toList();
          _dropdownValues = visitors.map((visitor) => visitor.name).toList();
          print(jsonResponse);
        });
      }
    }catch (e) {
      print('Error submitting form: $e');
    }
  }

  late List<dynamic> pictures;
  Future <void> getVisitorPicture() async{
    try{
      var request = http.MultipartRequest('GET',Uri.parse('${APIHandler.ip}/get_all_pictures'),);
      var response = await request.send();
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(await response.stream.bytesToString());
        setState(() {
          pictures = jsonResponse.map((json) => Picture.fromJson(json)).toList().reversed.toList();//.sort((a , b
        });
      }
    }catch (e) {
      print('Error submitting form: $e');
    }
  }

  var displayedImage;
  Uint8List? visitorImageBytes;
  Future<void> fetchImage(int visitorId) async {
    final response = await http.get(Uri.parse('${APIHandler.ip}/VisitorImages/$visitorId'));

    if (response.statusCode == 200) {
      
      print(visitorImageBytes.runtimeType);
      setState(() {
        // visitorImageBytes = response.bodyBytes;
        visitorImageBytes = Uint8List.fromList(base64.decode(json.decode(response.body)['image']));
      });
    } else {
    }
  }


//   Future<void> getAllCamerasAndLocations() async {
//   try {
//     // Step 1: Get all cameras
//     final camerasResponse = await http.get(Uri.parse('${APIHandler.ip}/GetAllCameras'));
//     final List<dynamic> cameras = jsonDecode(camerasResponse.body);

//     // Step 2: Get locations for each camera
//     final List<dynamic> locations = [];
//     for (final camera in cameras) {
//       final cameraName = camera['name'];
//       final locationResponse = await http.get(Uri.parse('${APIHandler.ip}/GetLocationByCamera/$cameraName'));
//       final List<dynamic> cameraLocations = jsonDecode(locationResponse.body);
//       locations.addAll(cameraLocations);
//     }
//     // print(locations);
//     // dropdownOptions = locations;
//     dropdownOptions = locations
//     .where((location) => location['LocationType'] != 'Gate') // Exclude locations with 'Gate' type
//     .map((location) => location['LocationName']?.toString()) // Cast to String or null
//     .where((name) => name != null) // Filter out null values
//     .cast<String>() // Cast to List<String>
//     .toList();
//     print(dropdownOptions);
//     // Print or use the 'cameras' and 'locations' lists as needed
//     print('Cameras: $cameras');
//     print('Locations: $locations');
//   } catch (e) {
//     print('Error: $e');
//   }
// }

  List<Location> locations = [];
  Future <void> getLocations() async{
    print('loc running');
    try{
      var request = http.MultipartRequest('GET',Uri.parse('${APIHandler.ip}/GetAllLocations'),);
      var response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(await response.stream.bytesToString());
        print(jsonResponse);
        setState(() {
          locations = jsonResponse.map((json) => Location.fromJson(json)).toList();
          print(locations);

          // Filter locations with type "gate"
          List<Location> gateLocations = locations.where((location) => location.type == 'Gate').toList();
          // Create a list of location names with type "gate" for the sourceList
          sourceList = gateLocations.map((location) => location.name).toList();
          print(gateLocations);
          print(sourceList);
          dropdownOptions = locations.where((location) => location.type != 'Gate').map((location) => location.name).toList();
          dropdownOptions = locations.where((location) => location.isDestination != '0').map((location) => location.name).toList();
          // dropdownOptions = locations.map((location) => location.name).toList();
          print(dropdownOptions);
          isLoading = false; // Data is loaded, set loading state to false
          // sourceList = locations.map((location) => location.name).toList();
        });
      }
    }catch (e) {
      print('Error submitting form: $e');
      isLoading = false; // Data is loaded, set loading state to false
    }
  }

  File? _image;
  // Function to open the camera
  Future<void> _openCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      // Display loading dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Please wait...'),
              ],
            ),
          );
        },
      );

      try {
        // Call the API here
        await _callApi();
      } finally {
        // Close the loading dialog
        Navigator.pop(context);
      }
    }
    setState(() {
      
    });
  }

  Future<void> _openGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      // Display loading dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Please wait...'),
              ],
            ),
          );
        },
      );

      try {
        // Call the API here
        await _callApi();
      } finally {
        // Close the loading dialog
        Navigator.pop(context);
      }
    }
    setState(() {
      
    });
  }

  Future<void> _callApi() async {
    print(_image);
    print(_image!.path);
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${APIHandler.ip}/GetVisitorWithImage'), // your API endpoint
      );

      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          _image!.path,
        ),
      );

      var response = await request.send();

      if (response.statusCode == 200) {
        var jsonResponse = await response.stream.bytesToString();
        var data = json.decode(jsonResponse);
        print(data);
        // Handle the response data as needed

        // Assuming data is a list and you want to set the "name" property
        if (data.isNotEmpty) {
          setState(() {
            _searchController.text = data[0]['name'];
            fetchImage(data[0]['id']);
            visitorId=data[0]['id'];
            TimeOfDay _time = TimeOfDay.now();
            time_Controller.text=_time.format(context);
            _filteredValues.clear();
          });
        }

      } else {
        print('Failed to call API. Status code: ${response.statusCode}');
        Future.delayed(Duration.zero, () {
          _searchController.text='';
          time_Controller.text='';
          _filteredValues=[];
          visitorImageBytes=null;
          // Navigator.pop(context);
          showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('The visitor with the provided image was not found.'),
              // content: Text('Failed to call the API. Status code: ${response.statusCode}'),
              actions: [
                TextButton(
                  onPressed: () {
                    
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        });
        // Handle error
        // Show an error dialog
        
        
      }
    } catch (e) {
      print('An error occurred while calling the API: $e');
      // Handle error
    }
  }


  Future<void> _showDropDownDialog(BuildContext context) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text("Select Destinations"),
            content: Container(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    for (Location location in locations)
                      CheckboxListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(location.name),
                            Text(
                              // location.restrict ? 'Restricted' : 'Not Restricted',
                              location.restrict ? 'R' : 'NR',
                              style: TextStyle(
                                color: location.restrict ? Colors.red : Colors.green,
                              ),
                            ),
                          ],
                        ),
                        value: selectedDestinations.contains(location.name),
                        onChanged: location.restrict
                          ? null // Disable the checkbox if location is restricted
                          : (bool? value) {
                              setState(() {
                                if (value != null) {
                                  if (value) {
                                    selectedDestinations.add(location.name);
                                    selectDestinations.add(location.name);
                                  } else {
                                    selectedDestinations.remove(location.name);
                                    selectDestinations.remove(location.name);
                                  }
                                }
                              });
                            },
                        // onChanged: (bool? value) {
                        //   setState(() {
                        //     if (value != null) {
                        //       if (value) {
                        //         selectedDestinations.add(location.name);
                        //         selectDestinations.add(location.name);
                        //       } else {
                        //         selectedDestinations.remove(location.name);
                        //         selectDestinations.remove(location.name);
                        //       }
                        //     }
                        //   });
                        // },
                      ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    selectedDestination =
                        selectedDestinations.isNotEmpty ? selectedDestinations.join(', ') : null;
                    print(selectedDestinations);
                    print(selectDestinations);
                  });
                  Navigator.pop(context);
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    },
  );
}
  // Future <void> _showDropDownDialog(BuildContext context) async {
  //   await showDialog(
  //     context: context,
  //     barrierDismissible: false, // Set to false to disable closing on tap outside
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //         builder: (context, setState) {
  //           return AlertDialog(
  //             title: Text("Select Destinations"),
  //             content: Container(
  //               width: double.maxFinite,
  //               child: SingleChildScrollView(
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: <Widget>[
  //                     for (String destination in dropdownOptions)
  //                       CheckboxListTile(
  //                         title: Text(destination),
  //                         value: selectedDestinations.contains(destination),
  //                         onChanged: (bool? value) {
  //                           setState(() {
  //                             if (value != null) {
  //                               if (value) {
  //                                 selectedDestinations.add(destination);
  //                                 selectDestinations.add(destination);
  //                                 // selectedDestination = '$destination, ';
  //                                 // setState((){});
  //                                 // print(selectDestinations);
  //                               } else {
  //                                 selectedDestinations.remove(destination);
  //                                 selectDestinations.remove(destination);
  //                               }
  //                             }
  //                           });
  //                         },
  //                       ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             actions: [
  //               // TextButton(
  //               //   onPressed: () {
  //               //     setState((){});
  //               //     Navigator.pop(context);
  //               //   },
  //               //   child: Text("Cancel"),
  //               // ),
  //               TextButton(
  //                 onPressed: () {
  //                   setState(() {
  //                     selectedDestination = selectedDestinations.isNotEmpty ? selectedDestinations.join(', ') : null;
  //                     print(selectedDestinations);
  //                     print(selectDestinations);
  //                   });
  //                   Navigator.pop(context);
  //                 },
  //                 child: Text("OK"),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     },
  //   );
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add New Visit',style: TextStyle(fontSize: 30),)),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: isLoading?Center(child: CircularProgressIndicator()):SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Text('Scan Visitor',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),)),
              SizedBox(height: 10,),
              Center(
                child: GestureDetector(
                  onTap: (){
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.camera),
                              title: Text('Camera'),
                              onTap: () {
                                _openCamera();
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.image),
                              title: Text('Gallery'),
                              onTap: () {
                                _openGallery();
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder()
                    ),
                    child: _image == null
                      ? Icon(Icons.person, size: 40)
                      : Image.file(
                          _image!,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                    ),
                ),
              ),
              SizedBox(height: 20,),
              Text('Select Visitor',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
              SizedBox(height: 5,),
              Container(
                child: TextFormField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  decoration: InputDecoration(
                    hintText: 'Select Visitor',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          visitorImageBytes=null;
                          time_Controller.text='';
                          _filteredValues=[];
                          selectedDestinations=[];
                          selectedDestination=null;
                        });
                        _searchFocusNode.unfocus(); // Unfocus the TextFormField
                      },
                    ),
                    prefixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: getVisitors,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              if (_filteredValues.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      for (Visitor visitor in visitors)
                    if (_filteredValues.contains(visitor.name))
                      ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(visitor.name),
                            Text(
                              visitor.block=='True' ? 'Blocked' : 'Not Blocked',
                              style: TextStyle(
                                color: visitor.block=='True' ? Colors.red : Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          setState(() {
                            int id = visitor.id;
                            fetchImage(id);
                            visitorId = id;
                            print(visitorId);
                            _searchController.text = visitor.name;
                            TimeOfDay _time = TimeOfDay.now();
                            time_Controller.text = _time.format(context);
                            _filteredValues.clear();
                            _searchFocusNode.unfocus();
                          });
                        },
                      ),
                      // for (String value in _filteredValues)
                      //   ListTile(
                      //     title: Text(value),
                      //     onTap: () {
                      //       setState(() {
                      //         // _searchController.text = visitors.firstWhere((visitor) => visitor.name == value).id.toString();
                      //         // int v_id=int.parse(_searchController.text);
                      //         // fetchImage(v_id);
                      //         int id=visitors.firstWhere((visitor) => visitor.name == value).id;
                      //         fetchImage(id);
                      //         visitorId=id;
                      //         print(visitorId);
                      //         _searchController.text = visitors.firstWhere((visitor) => visitor.name == value).name;
                      //         // String visitorName = visitors.firstWhere((visitor) => visitor.name == value).name;
                      //         // _searchController.text = visitorName;
                      //         TimeOfDay _time = TimeOfDay.now();
                      //         time_Controller.text=_time.format(context);
                      //         _filteredValues.clear();
                      //         _searchFocusNode.unfocus(); // Unfocus the TextFormField
                      //       });
                      //     },
                      //   ),
                    ],
                  ),
                ),
              SizedBox(height: 20),
              if (visitorImageBytes != null)
                Image.memory(visitorImageBytes!,
                  errorBuilder: (context, error, stackTrace) {
                    print('Error loading image: $error');
                    return Text('Error loading image');
                  },
                ),
              SizedBox(height: 20,),
              Text('Entry Time',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
              SizedBox(height: 5,),
              TextFormField(
                controller: time_Controller,
                // readOnly: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder()
                ),
              ),
              // SizedBox(height: 20),
              // Text('Source',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
              // SizedBox(height: 5,),
              // Container(
              //   decoration: BoxDecoration(
              //     border: Border.all(color: Colors.black),
              //   ),
              //   child: Padding(
              //     padding: const EdgeInsets.all(4.0),
              //     child: DropdownButton(
              //       underline: DropdownButtonHideUnderline(child: Container()),
              //         hint: Text('  Select Source'),
              //         icon: Icon(Icons.arrow_drop_down),
              //         isExpanded: true,
              //         value: selectedSource,
              //         items: sourceList.map((e) => DropdownMenuItem(
              //           child: Text(e),
              //           value: e,
              //         )).toList(), 
              //         onChanged: (String? value){
              //           setState(() {
              //             selectedSource=value;
              //             print(value);
              //           });
              //         }
              //       ),
              //   ),
              // ),
              SizedBox(height: 20),
              Text('Destination',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
              SizedBox(height: 5,),
              GestureDetector(
                onTap: () async {
                  await _showDropDownDialog(context);
                  setState(() {
                    
                  });
                },
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(selectedDestination?.isNotEmpty == true ? selectedDestination! : 'Select Destination')),
                        // Text(selectedDestination ?? 'Select Destination'),
                        Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
              ),
              // Container(
              //   decoration: BoxDecoration(
              //     border: Border.all(color: Colors.black),
              //   ),
              //   child: Padding(
              //     padding: const EdgeInsets.all(4.0),
              //     child: DropdownButton(
              //       underline: DropdownButtonHideUnderline(child: Container()),
              //         hint: Text('  Select Destination'),
              //         icon: Icon(Icons.arrow_drop_down),
              //         isExpanded: true,
              //         value: selectedDestination,
              //          items: dropdownOptions.map((e) => DropdownMenuItem(
              //           child: Text(e),
              //           value: e,
              //         )).toList(),
              //         onChanged: (String? value){
              //           setState(() {
              //             selectedDestination=value;
              //             selectedDestinations.add(value!);
              //             print(selectedDestination);
              //             print(selectedDestinations);
              //           });
              //         }
              //       ),
              //   ),
              // ),
              SizedBox(height: 20,),
              GestureDetector(
                // onTap: (){
                //   tracking();
                // },
                onTap: isSending ? null: _tracking,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      // color: Colors.blue
                      color: isSending ? Colors.grey : Colors.blue,
                    ),
                    child: Center(
                      child: isSending ? Text('Visit Adding...',style: TextStyle(color: Colors.white)):Text('Add Visit',style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      // appBar: AppBar(title: Text('Add New Visit',style: TextStyle(fontSize: 30),)),
      // body: Padding(
      //   padding: EdgeInsets.all(20),
      //   child: SingleChildScrollView(
      //     scrollDirection: Axis.vertical,
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         Text('Select Visitor',style: TextStyle(color: Colors.blue,fontSize: 15,fontWeight: FontWeight.bold),),
      //         SizedBox(height: 5,),
      //         Container(
      //           // padding: const EdgeInsets.symmetric(horizontal: 8.0),
      //           child: TextFormField(
      //             controller: _searchController,
      //             decoration: InputDecoration(
      //               hintText: 'Select Visitor',
      //               hintStyle: TextStyle(color: Colors.blue),
      //               suffixIcon: IconButton(
      //                 icon: Icon(Icons.clear,color: Colors.blue,),
      //                 onPressed: () {
      //                   _searchController.clear();
      //                   setState(() {
      //                     visitorImageBytes=null;
      //                   });
      //                 },
      //               ),
      //               prefixIcon: IconButton(
      //                 icon: Icon(Icons.search,color: Colors.blue,),
      //                 // onPressed: () {

      //                 //   // Perform the search here
      //                 // },
      //                 onPressed: getVisitors,
      //               ),
      //               border: OutlineInputBorder(
      //                 // borderRadius: BorderRadius.circular(20.0),
      //               ),
      //             ),
      //           ),
      //         ),
      //         if (_filteredValues.isNotEmpty)
      //           Container(
      //             padding: EdgeInsets.symmetric(horizontal: 16.0),
      //             child: Column(
      //               children: [
      //                 for (String value in _filteredValues)
      //                   ListTile(
      //                     title: Text(value),
      //                     onTap: () {
      //                       setState(() {
      //                         _searchController.text = visitors.firstWhere((visitor) => visitor.name == value).id.toString();
      //                         int v_id=int.parse(_searchController.text);
      //                         fetchImage(v_id);
      //                         TimeOfDay _time = new TimeOfDay.now();
      //                         time_Controller.text=_time.format(context);
      //                         _filteredValues.clear();
      //                       });
      //                     },
      //                   ),
      //               ],
      //             ),
      //           ),
      //         SizedBox(height: 20),
      //         if (visitorImageBytes != null)
      //           Image.memory(visitorImageBytes!,
      //             errorBuilder: (context, error, stackTrace) {
      //               print('Error loading image: $error');
      //               return Text('Error loading image');
      //             },
      //           ),
      //         SizedBox(height: 20,),
      //         Text('Entry Time',style: TextStyle(color: Colors.blue,fontSize: 15,fontWeight: FontWeight.bold)),
      //         SizedBox(height: 5,),
      //         TextFormField(
      //           controller: time_Controller,
      //           decoration: InputDecoration(
      //             border: OutlineInputBorder()
      //           ),
      //         ),
      //         SizedBox(height: 20),
      //         Text('Source',style: TextStyle(color: Colors.blue,fontSize: 15,fontWeight: FontWeight.bold)),
      //         SizedBox(height: 5,),
      //         Container(
      //           decoration: BoxDecoration(
      //             border: Border.all(color: Colors.blue), // Add border here
      //           ),
      //           child: Padding(
      //             padding: const EdgeInsets.all(4.0),
      //             child: DropdownButton(
      //               underline: DropdownButtonHideUnderline(child: Container()),
      //                 hint: Text('  Select Source',style: TextStyle(color: Colors.blue),),
      //                 icon: Icon(Icons.arrow_drop_down,color: Colors.blue),
      //                 isExpanded: true,
      //                 value: selectedSource,
      //                 items: sourceList.map((e) => DropdownMenuItem(
      //                   child: Text(e),
      //                   value: e,
      //                 )).toList(), 
      //                 onChanged: (String? value){
      //                   setState(() {
      //                     selectedSource=value;
      //                   });
      //                 }
      //               ),
      //           ),
      //         ),
      //         SizedBox(height: 20),
      //         Text('Destination',style: TextStyle(color: Colors.blue,fontSize: 15,fontWeight: FontWeight.bold)),
      //         SizedBox(height: 5,),
      //         Container(
      //           decoration: BoxDecoration(
      //             border: Border.all(color: Colors.blue), // Add border here
      //           ),
      //           child: Padding(
      //             padding: const EdgeInsets.all(4.0),
      //             child: DropdownButton(
      //               underline: DropdownButtonHideUnderline(child: Container()),
      //                 hint: Text('  Select Destination',style: TextStyle(color: Colors.blue),),
      //                 icon: Icon(Icons.arrow_drop_down,color: Colors.blue),
      //                 isExpanded: true,
      //                 value: selectedDestination,
      //                  items: dropdownOptions.map((e) => DropdownMenuItem(
      //                   child: Text(e),
      //                   value: e,
      //                 )).toList(),
      //                 onChanged: (String? value){
      //                   setState(() {
      //                     selectedDestination=value;
      //                   });
      //                 }
      //               ),
      //       //         DropdownButton<String>(
      //       //   value: selectedLocation,
      //       //   onChanged: (String? newValue) {
      //       //     setState(() {
      //       //       selectedLocation = newValue;
      //       //     });
      //       //   },
      //       //   items: locations.map((location) {
      //       //     return DropdownMenuItem<String>(
      //       //       value: location.name,
      //       //       child: Text(location.name),
      //       //     );
      //       //   }).toList(),
      //       // ),
      //           ),
      //         ),
      //         SizedBox(height: 20,),
      //         GestureDetector(
      //           // onTap: (){
      //           //   tracking();
      //           // },
      //           onTap: isSending ? null: _tracking,
      //           child: MouseRegion(
      //             cursor: SystemMouseCursors.click,
      //             child: Container(
      //               height: 60,
      //               decoration: BoxDecoration(
      //                 border: Border.all(color: Colors.black),
      //                 color: Colors.blue
      //               ),
      //               child: Center(
      //                 child: Text('Add Visit',style: TextStyle(color: Colors.white),),
      //               ),
      //             ),
      //           ),
      //         )
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}