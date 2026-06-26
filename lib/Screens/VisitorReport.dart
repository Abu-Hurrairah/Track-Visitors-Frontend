import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/APIHandler/api.dart';
import 'package:project/CommonUtils.dart/LogoutConfirmationDialog.dart';
import 'package:project/Model/VisitorModel.dart';
import 'package:project/Screens/Admin.dart';
import 'package:project/Screens/Login.dart';
import 'package:http/http.dart' as http;
import '../CustomWidgets/Widgets.dart';

class VisitorReportScreen extends StatefulWidget {
  const VisitorReportScreen({super.key});

  @override
  State<VisitorReportScreen> createState() => _VisitorReportScreenState();
}

class _VisitorReportScreenState extends State<VisitorReportScreen> {
  TextEditingController controller_searchDate1=TextEditingController();
  TextEditingController controller_searchDate2=TextEditingController();
  int serialNumber = 0  ;
  TimeOfDay _time = new TimeOfDay.now();
  DateTime _date1 = DateTime.now();
  DateTime _date2 = DateTime.now();
  List<Map<String, dynamic>> visitors = [];

  // List<Visitor> visitors = [];
  // Future <void> getVisitors() async{
  //   try{
  //     var request = http.MultipartRequest('GET',Uri.parse('http://localhost:5000/GetAllVisitors'),);
  //     var response = await request.send();
  //     if (response.statusCode == 200) {
  //       final List<dynamic> jsonResponse = json.decode(await response.stream.bytesToString());
  //       setState(() {
  //         visitors = jsonResponse.map((json) => Visitor.fromJson(json)).toList();
  //         // dropdownOptions = users.map((user) => user.name).toList();
  //         print(jsonResponse);
  //       });
  //     }
  //   }catch (e) {
  //     print('Error submitting form: $e');
  //   }
  // }


