import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class StartUpViewModel extends BaseViewModel {
  BuildContext? context;

  Future handleStartUpLogic(BuildContext context) async {
    this.context = context;
    setBusy(true);

    await Future.delayed(Duration(milliseconds: 800));

    setBusy(false);
  }
}
