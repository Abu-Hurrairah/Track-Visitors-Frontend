import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project/APIHandler/api.dart';
import 'package:project/Global/GuardGlobal.dart';
import 'package:project/Model/CameraModel.dart';
import 'package:project/Screens/ShowImage.dart';
import 'package:video_player/video_player.dart';

class DetectedCamerasScreen extends StatefulWidget {
  List<List<String>> paths;
   int visitorId;
   dynamic startTime;
  DetectedCamerasScreen(this.paths,this.visitorId,this.startTime);

  @override
  State<DetectedCamerasScreen> createState() => _DetectedCamerasScreenState();
}

class _DetectedCamerasScreenState extends State<DetectedCamerasScreen> {
  TextEditingController time_controller=TextEditingController();
  TextEditingController camera_controller=TextEditingController();
  String selectedVideoUrl = '';
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController; // Chewie controller
  TimeOfDay _time = new TimeOfDay.now();
  String? selectedValue;
  // List<String> dropdownOptions = ['C1', 'C2', 'C3', 'C4', 'C5', 'C6'];
  List<String> dropdownOptions = [];
  bool showDropdown = false;
  List<String> cameraValue=[];
  List<String> timeValues=[];
  bool isSending = false;
  Timer? _timeUpdateTimer;

  late List<List<String>> paths;
  

