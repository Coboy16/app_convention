import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: depend_on_referenced_packages
import 'package:provider/single_child_widget.dart';

import '/features/feactures.dart';
import '/shared/shared.dart';

List<SingleChildWidget> getListBloc() {
  return [
    BlocProvider(create: (context) => sl<AuthBloc>()),

    BlocProvider(create: (context) => NavigationBloc()),
    BlocProvider(create: (context) => sl<DashboardBloc>()),

    BlocProvider(create: (context) => sl<ProfileBloc>()),
    BlocProvider(create: (context) => sl<PostsBloc>()),
    BlocProvider(create: (context) => sl<FeedPostsBloc>()),
  ];
}

List<SingleChildWidget> getListeners() {
  return [];
}
