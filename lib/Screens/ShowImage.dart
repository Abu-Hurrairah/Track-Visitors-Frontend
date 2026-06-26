import 'dart:typed_data';

import 'package:flutter/material.dart';

class ShowImageScreen extends StatefulWidget {
  final List<int>? image;
  ShowImageScreen(this.image);

  @override
  State<ShowImageScreen> createState() => _ShowImageScreenState();
}

class _ShowImageScreenState extends State<ShowImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Camera Image')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Text('Image'),
              if (widget.image != null && widget.image!.isNotEmpty)
                Image.memory(Uint8List.fromList(widget.image!),
                  errorBuilder: (context, error, stackTrace) {
                    print('Error loading image: $error');
                    return Text('Error loading image');
                  },
                ),
              // if(widget.image.isNotEmpty)
              //   Image.memory(widget.image)
            ],
          ),
        ),
      ),
    );
  }
}