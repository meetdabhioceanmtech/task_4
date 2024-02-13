import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:screenshot/screenshot.dart';
import 'package:task_4_college/model/overlay_json_model.dart';
import 'package:task_4_college/utils/snack_bar.dart';

class OverlayJsonTemplate extends StatefulWidget {
  const OverlayJsonTemplate({super.key});

  @override
  State<OverlayJsonTemplate> createState() => _OverlayJsonTemplateState();
}

class _OverlayJsonTemplateState extends State<OverlayJsonTemplate> {
  List<SectorModel> templateList = [];
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    addJson();
  }

  addJson() {
    loadJsonAsset('assets/json/first.json');
    loadJsonAsset('assets/json/second.json');
    loadJsonAsset('assets/json/3.json');
    loadJsonAsset('assets/json/4.json');
  }

  Future<void> loadJsonAsset(String assetPath) async {
    try {
      String jsonString = await rootBundle.loadString(assetPath);
      Map<String, dynamic> jsonData = jsonDecode(jsonString);
      templateList.add(SectorModel.fromJson(jsonData));
      setState(() {});
    } catch (e) {
      debugPrint('Error loading asset $assetPath: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Overlay json template')),
      body: Container(
        color: Colors.grey.withOpacity(0.3),
        child: Center(
          child: Screenshot(
            controller: screenshotController,
            child: LayoutBuilder(builder: (context, constraints) {
              return AspectRatio(
                aspectRatio: 1.0,
                // width: screenSize.width,
                // height: screenSize.width / 1.0,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/image/bg.jpeg',
                      fit: BoxFit.cover,
                      height: 1080.h,
                      width: 1080.w,
                    ),
                    PageView(
                      allowImplicitScrolling: true,
                      scrollDirection: Axis.horizontal,
                      children: List.generate(
                        templateList.length,
                        (index) {
                          return Stack(
                            children: [
                              Image.memory(
                                Uint8List.fromList(
                                  base64Decode(
                                    templateList[index].backgroundImage!.src!.split(',').last,
                                  ),
                                ),
                                // height: templateList[index].backgroundImage?.height?.h,
                                // width: templateList[index].backgroundImage?.width?.w,
                              ),
                              if (templateList[index].editorObjects?.isNotEmpty == true ||
                                  templateList[index].editorObjects != null)
                                ...templateList[index].editorObjects!.map(
                                  (editorObject) {
                                    double left = (editorObject.left ?? editorObject.centerX ?? 15) / 2.6 + 2;
                                    double top = (editorObject.top ?? editorObject.centerY ?? 15) / 2.6 - 1;
                                    double width = ((editorObject.width ?? 0) * (editorObject.scaleX ?? 1));
                                    double height = ((editorObject.height ?? 0) * (editorObject.scaleY ?? 1));
                                    return editorObject.type == 'textbox'
                                        ? Positioned(
                                            left: left.w,
                                            top: top.w,
                                            child: SizedBox(
                                              width: width.w,
                                              height: height.h,
                                              child: Text(
                                                editorObject.text ?? '',
                                                textAlign: (editorObject.textAlign == 'right')
                                                    ? TextAlign.right
                                                    : (editorObject.textAlign == 'center')
                                                        ? TextAlign.center
                                                        : TextAlign.left,
                                                style: TextStyle(
                                                  // style: GoogleFonts.getFont(
                                                  //   editorObject.fontFamily?.split('-').first == 'null' ||
                                                  //           editorObject.fontFamily?.split('-').first == ''
                                                  //       ? 'Poppins'
                                                  //       : editorObject.fontFamily?.split('-').first ?? 'Poppins',
                                                  color:
                                                      (editorObject.fill != null && editorObject.fill!.startsWith('#'))
                                                          ? getTextColor(editorObject.fill!)
                                                          : null,
                                                  fontSize: ((editorObject.fontSize ?? 16) / 3).sp,
                                                  fontWeight: editorObject.fontFamily?.split('-').last == 'Bold'
                                                      ? FontWeight.w700
                                                      : editorObject.fontFamily?.split('-').last == 'Semibold'
                                                          ? FontWeight.w600
                                                          : FontWeight.normal,
                                                  fontStyle: FontStyle.normal,
                                                ),
                                              ),
                                            ),
                                          )
                                        : const SizedBox.shrink();
                                  },
                                ),
                              if (templateList[index].editorObjects != null)
                                ...templateList[index].editorObjects!.map(
                                  (editorObject) {
                                    double left = (((editorObject.centerX ?? editorObject.left ?? 15) / 2.88));
                                    double top = (((editorObject.centerY ?? editorObject.top ?? 15) / 2.86));
                                    double height = ((editorObject.height ?? 0) * (editorObject.scaleY ?? 1));
                                    double width = ((editorObject.width ?? 0) * (editorObject.scaleX ?? 1));

                                    return editorObject.type == 'image'
                                        ? Positioned(
                                            left: left.w,
                                            top: top.w,
                                            child: Image.memory(
                                              width: ((height + 8) / 3).w,
                                              height: ((width + 8) / 3).w,
                                              Uint8List.fromList(
                                                base64Decode(
                                                  editorObject.src!.split(',').last,
                                                ),
                                              ),
                                            ),
                                          )
                                        : const SizedBox.shrink();
                                  },
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await screenshotController.capture().then(
            (value) async {
              if (value != null) {
                var isDone = await ImageGallerySaver.saveImage(
                  Uint8List.fromList(value),
                  quality: 100,
                );
                if (isDone != null) {
                  CustomSnackbar.show(snackbarType: SnackbarType.SUCCESS, message: 'File saved successfully');
                } else {
                  CustomSnackbar.show(snackbarType: SnackbarType.SUCCESS, message: 'Can\'t save the file? Try again.');
                }
              }
            },
          );
        },
        child: const Icon(Icons.save),
      ),
    );
  }

  Color getTextColor(String color) {
    var hexColor = color.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
    return const Color(0xFFFFFFFF);
  }
}
