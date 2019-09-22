import 'dart:async';

import 'package:meow_meow/model/user_model.dart';

import '../base_bloc.dart';

class LoginBloc extends BaseBloc {
  final _streamUserInfo = new BehaviorSubject<UserModel>();

  Observable<UserModel> get streamUserInfo => _streamUserInfo.stream;

  void fetchUserInfo(UserModel model) {
    _streamUserInfo.sink.add(model);
  }

  void saveSharePref(String uuid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("uuid", uuid);
    prefs.getString("uuid");
  }

  @override
  void dispose() {
    _streamUserInfo.close();
  }
}
