import 'package:meow_meow/model/user_model.dart';

import '../base_bloc.dart';

class LoginBloc extends BaseBloc {
  final _streamUserInfo = new BehaviorSubject<UserModel>();

  Observable<UserModel> get streamUserInfo => _streamUserInfo.stream;

  void fetchUserInfo(String uuid) {
    Firestore.instance
        .collection('user')
        .document(uuid)
        .snapshots()
        .listen((data) {
      UserModel userModel = UserModel.fromJson(data.data);
      _streamUserInfo.sink.add(userModel);
      _saveSharePref(userModel);
      return userModel;
    });
  }

  void _saveSharePref(UserModel model) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("uuid", model.uuid);
    prefs.getString("uuid");
  }

  @override
  void dispose() {
    _streamUserInfo.close();
  }
}
