import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/auth_api.dart';
import 'package:twitter_clone/core/core.dart';
import 'package:twitter_clone/models/user_model.dart';
import '../../home/view/home_view.dart';
import 'package:appwrite/models.dart' as model;
import '../view/login_view.dart';
import '/apis/user_api.dart';

final authControllerProvider =
@@ -22,14 +24,12 @@ final currentUserAccountProvider = FutureProvider((ref) {
class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  final UserAPI _userAPI;
  AuthController({
    required AuthAPI authAPI, 
    required UserAPI userAPI
    })  : _authAPI = authAPI,
          _userAPI = userAPI,
  AuthController({required AuthAPI authAPI, required UserAPI userAPI})
      : _authAPI = authAPI,
        _userAPI = userAPI,
        super(false);
  // state = isLoading
   Future<model.Account?> currentUser() => _authAPI.currentUserAccount();
  Future<model.Account?> currentUser() => _authAPI.currentUserAccount();
  void signUp({
    required String email,
    required String password,
@@ -41,11 +41,26 @@ class AuthController extends StateNotifier<bool> {
      password: password,
    );
    state = false;
    res.fold(
      (l) => showSnackbar(context, l.message),
      // ignore: avoid_print
      (r) => print(r.email),
    );
    res.fold((l) => showSnackbar(context, l.message),
        // ignore: avoid_print
        (r) async {
      UserModel userModel = UserModel(
          email: email,
          name: getNameFromEmail(email),
          followers: const [],
          following: const [],
          profilePic: '',
          bannerPic: '',
          uid: '',
          bio: '',
          isTwitterBlue: false);
      final res2 = await _userAPI.saveUserData(userModel);
      res2.fold((l) => showSnackbar(context, l.message), (r) {
        showSnackbar(context, 'Account created! please login');
        Navigator.push(context, LoginView.route());
      });

    });
  }

  void login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.login(
      email: email,
      password: password,
    );
    state = false;
    res.fold(
      (l) => showSnackbar(context, l.message),
      (r) => Navigator.push(context, HomeView.route()),
    );
  }
}