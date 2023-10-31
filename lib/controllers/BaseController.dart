import 'package:get/get.dart';

enum ViewState { idle, busy }

class BaseController extends GetxController{
  ViewState _state = ViewState.idle;
  ViewState get state => _state;

  void setState(ViewState viewState){
    _state = viewState;
    update();
  }
}