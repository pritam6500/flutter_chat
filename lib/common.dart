import 'package:flutter/widgets.dart';

import 'bloc.dart';

class GlobalValues extends InheritedWidget {
  final bloc = new Bloc();
  GlobalValues({Key key, Widget child}) : super(key: key, child: child);
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
  static Bloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<GlobalValues>().bloc;
  }
  
}
