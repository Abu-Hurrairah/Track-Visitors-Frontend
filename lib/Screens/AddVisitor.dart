import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/APIHandler/api.dart';
import 'package:project/CommonUtils.dart/LogoutConfirmationDialog.dart';
import 'package:project/Screens/AddNewVisit.dart';
import 'package:project/Screens/Guard.dart';
import 'package:project/Screens/Login.dart';


class AddVisitorScreen extends StatefulWidget {
  const AddVisitorScreen({super.key});

  @override
  State<AddVisitorScreen> createState() => _AddVisitorScreenState();
}

class _AddVisitorScreenState extends State<AddVisitorScreen> {
  TextEditingController visitorName_controller=TextEditingController();
  TextEditingController visitorContactNumber_controller=TextEditingController();
  String? selectedDestination;
  List<String> dropdownOptions = ['Admin Office', 'Data Cell', 'Lab5'];
  List<XFile> selectedImages = [];
  int image_count=0;
  bool isSending=false;

  Future<void> pickImages() async {
    final ImagePicker _picker = ImagePicker();

    // Show a dialog or options for the user to choose the source
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choose Image Source"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  List<XFile>? images = await _picker.pickMultiImage(
                    imageQuality: 85,
                    maxHeight: 400,
                    maxWidth: 400,
                  );
                  if (images != null) {
                    processImages(images);
                  }
                },
                child: Text("Take Picture"),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  List<XFile>? images = await _picker.pickMultiImage(
                    imageQuality: 85,
                    maxHeight: 400,
                    maxWidth: 400,
                  );
                  if (images != null) {
                    processImages(images);
                  }
                },
                child: Text("Choose from Gallery"),
              ),
            ],
          ),
        );
      },
    );
  }

  void processImages(List<XFile> images) {
    for (XFile image in images) {
      image_count++;
      String imageName = 'img$image_count.png';

      String imagePath = image.path;
      String newPath = Directory.systemTemp.path + '/' + imageName;

      // Save the image with a new name
      File(imagePath).copy(newPath).then((_) {
        setState(() {
          selectedImages.add(XFile(newPath));
        });
      });
    }
  }
  
  // Future<void> pickImages() async {
  //   List<XFile>? images = await ImagePicker().pickMultiImage();
  //   if (images != null) {
  //     // String imageName = 'img$image_count.jpg';
  //     // image_count++;
  //     // setState(() {
  //     //   selectedImages.addAll(images);
  //     // });

  //     for (XFile image in images) {
  //     image_count++;
  //     String imageName = 'img$image_count.png';
      

  //     String imagePath = image.path;
  //     String newPath = Directory.systemTemp.path + '/' + imageName;

  //     await File(imagePath).copy(newPath); // Save with new name

  //     setState(() {
  //       selectedImages.add(XFile(newPath));
  //     });
  //   }
  //   }
  // }
  

  Future<void> submitForm() async {
    String name = visitorName_controller.text;
    String contactNumber = visitorContactNumber_controller.text;

    if (name.isEmpty || contactNumber.isEmpty || selectedImages.isEmpty) {
      return;
    }
    List<String> imageBase64List = [];

    for (var image in selectedImages) {
      List<int> imageBytes = await image.readAsBytes();
      String base64Image = base64Encode(imageBytes);
      imageBase64List.add(base64Image);
    }

    //// int statusCode = await APIHandler.addVisitor(name, contactNumber, selectedDestination!, imageBase64List);
    // dynamic response = await APIHandler.addVisitor(name, contactNumber, selectedDestination!, imageBase64List);
    // if (response.statusCode == 200) {
    //   Navigator.of(context).push(
    //     MaterialPageRoute(builder: (context){
    //       return DetectedCamerasScreen();
    //     })
    //   );
    //   // Success! Handle accordingly
    // } else {
    //   // Error occurred, handle accordingly
    // }
  }

  Future<void> _submitForm() async {
    String name = visitorName_controller.text;
    String contactNumber = visitorContactNumber_controller.text;

    if (name.isEmpty || contactNumber.isEmpty || selectedImages.isEmpty) {
      print('NO selected');
      return ;
    }
    try{
      var response=await APIHandler.addVisitor(name, contactNumber,image_count, selectedImages);
      if (response.statusCode == 200) {
        // Success! Handle accordingly
        // Navigator.of(context).push(
        //   MaterialPageRoute(builder: (context){
        //     // return DetectedCamerasScreen(response);
        //     return AddNewVisitScreen(response);
        //   })
        // );
        print('Data submitted successfully');
      } else {
        // Error occurred, handle accordingly
        print('Data submission error: ${response.reasonPhrase}');
      }
    }catch (e) {
      print('Error submitting form: $e');
    }
  }

  void _handleSubmit() async {
    if (visitorName_controller.text.isEmpty ||
        visitorContactNumber_controller.text.isEmpty ) {
      // Display form validation error
      // ...
      return;
    } else {
      setState(() {
        isSending = true; // Start sending, disable the button
      });
      if (selectedImages.isEmpty) {
        // Display image selection error
        // ...
        return;
      } else {
        try {
          var request = http.MultipartRequest('POST',Uri.parse('${APIHandler.ip}/AddVisitor'),);

          request.fields['name'] = visitorName_controller.text;
          request.fields['contact'] = visitorContactNumber_controller.text;
          // request.fields['destination'] = _destinationController.text;
          request.fields['count'] = selectedImages.length.toString();

          for (int i = 0; i < selectedImages.length; i++) {
            request.files.add(
              await http.MultipartFile.fromPath(
                'image${i + 1}',
                selectedImages[i].path,
                contentType: MediaType('image', 'png'), // Adjust content type as needed
              ),
            );
          }

          var response = await request.send();

          if (response.statusCode == 200) {
            String responseText = await response.stream.bytesToString();
            Map<String, dynamic> responseData = json.decode(responseText);
            String message = responseData['message'];
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Success'),
                  content: Text(message),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        // Navigate to the AddNewVisitScreen or perform other actions as needed
                        setState(() {
                          Navigator.of(context).pop();
                        });
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context){
                            return AddNewVisitScreen();
                          })
                        );
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
            // Navigator.of(context).push(
            //   MaterialPageRoute(builder: (context){
            //     return AddNewVisitScreen();
            //   })
            // );
            // Success! Display success dialog and reset fields
            // ...
          } else {
            // Display error dialog
            // ...
            // Handle error cases
            String errorMessage = 'An error occurred'; // Default error message

            // Check if the response contains an error message
            if (response.statusCode == 500) {
              // Parse the response text to extract the error message
              String responseText = await response.stream.bytesToString();
              Map<String, dynamic> responseData = json.decode(responseText);
              errorMessage = responseData['error']; // Extract the error message
            }

            // Show an error dialog box with the error message
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Error'),
                  content: Text(errorMessage),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        // Close the dialog box
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        } catch (error) {
          // Handle network or API call error
          // ...
        }
        finally {
        setState(() {
          isSending = false; // Response received, enable the button
        });}
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Add Visitor',style: TextStyle(fontSize: 30),),),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
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
                Text('Add Visitor',style: TextStyle(fontSize: 25,color: Colors.blue),),
                SizedBox(height: 25,),
                GestureDetector(
                  onTap: pickImages,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.blue)
                      ),
                      child: Center(
                        child: selectedImages.isEmpty?Text('Take Pictures',style: TextStyle(fontSize: 20,color: Colors.blue),):ClipOval(child: SizedBox(width: 200,height: 200,child: Image.file(File(selectedImages[0].path,),fit: BoxFit.cover))) //contain
                      ),
                    ),
                    // CircleAvatar(
                    //   radius: 100, // Adjust as needed
                    //   backgroundColor: Colors.transparent, // No background color
                    //   backgroundImage: selectedImages.isEmpty
                    //       ? null
                    //       : NetworkImage(selectedImages[0].path),
                    //   child: selectedImages.isEmpty ? Text('Take Pictures') : null,
                    // ),
                  ),
                ),
                SizedBox(height: 5,),
                selectedImages.isEmpty ? Text('') : Container(
                  height:110,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: selectedImages.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.all(4.0),
                        width: 100, // Adjust the width as needed
                        height: 100, // Adjust the height as needed
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: FileImage(File(selectedImages[index].path)),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 25,),
                TextFormField(
                  controller: visitorName_controller,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    hintText: "Visitor Name",
                    hintStyle: TextStyle(color: Colors.blue),
                    labelText: "Visitor Name",
                    labelStyle: TextStyle(color: Colors.blue),
                    prefixIcon: Icon(Icons.person,size: 30,color: Colors.blue,),
                  ),
                ),
                SizedBox(height: 25,),
                TextFormField(
                  controller: visitorContactNumber_controller,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    hintText: "Contact Information",
                    hintStyle: TextStyle(color: Colors.blue),
                    labelText: "Contact Information",
                    labelStyle: TextStyle(color: Colors.blue),
                    prefixIcon: Icon(Icons.phone,size: 30,color: Colors.blue,),
                  ),
                ),
                // SizedBox(height: 25,),
                // DropdownButton(
                //   hint: Text('Select Destination'),
                //   icon: Icon(Icons.arrow_drop_down),
                //   isExpanded: true,
                //   value: selectedDestination,
                //   items: dropdownOptions.map((e) => DropdownMenuItem(
                //     child: Text(e),
                //     value: e,
                //   )).toList(), 
                //   onChanged: (String? value){
                //     setState(() {
                //       selectedDestination=value;
                //     });
                //   }
                // ),
                SizedBox(height: 25,),
                ElevatedButton(
                  // onPressed: _submitForm,
                  onPressed: isSending ? null : _handleSubmit,
                  child: Text(isSending ? 'Sending...' : 'Submit'),
                ),
                SizedBox(width: 5,),
                Container(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: selectedImages.length,
                    itemBuilder: (context, index) {
                      return Text('${selectedImages[index].path}');
                    }
                  ),
                ),
                Container(
                  child: selectedImages.isEmpty
                    ? const Center(child: Text('Sorry, nothing selected!!'))
                    : Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      children: selectedImages.map((image) {
                        return Image.file(File(image.path), fit: BoxFit.fitWidth);
                      // return Image.network(image.path,fit: BoxFit.fitWidth,);
                    }).toList(),
                  ),
                ),

                // SizedBox(height: 35,),
                // TextButton(
                //   onPressed: (){
                //     // Navigator.of(context).push(
                //     //   MaterialPageRoute(builder: (context){
                //     //     return GetSetVideoScreen();
                //     //   })
                //     // );
                //   }, 
                //   child: Text('If you want to send video')
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}