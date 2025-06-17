import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: RotatingContainer());
  }
}

class RotatingContainer extends StatefulWidget {
  const RotatingContainer({super.key});

  @override
  _RotatingContainerState createState() => _RotatingContainerState();
}

//class
class _RotatingContainerState extends State<RotatingContainer>
    with SingleTickerProviderStateMixin {
  double rotationX = 0, goalRotationX = 0;
  double rotationY = 0, goalRotationY = 0;
  late AnimationController controller;

  StreamSubscription<GyroscopeEvent>? gyroSub;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(vsync: this);
    controller.repeat(period: Duration(milliseconds: 16));

    DateTime? lastGyroTimestamp = DateTime.now();

    gyroSub = gyroscopeEventStream().listen((event) {
      final now = DateTime.now();
      // if (lastGyroTimestamp != null) {
      final dt = now.difference(lastGyroTimestamp!).inMilliseconds / 1000.0;
      goalRotationY += event.y * dt;
      goalRotationY = goalRotationY.clamp(-pi / 4, pi / 4);

      goalRotationX -= event.x * dt;
      goalRotationX = goalRotationX.clamp(-pi / 4, pi / 4);
      // }
      lastGyroTimestamp = now;
    });
  }

  @override
  void dispose() {
    gyroSub?.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            rotationX = lerp(rotationX, goalRotationX, 0.1);
            rotationY = lerp(rotationY, goalRotationY, 0.1);

            goalRotationX = lerp(goalRotationX, 0, 0.04);
            goalRotationY = lerp(goalRotationY, 0, 0.04);
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(rotationX)
                ..rotateY(rotationY),
              child: child,
            );
          },
          child: Container(
            width: 250,
            height: 150,
            color: Colors.blue,
            child: Center(
              child: Text(
                "Rotating Container",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

double lerp(double a, double b, double t) {
  return a + (b - a) * t;
}








// import 'dart:async';
// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:sensors_plus/sensors_plus.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(home: RotatingContainer());
//   }
// }

// class RotatingContainer extends StatefulWidget {
//   const RotatingContainer({super.key});

//   @override
//   _RotatingContainerState createState() => _RotatingContainerState();
// }

// class _RotatingContainerState extends State<RotatingContainer>
//     with SingleTickerProviderStateMixin {
//   double rotationX = 0, goalRotationX = 0;
//   double rotationY = 0, goalRotationY = 0;
//   double rotationZ = 0, goalRotationZ = 0;
//   late AnimationController controller;

//   double? initialAngleX;
   //double? initialAngleY;

   // DateTime? lastGyroTimestamp;

//   StreamSubscription<GyroscopeEvent>? gyroSub;
//   StreamSubscription<AccelerometerEvent>? accelSub;

//   @override
//   void initState() {
//     super.initState();

//     controller = AnimationController(vsync: this);
//     controller.repeat(period: Duration(milliseconds: 16));

//     DateTime? lastGyroTimestamp;

//     gyroSub = gyroscopeEventStream().listen((event) {
//       final now = DateTime.now();
//       if (lastGyroTimestamp != null) {
//         final dt = now.difference(lastGyroTimestamp!).inMilliseconds / 1000.0;
//         goalRotationY -= event.y * dt;
//         goalRotationY = goalRotationY.clamp(-pi / 4, pi / 4);

//         goalRotationX += event.x * dt; // добавь это!
//         goalRotationX = goalRotationX.clamp(-pi / 4, pi / 4);
//       }
//       lastGyroTimestamp = now;
//     });

//     accelSub = accelerometerEventStream().listen((event) {
//       print('accelerometer: \n x-${event.x} \n y-${event.y} \n z-${event.z}');
//       double accAngleX = atan2(event.y, event.z);
//        double accAngleY = atan2(
//          event.x,
//          sqrt(event.y * event.y + event.z * event.z),
//        );

//       if (initialAngleX == null
//       || initialAngleY == null
//       ) {
//         initialAngleX = accAngleX;
//         initialAngleY = accAngleY;
//       }

//       goalRotationX = accAngleX - initialAngleX!;
//       goalRotationY = accAngleY - initialAngleY!;

//       goalRotationX = goalRotationX.clamp(-pi / 4, pi / 4);
//       goalRotationY = goalRotationY.clamp(-pi / 4, pi / 4);

//        const double alignmentThreshold = 0.2; // 0.1 = ` 5.7 degrees
//        const double correctionStrength = 0.1;

//        if (rotationX.abs() < alignmentThreshold) {
//          gyroX *= (1 - correctionStrength);
//        }
//        if (rotationY.abs() < alignmentThreshold) {
//          gyroY *= (1 - correctionStrength);
//        }
//     });
//   }

//   @override
//   void dispose() {
//     gyroSub?.cancel();
//     accelSub?.cancel();
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: AnimatedBuilder(
//           animation: controller,
//           builder: (context, child) {
//             rotationX = lerp(rotationX, goalRotationX, 0.1);
//             rotationY = lerp(rotationY, goalRotationY, 0.1);

//             goalRotationX = lerp(goalRotationX, 0, 0.02);
//             goalRotationY = lerp(goalRotationY, 0, 0.02);
//             return Transform(
//               alignment: Alignment.center,
//               transform: Matrix4.identity()
//                 ..setEntry(3, 2, 0.001)
//                 ..rotateX(rotationX)
//                 ..rotateY(rotationY),
//               child: child,
//             );
//           },
//           child: Container(
//             width: 250,
//             height: 150,
//             color: Colors.blue,
//             child: Center(
//               child: Text(
//                 "Rotating Container",
//                 style: TextStyle(color: Colors.white, fontSize: 18),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// double lerp(double a, double b, double t) {
//   return a + (b - a) * t;
// }
