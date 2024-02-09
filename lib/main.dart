// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_4_college/alignment/alignment.dart';
import 'package:task_4_college/cubit/collage_cubit_cubit.dart';
import 'package:task_4_college/collage/image_collage.dart';
import 'package:task_4_college/overlay_json/overlay_json_template.dart';
import 'package:task_4_college/zoom/zoom.dart';

void main() {
  BlocOverrides.runZoned(
    () => runApp(const MyApp()),
    blocObserver: AppBlocObserver(),
  );
}

final GlobalKey<ScaffoldMessengerState> snackbarKey = GlobalKey<ScaffoldMessengerState>();

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
            // TextButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => const MyHomePage2(),
            //       ),
            //     );
            //   },
            //   child: const Text('Dynamic Grid'),
            // ),
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
                    builder: (context) => const ZoomExample(),
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
