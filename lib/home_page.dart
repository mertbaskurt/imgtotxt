import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imgtotxt/claude_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _image;
  String? _description;
  bool _isLoading = false;
  final _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        maxHeight: 1080,
        maxWidth: 1920,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
        await _analyseImage();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _analyseImage() async {
    if (_image == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final description = await ClaudeService().analyzeImage(_image!);

      setState(() {
        _description = description;
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI APP'),
      ),

      //BODY

      body: Column(
        children: [
          //display img
          Container(
            height: 300,
            color: Colors.grey.shade300,
            child: _image != null
                ? Image.file(_image!)
                : const Center(child: Text("Fotoğraf seç")),
          ),

          const SizedBox(height: 25,),




          //buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //fotograf cek
              ElevatedButton(
                onPressed: () => _pickImage(ImageSource.camera),
                child: const Text('Fotoğraf çek'),
              ),

              //fotograf sec buton
              ElevatedButton(
                onPressed: () => _pickImage(ImageSource.gallery),
                child: const Text('Fotoğraf seç'),
              ),
            ],
          ),

          const SizedBox(height: 25,),

          //desc
          if(_isLoading) const Center(child: CircularProgressIndicator())


          else if(_description != null)
          Text(_description!),


        
        ],
      ),
    );
  }
}
