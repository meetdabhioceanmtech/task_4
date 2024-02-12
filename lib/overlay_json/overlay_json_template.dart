import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
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
      appBar: AppBar(
        title: const Text('Overlay json template'),
      ),
      body: Container(
        color: Colors.grey.withOpacity(0.3),
        child: Center(
          child: Screenshot(
            controller: screenshotController,
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                color: Colors.white,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/image/bg.jpeg',
                      fit: BoxFit.cover,
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
                              ),
                              if (templateList[index].editorObjects != null)
                                ...templateList[index].editorObjects!.map(
                                  (editorObject) {
                                    double left = (((editorObject.left ?? editorObject.centerX ?? 15) / 3) + 3).w;
                                    double top = (((editorObject.top ?? editorObject.centerY ?? 15) / 3) + 20).h;
                                    double width = (editorObject.width ?? 0) * (editorObject.scaleX ?? 1);
                                    double height = ((editorObject.height ?? 0) * (editorObject.scaleY ?? 1)).h;
                                    return editorObject.type == 'textbox'
                                        ? Positioned(
                                            left: left,
                                            top: top,
                                            child: SizedBox(
                                              width: width,
                                              height: height,
                                              child: Text(
                                                editorObject.text ?? '',
                                                textAlign: (editorObject.textAlign == 'right')
                                                    ? TextAlign.right
                                                    : (editorObject.textAlign == 'center')
                                                        ? TextAlign.center
                                                        : TextAlign.left,
                                                style: GoogleFonts.getFont(
                                                  editorObject.fontFamily?.split('-').first ?? 'Poppins',
                                                  color:
                                                      (editorObject.fill != null && editorObject.fill!.startsWith('#'))
                                                          ? getTextColor(editorObject.fill!)
                                                          : null,
                                                  fontSize: ((editorObject.fontSize ?? 16) / 4).sp,
                                                  fontWeight: editorObject.fontFamily?.split('-').last == 'Bold'
                                                      ? FontWeight.w700
                                                      : editorObject.fontFamily?.split('-').last == 'Semibold'
                                                          ? FontWeight.normal
                                                          : FontWeight.w600,
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
                                    double top = (((editorObject.centerY ?? editorObject.top ?? 15) / 3) - 22).h;
                                    double left = (((editorObject.centerX ?? editorObject.left ?? 15) / 3) - 40).w;
                                    double height = ((editorObject.height ?? 0) * (editorObject.scaleY ?? 1)).h;
                                    double width = ((editorObject.width ?? 0) * (editorObject.scaleX ?? 1)).w;

                                    return editorObject.type == 'image'
                                        ? Positioned(
                                            left: left,
                                            top: top,
                                            child: Image.memory(
                                              width: ((height + 8) / 3).w,
                                              height: ((width + 8) / 3).h,
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
              ),
            ),
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
