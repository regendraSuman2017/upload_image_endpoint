
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class UploadImageDemo extends StatefulWidget {
  UploadImageDemo() : super();

  final String title = "Upload Image Demo";

  @override
  UploadImageDemoState createState() => UploadImageDemoState();
}

class UploadImageDemoState extends State<UploadImageDemo> {
  //
  //static const String uploadEndPoint = 'http://localhost/flutter_test/upload_image.php';
  //static const String uploadEndPoint = 'http://localhost/testapp - Copy/upload_image.php';
  static const String uploadEndPoint = 'http://localhost/testapp/index.php/Welcome/index?';
  Uri uri = Uri.parse(uploadEndPoint);
  XFile? pickedFile;

  ImagePicker picker = ImagePicker();
  var _image;

  String status = '';
  String? base64Image;
  File? tmpFile;
  String errMessage = 'Error Uploading Image';

  chooseImage() async{

    pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      tmpFile = File(pickedFile!.path);
      base64Image = base64Encode(tmpFile!.readAsBytesSync());
    });
    print("lkajdlksa ${base64Image}");
    setStatus('');
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  startUpload() {
    setStatus('Uploading Image...');
    if (null == tmpFile) {
      setStatus(errMessage);
      return;
    }
    print("Last Path ${tmpFile!.path}");
    String fileName = tmpFile!.path.split('/').last;
    print("Last Path ${fileName}");
    upload(fileName);
  }

  upload(String fileName) {
    http.post(uri, body: jsonEncode({
      "image": base64Image,
      "name": fileName,
    })).then((result) {
      print("lkajdlakjd ${result}");
      setStatus(result.statusCode == 200 ? result.body : errMessage);
    }).catchError((error) {
      setStatus(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("Upload Image Demo"),
      ),
      body: Center(
        child: Container(
          width: 300,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.red
            )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                  "Thank you!", style: GoogleFonts.nunitoSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w500)
              ),

              SizedBox(height: 10,),
              Text(
                  "Your application hase been submitted successfully.", style: GoogleFonts.nunitoSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                color: Color(0XFF413e3e)
              ),
                textAlign: TextAlign.center,
              ),
             /* Text("Best Color", style: TextStyle(color: Colors.red),),
              OutlinedButton(
                onPressed: chooseImage,
                child: Text('Choose Image'),
              ),
              SizedBox(
                height: 20.0,
              ),
              tmpFile==null?Text("ss"):Image.file(tmpFile!,height: 20),
              SizedBox(
                height: 20.0,
              ),
              OutlinedButton(
                onPressed: startUpload,
                child: Text('Upload Image'),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                status,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
