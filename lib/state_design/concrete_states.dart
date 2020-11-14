import 'package:design_patterns/state_design/abs_state.dart';
import 'package:design_patterns/state_design/custom_button.dart';
import 'package:flutter/material.dart';

class BlueState extends AbsState {
  @override
  Color change(CustomButton button) {
    button.setState(new GreenState());
    return Colors.blue;
  }
}

class GreenState extends AbsState {
  @override
  Color change(CustomButton button) {
    button.setState(new PurpleState());
    return Colors.green;
  }
}

class PurpleState extends AbsState {
  @override
  Color change(CustomButton button) {
    button.setState(new BlueState());
    return Colors.purple;
  }
}
