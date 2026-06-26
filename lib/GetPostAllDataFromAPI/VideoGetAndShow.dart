import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoGetAndShowScreen extends StatefulWidget {
  const VideoGetAndShowScreen({super.key});

  @override
  State<VideoGetAndShowScreen> createState() => _VideoGetAndShowScreenState();
}

class _VideoGetAndShowScreenState extends State<VideoGetAndShowScreen> {
  ChewieController? _chewieController;
  late VideoPlayerController _videoPlayerController;

  late VideoPlayerController _videoController;
  bool _isPlaying = false;

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

  void pickVideo() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: false,
    );

    if (result != null) {
      final filePath = result.files.single.path;
      // If the user picked a video from their gallery, we need to register it locally on the app before using it within Flutter.
      // If the user picked a video from their gallery, we'll display it above the camera preview.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Picked video: $filePath"),
        ),
      );
      _videoController.pause(); // Pause the current video
      _videoController = VideoPlayerController.file(File(filePath!))
        ..initialize().then((_) {
          setState(() {
            _isPlaying = true;
          });
          _videoController.play();
        });
    }
  }

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset(
        'asset/videos/06206-1743734868444377482-20240107_014244-vid1.mp4')
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose(); // Dispose of ChewieController
    _videoController.dispose();
    super.dispose();
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Video'),),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: (){
                  _pickVideo();
                }, 
                child: Text('Select Video')
              ),
              Center(
                child: _videoController.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _videoController.value.aspectRatio,
                        child: VideoPlayer(_videoController),
                      )
                    : Container(),
              ),
              if(selectedVideo!=null)
                  Text(selectedVideo!.path),
                  // AspectRatio(
                  //   aspectRatio: _videoPlayerController.value.aspectRatio,
                  //   child: VideoPlayer(_videoPlayerController),
                  // ),
                  if (_chewieController != null)
                    Chewie(
                      controller: _chewieController!, // Use ChewieController
                    ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Pick a video from the gallery
          pickVideo();
        },
        child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
      ),
    );
  }
}