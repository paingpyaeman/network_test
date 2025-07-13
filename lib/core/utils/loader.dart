import 'package:flutter/material.dart';
import 'package:loading_progress/loading_progress.dart';

class Loader {
  static final List<int> _loadings = [];

  static void start(BuildContext context) {
    _loadings.add(1);

    LoadingProgress.start(
      context,
      widget: Container(
        width: MediaQuery.of(context).size.width / 4,
        padding: EdgeInsets.all(MediaQuery.of(context).size.width / 13),
        child: const AspectRatio(
          aspectRatio: 1,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeCap: StrokeCap.round,
            strokeWidth: 8.0,
          ),
        ),
      ),
    );
  }

  static void stop(BuildContext context) {
    if (_loadings.isNotEmpty) {
      _loadings.removeLast();
      LoadingProgress.stop(context);
    }
  }
}
