import 'package:biometrics_demo/constants.dart';
// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// import 'package:nb_utils/nb_utils.dart';

Widget placeholderWidget() =>
    Image.asset('images/LikeButton/image/grey.jpg', fit: BoxFit.cover);

AppStore appStore = AppStore();

class AppStore {
  Color textPrimaryColor = Color(0xFF212121);
  Color iconColorPrimaryDark = Color(0xFF212121);
  Color scaffoldBackground = Color(0xFFEBF2F7);
  Color backgroundColor = Colors.black;
  Color backgroundSecondaryColor = Color(0xFF131d25);
  Color appColorPrimaryLightColor = Color(0xFFF9FAFF);
  Color textSecondaryColor = Color(0xFF5A5C5E);
  Color appBarColor = Colors.white;
  Color iconColor = Color(0xFF212121);
  Color iconSecondaryColor = Color(0xFFA8ABAD);
  Color cardColor = Colors.white;
  Color appColorPrimary = Color(0xFF1157FA);
  Color scaffoldBackgroundColor = Color(0xFFEFEFEF);

  AppStore();
}

Widget text(
  String? text, {
  var fontSize = 18.0,
  Color? textColor,
  var fontFamily,
  var isCentered = false,
  var maxLine = 1,
  var latterSpacing = 0.5,
  bool textAllCaps = false,
  var isLongText = false,
  bool lineThrough = false,
}) {
  return Text(
    textAllCaps ? text!.toUpperCase() : text!,
    textAlign: isCentered ? TextAlign.center : TextAlign.start,
    maxLines: isLongText ? null : maxLine,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontFamily: fontFamily ?? null,
      fontSize: fontSize,
      color: textColor ?? Color(0xFF5A5C5E),
      height: 1.5,
      letterSpacing: latterSpacing,
      decoration:
          lineThrough ? TextDecoration.lineThrough : TextDecoration.none,
    ),
  );
}

/// default box shadow
List<BoxShadow> defaultBoxShadow({
  Color? shadowColor,
  double? blurRadius,
  double? spreadRadius,
  Offset offset = const Offset(0.0, 0.0),
}) {
  return [
    BoxShadow(
      color: shadowColor ?? shadowColorGlobal,
      blurRadius: blurRadius ?? defaultBlurRadius,
      spreadRadius: spreadRadius ?? defaultSpreadRadius,
      offset: offset,
    ),
  ];
}

BoxDecoration boxDecoration({
  double radius = 2,
  Color color = Colors.transparent,
  Color? bgColor,
  var showShadow = false,
}) {
  return BoxDecoration(
    color: bgColor ?? Color(0xFFEBF2F7),
    boxShadow:
        showShadow
            ? defaultBoxShadow(shadowColor: Color(0x95E9EBF0))
            : [BoxShadow(color: Colors.transparent)],
    border: Border.all(color: color),
    borderRadius: BorderRadius.all(Radius.circular(radius)),
  );
}

// void changeStatusColor(Color color) async {
//   setStatusBarColor(color);
// }

// Widget commonCacheImageWidget(String? url, double height, {double? width, BoxFit? fit}) {
//   if (url.validate().startsWith('http')) {
//     return CachedNetworkImage(
//       placeholder: (context, url) => placeholderWidget(),
//       imageUrl: '$url',
//       height: height,
//       width: width,
//       fit: fit ?? BoxFit.cover,
//       errorWidget: (_, __, ___) {
//         return SizedBox(height: height, width: width);
//       },
//     );
//   } else {
//     return Image.asset(url!, height: height, width: width, fit: fit ?? BoxFit.cover);
//   }
// }

class EditText extends StatefulWidget {
  var isPassword;
  var isSecure;
  var fontSize;
  var textColor;
  // var fontFamily;
  var text;
  var hint;
  var maxLine;
  TextEditingController? mController;

  VoidCallback? onPressed;

  EditText({
    var this.fontSize = textSizeNormal,
    var this.textColor = TextColorSecondary,
    // var this.fontFamily = fontRegular,
    var this.isPassword = true,
    var this.hint = "",
    var this.isSecure = false,
    var this.text = "",
    var this.mController,
    var this.maxLine = 1,
  });

  @override
  State<StatefulWidget> createState() {
    return EditTextState();
  }
}

class EditTextState extends State<EditText> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.mController,
      obscureText: widget.isPassword,
      style: TextStyle(
        color: appStore.textPrimaryColor,
        fontSize: textSizeLargeMedium,
      ),
      decoration: InputDecoration(
        suffixIcon:
            widget.isSecure
                ? GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.isPassword = !widget.isPassword;
                    });
                  },
                  child: new Icon(
                    widget.isPassword ? Icons.visibility : Icons.visibility_off,
                    color: appStore.iconColor,
                  ),
                )
                : null,
        contentPadding: EdgeInsets.fromLTRB(16, 10, 16, 10),
        hintText: widget.hint,
        hintStyle: TextStyle(color: TextColorThird),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: ViewColor, width: 0.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: ViewColor, width: 0.0),
        ),
      ),
    );
  }
}
