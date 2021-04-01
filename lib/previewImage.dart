// import 'package:flutter/material.dart';
// class ShowImageToFullScreen extends StatefulWidget {
//   String imageUrl;
//   String imageDescription;
//
//   ShowImageToFullScreen(this.imageUrl,this.imageDescription);
//
//   @override
//   _ShowImageToFullScreenState createState() => _ShowImageToFullScreenState();
// }
//
// class _ShowImageToFullScreenState extends State<ShowImageToFullScreen> {
//   @override
//   void setState(fn) {
//     // TODO: implement setState
//     super.setState(fn);
//   }
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Stack(
//           children: [
//             InteractiveViewer(
//                 panEnabled: false, // Set it to false
//                 boundaryMargin: EdgeInsets.all(100),
//                 minScale: 0.5,
//                 maxScale: 2,
//                 child: Image(image: NetworkImage(widget.imageUrl),)
//             ),
//             Positioned(
//               left: 10,
//               bottom: 10,
//               child: Text(widget.imageDescription,style: TextStyle(
//                 color: Colors.red,
//                 fontSize: 15,
//               ),),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
