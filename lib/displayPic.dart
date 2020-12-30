import 'package:flutter/material.dart';
import './albumModel.dart';
import 'package:http/http.dart' as http;
import "dart:io" as Io;
import "dart:io";
import 'dart:convert';

Future<Album> fetchAlbum(imagePath2File) async {
  final bytes = Io.File(imagePath2File).readAsBytesSync();

  var uri = Uri.parse(
      "https://southcentralus.api.cognitive.microsoft.com/customvision/v3.0/Prediction/f8c9e6b7-2aa6-4523-ae73-cf31b4cda4f1/classify/iterations/Iteration1/image/");
  var request = new http.Request("POST", uri)
    ..headers['Prediction-Key'] = "b0543df758314a37bdb2ec1f12021157"
    ..headers['Content-Type'] = "application/octet-stream"
    ..bodyBytes = bytes;

  //var response = await request.send();
  http.Response response = await http.Response.fromStream(await request.send());
  print(request);
  print("Result: ${response.statusCode}");
  print(response.statusCode);
  print(response.body);
  print("0ssssss");
  // final body = Album.fromJson(jsonDecode(response.body));
  // print("BODYYYY");
  // print(body.predictions);
  return Album.fromJson(jsonDecode(response.body));

  //  response.stream.transform(utf8.decoder).listen((value) {
  //   print("Value :" + value);
  // });

  // if (response.statusCode == 200) {
  //   // If the server did return a 200 OK response,
  //   // then parse the JSON.
  //   response.stream.transform(utf8.decoder).listen((value) {
  //     print("Value :" + value);
  //   });

  //   return Album.fromJson(jsonDecode(request.body));
  // } else {
  //   // If the server did not return a 200 OK response,
  //   // then throw an exception.
  //   throw Exception('Failed to load album');
  // }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;
  final Future<Album> futureAlbum1;
  DisplayPictureScreen({Key key, this.imagePath, this.futureAlbum1})
      : super(key: key);

  @override
  _DisplayPictureScreenState createState() =>
      _DisplayPictureScreenState(futureAlbum1, imagePath);
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  Future<Album> futureAlbum1;
  String imagePath;
  _DisplayPictureScreenState(this.futureAlbum1, this.imagePath);

  // print("----->" + imagePath);
//ddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
// Future uploadImage(File imageFile)async{
//   var stream= new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
//   var length= await imageFile.length();
//   var uri = Uri.parse("Image upload url");
//   var request = new http.MultipartRequest("POST", uri);
//   var filename = "Your image name";
//   var multipartFile = new http.MultipartFile("image", stream, length, filename: basename(filename));
//   request.files.add(multipartFile);
//   var response = await request.send();
//   if(response.statusCode==200){
//     print("Image Uploaded");
//   }else{
//     print("Upload Failed");
//  }
// }
//ddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd

  @override
  void initState() {
    super.initState();
    print("Temp Image Path: " + imagePath);
    futureAlbum1 = fetchAlbum(imagePath);
    // setState(() {

    // });
  }

  // Future<String> image2String() async {
  //   Image image = Image.file(File(imagePath));
  //   final bytes = await Io.File(image).readAsBytes();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: ListView(
        children: [
          Image.file(File(widget.imagePath)),
          Center(
            child: FutureBuilder<Album>(
              future: futureAlbum1,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  print("eeeeeee");
                  print(snapshot.data.toString());
                  print(snapshot.data.predictions);
                  print(snapshot.data.predictions[0].tagName);
                  return Text(snapshot.data.predictions[0].tagName);
                } else if (snapshot.hasError) {
                  return Text("Error1: ${snapshot.error}");
                }

                // By default, show a loading spinner.
                return CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),
    );
  }
}

//TODO: convert image form path to stirng to POST then only get
// or post then use .then https://stackoverflow.com/questions/50278258/http-post-with-json-on-body-flutter-dart

//Success POS and get, but stuck in stream ..need change to string and print it out
// from response.body, break down the nested JSON and take the first prediction