  Future<void> getVisitorsReport(String startDate, String endDate) async {
    try {
      String apiUrl = '${APIHandler.ip}/GetVisitorsReport';

      Map<String, dynamic> requestData = {
        'start_date': startDate,
        'end_date': endDate,
      };

      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(await response.body);
        setState(() {
          visitors = jsonResponse.map((json) => Map<String, dynamic>.from(json)).toList();
          print(jsonResponse);
        });
        // // Successful response
        // List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
        //   json.decode(response.body),
        // );

        // setState(() {
        //   visitors = data;
        // });
        // // Update the visitors list with the new data
        // setState(() {
        //   visitors = data.map((json) => Visitor.fromJson(json)).toList();
        // });

        // Process data as needed, e.g., update UI, etc.
        // print(data);
        print('aaaaaa');
        // print(data);
      } else {
        // Handle unsuccessful response
        print('Failed to fetch visitors report. Status code: ${response.statusCode}');
        print(response.body);
      }
    } catch (e) {
      // Handle other exceptions
      print('Error: $e');
    }
  }

  Future<void> _selectDate1(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date1,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _date1) {
      print('Date selected: ${_date1.toString()}');
      setState(() {
        _date1 = picked;
        controller_searchDate1.text = _date1.toString().split(' ')[0];
      });
    }
  }

  Future<void> _selectDate2(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date2,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _date2) {
      print('Date selected: ${_date2.toString()}');
      setState(() {
        _date2 = picked;
        controller_searchDate2.text = _date2.toString().split(' ')[0];
      });
    }
  }

  // Future<Null> _selectTime1(BuildContext context) async {
  //   final TimeOfDay? picked = await showTimePicker(
  //     context: context,
  //     initialTime: _time,
  //   );

  //   if(picked != null && picked != _time) {
  //     print('Time selected: ${_time.toString()}');
  //     setState((){
  //       _time = picked;
  //       controller_searchVisitor1.text=_time.format(context);
  //     });
  //   }
  // }

  // Future<Null> _selectTime2(BuildContext context) async {
  //   final TimeOfDay? picked = await showTimePicker(
  //     context: context,
  //     initialTime: _time,
  //   );

  //   if(picked != null && picked != _time) {
  //     print('Time selected: ${_time.toString()}');
  //     setState((){
  //       _time = picked;
  //       controller_searchVisitor2.text=_time.format(context);
  //     });
  //   }
  // }

  Future<void> downloadVisitorsReport(String startDate, String endDate) async {
    final url = "${APIHandler.ip}"; // Replace with your actual API endpoint URL

    try {
      final response = await http.post(
        Uri.parse('$url/DownloadVisitorsReport'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'start_date': startDate,
          'end_date': endDate,
        }),
      );

      if (response.statusCode == 200) {
        // Download the PDF or handle the response as needed
        print('Visitors report downloaded successfully.');
      } else {
        print("Failed to download visitors report. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error downloading visitors report: $e");
    }
  }

  void _showImageDialog(BuildContext context, String imageBase64) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.height * 0.7,
            child: Image.memory(
              base64Decode(imageBase64),
              fit: BoxFit.contain,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  String? formatTime(String? rawTime) {
    if (rawTime == null) {
      return 'N/A'; // or any other default value you want to show for null time
    }

    // Parse the raw time string
    DateTime parsedTime = DateTime.parse('2022-01-01 $rawTime');

    // Format the time using intl package
    String formattedTime = DateFormat('hh:mm a').format(parsedTime);

    return formattedTime;
  }



  @override
  void initState() {
    super.initState();
    // getVisitors();
    
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
              Text('Visitors Report',style: TextStyle(fontSize: 30,color: Colors.blue),),
              SizedBox(height: 40,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 65,
                    width: 180,
                    child: TextFormField(
                      controller: controller_searchDate1,
                      style: TextStyle(fontSize: 20),
                      onTap: () {
                        _selectDate1(context);
                      },
                      decoration: InputDecoration(
                        // border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                        hintText: 'YYYY-MM-DD',
                        hintStyle: TextStyle(fontSize: 15,color: Colors.blue),
                        labelText: 'Select Start Date',
                        // prefixIcon: IconButton(
                        //   onPressed: (){
                        //     _selectDate1(context);
                        //   }, 
                        //   icon: Icon(Icons.search,color: Colors.blue,)
                        // ),
                        // suffixIcon: IconButton(
                        //   onPressed: () {
                        //     controller_searchVisitor1.clear();
                        //   },
                        //   icon: Icon(Icons.close, color: Colors.blue),
                        // ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 1,
                          ),
                        ),
                        // enabledBorder: OutlineInputBorder(
                        //   borderSide: BorderSide(
                        //     color: Colors.blue,
                        //     width: 1,
                        //   ),
                        //   // borderRadius: BorderRadius.circular(30)
                        // ),
                      ),
                    ),
                  ),
                  Container(
                    height: 65,
                    width: 180,
                    child: TextFormField(
                      controller: controller_searchDate2,
                      style: TextStyle(fontSize: 20),
                      onTap: () {
                        _selectDate2(context);
                      },
                      decoration: InputDecoration(
                        // border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                        hintText: 'YYYY-MM-DD',
                        hintStyle: TextStyle(fontSize: 15,color: Colors.blue),
                        labelText: 'Select End Date',
                        // prefixIcon: IconButton(
                        //   onPressed: (){
                        //     _selectDate2(context);
                        //   }, 
                        //   icon: Icon(Icons.search,color: Colors.blue,)
                        // ),
                        // suffixIcon: IconButton(
                        //       onPressed: () {
                        //         controller_searchVisitor2.clear();
                        //       },
                        //       icon: Icon(Icons.close, color: Colors.blue),
                        //     ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 1,
                          ),
                        ),
                        // enabledBorder: OutlineInputBorder(
                        //   borderSide: BorderSide(
                        //     color: Colors.blue,
                        //     width: 1,
                        //   ),
                        //   borderRadius: BorderRadius.circular(30)
                        // ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15,),
              GestureDetector(
                onTap: (){
                  getVisitorsReport(controller_searchDate1.text,controller_searchDate2.text);
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
                      child: Text('Search',style: TextStyle(fontSize: 20,color: Colors.white),),
                    ),
                  ),
                )
              ),
              SizedBox(height: 15,),
              // GestureDetector(
              //   onTap: (){
              //     downloadVisitorsReport(controller_searchDate1.text,controller_searchDate2.text);
              //     setState(() {
                    
              //     });
              //   },
              //   child: MouseRegion(
              //     cursor: SystemMouseCursors.click,
              //     child: Container(
              //       height: 50,
              //       width: 400,
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(40),
              //         color: Colors.blue,
              //       ),
              //       child: Center(
              //         child: Text('Download',style: TextStyle(fontSize: 20,color: Colors.white),),
              //       ),
              //     ),
              //   )
              // ),
              SizedBox(height: 30,),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 15,
                    columns: [
                      // DataColumn(label: Text('Visitor ID',style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)),
                      DataColumn(label: Text('S.No',style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)),
                      DataColumn(label: Text("Name",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)),
                      DataColumn(label: Text("Visitor Phone No.",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)),
                      DataColumn(label: Text("Locations Visited",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)),
                      DataColumn(label: Text("Visit Date",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)),
                      DataColumn(label: Text("Entry Time",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)),
                      DataColumn(label: Text("Exit Time",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)),
                      DataColumn(label: Text('Image',style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)),
                    ], 
                    rows: visitors.map((visitor) {
                      serialNumber++;
                      return DataRow(
                        cells: [
                          DataCell(getText(serialNumber.toString(),10)),
                          DataCell(Text('${visitor['VisitorName']}')),
                          DataCell(Text('${visitor['VisitorPhone']}')),
                          DataCell(Text('${visitor['LocationsVisited']}')),
                          DataCell(Text('${visitor['VisitDate']}')),
                          DataCell(Text('${formatTime(visitor['EntryTime'])}')),
                          DataCell(Text('${formatTime(visitor['ExitTime'])}')),
                          DataCell(
                            InkWell(
                              onTap: () {
                                _showImageDialog(context, visitor['image']);
                              },
                              child: Image.memory(
                                base64Decode(visitor['image']),
                                width: 50,
                                height: 50,
                              ),
                            ),
                          ),
                          // DataCell(Text('${TimeOfDay.fromDateTime(DateTime.parse('2022-01-01 ${visitor['EntryTime']}')).format(context)}')),
                          // DataCell(Text('${TimeOfDay.fromDateTime(DateTime.parse('2022-01-01 ${visitor['ExitTime']}')).format(context) ?? 'N/A'}')),
                        ]
                      );
                    }
                    ).toList(),
                  ),
                ),
              )
            ]
          ),
        )
      )
    );
  }
}