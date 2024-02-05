import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:screenshot/screenshot.dart';
import 'package:task_4_college/collage/collage_show.dart';
import 'package:task_4_college/cubit/collage_cubit_cubit.dart';
import 'package:task_4_college/model/image_model.dart';
import 'package:task_4_college/snack_bar.dart';

class MyHomePage1 extends StatefulWidget {
  const MyHomePage1({super.key});

  @override
  MyHomePage1State createState() => MyHomePage1State();
}

class MyHomePage1State extends State<MyHomePage1> with WidgetsBindingObserver {
  ScreenshotController screenshotController = ScreenshotController();
  late CollageCubit collageCubit;
  @override
  void initState() {
    collageCubit = BlocProvider.of<CollageCubit>(context);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      collageCubit.inistall(selectedCollageId: 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Collage"),
      ),
      body: BlocBuilder<CollageCubit, CollageCubitState>(
        bloc: collageCubit,
        builder: (context, state) {
          if (state is ImageListState) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Screenshot(
                      controller: screenshotController,
                      child: CollageWidget().commonCollageShow(
                        context: context,
                        isDisabled: false,
                        isColorShow: true,
                        collageCubit: collageCubit,
                        collageData: dummyData.where((element) => element.id == state.selectedCollageId).first,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  colorSelection(context, state),
                  const SizedBox(height: 10),
                  bottomRowList(state)
                ],
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: BlocBuilder<CollageCubit, CollageCubitState>(
        bloc: collageCubit,
        builder: (context, state) {
          if (state is ImageListState) {
            return FloatingActionButton(
              onPressed: () async {
                await screenshotController.capture().then(
                  (value) async {
                    bool isEmptyImage = dummyData
                        .where((element) => element.id == state.selectedCollageId)
                        .first
                        .tiles
                        .every((element) => element.imagePath != '');
                    if (isEmptyImage) {
                      if (value != null) {
                        var isDone = await ImageGallerySaver.saveImage(
                          Uint8List.fromList(value),
                          quality: 100,
                        );
                        if (isDone != null) {
                          CustomSnackbar.show(snackbarType: SnackbarType.SUCCESS, message: 'File saved successfully');
                        } else {
                          CustomSnackbar.show(
                              snackbarType: SnackbarType.SUCCESS, message: 'Can\'t save the file? Try again.');
                        }
                      }
                    } else {
                      CustomSnackbar.show(snackbarType: SnackbarType.ERROR, message: 'Uplaod All Image.');
                    }
                  },
                );
              },
              child: const Icon(Icons.save),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget colorSelection(BuildContext context, ImageListState state) {
    return GestureDetector(
      onTap: () async {
        Color selectedColor = await showColorPickerDialog(
          context,
          Colors.red,
          backgroundColor: Colors.white,
          pickersEnabled: {
            ColorPickerType.wheel: true,
            ColorPickerType.both: false,
            ColorPickerType.accent: false,
            ColorPickerType.primary: false,
          },
          showRecentColors: false,
        );
        collageCubit.changeColor(state: state, color: selectedColor);
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Frame Color Select'),
            Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: state.color,
                border: Border.all(color: Colors.black),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomRowList(ImageListState state) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        itemCount: dummyData.length,
        shrinkWrap: true,
        primary: true,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (context, index) {
          Collage collage = dummyData[index];
          return Container(
            margin: const EdgeInsets.all(5),
            padding: EdgeInsets.all(state.selectedCollageId == collage.id ? 1 : 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: state.selectedCollageId == collage.id
                  ? Colors.black.withOpacity(0.8)
                  : Colors.grey.withOpacity(
                      0.1,
                    ),
            ),
            child: GestureDetector(
              onTap: () => collageCubit.blankList(state: state, selectedId: collage.id),
              child: Center(
                child: CollageWidget().commonCollageShow(
                  context: context,
                  isColorShow: false,
                  isDisabled: true,
                  collageCubit: collageCubit,
                  collageData: dummyData[index],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
