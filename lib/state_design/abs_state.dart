import 'dart:ui';

import 'package:design_patterns/state_design/custom_button.dart';

abstract class AbsState {
  Color change(CustomButton button);
}
