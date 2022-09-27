import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stackoverflow/controler/main_controller.dart';

final ytProvider = ChangeNotifierProvider<YoutubeMainClass>((ref) {
  return YoutubeMainClass();
});
