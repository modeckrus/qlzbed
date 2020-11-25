// import 'dart:io';

// import 'package:qlzbed/entities/timestamp.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';

// import '../entities/msize.dart';
// import 'image_capture_bloc/imagecapture_bloc.dart';
// import 'my_image.dart';

// class ImageCapture extends StatefulWidget {
//   final String uid;
//   final String path;
//   const ImageCapture({Key key, @required this.uid, @required this.path})
//       : super(key: key);

//   createState() => _ImageCaptureState(uid);
// }

// class _ImageCaptureState extends State<ImageCapture> {
//   /// Active image file
//   File _imageFile;
//   final String uid;

//   _ImageCaptureState(this.uid);

//   /// Cropper plugin
//   Future<void> _cropImage() async {
//     File cropped = await ImageCropper.cropImage(
//       sourcePath: _imageFile.path,
//       // ratioX: 1.0,
//       // ratioY: 1.0,
//       // maxWidth: 512,
//       // maxHeight: 512,
//     );

//     setState(() {
//       _imageFile = cropped ?? _imageFile;
//     });
//   }

//   /// Select an image via gallery or camera
//   Future<void> _pickImage(ImageSource source) async {
//     File selected = await ImagePicker.pickImage(source: source);

//     setState(() {
//       _imageFile = selected;
//     });
//   }

//   /// Remove image
//   void _clear() {
//     setState(() => _imageFile = null);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//         create: (_) =>
//             ImagecaptureBloc(storage: FirebaseStorage.instance.ref()),
//         child: Scaffold(
//             appBar: AppBar(),
//             bottomNavigationBar: BottomAppBar(
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   IconButton(
//                     icon: Icon(
//                       Icons.photo_camera,
//                       size: 30,
//                     ),
//                     onPressed: () => _pickImage(ImageSource.camera),
//                     color: Colors.blue,
//                   ),
//                   IconButton(
//                     icon: Icon(
//                       Icons.photo_library,
//                       size: 30,
//                     ),
//                     onPressed: () => _pickImage(ImageSource.gallery),
//                     color: Colors.pink,
//                   ),
//                 ],
//               ),
//             ),
//             body: buildBody()));
//   }

//   Widget buildBody() {
//     if (_imageFile != null) {
//       return ListView(
//         children: <Widget>[
//           Container(padding: EdgeInsets.all(32), child: Image.file(_imageFile)),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: <Widget>[
//               FlatButton(
//                 color: Colors.black,
//                 child: Icon(Icons.crop),
//                 onPressed: _cropImage,
//               ),
//               FlatButton(
//                 color: Colors.black,
//                 child: Icon(Icons.refresh),
//                 onPressed: _clear,
//               ),
//             ],
//           ),
//           Padding(
//             padding: const EdgeInsets.all(32),
//             child: Uploader(
//               file: _imageFile,
//               uid: uid,
//               path: widget.path,
//             ),
//           )
//         ],
//       );
//     } else {
//       return StreamBuilder(
//         stream: Firestore.instance
//             .collection('user')
//             .document(widget.uid)
//             .collection('images')
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return ErrorWidget(snapshot.error);
//           }
//           if (!snapshot.hasData) {
//             return LinearProgressIndicator();
//           }
//           final query = snapshot.data as QuerySnapshot;
//           final images = query.documents;
//           return Container(
//             child: GridView.builder(
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2),
//                 scrollDirection: Axis.vertical,
//                 itemCount: images.length,
//                 itemBuilder: (context, index) {
//                   return Container(
//                     padding: EdgeInsets.all(4),
//                     child: GestureDetector(
//                       onTap: () {
//                         Navigator.pop(context, images[index].data['Path']);
//                       },
//                       child: MyImage(
//                           path: images[index].data['Path'],
//                           size: MSize(width: 200, height: 200)),
//                     ),
//                   );
//                 }),
//           );
//         },
//       );
//     }
//   }
// }

// /// Widget used to handle the management of
// class Uploader extends StatefulWidget {
//   final File file;
//   final String uid;
//   final String path;
//   Uploader(
//       {Key key, @required this.file, @required this.uid, @required this.path})
//       : super(key: key);

//   createState() => _UploaderState(uid);
// }

// class _UploaderState extends State<Uploader> {
//   final String uid;
//   final FirebaseStorage _storage = FirebaseStorage.instance;

//   StorageUploadTask _uploadTask;
//   String storagePath;
//   _UploaderState(this.uid);

//   _startUpload() {
//     storagePath =
//         'users/$uid/${widget.file.path.split('/').last.split('.').first}/${widget.file.path.split('/').last}';
//     BlocProvider.of<ImagecaptureBloc>(context)
//         .add(ImageCaptureStartUpload(file: widget.file, path: storagePath));
//     // setState(() {
//     //   _uploadTask = _storage.ref().child(storagePath).putFile(widget.file);
//     // });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<ImagecaptureBloc, ImagecaptureState>(
//       listener: (context, state) async {
//         if (state is ImageCaptureSuccessfulS ||
//             state is ImageCaptureFinishedS) {
//           await Firestore.instance
//               .collection("user")
//               .document(uid)
//               .collection("images")
//               .add({
//             'Path': storagePath,
//             'Ismine': true,
//           });
//           final docref = await Firestore.instance
//               .collection("service")
//               .document('service')
//               .collection("thubnail")
//               .add({
//             'Path': storagePath,
//             'Ready': false,
//             'Sizes': [
//               {
//                 'Width': 100,
//                 'Height': 100,
//               },
//               {
//                 'Width': 200,
//                 'Height': 200,
//               },
//               {
//                 'Width': 300,
//                 'Height': 300,
//               },
//               {
//                 'Width': 500,
//                 'Height': 500,
//               }
//             ]
//           });
//           docref.snapshots().listen((event) {
//             if (event.data['Ready'] != null || event.data['Ready'] == true) {
//               Navigator.pop(context, storagePath);
//             }
//           });
//         }
//       },
//       child: BlocBuilder<ImagecaptureBloc, ImagecaptureState>(
//         builder: (context, state) {
//           if (state is ImageCaptureProgressS) {
//             return Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 LinearProgressIndicator(value: state.persent),
//                 Text(
//                   '${(state.persent * 100).toStringAsFixed(2)} % ',
//                   style: TextStyle(fontSize: 50),
//                 ),
//               ],
//             );
//           }
//           if (state is ImageCaptureSuccessfulS ||
//               state is ImageCaptureFinishedS) {
//             return Center(
//               child: Text('🎉🎉🎉',
//                   style: TextStyle(
//                       color: Colors.greenAccent, height: 2, fontSize: 30)),
//             );
//           }
//           if (state is ImageCapturePauseS) {
//             return FlatButton(
//               child: Icon(Icons.play_arrow, size: 50),
//               onPressed: () {
//                 BlocProvider.of<ImagecaptureBloc>(context)
//                     .add(ImageCapturePauseE());
//               },
//             );
//           }
//           if (state is ImagecaptureInitial) {
//             return FlatButton.icon(
//                 color: Colors.blue,
//                 label: Text('Upload'),
//                 icon: Icon(Icons.cloud_upload),
//                 onPressed: _startUpload);
//           }
//           return Container();
//         },
//       ),
//     );
//     //   if (_uploadTask != null) {
//     //     return StreamBuilder<StorageTaskEvent>(
//     //         stream: _uploadTask.events,
//     //         builder: (context, snapshot) {
//     //           var event = snapshot?.data?.snapshot;

//     //           double progressPercent = event != null
//     //               ? event.bytesTransferred / event.totalByteCount
//     //               : 0;
//     //           if (_uploadTask.isComplete) {
//     //             Firestore.instance
//     //                 .collection("user")
//     //                 .document(uid)
//     //                 .collection("images")
//     //                 .add({
//     //               'Path': storagePath,
//     //               'Ismine': true,
//     //             });
//     //             Firestore.instance
//     //                 .collection("service")
//     //                 .document('service')
//     //                 .collection("thubnail")
//     //                 .add({
//     //               'Path': storagePath,
//     //               'Ready': false,
//     //               'Sizes': [
//     //                 {
//     //                   'Width': 100,
//     //                   'Height': 100,
//     //                 },
//     //                 {
//     //                   'Width': 200,
//     //                   'Height': 200,
//     //                 },
//     //                 {
//     //                   'Width': 300,
//     //                   'Height': 300,
//     //                 },
//     //                 {
//     //                   'Width': 500,
//     //                   'Height': 500,
//     //                 }
//     //               ]
//     //             });
//     //             //Navigator.pop(context, [widget.file.path, storagePath]);
//     //           }
//     //           return Column(
//     //               mainAxisAlignment: MainAxisAlignment.center,
//     //               crossAxisAlignment: CrossAxisAlignment.center,
//     //               children: [
//     //                 if (_uploadTask.isComplete)
//     //                   Text('🎉🎉🎉',
//     //                       style: TextStyle(
//     //                           color: Colors.greenAccent,
//     //                           height: 2,
//     //                           fontSize: 30)),
//     //                 if (_uploadTask.isPaused)
//     //                   FlatButton(
//     //                     child: Icon(Icons.play_arrow, size: 50),
//     //                     onPressed: _uploadTask.resume,
//     //                   ),
//     //                 if (_uploadTask.isInProgress)
//     //                   FlatButton(
//     //                     child: Icon(Icons.pause, size: 50),
//     //                     onPressed: _uploadTask.pause,
//     //                   ),
//     //                 LinearProgressIndicator(value: progressPercent),
//     //                 Text(
//     //                   '${(progressPercent * 100).toStringAsFixed(2)} % ',
//     //                   style: TextStyle(fontSize: 50),
//     //                 ),
//     //               ]);
//     //         });
//     //   } else {
//     //     return FlatButton.icon(
//     //         color: Colors.blue,
//     //         label: Text('Upload to Firebase'),
//     //         icon: Icon(Icons.cloud_upload),
//     //         onPressed: _startUpload);
//     //   }
//   }
// }
