import 'package:flutter/cupertino.dart' show CupertinoPageRoute;
import 'package:flutter/material.dart';

import '../constants/layout_constants.dart';

extension ContextExtensions<T> on BuildContext {

  Size get screenSize => MediaQuery.sizeOf(this);

  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => Theme.of(this).textTheme;

  void push(Widget page) async {
    await Future.delayed(Duration.zero);
    await Navigator.of(this).push(
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }

  void canPush(Widget page) async {
    Navigator.of(this).push(
      CupertinoPageRoute(
        builder: (context) => page,
      ),
    );
  }

  /// This is to make the user not feel like navigating to new screen
  void pushWithoutTransition(Widget page) async {
    await Navigator.of(this).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  void pushAndRemoveWithoutTransition(Widget page) async {
    await Navigator.of(this).pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => page,
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
        (route) => false);
  }

  void pushAndRemoveOthers(Widget page) async {
    await Future.delayed(Duration.zero);
    await Navigator.of(this).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => page,
      ),
      (route) => false,
    );
  }

  void pushReplacement(Widget page) async {
    await Future.delayed(Duration.zero);
    await Navigator.of(this).pushReplacement(
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }

  /// Pop the top-most route off the navigator that most tightly encloses the
  ///  given context.
  //void pop([T? result]) => Navigator.pop(this, result);

  void closeDrawer() => Scaffold.of(this).closeDrawer();

  // void showLoadingOverlay() async {
  //   await showDialog(
  //     context: this,
  //     builder: (context) {
  //       return const LoadingWidget();
  //     },
  //     barrierDismissible: false,
  //   );
  // }

  void showSnackbarError(String message) {
    ScaffoldMessenger.of(this).clearSnackBars();
    ScaffoldMessenger.of(this).showSnackBar(
      _snackbarContent(
        backgroundColor: Colors.red,
        message: message,
        icon: Icons.info,
      ),
    );
  }

  void showSnackbarSuccess(String message) {
    ScaffoldMessenger.of(this).clearSnackBars();
    ScaffoldMessenger.of(this).showSnackBar(
      _snackbarContent(
        backgroundColor: const Color.fromARGB(255, 27, 148, 92),
        message: message,
        icon: Icons.check_circle,
      ),
    );
  }

  SnackBar _snackbarContent({
    required Color backgroundColor,
    required String message,
    required IconData icon,
  }) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: backgroundColor,
      content: Row(
        children: [
          Expanded(
            flex: 10,
            child: Text(
              message,
              style: theme.textTheme.labelMedium!.copyWith(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
              child: Icon(
            icon,
            color: Colors.white,
          )),
        ],
      ),
    );
  }

  Future<T?> showBottomSheet({
    required Widget sheet,
    bool isDismissible = true,
  }) {
    return _showBottomSheet(sheet, isDismissible);
  }

  Future<T?> _showBottomSheet(Widget child, bool isDismissible) {
    return showModalBottomSheet(
      context: this,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: isDismissible,
      useSafeArea: true,
      constraints: BoxConstraints(
        maxHeight: screenSize.height * 0.9,
        minWidth: double.infinity,
      ),
      builder: (_) => PopScope(
        canPop: isDismissible,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            18,
            18,
            18,
            defaultBottomPaddingSize,
          ),
          child: child,
        ),
      ),
    );
  }

  Future<T?> showAlertDialog({
    bool barrierDismissible = true,
    required Widget child,
  }) {
    return showGeneralDialog(
      context: this,
      barrierDismissible: barrierDismissible,
      barrierLabel: 'نافذة تنبية',
      pageBuilder: (context, animation, secondaryAnimation) => ScaleTransition(
        scale: CurvedAnimation(
          parent: animation,
          curve: Curves.easeIn,
          reverseCurve: Curves.easeIn,
        ),
        child: PopScope(
          canPop: barrierDismissible,
          child: Dialog(
            alignment: Alignment.center,
            insetAnimationCurve: Curves.easeInOut,
            child: Padding(
              padding: pgAllPadding24,
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  double getResponsiveFontSize(double fontSize) {
    double screenWidth = MediaQuery.of(this).size.width;
    return screenWidth * (fontSize / 375); // 375 is the base width
  }
}
