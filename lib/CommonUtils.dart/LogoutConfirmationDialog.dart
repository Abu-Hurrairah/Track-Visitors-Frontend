
import 'package:flutter/material.dart';
import 'package:project/Screens/Login.dart';

void showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout Confirmation'),
          content: Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Perform logout action here
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) {
                    return Login();
                  }),
                );
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }