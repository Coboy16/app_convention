import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: depend_on_referenced_packages
import 'package:provider/single_child_widget.dart';

import '/features/feactures.dart';
import '/shared/shared.dart';

List<SingleChildWidget> getListBloc() {
  return [
    BlocProvider(create: (context) => sl<AuthBloc>()),

    BlocProvider(create: (context) => NavigationBloc()),

    BlocProvider(create: (context) => ProfileBloc()),
    BlocProvider(create: (context) => FeedBloc()),
    BlocProvider(create: (context) => DashboardBloc()),
  ];
}

List<SingleChildWidget> getListeners() {
  return [];
}
