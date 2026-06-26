// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:project/APIHandler/api.dart';

class DeleteFloorsScreen extends StatefulWidget {
  const DeleteFloorsScreen({super.key});

  @override
  State<DeleteFloorsScreen> createState() => _DeleteFloorsScreenState();
}

class _DeleteFloorsScreenState extends State<DeleteFloorsScreen> {

  List<DFloor> selectedFloors = [];
  List<String> selectedFloorsName = [];
  List<int> selectedFloorsId = [];
  List<Map<String,dynamic>> selectedFloorsMap = [];

  List<DFloor> floors = [];
  Future <void> getFloors() async{
    try{
      // var request = http.MultipartRequest('GET',Uri.parse('${APIHandler.ip}/GetAllFloors'),);
      // var response = await request.send();
      var response = await http.get(Uri.parse('${APIHandler.ip}/GetAllFloors'));
      if (response.statusCode == 200) {
        // final List<dynamic> jsonResponse = json.decode(await response.stream.bytesToString());
        final dynamic jsonResponse = jsonDecode(response.body);
        print(jsonResponse);
        print(jsonResponse.runtimeType);
        setState(() {
          floors = jsonResponse.map((json) => DFloor.fromJson(json)).cast<DFloor>().toList();
          // dropdownOptions = users.map((user) => user.name).toList();
          print(floors);
          // filteredFloors=floors;
        });
      }
    }catch (e) {
      print('Error submitting form: $e');
    }
  }

  Future<void> deleteFloors(List<Map<String, dynamic>> selectedFloors) async {
    final url = '${APIHandler.ip}/DeleteFloors'; // Replace with your actual server endpoint

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'selectedItems': selectedFloors}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print(responseData['message']);
      } else {
        print('Failed to delete floors. Status code: ${response.statusCode}');
        // Handle error scenarios
      }
    } catch (e) {
      print('Error deleting floors: $e');
      // Handle error scenarios
    }
  }

  // Function to show the floor selection dialog
  Future<void> _showFloorSelectionDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Select Floors'),
              content: SingleChildScrollView(
                child: Column(
                  children: floors.map((floor) {
                    return CheckboxListTile(
                      title: Text(floor.name),
                      value: selectedFloors.contains(floor),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value != null) {
                            if (value) {
                              selectedFloors.add(floor);
                              selectedFloorsName.add(floor.name);
                              selectedFloorsId.add(floor.id ?? 0);
                              selectedFloorsMap.add({'id': floor.id});
                              print(selectedFloors);
                              print(selectedFloorsName);
                              print(selectedFloorsId);
                              print(selectedFloorsMap);
                            } else {
                              selectedFloors.removeWhere((element) => element == floor);
                              selectedFloorsName.removeWhere((element) => element == floor.name);
                              selectedFloorsId.removeWhere((element) => element == floor.id);
                              selectedFloorsMap.removeWhere((element) => element['id'] == floor.id);
                              print(selectedFloors);
                              print(selectedFloorsName);
                              print(selectedFloorsId);
                              print(selectedFloorsMap);
                            }
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: <Widget>[
                // TextButton(
                //   onPressed: () {
                //     Navigator.of(context).pop();
                //   },
                //   child: Text('Cancel'),
                // ),
                TextButton(
                  onPressed: () async {
                    // Perform actions with the selected floors
                    print('Selected Floors: ${selectedFloors.map((floor) => floor.name).join(', ')}');
                    setState(() {});
                    await Future.delayed(Duration.zero);
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          }
        );
      },
    );
  }


  @override
  void initState() {
    super.initState();
    getFloors();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Eliminar piso')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              await _showFloorSelectionDialog(context);
              setState(() {
                
              });
            },
            child: Text('Select Floors'),
          ),
          // Display the selected floors
          Text('Selected Floors: ${selectedFloors.map((floor) => floor.name).join(', ')}')
          // // Display the selected floors
          // FutureBuilder<void>(
          //   future: Future.delayed(Duration.zero),
          //   builder: (context, snapshot) {
          //     return Text('Selected Floors: ${selectedFloors.map((floor) => floor.name).join(', ')}');
          //   },
          // ),
        ],
      ),
    );
  }
}


class DFloor {
  final int? id;
  String name;

  DFloor({
    this.id,
    required this.name,
  });

  factory DFloor.fromJson(Map<String, dynamic> json) {
    return DFloor(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory DFloor.fromMap(Map<String, dynamic> map) {
    return DFloor(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }

  // String toJson() => json.encode(toMap());

  // factory DFloor.fromJson(String source) => DFloor.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'DFloor(id: $id, name: $name)';

  DFloor copyWith({
    int? id,
    String? name,
  }) {
    return DFloor(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  // @override
  // bool operator ==(covariant DFloor other) {
  //   if (identical(this, other)) return true;
  
  //   return 
  //     other.id == id &&
  //     other.name == name;
  // }

  // @override
  // int get hashCode => id.hashCode ^ name.hashCode;
}
