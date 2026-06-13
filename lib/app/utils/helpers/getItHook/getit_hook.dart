import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:marker/app/utils/helpers/injectable/injectable.dart';

abstract class GetItHook<T extends GetxController> extends StatefulWidget {
  const GetItHook({super.key, T? controller}) : _controller = controller;

  @override
  State<GetItHook> createState() => _GetItHookState<T>();

  void _onInit() => onInit();

  void onInit();

  bool get canDisposeController;

  Widget build(BuildContext context);

  T get controller => _controller ?? getIt<T>();

  final T? _controller;

  void onDispose();

  void _unRegister() {
    if (canDisposeController && getIt.isRegistered<T>()) {
      getIt.resetLazySingleton<T>();
    }
  }
}

class _GetItHookState<T extends GetxController> extends State<GetItHook> {
  @override
  Widget build(BuildContext context) => widget.build(context);

  @override
  void initState() {
    super.initState();
    widget._onInit();
  }

  @override
  void dispose() {
    widget.onDispose();
    super.dispose();
    widget._unRegister();
  }
}
