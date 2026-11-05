import 'package:flutter/widgets.dart';

abstract final class TourTargets {
  static final GlobalKey newCategory = GlobalKey(debugLabel: 'tour-new-category');
  static final GlobalKey search = GlobalKey(debugLabel: 'tour-search');
  static final GlobalKey scanButton = GlobalKey(debugLabel: 'tour-scan-button');
  static final GlobalKey menu = GlobalKey(debugLabel: 'tour-menu');
  static final GlobalKey wishesTab = GlobalKey(debugLabel: 'tour-wishes-tab');
  static final GlobalKey discoveriesTab = GlobalKey(debugLabel: 'tour-discoveries-tab');
  static final GlobalKey releasesTab = GlobalKey(debugLabel: 'tour-releases-tab');
}
