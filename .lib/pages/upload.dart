import 'package:flutter/material.dart';
import 'package:inphomeet/widgets/header.dart';

class Upload extends StatefulWidget {
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titleText: "Upload"),
      body: Text("Upload"),
    );
  }
}
