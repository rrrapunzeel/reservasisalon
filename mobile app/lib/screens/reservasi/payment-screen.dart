// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:supabase_auth/screens/reservasi/checkout-page.dart';
// import 'package:supabase_auth/screens/reservasi/preview-page.dart';
// import 'package:supabase_auth/screens/reservasi/reservasi-page.dart';
// import 'package:supabase_auth/screens/reservasi/reservasi-view.dart';
// import 'package:time/time.dart';
// import 'dart:async';

// import '../../core/utils/color_constant.dart';

// class PaymentScreen extends StatefulWidget {
//   const PaymentScreen({Key? key}) : super(key: key);

//   @override
//   _PaymentScreenState createState() => _PaymentScreenState();
// }

// class _PaymentScreenState extends State<PaymentScreen> {
//   late DateTime _endTime;
//   late Duration _remainingTime;
//   final List<Widget> pages = const [
//     CheckoutPage(),
//     ReservasiView(),
//   ];

//   final List<String> tabTitles = const [
//     'Checkout',
//     'Confirmation',
//     'Payment',
//     'Detail Reservasi'
//   ];
//   final RxInt currentPageIndex = 2.obs;

//   @override
//   void initState() {
//     super.initState();
//     _endTime = DateTime.now() +
//         30.minutes; // Set the end time as current time + 30 minutes
//     _remainingTime = _endTime
//         .difference(DateTime.now()); // Calculate the initial remaining time

//     // Start a timer to update the remaining time every second
//     Timer.periodic(const Duration(seconds: 1), (_) {
//       setState(() {
//         _remainingTime = _endTime.difference(DateTime.now());
//       });

//       if (_remainingTime.isNegative) {
//         // If the remaining time is negative, navigate to the payment failed screen
//         Navigator.pushNamed(context, '/payment-failed');
//       }
//     });
//   }

//   Widget buildProgressTab() {
//     return Container(
//       height: 70,
//       color: Colors.white,
//       alignment: Alignment.center,
//       child: SizedBox(
//         child: ListView.builder(
//           scrollDirection: Axis.horizontal,
//           itemCount: tabTitles.length,
//           itemBuilder: (context, index) {
//             final isCurrentPage = index == currentPageIndex.value;
//             return InkWell(
//               onTap: () {
//                 if (index == 0) {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const CheckoutPage(),
//                     ),
//                   );
//                 } else if (index == 1) {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const PreviewPage(),
//                     ),
//                   );
//                 } else if (index == 2) {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const ReservasiView(),
//                     ),
//                   );
//                 }
//               },
//               child: Container(
//                 padding: const EdgeInsets.all(8),
//                 child: Column(
//                   children: [
//                     Container(
//                       width: 30,
//                       height: 30,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color:
//                             isCurrentPage ? ColorConstant.pink300 : Colors.grey,
//                       ),
//                       child: Center(
//                         child: Text(
//                           '${index + 1}',
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                     Text(
//                       tabTitles[index],
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color:
//                             isCurrentPage ? ColorConstant.pink300 : Colors.grey,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: ColorConstant.pink300,
//         centerTitle: true,
//         title: const Text("Booking Confirmation"),
//       ),
//       body: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.symmetric(vertical: 16),
//             child: buildProgressTab(),
//           ),
//           Expanded(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   '${_remainingTime.inMinutes}:${(_remainingTime.inSeconds % 60).toString().padLeft(2, '0')}',
//                   style: const TextStyle(fontSize: 48),
//                 ),
//                 const SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: () {
//                     // Complete payment logic
//                     Navigator.pushNamed(context, '/payment-success');
//                   },
//                   child: const Text('Complete Payment'),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
