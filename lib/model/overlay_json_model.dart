class SectorModel {
  List<EditorObjects>? editorObjects;
  EditorObjects? backgroundImage;

  SectorModel({this.editorObjects, this.backgroundImage});

  SectorModel.fromJson(Map<String, dynamic> json) {
    if (json['objects'] != null) {
      editorObjects = <EditorObjects>[];
      json['objects'].forEach((v) {
        editorObjects!.add(EditorObjects.fromJson(v));
      });
    }
    backgroundImage = json['backgroundImage'] != null ? EditorObjects.fromJson(json['backgroundImage']) : null;
  }
}

class EditorObjects {
  String? type;
  String? version;
  String? originX;
  String? originY;
  double? left;
  double? top;
  double? width;
  double? height;
  String? fill;
  int? strokeWidth;
  String? strokeLineCap;
  int? strokeDashOffset;
  String? strokeLineJoin;
  int? strokeMiterLimit;
  double? scaleX;
  double? scaleY;
  double? angle;
  bool? flipX;
  bool? flipY;
  int? opacity;
  bool? visible;
  String? backgroundColor;
  String? fillRule;
  String? paintFirst;
  String? globalCompositeOperation;
  int? skewX;
  int? skewY;
  String? text;
  double? fontSize;
  String? fontWeight;
  String? fontFamily;
  String? fontStyle;
  double? lineHeight;
  bool? underline;
  bool? overline;
  bool? linethrough;
  String? textAlign;
  String? textBackgroundColor;
  int? charSpacing;
  int? minWidth;
  bool? splitByGrapheme;
  String? crossOrigin;
  double? centerX;
  double? centerY;
  int? cropX;
  int? cropY;
  String? src;

  EditorObjects({
    this.type,
    this.version,
    this.originX,
    this.originY,
    this.left,
    this.top,
    this.width,
    this.height,
    this.fill,
    this.strokeWidth,
    this.strokeLineCap,
    this.strokeDashOffset,
    this.strokeLineJoin,
    this.strokeMiterLimit,
    this.scaleX,
    this.scaleY,
    this.angle,
    this.flipX,
    this.flipY,
    this.opacity,
    this.visible,
    this.backgroundColor,
    this.fillRule,
    this.paintFirst,
    this.globalCompositeOperation,
    this.skewX,
    this.skewY,
    this.text,
    this.fontSize,
    this.fontWeight,
    this.fontFamily,
    this.fontStyle,
    this.lineHeight,
    this.underline,
    this.overline,
    this.linethrough,
    this.textAlign,
    this.textBackgroundColor,
    this.charSpacing,
    this.minWidth,
    this.splitByGrapheme,
    this.crossOrigin,
    this.centerX,
    this.centerY,
    this.cropX,
    this.cropY,
    this.src,
  });

  EditorObjects.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    version = json['version'];
    originX = json['originX'];
    originY = json['originY'];
    left = double.tryParse(json['left'].toString());
    top = double.tryParse(json['top'].toString());
    width = double.tryParse(json['width'].toString());
    height = double.tryParse(json['height'].toString());
    fill = json['fill'];
    strokeWidth = json['strokeWidth'];
    strokeLineCap = json['strokeLineCap'];
    strokeDashOffset = json['strokeDashOffset'];
    strokeLineJoin = json['strokeLineJoin'];
    strokeMiterLimit = json['strokeMiterLimit'];
    scaleX = double.tryParse(json['scaleX'].toString());
    scaleY = double.tryParse(json['scaleY'].toString());
    angle = double.tryParse(json['angle'].toString());
    flipX = json['flipX'];
    flipY = json['flipY'];
    opacity = json['opacity'];
    visible = json['visible'];
    backgroundColor = json['backgroundColor'];
    fillRule = json['fillRule'];
    paintFirst = json['paintFirst'];
    globalCompositeOperation = json['globalCompositeOperation'];
    skewX = int.tryParse(json['skewX'].toString());
    skewY = int.tryParse(json['skewY'].toString());
    text = json['text'];
    fontSize = double.tryParse(json['fontSize'].toString());
    fontWeight = json['fontWeight']?.toString() ?? '';
    fontFamily = json['fontFamily'];
    fontStyle = json['fontStyle'];
    lineHeight = json['lineHeight'];
    underline = json['underline'];
    overline = json['overline'];
    linethrough = json['linethrough'];
    textAlign = json['textAlign'];
    textBackgroundColor = json['textBackgroundColor'];
    charSpacing = json['charSpacing'];
    minWidth = json['minWidth'];
    splitByGrapheme = json['splitByGrapheme'];
    crossOrigin = json['crossOrigin'];
    centerX = double.tryParse(json['centerx'].toString());
    centerY = double.tryParse(json['centery'].toString());
    cropX = json['cropX'];
    cropY = json['cropY'];
    src = json['src'];
  }
}
