import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_4_college/alignment/alignment.dart';
import 'package:task_4_college/cubit/collage_cubit_cubit.dart';
import 'package:task_4_college/collage/image_collage.dart';
import 'package:task_4_college/overlay_json/overlay_json_template.dart';
import 'package:task_4_college/zoom/zoom.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

final GlobalKey<ScaffoldMessengerState> snackbarKey = GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(414, 896),
    );
    return BlocProvider(
      create: (context) => CollageCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: snackbarKey,
        title: 'Oceanmtech Task',
        theme: ThemeData(
          primaryColor: Colors.blue,
          primarySwatch: Colors.blue,
        ),
        home: const MyHomeScreen(),
      ),
    );
  }
}

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key});

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              style: const ButtonStyle(splashFactory: NoSplash.splashFactory),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OverlayJsonTemplate(),
                  ),
                );
              },
              child: const Text('Task 1 (Overlay json template)'),
            ),
            TextButton(
              style: const ButtonStyle(splashFactory: NoSplash.splashFactory),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ZoomableImage(),
                  ),
                );
              },
              child: const Text('Task 2 (Image Zoom)'),
            ),
            TextButton(
              style: const ButtonStyle(splashFactory: NoSplash.splashFactory),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ImageCollage(),
                  ),
                );
              },
              child: const Text('Task 3 (Dynamic Grid Template)'),
            ),
            TextButton(
              style: const ButtonStyle(splashFactory: NoSplash.splashFactory),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AlignmentTask5(),
                  ),
                );
              },
              child: const Text('Task 5 (Element Alignment)'),
            ),
          ],
        ),
      ),
    );
  }
}
