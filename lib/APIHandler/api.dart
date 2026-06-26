import 'dart:convert';

import 'package:http/http.dart' as http;

class APIHandler {
  static String ip = "http://localhost:5000";

  static Future<dynamic> addVisitor(String name, String contactNumber,int image_count, List<dynamic> imagePaths) async {
    try{
      // String url = "$ip/upload_visitor_info";
      String url = "$ip/AddVisitor";
      var request = await http.MultipartRequest('POST', Uri.parse(url));

      for (var image in imagePaths) {
        http.MultipartFile file = await http.MultipartFile.fromPath('images', image.path);
        request.files.add(file);
      }
      // http.MultipartFile file = await http.MultipartFile.fromPath('images', selectedImages[0].path);
      // request.files.add(file);
      request.fields['name'] = name;
      request.fields['contact'] = contactNumber;
      // request.fields['destination'] = destination;
      request.fields['count'] = image_count.toString();

      var response = await request.send();
      return response;
    }catch(e){
      print('Error submitting form: $e');
    }
  }

  static Future<dynamic> addVisit(String visitor, String time, String destination) async {
    try{
      String url = "$ip/StartVisit";
      var request = await http.MultipartRequest('POST', Uri.parse(url));

      request.fields['id'] = visitor;
      request.fields['starttime'] = time;
      request.fields['destination'] = destination;

      var response = await request.send();
      return response;
    }catch(e){
      print('Error submitting form: $e');
    }
  }




  
  static Future <dynamic> getAllLocations() async{
    print('location running');
    try{
      // var request = http.MultipartRequest('GET',Uri.parse('http://localhost:5000/GetAllLocations'),);
      String url="$ip/GetAllLocation";
      var request=http.MultipartRequest('GET',Uri.parse(url));
      var response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(await response.stream.bytesToString());
        print(jsonResponse);
        return jsonResponse;
      }
    }catch (e) {
      print('Error submitting form: $e');
    }
  }


  static Future<List<Map<String, dynamic>>> checkLogin(String name, String password) async {
    try{
      // String url = "$ip/upload_visitor_info";
      String url = "$ip/Login";
      var request = await http.Request('POST', Uri.parse(url));

      // Set the Content-Type header to 'application/json'
    request.headers['Content-Type'] = 'application/json';

    // Add the username and password as JSON data in the request body
    Map<String, dynamic> requestData = {
      'username': name,
      'password': password,
    };

    request.body = jsonEncode(requestData);

      var response = await request.send();
      print(response.statusCode);

      // Convert the streamed response to a regular Response
    var responseStream = await response.stream.bytesToString();
    print(responseStream);
    var jsonResponse = json.decode(responseStream);
    print(jsonResponse);
    print(jsonResponse.runtimeType);
    // List<Map<String, dynamic>> userList = jsonResponse.cast<Map<String, dynamic>>();
    // print(userList);
    // print(userList.runtimeType);
    return jsonResponse.cast<Map<String, dynamic>>();

      // return response;
    }catch(e){
      print('Error submitting form: $e');
      // return http.Response('Error: $e', HttpStatus.internalServerError);
      throw e; // Throw an exception in case of an error
    }
  }

  static Future <dynamic> getAllAlerts() async{
    print('Alert running');
    try{
      // var request = http.MultipartRequest('GET',Uri.parse('http://localhost:5000/GetAllLocations'),);
      String url="$ip/GetAllAlerts";
      var request=http.MultipartRequest('GET',Uri.parse(url));
      var response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(await response.stream.bytesToString());
        print(jsonResponse);
        return jsonResponse;
      }
    }catch (e) {
      print('Error submitting form: $e');
    }
  }


}

// class APIHandler {
//   static String ip = "http://127.0.0.1:5000";

//   static Future<dynamic> addVisitor(
//       String name, String contactNumber, String destination, List<dynamic> imagePaths) async {
//     String url = "$ip/upload_visitor_info";

//     Map<String, dynamic> requestData = {
//       'name': name,
//       'contact_number': contactNumber,
//       'destination': destination,
//       'images': imagePaths,
//     };

//     try {
//       var response = await http.post(
//         Uri.parse(url),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(requestData),
//       );
//       return response;
//     } catch (e) {
//       print('Error sending request: $e');
//       return -1;
//     }
//   }
// }