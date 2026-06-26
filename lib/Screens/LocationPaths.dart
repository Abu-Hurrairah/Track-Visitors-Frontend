import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project/APIHandler/api.dart';
import 'package:project/Model/LocationModel.dart';
import 'package:http/http.dart' as http;

class LocationPathsScreen extends StatefulWidget {
  const LocationPathsScreen({super.key});

  @override
  State<LocationPathsScreen> createState() => _LocationPathsScreenState();
}

class _LocationPathsScreenState extends State<LocationPathsScreen> {
  List<String> dropdownOptions=[];
  List<String> sourceList=[];
  String? selectedSource;
  String? selectedDestination;
  List<String> locationPaths = [];


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

          List<Location> gateLocations = locations.where((location) => location.type == 'Gate').toList();

          sourceList = gateLocations.map((location) => location.name).toList();
          print(gateLocations);
          print(sourceList);
          dropdownOptions = locations.map((location) => location.name).toList();
          print(dropdownOptions);
          // sourceList = locations.map((location) => location.name).toList();
        });
      }
    }catch (e) {
      print('Error submitting form: $e');
    }
  }

  Future<List<String>> getLocationPaths(String source, String destination) async {
    try {
      final response = await http.post(
        Uri.parse('${APIHandler.ip}/GetLocationPaths'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'source': source,
          'destination': destination,
        }),
      );

      if (response.statusCode == 200) {
    final Map<String, dynamic> jsonResponse = json.decode(response.body);
    print(response.body);
    print(jsonResponse);

    if (jsonResponse.containsKey('paths')) {
      List<String> locationPath = (jsonResponse['paths'] as List).cast<String>();
      return locationPath;
    } else {
      throw Exception('Paths not found in the response');
    }
  } else {
    throw Exception('Failed to load location paths');
  }
    } 
    catch (e) {
      print('Error: $e');
      throw Exception('Error getting location paths');
    }
  }


  // Future<List<String>> getLocationPaths(String source, String destination) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('http://localhost:5000/GetLocationPaths'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json',
  //       },
  //       body: jsonEncode({
  //         'source': source,
  //         'destination': destination,
  //       }),
  //     );

  //     if (response.statusCode == 200) {
  //       // final List<dynamic> jsonResponse = json.decode(response.body);
  //       // return jsonResponse.cast<String>();
  //       final List<dynamic> jsonResponse = json.decode(response.body);
  //       List<String> locationPath = jsonResponse.cast<String>();
  //       return locationPath;
  //     } else {
  //       throw Exception('Failed to load location paths');
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //     throw Exception('Error getting location paths');
  //   }
  // }


  @override
  void initState() {
    super.initState();
    getLocations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Location Paths',style: TextStyle(fontSize: 30),)),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
              Text('Source',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
              SizedBox(height: 5,),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: DropdownButton(
                    underline: DropdownButtonHideUnderline(child: Container()),
                      hint: Text('  Select Source'),
                      icon: Icon(Icons.arrow_drop_down),
                      isExpanded: true,
                      value: selectedSource,
                      items: sourceList.map((e) => DropdownMenuItem(
                        child: Text(e),
                        value: e,
                      )).toList(), 
                      onChanged: (String? value){
                        setState(() {
                          selectedSource=value;
                          print(value);
                        });
                      }
                    ),
                ),
              ),
              SizedBox(height: 20),
              Text('Destination',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
              SizedBox(height: 5,),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: DropdownButton(
                    underline: DropdownButtonHideUnderline(child: Container()),
                      hint: Text('  Select Destination'),
                      icon: Icon(Icons.arrow_drop_down),
                      isExpanded: true,
                      value: selectedDestination,
                       items: dropdownOptions.map((e) => DropdownMenuItem(
                        child: Text(e),
                        value: e,
                      )).toList(),
                      onChanged: (String? value){
                        setState(() {
                          selectedDestination=value;
                          // selectedDestinations.add(value!);
                        });
                      }
                    ),
                ),
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: ()async{
                  final paths = await getLocationPaths(selectedSource!, selectedDestination!);
                    setState(() {
                      locationPaths = paths;
                    });
                  // getLocationPaths(selectedSource!,selectedDestination!);
                  // setState(() {
                    
                  // });
                }, 
                child: Text('Find Paths')
              ),
              SizedBox(height: 20,),
            Text('Location Paths', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: locationPaths.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(locationPaths[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}