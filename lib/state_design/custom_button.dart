import 'dart:ui';

import 'package:design_patterns/state_design/abs_state.dart';

import 'concrete_states.dart';

class CustomButton {
  AbsState _current;

  CustomButton._privateConstructor() {
    _current = new BlueState();
  }

  static final CustomButton instance = CustomButton._privateConstructor();

  CustomButton getInstance() {
    return this;
  }

  void setState(AbsState state) {
    _current = state;
  }

  Color change() {
    return _current.change(this);
  }
}
