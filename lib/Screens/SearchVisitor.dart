import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class SearchVisitorScreen extends StatefulWidget {
  const SearchVisitorScreen({super.key});

  @override
  State<SearchVisitorScreen> createState() => _SearchVisitorScreenState();
}

class _SearchVisitorScreenState extends State<SearchVisitorScreen> {

  List<Map<String, dynamic>> visitors = []; // Replace with the actual list of visitors
  String selectedVisitor = ''; // Holds the currently selected visitor
  String selectedVisitorId = ''; // Holds the currently selected visitor ID
  DateTime? startDate;
  DateTime? endDate;
  List<Map<String, dynamic>> visitorReport = [];

  Future<void> fetchVisitorReport(String id, String startDate, String endDate) async {
    try {
      String apiUrl = 'your_api_url_here'; // Replace with your actual API endpoint

      Map<String, String> queryParams = {
        'id': id,
        'start_date': startDate,
        'end_date': endDate,
      };

      String queryString = Uri(queryParameters: queryParams).query;

      final response = await http.get(Uri.parse('$apiUrl?$queryString'));

      if (response.statusCode == 200) {
        // Successfully fetched data
        final data = json.decode(response.body);
        // Process data or update UI as needed
        visitorReport = List<Map<String, dynamic>>.from(data['visitors']);
        print(data);
      } else {
        // Error handling if the request was not successful
        print('Failed to fetch visitors report. Status code: ${response.statusCode}');
        print(response.body);
      }
    } catch (e) {
      // Handle any exceptions that might occur during the request
      print('Exception occurred: $e');
    }
  }

  Future<void> fetchAllVisitors() async {
    try {
      String apiUrl = 'your_api_url_here'; // Replace with your actual API endpoint
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Successfully fetched data
        final data = json.decode(response.body);

        // Assuming your API response has a 'visitors' key containing a list of visitors
        List<Map<String, dynamic>> fetchedVisitors = data['visitors'];

        // Update the visitors list after fetching data
        setState(() {
          visitors = fetchedVisitors;
        });
      } else {
        // Error handling if the request was not successful
        print('Failed to fetch visitors. Status code: ${response.statusCode}');
        print(response.body);
      }
    } catch (e) {
      // Handle any exceptions that might occur during the request
      print('Exception occurred: $e');
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != (isStartDate ? endDate : startDate)) {
      setState(() {
        if (isStartDate) {
          startDate = pickedDate;
//           Text(
//   'Start Date: ${startDate != null ? DateFormat('yyyy-MM-dd').format(startDate!) : "None"}',
//   style: TextStyle(fontSize: 16),
// );

        } else {
          endDate = pickedDate;
//           Text(
//   'Start Date: ${startDate != null ? DateFormat('yyyy-MM-dd').format(startDate!) : "None"}',
//   style: TextStyle(fontSize: 16),
// );

        }
      });
    }
  }


  @override
  void initState() {
    super.initState();
    // Fetch visitors when the widget is initialized
    fetchAllVisitors();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // DropdownButton widget to display the visitors
            DropdownButton<String>(
              value: selectedVisitor,
              items: visitors.map((visitor) {
                return DropdownMenuItem<String>(
                  value: visitor['id'].toString(), // Adjust based on your visitor data
                  child: Text(visitor['name']), // Adjust based on your visitor data
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedVisitor = value!;
                  selectedVisitorId = value!;
                });
              },
              hint: Text('Select a Visitor'),
            ),
            SizedBox(height: 20),
            // Display the selected visitor (optional)
            Text(
              'Selected Visitor: ${selectedVisitor ?? "None"}',
              style: TextStyle(fontSize: 16),
            ),
            
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Start Date: ${startDate?.toLocal()}'.split(' ')[0],
                  style: TextStyle(fontSize: 16),
                ),
                ElevatedButton(
                  onPressed: () => _selectDate(context, true),
                  child: Text('Select Start Date'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'End Date: ${endDate?.toLocal()}'.split(' ')[0],
                  style: TextStyle(fontSize: 16),
                ),
                ElevatedButton(
                  onPressed: () => _selectDate(context, false),
                  child: Text('Select End Date'),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (selectedVisitorId.isNotEmpty && startDate != null && endDate != null) {
                  // Do something with the selected values
                  print('Selected Visitor ID: $selectedVisitorId');
                  print('Start Date: ${startDate!.toLocal()}');
                  print('End Date: ${endDate!.toLocal()}');

                  // Call fetchVisitorReport with the selected values
                  fetchVisitorReport(
                    selectedVisitorId,
                    startDate!.toLocal().toString(),
                    endDate!.toLocal().toString(),
                  );
                } else {
                  print('Incomplete selection. Please select a visitor and dates.');
                }
              },
              child: Text('Save Visitor ID and Dates'),
            ),
            SizedBox(height: 20),
            // Show fetched data
            Expanded(
              child: ListView.builder(
                itemCount: visitors.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(visitors[index]['name']),
                    subtitle: Text('Visitor ID: ${visitors[index]['id']}'),
                    // Add more details as needed
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