  @override
  void initState() {
    super.initState();
    paths = widget.paths;
    // Initialize _chewieController as null
    _chewieController = null;
    getCameras();
    print(GuardGlobal.guardGlobalDutyLocationCameraName);
    cameraValue.add(GuardGlobal.guardGlobalDutyLocationCameraName);
    print(cameraValue);
    timeValues.add(widget.startTime);
    print(timeValues);
    fetchData();
    // Create a timer that updates the time every second.
    _timeUpdateTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!time_controller.text.isEmpty) {
        // Calculate the next time value
        TimeOfDay currentTime = TimeOfDay.now();
        setState(() {
          time_controller.text = currentTime.format(context);
        });
      }
    });
  }
  
  File? selectedVideo;

  Future<void> _pickVideo() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp4', 'avi', 'mkv'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        selectedVideo = File(result.files.single.path!);
        _videoPlayerController = VideoPlayerController.file(selectedVideo!)
          ..initialize().then((_) {
            setState(() {
               _chewieController = ChewieController(
                videoPlayerController: _videoPlayerController,
                autoPlay: true,
                looping: false,
                // Add other ChewieController options as needed
              );
            });
          });
      });
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose(); // Dispose of ChewieController
    _timeUpdateTimer?.cancel();
    super.dispose();
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );

    if(picked != null && picked != _time) {
      print('Time selected: ${_time.toString()}');
      setState((){
        _time = picked;
        time_controller.text=_time.format(context);
      });
    }
  }

  int getCameraIdByName(String cameraName) {
    final camera = cameras.firstWhere((camera) => camera.name == cameraName, orElse: () => Camera(id: 0, name: ''));
    return camera.id;
  }

  String? camValue;
  String? timeValue;
  bool result=false;
  int camera_id=26;
  bool deviated=false;
  void _send() async {
    if (time_controller.text.isEmpty || camera_controller.text.isEmpty || widget.visitorId==null) {
      return;
    } else {
      setState(() {
        isSending = true;
      });
      try {
        print('as');
        var request = http.MultipartRequest('POST',Uri.parse('${APIHandler.ip}/CheckVisitorIsPresent'),);
        print(request);
        request.fields['time'] = time_controller.text;
        request.fields['camera_name'] = camera_controller.text;
        request.fields['visitor_id'] = widget.visitorId.toString();
        request.fields['camera_id'] = getCameraIdByName(camera_controller.text).toString();
        print(getCameraIdByName(camera_controller.text));
        print(time_controller.text);
        print(widget.visitorId);
        print(camera_id);
        print(camera_controller.text);
        final multipartFile = await http.MultipartFile.fromPath('video', selectedVideo!.path);
        request.files.add(multipartFile);
        // print(camera_id);

          var response = await request.send();
          print(selectedVideo);
          if (response.statusCode == 200) {
            print(response.statusCode);
            print(response);
            setState(()async {
              String responseText = await response.stream.bytesToString();
              Map<String, dynamic> responseData = json.decode(responseText);
              print(responseData);
              camValue = responseData['details']['camera'];
              timeValue = responseData['details']['time'];
              result=responseData['details']['detect'];
              deviated=responseData['details']['is_not_deviated'];
              print(result);
              if(result==true){
                cameraValue.add(camValue!);
                timeValues.add(timeValue!);
                setState(() {
                  
                });
              }
              print('Camera value: $camValue');
              print('Time value: $timeValue');
              print('Camera List: $cameraValue');
              print('Time List: $timeValues');
              print(result?'Visitor is found':'Visitor is not found');
              print(result);
              print(deviated);
              if(result==false){
                showDialog(
                  context: context, 
                  builder: (context){
                    return AlertDialog(
                      title: Text('Failed'),
                      content: Text('Visitor is not found'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            setState(() {
                              Navigator.of(context).pop();
                            });
                          },
                          child: Text('Close'),
                        ),
                      ],
                    );
                  }
                );
              }
              else{
                showDialog(
                  context: context, 
                  builder: (context){
                    return AlertDialog(
                      title: Text('Success'),
                      content: Text('Visitor is found'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            setState(() {
                              Navigator.of(context).pop();
                            });
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  }
                );
              }
            });
          } else {
            print('Error');
          }
        } catch (error) {
          print(error);
          print('No');
        } finally{
          setState(() {
            isSending = false;
            print('this');
            if(result==true)
              print('is');
              getDetectedFrame();
            // }
            // else{
            //   print('a');
            //   showDialog(
            //     context: context, 
            //     builder: (context){
            //       return AlertDialog(
            //         title: Text('Message'),
            //         content: Text('Visitor is not found'),
            //         actions: <Widget>[
            //           TextButton(
            //             onPressed: () {
            //               setState(() {
            //                 Navigator.of(context).pop();
            //               });
            //             },
            //             child: Text('Close'),
            //           ),
            //         ],
            //       );
            //     }
            //   );
            // }
          }
          );
        }
      }
    }

  // Uint8List? imageBytes;
  List<int>? imageBytes;
  Future <void> getDetectedFrame() async{
    print('heeeeee');
    try{
      String cam=camera_controller.text;
      print(cam);
      String vid=widget.visitorId.toString();
      print(vid);
      var url = Uri.parse('${APIHandler.ip}/GetDetectedFrame/$vid/$cam');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        String encodedImage = data['image'];
        setState(() {
          // imageBytes = response.bodyBytes;
          imageBytes = base64.decode(encodedImage);
          print(imageBytes);
        });
        print('Ali');
        print(imageBytes);
        print('Ali');
        setState(() {
          
        });
      }
      else{
        print('No Data');
      }
    }catch(error){
      print(error);
    }
  }

  List<Camera> cameras = [];
  Future <void> getCameras() async{
    try{
      var request = http.MultipartRequest('GET',Uri.parse('${APIHandler.ip}/GetAllCameras'),);
      var response = await request.send();
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(await response.stream.bytesToString());
        setState((){
          cameras = jsonResponse.map((json) => Camera.fromJson(json)).toList();
          dropdownOptions = cameras.map((camera) => camera.name).toList();
          print(dropdownOptions);
        });
      }
    }catch (e) {
      print('Error submitting form: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getAllCamerasLocationsConnections() async {
    try {
      final response = await http.get(Uri.parse('${APIHandler.ip}/GetAllCamerasLocationsConnections'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        // Convert the data to a list of maps
        List<Map<String, dynamic>> cameraDataList = List<Map<String, dynamic>>.from(data);
        return cameraDataList;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  List<Map<String, dynamic>>? cameraDataList;
  // Example usage:
  Future<void> fetchData() async {
    cameraDataList = await getAllCamerasLocationsConnections();
    // Now you can use cameraDataList to display or process the data as needed
    for (var cameraData in cameraDataList!) {
      print('Camera Name: ${cameraData['CameraName']}');
      print('Connected Locations: ${cameraData['LocationNames']}');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detected Cameras',style: TextStyle(fontSize: 30),)),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: paths.length,
                itemBuilder: (context, index) {
                  final path = paths[index];
                  final pathIndex = index + 1;

                  return Card(
                    margin: EdgeInsets.all(16.0),
                    elevation: 4,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Path $pathIndex:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Wrap(
                              spacing: 15,
                              runSpacing: 4,
                              children: path.map((step) {
                                return GestureDetector(
                                  onTap: () {
                                    List<String> c=cameraValue;
                                    print(cameraValue);
                                    print(c);
                                    c.removeWhere((item) => item == GuardGlobal.guardGlobalDutyLocationCameraName);
                                    print(cameraValue);
                                    print(c);
                                    if (step!=GuardGlobal.guardGlobalDutyLocationCameraName && c.contains(step)){
                                      imageBytes!=null?Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context){
                                          return ShowImageScreen(imageBytes);
                                        })
                                      ):showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text('Path:${pathIndex}, $step'),
                                          );
                                        },
                                      );
                                    }
                                    if(step==GuardGlobal.guardGlobalDutyLocationCameraName) {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text('Gate Position'),
                                          );
                                        },
                                      );
                                    }
                                    else{
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text('Path:${pathIndex}, $step'),
                                          );
                                        },
                                      );
                                    }
                                  },
                                  child: Column(
                                    children: [
                                      step==GuardGlobal.guardGlobalDutyLocationCameraName?Text(widget.startTime,):SizedBox(height: 19.5,),
                                      step==camValue && result?Text(timeValue!):SizedBox(height: 19.5,),
                                      // step==camValue && result?Text(timeValues[index]):SizedBox(height: 19.5,),
                                      MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: Stack(
                                          children: [
                                            Chip(
                                              label: Text(step),
                                              backgroundColor: cameraValue.contains(step) ? Colors.blue[800] : Colors.blue,
                                              labelStyle: TextStyle(color: Colors.white),
                                            ),
                                            Positioned(
                                              top: 8,
                                              right: 5,
                                              child: Container(
                                                width: 10,
                                                height: 10,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: cameraValue.contains(step) ? Colors.green[800] : Colors.red,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 10,),
              GestureDetector(
                onTap: (){
                  _pickVideo();
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        color: Colors.red[400],
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Center(
                        child: Text('Choose Video',style: TextStyle(color: Colors.white),) 
                      ),
                    ),
                  ),
                ),
              ),
              if(selectedVideo!=null)
                // Text(selectedVideo!.path),
                // AspectRatio(
                //   aspectRatio: _videoPlayerController.value.aspectRatio,
                //   child: VideoPlayer(_videoPlayerController),
                // ),
                if (_chewieController != null)
                  Chewie(
                    controller: _chewieController!, // Use ChewieController
                  ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: (){
                      time_controller.text=_time.format(context);
                      setState(() {
                        _selectTime(context);  
                      });
                    }, 
                    child: Text("Choose Time",style: TextStyle(color: Colors.black),)
                  ), 
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            child: SingleChildScrollView(
                              child: Container(
                                width: double.maxFinite,
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: dropdownOptions.map((String option) {
                                    // Find the corresponding cameraData for the selected option
                                    Map<String, dynamic>? cameraData = cameraDataList!.firstWhere(
                                      (data) => data['CameraName'] == option,
                                    );

                                    return Card(
                                      elevation: 4, // Set the elevation for the Card
                                      child: ListTile(
                                        title: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                // Display the camera name
                                                cameraData != null ? cameraData['CameraName'] : option,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                // Display the location name
                                                cameraData != null ? cameraData['LocationNames'] : '',
                                                textAlign: TextAlign.end,
                                              ),
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          Navigator.pop(context);
                                          setState(() {
                                            selectedValue = option;
                                            camera_controller.text = option;
                                          });
                                        },
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Text("Choose Camera", style: TextStyle(color: Colors.black)),
                  )

                  // TextButton(
                  //   onPressed: () {
                  //     showDialog(
                  //       context: context,
                  //       builder: (context) {
                  //         return Dialog(
                  //           child: Container(
                  //             width: double.maxFinite,
                  //             padding: EdgeInsets.all(16.0),
                  //             child: Column(
                  //               mainAxisSize: MainAxisSize.min,
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: dropdownOptions.map((String option) {
                  //                 return ListTile(
                  //                   title: Text(option),
                  //                   onTap: () {
                  //                     Navigator.pop(context);
                  //                     setState(() {
                  //                       selectedValue = option;
                  //                       camera_controller.text=option;
                  //                     });
                  //                   },
                  //                 );
                  //               }).toList(),
                  //             ),
                  //           ),
                  //         );
                  //       },
                  //     );
                  //   },
                  //   child: Text("Choose Camera", style: TextStyle(color: Colors.black)),
                  // )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 150,
                    child: TextFormField(
                      controller: time_controller,
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    child: TextFormField(
                      controller: camera_controller,
                    ),
                  )
                ],
              ),
              SizedBox(height: 10,),
              GestureDetector(
                onTap: isSending ? null : _send,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        color: isSending ? Colors.grey : Colors.red[400],
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Center(
                        child: isSending?Text('Sending...',style: TextStyle(color: Colors.white),) :Text('Send',style: TextStyle(color: Colors.white),) 
                      ),
                    ),
                  ),
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }
}