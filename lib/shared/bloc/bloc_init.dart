import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: depend_on_referenced_packages
import 'package:provider/single_child_widget.dart';

import '/features/feactures.dart';

List<SingleChildWidget> getListBloc() {
  return [BlocProvider(create: (context) => NavigationBloc())];
}

List<SingleChildWidget> getListeners() {
  return [];
}
