import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project/Model/LocationModel.dart';
import 'package:http/http.dart' as http;
import 'package:project/Model/VisitorModel.dart';

class RerouteScreen extends StatefulWidget {
  const RerouteScreen({super.key});

  @override
  State<RerouteScreen> createState() => _RerouteScreenState();
}

class _RerouteScreenState extends State<RerouteScreen> {

  Visitor? selectedVisitor;
  VisitorDestinations? selectedVisitorDestinations;
  Location? selectedLocation;

  int selectedVisitorId = 0;
  int selectedVisitorDestinationsId = 0;
  int selectedLocationId = 0;

  List<Location> locations = [];
  Future<void> getAllLocations() async {
    try {
      final response = await http.get(
        Uri.parse('YOUR_API_ENDPOINT_HERE'), // Replace with your API endpoint
        // Add headers if needed
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        locations = data.map((json) => Location.fromJson(json)).toList();
        // Use the locations list as needed
      } else {
        // Handle API error
        print('Failed to fetch locations: ${response.statusCode}');
      }
    } catch (e) {
      // Handle other exceptions
      print('Error: $e');
    }
  }

  List<Visitor> visitors = [];
  Future<void> getCurrentVisitors() async {
    try {
      final response = await http.get(
        Uri.parse('YOUR_API_ENDPOINT_HERE'), // Replace with your API endpoint
        // Add headers if needed
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        visitors = data.map((json) => Visitor.fromJson(json)).toList();
        // Use the visitors list as needed
      } else {
        // Handle API error
        print('Failed to fetch current visitors: ${response.statusCode}');
      }
    } catch (e) {
      // Handle other exceptions
      print('Error: $e');
    }
  }

  List<Visit> visits = [];
  Future<void> getVisitDestinations(int visitorId) async {
    try {
      final response = await http.get(
        Uri.parse('YOUR_API_ENDPOINT_HERE?id=$visitorId'), // Replace with your API endpoint
        // Add headers if needed
      );

      if (response.statusCode == 200) {
        final List<dynamic> dataList = json.decode(response.body);
        visits = parseVisits(dataList);
        // Use the visits list as needed
      } else {
        // Handle API error
        print('Failed to fetch visit destinations: ${response.statusCode}');
      }
    } catch (e) {
      // Handle other exceptions
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // First dropdown for current visitor name
            DropdownButtonFormField<Visitor>(
              value: selectedVisitor,
              onChanged: (Visitor? newValue) {
                setState(() {
                  selectedVisitor = newValue;
                  selectedVisitorId = newValue?.id ?? 0; // Store selected Visitor ID
                  // Fetch visit destinations when a visitor is selected
                  if (selectedVisitor != null) {
                    getVisitDestinations(selectedVisitor!.id);
                  }
                });
              },
              items: visitors.map((Visitor visitor) {
                return DropdownMenuItem<Visitor>(
                  value: visitor,
                  child: Text(visitor.name),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Select Current Visitor',
                border: OutlineInputBorder(),
              ),
            ),
            
            SizedBox(height: 16.0),
            // Placeholder for displaying selected visitor and destinations
            selectedVisitor != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Selected Visitor: ${selectedVisitor!.name}'),
                      selectedVisitorDestinations != null
                          ? Text('Selected Destinations: ${selectedVisitorDestinations!.destinations.join(', ')}')
                          : Container(),
                      // Add more info or widgets related to the selected visitor
                    ],
                  )
                : Container(),
                SizedBox(height: 16.0),
            // Second dropdown for visitor destinations
            DropdownButtonFormField<Visit>(
              value: null, // Reset the selected visit when visitor changes
              onChanged: (Visit? newValue) {
                setState(() {
                  selectedVisitorDestinationsId = newValue?.id ?? 0; // Store selected Visit Destinations ID
                  // Handle selected visit destinations
                  // You can set 'selectedVisitorDestinations' or perform any logic here
                });
              },
              items: visits.map((Visit visit) {
                return DropdownMenuItem<Visit>(
                  value: visit,
                  child: Text('Visit ${visit.id} Destinations'),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Select Visitor Destinations',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            // Third dropdown for locations
            DropdownButtonFormField<Location>(
              value: selectedLocation,
              onChanged: (Location? newValue) {
                setState(() {
                  selectedLocation = newValue;
                  selectedLocationId = newValue?.id ?? 0; // Store selected Location ID
                  // Add any logic you want to perform when a location is selected
                });
              },
              items: locations.map((Location location) {
                return DropdownMenuItem<Location>(
                  value: location,
                  child: Text(location.name),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Select Location',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class Visit {
  final int id;
  final DateTime date;
  final DateTime entryTime;
  final List<int> visitDestinations;
  final List<String> visitDestinationsNames;

  Visit({
    required this.id,
    required this.date,
    required this.entryTime,
    required this.visitDestinations,
    required this.visitDestinationsNames,
  });

  factory Visit.fromJson(Map<String, dynamic> json) {
    return Visit(
      id: json['id'],
      date: DateTime.parse(json['date']),
      entryTime: DateTime.parse(json['entry_time']),
      visitDestinations: List<int>.from(json['visit_destinations']),
      visitDestinationsNames: List<String>.from(json['visit_destinations_names']),
    );
  }
}

List<Visit> parseVisits(List<dynamic> jsonList) {
  return jsonList.map((json) => Visit.fromJson(json)).toList();
}

class VisitorDestinations {
  final int id;
  final String name;
  final List<String> destinations;

  VisitorDestinations({
    required this.id,
    required this.name,
    required this.destinations,
  });
}